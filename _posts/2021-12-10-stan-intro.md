---
author: kevin
categories:
- tutorial
featured: true
image: "<https://mc-stan.org/images/stan_logo.png>"
output:
  html_document: default
  md_document:
    preserve_yaml: true
    variant: gfm
  pdf_document: default
title: Intro to Probabilistic Programming with Stan
---

In this tutorial we’re going to talk about what probabilistic
programming is and how we can use it for statistical modeling. If you
aren’t familiar at all with Bayesian stats, check out my [previous post
on the topic](https://dibsmethodsmeetings.github.io/bayes/). If you’re
used to probabilistic programming but just want to learn the Stan
language, you can go straight to the fantastic [Stan User’s
Guide](https://mc-stan.org/docs/2_28/stan-users-guide/index.html), which
explains how to program a wide variety of models.

# What is probabilistic programming?

Probabilistic programming is a relatively new and exciting approach to
statistical modeling that lets you create models in a standardized
language without having to implement any of the nitty-gritty details or
work out too much math. Although not all probabilistic programs are
Bayesian, probabalistic programming makes Bayesian modeling easy, and so
it’s a great way to learn what Bayesian models are, how they’re fit to
data, and what you can do with them. To explain what probabilistic
programming is, I’m going to use just a little bit of math. Bear with
me, because this is important!

In Bayesian statistics, we start with a model and some data. As a simple
example, we might model some ratings on a scale using a normal
distribution with a particular mean
*μ*
and variance
*σ*<sup>2</sup>
. Our goal is to identify the most likely parameter values given our
data (that is, the values of
*μ*
and
*σ*
that best explain our data). To determine which which parameter values
are best, we make use of Bayes’ formula:

*P*(*θ*\|𝒟) ∝ *P*(*θ*)*P*(𝒟\|*θ*)

This formula says that the probability of a parameter value
*θ*
given our data
𝒟
is proportional to our prior probability of that parameter value
multiplied by the likelihood that the data could have been generated
from that parameter value. How do we determine the likelihood? Well,
sometimes we can derive the likelihood (and hence the posterior) by
hand. But in most cases, this approach is too difficult or
time-consuming. In probabilistic programming, we write a program that
simulates our model given some parameter values. This is actually useful
in its own right: we can use this program to see how the model behaves
under different settings of the parameters. But in statistical
inference, the important part is that we run that program to
(approximately) calculate the likelihood, which in turn lets us
calculate the posterior probability of the parameter values given our
data.

## Why Stan?

There are a good number of probabilistic programming languages out
there. Today we’re going to focus on [Stan](https://mc-stan.org), which
is one of the fastest, most reliable, and most widely used probabilistic
programming languages out there. One of the cool things about Stan is
that there are a number of different interfactes to Stan: you can use
Stan through R, through Python, through Matlab, through Julia, and even
directly through the command-line! If you’ve read [my tutorial on
Bayesian regression with
brms](https://dibsmethodsmeetings.github.io/brms-intro/), then you’ve
actually already used one of the easiest interfaces to Stan, which
writes Stan programs for you based on `lmer`-like formulas. Lastly, Stan
has one of the [largest communities](https://mc-stan.org/community/)
that makes getting coding help and statistical advice easy.

## The components of a Stan program

Unsurprisingly, Stan programs are written in Stan files, which use the
extension `.stan`. The Stan language has similar syntax to `C++`, in
that it uses curly braces (`{` and `}`) to define blocks of code,
semicolons (`;`) after each statement, and has a type declaration for
every variable in the program. There are two primitive data types: `int`
for integers, and `real` for floating-point/decimal numbers. There are
also a few different container types: `array`, `vector`, and
`row_vector` for one-dimensional containers, and `matrix` for
N-dimensional containers. For now, the differences between `array`,
`vector`, and `row_vector` aren’t that important. Just know that when
possible, we will try to use type `vector`, which will generally be most
efficient.

Stan programs consist of up to seven different blocks of code, in the
following order (\*required):

-   `functions`
-   `data`\*
-   `transformed data`
-   `parameters`\*
-   `transformed parameters`
-   `model`\*
-   `generated quantities`

In the remainder of the workshop, we’re going to focus on the `data`,
`parameters`, `model`, and `generated_quantities` blocks. Let’s start
with the simplest use case for Stan: simulating fake data.

# Simulating fake data with Stan

To demonstrate how to simulate data using Stan, let’s first get a nice
dataset to work with. Here I’m going to load some packages, and then run
some code to gather data from the Spotify top 200 songs per week in
2021. Don’t worry about how this code actually works (we can save that
for a future meeting…), but know that it will take some time (\~15mins)
if you run this on your computer.

## Getting some data

``` r
library(cmdstanr)   # for stan
library(tidyverse)  # for data wrangling
library(lubridate)  # for dates
library(rvest)      # for scraping spotify charts
library(spotifyr)   # for spotify audio features
library(tidybayes)  # for accessing model posteriors 
options(mc.cores=parallel::detectCores())

## gather spotify chart data (modified from https://rpubs.com/argdata/web_scraping)
scrape_spotify <- function(url) {
    page <- url %>% read_html() # read the HTML page
    
    rank <- page %>%
        html_elements('.chart-table-position') %>%
        html_text() %>%
        as.integer
    track <- page %>% 
        html_elements('strong') %>% 
        html_text()
    artist <- page %>% 
        html_elements('.chart-table-track span') %>% 
        html_text() %>%
        str_remove('by ')
    streams <- page %>% 
        html_elements('td.chart-table-streams') %>% 
        html_text() %>%
        str_remove_all(',') %>%
        as.integer
    URI <- page %>%
        html_elements('a') %>%
        html_attr('href') %>%
        str_subset('https://open.spotify.com/track/') %>%
        str_remove('https://open.spotify.com/track/')
    
    ## combine, name, and make it a tibble
    chart <- tibble(rank=rank, track=track, artist=artist, streams=streams, URI=URI)
    return(chart)
}

## setup access to Spotify API
access_token <- get_spotify_access_token()

## load the top 200 songs in the US per week in 2021
spotify2021 <- tibble(week=seq(ymd('2021-01-01'), ymd('2021-11-19'), by = 'weeks')) %>%
    mutate(url=paste0('https://spotifycharts.com/regional/us/weekly/', week, '--', week+days(7)),
           data=map(url, scrape_spotify)) %>%
    unnest(data) %>%
    mutate(streams=streams/1000000)

## extract spotify's audio features for each song
features <- tibble(URI=unique(spotify2021$URI)) %>%
    mutate(features=map(URI, ~ get_track_audio_features(.x, authorization=access_token))) %>%
    unnest(features)

## make one tidy data frame
spotify2021 <- spotify2021 %>% left_join(features, by='URI') %>%
    select(-URI, -analysis_url, -track_href, -id, -type) %>%
    relocate(week, rank, track, artist, streams, duration_ms, tempo,
             time_signature, key, mode, valence, loudness, danceability,
             energy, speechiness, acousticness, instrumentalness, liveness, uri, url)
write_csv(spotify2021, '2021-12-10-spotify-data.csv')
spotify2021
```

    ## # A tibble: 9,400 × 20
    ##    week        rank track  artist streams duration_ms tempo time_signature   key
    ##    <date>     <dbl> <chr>  <chr>    <dbl>       <dbl> <dbl>          <dbl> <dbl>
    ##  1 2021-01-01     1 Good … SZA       6.32      279204 121.               4     1
    ##  2 2021-01-01     2 Anyone Justi…    6.15      190779 116.               4     2
    ##  3 2021-01-01     3 34+35  Arian…    5.61      173711 110.               4     0
    ##  4 2021-01-01     4 Mood … 24kGo…    5.58      140526  91.0              4     7
    ##  5 2021-01-01     5 Lemon… Inter…    5.37      195429 140.               4     1
    ##  6 2021-01-01     6 DÁKITI Bad B…    5.16      205090 110.               4     4
    ##  7 2021-01-01     7 posit… Arian…    5.10      172325 144.               4     0
    ##  8 2021-01-01     8 Whoop… CJ        4.88      123263 140.               4     3
    ##  9 2021-01-01     9 WITHO… The K…    4.78      161385  93.0              4     0
    ## 10 2021-01-01    10 Blind… The W…    4.44      200040 171.               4     1
    ## # … with 9,390 more rows, and 11 more variables: mode <dbl>, valence <dbl>,
    ## #   loudness <dbl>, danceability <dbl>, energy <dbl>, speechiness <dbl>,
    ## #   acousticness <dbl>, instrumentalness <dbl>, liveness <dbl>, uri <chr>,
    ## #   url <chr>

As we can see, we now have a dataframe of Spotify’s weekly top 200
tracks, along with the following information:

-   `week`: the week in 2021
-   `rank`: the song’s rank (`1` to `200`) in this week, with `1` being
    the top song
-   `track`: the name of the song
-   `artist`: the name of the artist who released the song
-   `streams`: the number of streams in that week (in millions)
-   `duration_ms`: the duration of the track in ms
-   `tempo`: the tempo of the track in beats per minute
-   `time_signature`: an estimated time signature ranging from `3` to
    `7` (for 3/4 to 7/4)
-   `key`: the key of the song from `0` (for C) to `11` (for B), or `-1`
    if no key was found
-   `mode`: whether the track is in a major (`1`) or minor (`0`) key
-   `valence`: the emotional valence of the track from `0` (negative
    valence/sad) to `1` (positive valence/happy)
-   `loudness`: the average loudness of the track in decibels
-   `danceability`: an estimate of how danceable the track is, from `0`
    (least danceable) to `1` (most danceable)
-   `energy`: an estimate of the intensity or activity of the track,
    from `0` (low energy) to `1` (high energy)
-   `speechiness`: an estimate of the proportion of speech in the track,
    from `0` (no speech) to `1` (only speech)
-   `acousticness`: an estimate of the degree to which a track is (`1`)
    or is not (`0`) acoustic
-   `instrumentalness`: an estimate of the degree to which a track
    contains (`1`) or does not contain (`0`) vocals
-   `liveness`: an estimate of whether the track was performed live
    (`1`) or not (`0`)
-   `uri`: the Spotify unique identifier for the track
-   `url`: a link to the track

## Simulating fake data: number of streams

Let’s say we want to know how many times, on average, the top 200 tracks
are streamed every week. Of course, we could just use
`mean(spotify2021$streams)` to get this number, but to get more
information we will need to specify a model. As a start, we can assume a
normal distribution with mean
*μ*
and standard deviation
*σ*
. In simulation, we assume that we know what the values of
*μ*
and
*σ*
are to check what the distribution of streams would look like if those
values were true. To do that, let’s write a Stan program, which I’ll
save in the file `2021-12-10-streams-sim.stan`:

    data {
      real<lower=0> mu;       // the mean
      real<lower=0> sigma;    // the standard deviation
    }

    parameters {
    }

    model {
    }

    generated quantities {
      // simulate data using a normal distribution
      real y_hat = normal_rng(mu, sigma);
    }

Since we’re simulating from a prior, we will take our parameters `mu`
and `sigma` as inputs to Stan by declaring them in the `data` block. The
code `real<lower=0> mu;` defines a variable called `mu` that will refer
to the mean of the number of streams, and similarly
`real<lower=0> sigma;` defines the standard deviation. Both of these
variables are lower-bounded at 0 with the expression `<lower=0>`,
because it wouldn’t make sense to simulate a negative number of streams
or a negative standard deviation (we would also put an upper bound here
if it made sense). Since our model has no remaining parameters, and we
are not yet modeling any data, both the `parameters` and `model` blocks
are empty. Finally, in the `generated quantities` block, we are telling
our model to simulate the number of streams by drawing a random number
from a normal distribution.

To run our Stan program, we will make use of the library `cmdstanr`. The
`rstan` library also works for this, but I’ve found `cmdstanr` to be
faster and more reliable. Let’s say we know that there are roughly one
million streams per week, but this varies with a standard deviation of
one hundred thousand streams. We can make a list of these values, and
pass them to Stan as data:

``` r
streams_sim_data <- list(mu=1, sigma=.1)
streams_sim_model <- cmdstan_model('2021-12-10-streams-sim.stan')  ## compile the model
streams_sim <- streams_sim_model$sample(data=streams_sim_data, fixed_param=TRUE)
```

    ## Running MCMC with 4 sequential chains...
    ## 
    ## Chain 1 Iteration:   1 / 1000 [  0%]  (Sampling) 
    ## Chain 1 Iteration: 100 / 1000 [ 10%]  (Sampling) 
    ## Chain 1 Iteration: 200 / 1000 [ 20%]  (Sampling) 
    ## Chain 1 Iteration: 300 / 1000 [ 30%]  (Sampling) 
    ## Chain 1 Iteration: 400 / 1000 [ 40%]  (Sampling) 
    ## Chain 1 Iteration: 500 / 1000 [ 50%]  (Sampling) 
    ## Chain 1 Iteration: 600 / 1000 [ 60%]  (Sampling) 
    ## Chain 1 Iteration: 700 / 1000 [ 70%]  (Sampling) 
    ## Chain 1 Iteration: 800 / 1000 [ 80%]  (Sampling) 
    ## Chain 1 Iteration: 900 / 1000 [ 90%]  (Sampling) 
    ## Chain 1 Iteration: 1000 / 1000 [100%]  (Sampling) 
    ## Chain 1 finished in 0.0 seconds.
    ## Chain 2 Iteration:   1 / 1000 [  0%]  (Sampling) 
    ## Chain 2 Iteration: 100 / 1000 [ 10%]  (Sampling) 
    ## Chain 2 Iteration: 200 / 1000 [ 20%]  (Sampling) 
    ## Chain 2 Iteration: 300 / 1000 [ 30%]  (Sampling) 
    ## Chain 2 Iteration: 400 / 1000 [ 40%]  (Sampling) 
    ## Chain 2 Iteration: 500 / 1000 [ 50%]  (Sampling) 
    ## Chain 2 Iteration: 600 / 1000 [ 60%]  (Sampling) 
    ## Chain 2 Iteration: 700 / 1000 [ 70%]  (Sampling) 
    ## Chain 2 Iteration: 800 / 1000 [ 80%]  (Sampling) 
    ## Chain 2 Iteration: 900 / 1000 [ 90%]  (Sampling) 
    ## Chain 2 Iteration: 1000 / 1000 [100%]  (Sampling) 
    ## Chain 2 finished in 0.0 seconds.
    ## Chain 3 Iteration:   1 / 1000 [  0%]  (Sampling) 
    ## Chain 3 Iteration: 100 / 1000 [ 10%]  (Sampling) 
    ## Chain 3 Iteration: 200 / 1000 [ 20%]  (Sampling) 
    ## Chain 3 Iteration: 300 / 1000 [ 30%]  (Sampling) 
    ## Chain 3 Iteration: 400 / 1000 [ 40%]  (Sampling) 
    ## Chain 3 Iteration: 500 / 1000 [ 50%]  (Sampling) 
    ## Chain 3 Iteration: 600 / 1000 [ 60%]  (Sampling) 
    ## Chain 3 Iteration: 700 / 1000 [ 70%]  (Sampling) 
    ## Chain 3 Iteration: 800 / 1000 [ 80%]  (Sampling) 
    ## Chain 3 Iteration: 900 / 1000 [ 90%]  (Sampling) 
    ## Chain 3 Iteration: 1000 / 1000 [100%]  (Sampling) 
    ## Chain 3 finished in 0.0 seconds.
    ## Chain 4 Iteration:   1 / 1000 [  0%]  (Sampling) 
    ## Chain 4 Iteration: 100 / 1000 [ 10%]  (Sampling) 
    ## Chain 4 Iteration: 200 / 1000 [ 20%]  (Sampling) 
    ## Chain 4 Iteration: 300 / 1000 [ 30%]  (Sampling) 
    ## Chain 4 Iteration: 400 / 1000 [ 40%]  (Sampling) 
    ## Chain 4 Iteration: 500 / 1000 [ 50%]  (Sampling) 
    ## Chain 4 Iteration: 600 / 1000 [ 60%]  (Sampling) 
    ## Chain 4 Iteration: 700 / 1000 [ 70%]  (Sampling) 
    ## Chain 4 Iteration: 800 / 1000 [ 80%]  (Sampling) 
    ## Chain 4 Iteration: 900 / 1000 [ 90%]  (Sampling) 
    ## Chain 4 Iteration: 1000 / 1000 [100%]  (Sampling) 
    ## Chain 4 finished in 0.0 seconds.
    ## 
    ## All 4 chains finished successfully.
    ## Mean chain execution time: 0.0 seconds.
    ## Total execution time: 0.6 seconds.

As we can see, the model has simulated 1000 stream counts in four
different chains. Note that above, we used the argument
`fixed_param=TRUE` to tell Stan that our model has no parameters, which
makes the sampling faster. Let’s look at a summary of our model:

``` r
streams_sim
```

    ##  variable mean median   sd  mad   q5  q95 rhat ess_bulk ess_tail
    ##     y_hat 1.00   1.00 0.10 0.10 0.83 1.17 1.00     3896     3899

This summary tells us that our simulated streams counts have an average
of about one million and a standard deviation of about one hundred
thousand. To access the simulated data, we have a few different options.
Within `cmdstanr`, the default is to use `streams_sim$draws()`. However,
I find that the `spread_draws` function from `tidybayes` is usually
easier to work with, as it gives us a nice tidy dataframe of whatever
variables we want. The other reason is that we’re going to use
`tidybayes` (technically `ggdist`) to make pretty plots of our draws.
Let’s get our draws and plot them:

``` r
draws <- streams_sim %>% gather_draws(y_hat)

ggplot(draws, aes(x=.value)) +
    stat_halfeye(point_interval=median_hdi, normalize='panels') +
    xlab('Streams (millions/week)') + ylab('Density') +
    facet_wrap(~ .variable, scales='free') +
    theme_tidybayes()
```

<img src="/assets/images/2021-12-10-stan-intro/streams_sim_draws-1.png" style="display: block; margin: auto;" />

Again, this tells us what we already expected: our simulated top 200
songs have somewhere around one million streams per week, and the number
of streams are normally distributed around that.

# Sampling from a prior distribution

It’s nice to simulate data, but of course our main goal is to infer what
the *actual* mean and standard deviation of stream counts for the top
200 tracks. To do so, we first need to define a prior distribution.
Thankfully, this is pretty easy in Stan: we just move the parameters
`mu` and `sigma` from the `data` block to the `parameters` block:

    data {

    }

    parameters {
      real<lower=0> mu;     // the mean
      real<lower=0> sigma;  // the standard deviation
    }

    model {
      // define priors for mu and sigma
      mu ~ normal(1, .1);
      sigma ~ normal(0, .1);
    }

    generated quantities {
      // simulate data using a normal distribution
      real y_hat = normal_rng(mu, sigma);
    }

Besides the declarations of `mu` and `sigma` being moved to the
`parameters` block, we can see that we’ve also added to the `model`
block. Specifically, the `model` block now specifies prior distributions
over our two parameters. The symbol `~` can be read as “is distributed
as”, so we’re saying that `mu` is distributed according to a normal
distribution with a mean of one million and a standard deviation of one
hundred thousand. Likewise, we’re assuming that `sigma` is distributed
normally around 0 with a standard deviation of one hundred thousand. You
might think that this would give us negative numbers, but Stan truncates
these normal distributions at 0 because of the `<lower=0>` in the
paramters’ declarations. Now let’s sample from our prior distribution to
simulate some fake data:

``` r
streams_prior_model <- cmdstan_model('2021-12-10-streams-prior.stan')  ## compile the model
streams_prior <- streams_prior_model$sample()
streams_prior

streams_prior %>%
    gather_draws(mu, sigma, y_hat) %>%
    mutate(.variable=factor(.variable, levels=c('y_hat', 'sigma', 'mu'))) %>%
    ggplot(aes(x=.value, y=.variable)) +
    stat_halfeye(point_interval=median_hdi, normalize='panels') +
    xlab('Streams (millions/week)') + ylab('Density') +
    facet_wrap(~ .variable, scales='free') +
    theme_tidybayes()
```

<img src="/assets/images/2021-12-10-stan-intro/streams_prior_sample-1.png" style="display: block; margin: auto;" />

    ## Running MCMC with 4 sequential chains...
    ## 
    ## Chain 1 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 1 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 1 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 1 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 1 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 1 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 1 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 1 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 1 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 1 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 1 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 1 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 1 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 1 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 1 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 1 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 1 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 1 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 1 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 1 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 1 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 1 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 1 finished in 0.0 seconds.
    ## Chain 2 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 2 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 2 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 2 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 2 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 2 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 2 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 2 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 2 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 2 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 2 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 2 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 2 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 2 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 2 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 2 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 2 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 2 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 2 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 2 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 2 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 2 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 2 finished in 0.0 seconds.
    ## Chain 3 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 3 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 3 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 3 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 3 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 3 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 3 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 3 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 3 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 3 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 3 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 3 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 3 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 3 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 3 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 3 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 3 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 3 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 3 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 3 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 3 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 3 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 3 finished in 0.0 seconds.
    ## Chain 4 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 4 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 4 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 4 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 4 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 4 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 4 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 4 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 4 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 4 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 4 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 4 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 4 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 4 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 4 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 4 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 4 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 4 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 4 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 4 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 4 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 4 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 4 finished in 0.0 seconds.
    ## 
    ## All 4 chains finished successfully.
    ## Mean chain execution time: 0.0 seconds.
    ## Total execution time: 0.5 seconds.
    ##  variable  mean median   sd  mad    q5   q95 rhat ess_bulk ess_tail
    ##     lp__  -3.96  -3.60 1.18 0.83 -6.25 -2.86 1.00     1147      961
    ##     mu     1.00   1.00 0.10 0.10  0.82  1.16 1.00     1708     1083
    ##     sigma  0.08   0.07 0.06 0.06  0.01  0.20 1.00     1284     1079
    ##     y_hat  0.99   1.00 0.14 0.13  0.76  1.22 1.00     2634     2397

Just like before, we now have simulated values of `y_hat` centered
around one million streams per week. However, the distribution of
`y_hat` is wider than before. When we simulated stream counts with a
fixed `mu` and `sigma`, the only source of noise in our simulated data
was the noise in the sampling process. But now that we have included
`mu` and `sigma` as parameters in the model, we also have uncertainty in
`mu` and `sigma` that creates some more noise in `y_hat`.

## Fitting a model to data

You might have noticed that that was a whole lot of work to go through
to sample from some normal distributions. Up until now, we could have
just as well used `rnorm` a few times to do the trick. So what’s the
point? Well, using (almost) the same Stan code, we can now fit this
simple model to our data to find the most likely values of
*μ*
and
*σ*
:

    data {
      int<lower=0> N;         // the number of data points
      vector<lower=0>[N] y;   // the data to model
    }

    parameters {
      real<lower=0> mu;       // the mean
      real<lower=0> sigma;    // the standard deviation
    }

    model {
      // define priors for mu and sigma
      mu ~ normal(1, .1);
      sigma ~ normal(0, .1);

      // define the likelihood of y
      y ~ normal(mu, sigma);
    }

    generated quantities {
      // simulate data using a normal distribution
      real y_hat = normal_rng(mu, sigma);
    }

Compared to the previous code, we have added two things. First, in the
`data` block, we added declarations for two variables. `y` is a vector
containing the stream counts for each track in each week. The syntax
`[N]` tells Stan that this vector is `N` numbers long, which is why we
also declared a data variable `N`. Finally, in the `model` block, we
added a line that defines the likelihood of `y` given our model: we are
modeling `y` as normally-distributed with mean `mu` and standard
deviation `sigma`. Rather than just evaluating the likelihood of the
data according to our prior distributions, Stan will sample the values
of `mu` and `sigma` according to their posterior probability using
Markov Chain Monte Carlo (MCMC), giving us an approximate posterior
distribution. Let’s run it and see what happens:

``` r
streams_data <- list(N=nrow(spotify2021), y=spotify2021$streams)
streams_model <- cmdstan_model('2021-12-10-streams.stan')  ## compile the model
streams <- streams_model$sample(data=streams_data, save_warmup=TRUE)
streams

draws <- streams %>% gather_draws(mu, sigma, y_hat)
ggplot(draws, aes(x=.value)) +
    stat_halfeye(point_interval=median_hdi, normalize='panels') +
    xlab('Streams (millions/week)') + ylab('Density') +
    facet_wrap(~ .variable, scales='free') +
    theme_tidybayes()
```

<img src="/assets/images/2021-12-10-stan-intro/streams_sample-1.png" style="display: block; margin: auto;" />

    ## Running MCMC with 4 sequential chains...
    ## 
    ## Chain 1 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 1 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 1 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 1 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 1 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 1 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 1 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 1 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 1 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 1 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 1 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 1 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 1 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 1 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 1 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 1 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 1 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 1 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 1 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 1 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 1 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 1 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 1 finished in 0.2 seconds.
    ## Chain 2 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 2 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 2 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 2 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 2 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 2 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 2 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 2 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 2 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 2 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 2 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 2 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 2 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 2 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 2 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 2 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 2 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 2 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 2 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 2 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 2 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 2 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 2 finished in 0.2 seconds.
    ## Chain 3 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 3 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 3 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 3 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 3 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 3 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 3 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 3 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 3 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 3 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 3 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 3 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 3 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 3 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 3 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 3 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 3 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 3 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 3 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 3 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 3 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 3 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 3 finished in 0.2 seconds.
    ## Chain 4 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 4 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 4 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 4 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 4 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 4 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 4 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 4 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 4 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 4 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 4 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 4 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 4 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 4 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 4 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 4 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 4 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 4 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 4 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 4 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 4 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 4 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 4 finished in 0.2 seconds.
    ## 
    ## All 4 chains finished successfully.
    ## Mean chain execution time: 0.2 seconds.
    ## Total execution time: 1.2 seconds.
    ##  variable      mean    median   sd  mad        q5       q95 rhat ess_bulk
    ##     lp__  -10568.72 -10568.40 0.98 0.74 -10570.70 -10567.80 1.00     1827
    ##     mu         2.52      2.52 0.02 0.02      2.49      2.55 1.00     3341
    ##     sigma      1.78      1.78 0.01 0.01      1.76      1.80 1.00     3511
    ##     y_hat      2.48      2.50 1.77 1.77     -0.42      5.45 1.00     3652
    ##  ess_tail
    ##      2221
    ##      2164
    ##      2378
    ##      4058

Even though our prior for `mu` was around one million streams per week,
it looks like our posterior is now around 2.5 million streams per week.
Likewise, the posterior for `sigma` is about 1.8 million, even though
our prior was centered around 0. Finally, looking at `y_hat`, it appears
that our model estimates the number of streams per week to be anywhere
from -500,000 to 5.5 million. Before we talk about these results any
further, though, let’s make sure that we can trust them.

# Assessing model convergence

Since we don’t have direct access to the posterior distribution, Stan
uses Markov Chain Monte Carlo (MCMC) to sample values of `mu` and
`sigma`. We won’t go into the details here, but the gist is that MCMC
approximates the posterior distributions over `mu` and `sigma` by trying
to sample their values in proportion to their posterior probability. If
the samples look like they have come from the posterior distribution, we
say the model has *converged*. If not, we cannot use the sampled values
for inference, because they don’t reflect our posterior.

## The fuzzy caterpillar check

There are few different metrics for assessing convergence of MCMC
chains. Honestly, the best one is visual: the “fuzzy caterpillar” check.
The idea is you plot the MCMC chains for each parameter as a function of
iteration number, like so:

``` r
ggplot(draws, aes(x=.iteration, y=.value, color=factor(.chain))) +
    geom_line() + xlab('Iteration') + ylab('Value') +
    scale_color_discrete(name='Chain') +
    facet_grid(.variable ~ ., scales='free_y') +
    theme_tidybayes()
```

<img src="/assets/images/2021-12-10-stan-intro/mcmc_trace-1.png" style="display: block; margin: auto;" />

Since all of these chains look like nice fuzzy caterpillars, we can be
pretty confident that they converged. To demonstrate what the chains
would look like if they *hadn’t* converged, let’s look at the chains
before the warmup period. The warmup period is the first stage of the
model while it is assumed to still be converging: typically we say that
something like the first half of the samples are in the warmup period,
and we throw them away to be left with just the good stuff.

``` r
streams$draws(variables=c('mu', 'sigma', 'y_hat'),
              inc_warmup=TRUE, format='draws_df') %>%
    pivot_longer(mu:y_hat, names_to='.variable', values_to='.value') %>%
    filter(.iteration <= 250) %>%
    ggplot(aes(x=.iteration, y=.value, color=factor(.chain))) +
    geom_line() + xlab('Iteration') + ylab('Value') +
    scale_color_discrete(name='Chain') +
    facet_grid(.variable ~ ., scales='free_y') +
    theme_tidybayes()
```

<img src="/assets/images/2021-12-10-stan-intro/mcmc_trace_warmup-1.png" style="display: block; margin: auto;" />

As we can see, the first 25 or so iterations do not look like nice fuzzy
caterpillars. Instead, we can tell all of the four chains apart from
each other, since they are close to their random initializaiton values.
But by iteration 50, it appears that our model has converged: the
parameters have all ended up around the values of our posterior
distribution.

## R-hat

If the qualitative visual check isn’t working for you, you might want
something a bit more quantitative. One option is R-hat, which is the
ratio of the between-chain variance and the within-chain variance of the
parameter values. This gives us a good quantification of the fuzzy
caterpillar check: if the between-chain variance is high (relative to
the within-chain variance), the chains are all exploring different
regions of the parameter space and don’t overlap much. On the other
hand, if the two variances are about equal, then the chains should look
like fuzzy caterpillars. Typically we look for R-hat values to be as
close to 1 as possible and we start to be suspicious of poor convergence
if R-hat \> 1.05.

``` r
streams$summary() %>% select(variable, rhat)
```

    ## # A tibble: 4 × 2
    ##   variable  rhat
    ##   <chr>    <dbl>
    ## 1 lp__      1.00
    ## 2 mu        1.00
    ## 3 sigma     1.00
    ## 4 y_hat     1.00

Since our R-hat values are all 1.00, our model looks pretty good.

## ESS

Related to R-hat, we can also look at the effective sample size (ESS) of
the model. Recall that we sampled 1000 draws from four MCMC chains,
resulting in 4000 total samples from the posterior. In an ideal scenario
where every iteration of the model is totally independent of the
previous iteration, this would mean that we have a sample size of 4000
samples. But most of the time, there is some amount of auto-correlation
of the parameter values between iterations. To account for this, ESS is
the sample size adjusted for within-chain auto-correlation. In other
words, even though we have 4000 samples from the posterior, because of
auto-correlation inherent in the model fitting process, we *effectively*
have fewer independent samples. `cmdstanr` actually gives us two
different ESSs: a bulk ESS and a tail ESS. The bulk ESS tells us the
effective sample size for our estimates of central tendency (i.e.,
mean/median), and the tail ESS tells us the effective sample size for
our estimates of the tail quantiles and credible intervals. Since there
are fewer samples at the tails, we will typically have a lower tail ESS
than bulk ESS. In any case, you want all of these ESSs to be as large as
possible. Minimally, it is good to have an ESS of 1000 for practical
applications.

``` r
streams$summary() %>% select(variable, ess_bulk, ess_tail)
```

    ## # A tibble: 4 × 3
    ##   variable ess_bulk ess_tail
    ##   <chr>       <dbl>    <dbl>
    ## 1 lp__        1827.    2222.
    ## 2 mu          3341.    2165.
    ## 3 sigma       3512.    2378.
    ## 4 y_hat       3653.    4059.

Our bulk ESS looks very good- all of the values are close to 4000.
Though the tail ESS is lower, it is still acceptable.

# Assessing model fit

Now that we know that our model converged, let’s try to figure out how
well it fit. In other words, how well does our model describe the data?
Just as the fuzzy-caterpillar check provides a quick & easy way of
assessing convergence, posterior predictive checks do the same for model
fit. To perform a posterior predictive check, all we have to do is plot
the distribution of simulated data alongside the distribution of actual
data:

``` r
draws %>%
    filter(.variable=='y_hat') %>%
    ggplot(aes(x=.value, fill=.variable)) +
    stat_slab(slab_alpha=.75) +
    stat_slab(slab_alpha=.75, data=tibble(.variable='y', .value=spotify2021$streams)) +
    geom_vline(xintercept=mean(spotify2021$streams)) +
    scale_fill_discrete(name='') +
    xlab('Streams (millions/week)') + ylab('Density') +
    coord_cartesian(xlim=c(-5, 10)) +
    theme_tidybayes()    
```

<img src="/assets/images/2021-12-10-stan-intro/pp_check-1.png" style="display: block; margin: auto;" />

We can see that even though our model captures the mean of the stream
counts (the black vertical line) very well, there are a few problems.
First and foremost, it predicts some negative stream counts. For the top
200 songs on Spotify, not only is a negative number of streams very
unlikely, it is also impossible. Second, it predicts that most stream
counts will be at the mean, but the data have a positive skew. Let’s try
to fix these two issues at once by using a log-normal distribution
instead of a Normal distribution. The log-normal distribution is simply
what you get when you exponentiate samples from the normal distribution:
*l**o**g**n**o**r**m**a**l*(*μ*,*σ*) = *e**x**p*(*N**o**r**m**a**l*(*μ*,*σ*))
. So let’s try this distribution out, adjusting our priors over `mu` and
`sigma`:

``` r
streams_model_lognormal <- cmdstan_model('2021-12-10-streams-lognormal.stan')  ## compile the model
streams_lognormal <- streams_model_lognormal$sample(data=streams_data)
streams_lognormal

streams_lognormal %>%
    gather_draws(y_hat) %>%
    ggplot(aes(x=.value, fill=.variable)) +
    stat_slab(slab_alpha=.75, fill=NA, color='black', data=filter(draws, .variable=='y_hat') %>% mutate(.variable='y_hat (normal)')) +
    stat_slab(slab_alpha=.75) +    
    stat_slab(slab_alpha=.75, data=tibble(.variable='y', .value=spotify2021$streams)) +
    geom_vline(xintercept=mean(spotify2021$streams)) +
    scale_fill_discrete(name='') +
    xlab('Streams (millions/week)') + ylab('Density') +
    coord_cartesian(xlim=c(-5, 10)) +
    theme_tidybayes()
```

<img src="/assets/images/2021-12-10-stan-intro/streams_lognormal_sample-1.png" style="display: block; margin: auto;" />

    ## Running MCMC with 4 sequential chains...
    ## 
    ## Chain 1 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 1 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 1 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 1 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 1 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 1 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 1 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 1 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 1 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 1 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 1 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 1 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 1 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 1 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 1 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 1 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 1 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 1 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 1 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 1 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 1 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 1 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 1 finished in 0.6 seconds.
    ## Chain 2 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 2 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 2 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 2 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 2 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 2 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 2 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 2 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 2 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 2 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 2 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 2 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 2 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 2 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 2 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 2 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 2 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 2 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 2 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 2 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 2 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 2 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 2 finished in 0.6 seconds.
    ## Chain 3 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 3 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 3 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 3 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 3 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 3 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 3 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 3 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 3 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 3 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 3 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 3 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 3 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 3 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 3 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 3 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 3 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 3 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 3 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 3 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 3 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 3 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 3 finished in 0.6 seconds.
    ## Chain 4 Iteration:    1 / 2000 [  0%]  (Warmup) 
    ## Chain 4 Iteration:  100 / 2000 [  5%]  (Warmup) 
    ## Chain 4 Iteration:  200 / 2000 [ 10%]  (Warmup) 
    ## Chain 4 Iteration:  300 / 2000 [ 15%]  (Warmup) 
    ## Chain 4 Iteration:  400 / 2000 [ 20%]  (Warmup) 
    ## Chain 4 Iteration:  500 / 2000 [ 25%]  (Warmup) 
    ## Chain 4 Iteration:  600 / 2000 [ 30%]  (Warmup) 
    ## Chain 4 Iteration:  700 / 2000 [ 35%]  (Warmup) 
    ## Chain 4 Iteration:  800 / 2000 [ 40%]  (Warmup) 
    ## Chain 4 Iteration:  900 / 2000 [ 45%]  (Warmup) 
    ## Chain 4 Iteration: 1000 / 2000 [ 50%]  (Warmup) 
    ## Chain 4 Iteration: 1001 / 2000 [ 50%]  (Sampling) 
    ## Chain 4 Iteration: 1100 / 2000 [ 55%]  (Sampling) 
    ## Chain 4 Iteration: 1200 / 2000 [ 60%]  (Sampling) 
    ## Chain 4 Iteration: 1300 / 2000 [ 65%]  (Sampling) 
    ## Chain 4 Iteration: 1400 / 2000 [ 70%]  (Sampling) 
    ## Chain 4 Iteration: 1500 / 2000 [ 75%]  (Sampling) 
    ## Chain 4 Iteration: 1600 / 2000 [ 80%]  (Sampling) 
    ## Chain 4 Iteration: 1700 / 2000 [ 85%]  (Sampling) 
    ## Chain 4 Iteration: 1800 / 2000 [ 90%]  (Sampling) 
    ## Chain 4 Iteration: 1900 / 2000 [ 95%]  (Sampling) 
    ## Chain 4 Iteration: 2000 / 2000 [100%]  (Sampling) 
    ## Chain 4 finished in 0.6 seconds.
    ## 
    ## All 4 chains finished successfully.
    ## Mean chain execution time: 0.6 seconds.
    ## Total execution time: 2.6 seconds.
    ##  variable     mean   median   sd  mad       q5      q95 rhat ess_bulk ess_tail
    ##     lp__  -5789.25 -5788.95 1.00 0.73 -5791.17 -5788.29 1.00     1781     2017
    ##     mu        0.81     0.81 0.00 0.00     0.81     0.82 1.00     3066     2334
    ##     sigma     0.45     0.45 0.00 0.00     0.44     0.45 1.00     2520     2268
    ##     y_hat     2.52     2.26 1.24 0.96     1.11     4.79 1.00     4131     3883

Clearly this model (blue) does a lot better at describing stream counts
than the previous one (black line), but it’s not perfect either.
Importantly, there is no single gold standard for model fit: a model
that fits perfectly fine for some purposes may not be good for other
purposes. So it is up to you, the modeler, to determine when your model
is good enough to inspect.

# Improving your model
