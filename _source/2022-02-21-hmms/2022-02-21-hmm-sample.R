library(tidyverse)
library(ggdist)

runif_lognormal <- function(Z, y_max, mu, sigma) {
    sapply(Z, function (z) ifelse(z == 1, rlnorm(1, mu, sigma), runif(1, 0, y_max)))
}

K <- 2                              ## number of states
pi <- c(1, 0)                       ## starting probabilities
theta <- matrix(c(.9, .1,           ## transition matrix
                  .25, .75),
                nrow=2, ncol=2,
                byrow=TRUE)

T <- 2500       ## number of time points to sample
Y_MAX <- 20     ## maxmimum uniform value for y
MU <- 1.5       ## lognormal location parameter
SIGMA <- 1/3    ## lognormal scale parameter

D <- tibble(trial=1:T, z=NA)   ## data set

## Sample latent states
D$z[1] <- 1
for (trial in 2:T) {
    D$z[trial] <- sample.int(K, 1, prob=theta[D$z[trial-1],])
}

## Same reaction times
D$rt <- runif_lognormal(D$z, Y_MAX, MU, SIGMA)

write_csv(D, '2022-02-21-reaction-times.csv')

## Plot
ggplot(D, aes(x=rt)) +
    geom_histogram(bins=100) +
    theme_classic()

D %>% filter(trial <= 100) %>%
    ggplot(aes(x=trial, y=z)) +
    geom_step() +
    theme_classic()


## for choosing a good MU/SIGMA
expand_grid(mu=c(1.5),
            sigma=c(0.33)) %>%
    ggplot(aes(xdist='lnorm', arg1=mu, arg2=sigma, group=mu, slab_fill=factor(mu))) +
    stat_halfeye() +
    facet_wrap(sigma ~ mu)
