---
title: "Data wrangling in the tidyverse"
author: kevin
categories: [ tutorial ]
image: https://www.tidyverse.org/images/hex-tidyverse.png
featured: true
output:
  html_document: default
  pdf_document: default
  md_document:
    variant: gfm
    preserve_yaml: TRUE
---

Today we’re going to tackle a common problem faced by graduate students:
you brainstormed to design an experiment with your PI, toiled away
programming the task, put it out into the world, and you finally got
your data! But there’s a catch: it’s the gnarliest spreadsheet you’ve
ever seen. You could try to clean it up in Excel, but the thought of
manually combing through thousands of data points just doesn’t seem
ideal. Not to mention that if you need to run the experiment again
(let’s face it, you probably will), you’ll have another ripe spreadsheet
for the cleaning. Cleaning data might not be your definition of a good
time, but chances are that you will be doing quite a good bit of it in
academia or in industry. So, it will help to streamline this process the
best you can.

There are lots of programming languages and packages that help with
wrangling data. But I’ve found that `R` makes things especially simple
with a relatively new set of tools known as the
[`tidyverse`](https://www.tidyverse.org). The name says it all: the
`tidyverse` is your one-stop-shop for making everything in your universe
tidy. Technically, `tidyverse` is a collection of `R` packages
(including `tidyr`, `dplyr`, and `ggplot`) contained within a
meta-package. If you don’t have `tidyverse` installed already, now is a
good time to do so:

``` r
install.packages('tidyverse')
```

And now we can import it:

``` r
library(tidyverse)   ## the only package we will ever need!
```

Now we’re ready to go! Before we get deep into the data, let’s talk a
little bit about how I tend to organize my data and code within a
project folder.

## File organization

To tidy our data, we first need to tidy our folders. One huge way that I
keep track of my files is by storing my projects in a
[GitHub](http://github.com) repository. As we covered in [this
post](https://dibsmethodsmeetings.github.io/magic-of-git/), a GitHub
repository is just a set of folders and files that are stored online on
GitHub’s servers. This is beyond the scope of this post, but putting
your files on GitHub means that you always have a backup, you can work
seamlessly on multiple computers or with collaborators, and you can
manage multiple versions of your files at the same time. And `git`
(without the hub) is a great way to get all of the benefits of version
control even if you don’t want to put the files online.

Once we have a folder for our new project (on GitHub, as a local `git`
repository, or just your everyday folder), we can start to put stuff in
that folder. Inside the folder I like to have: (a) a folder to store
data files (there will be at least two), (b) a script to wrangle that
data into a usable format, (c) one or more scripts to perform analyses,
(d) a folder to store plots and figures, and (e) if needed, other
folders to hold things like stimuli or code to run the experiment or to
run simulations. All in all, the file structure will look something like
this:

    project/
        pre-process.R
        analysis.R
        data/
            raw-data1.csv
            raw-data2.csv
            ...
            clean-data1.csv
            clean-data2.csv
            ...
        stimuli/
            stim1.png
            stim2.png
            ...
        exp/
            exp.html
            utils.js

Obviously things will vary from project to project, and you don’t need
to use this particular strategy, but I’ve found that sticking to a
standard makes things easy in the long run. It will also make it easier
on anyone else (collaborators, readers, etc) that might take a look at
your code.

## Back to the data

Now that that’s out of the way, we can return to the task at hand: data
wrangling. As a running example, I’m going to use (de-identified) data
from an actual experiment that I ran and we will walk through the code I
used to clean it up.

While I won’t go into any details about the experiment itself, it might
be helpful to know that this experiment was created through the platform
[Qualtrics](http://qualtrics.com), which is a pretty nice way to create
surveys on the web. While Qualtrics makes creating and distributing
surveys easy, however, it saves the data in a terrible format: one row
per participant. If you ask participants only one or two questions, this
format is probably fine. But most of the time psychologists tend to ask
people lots of questions, often asking the same types of questions over
and over again. To see how this can become a problem, let’s load our
dataset:

``` r
## this is the same as doing this in base R:
## raw_data <- read.csv('2021-09-24-raw-data.csv')

raw_data <- read_csv('2021-09-24-raw-data.csv')
raw_data
```

    ## # A tibble: 46 × 282
    ##    StartDate    EndDate    Status  IPAddress  Progress `Duration (in s… Finished
    ##    <chr>        <chr>      <chr>   <chr>      <chr>    <chr>            <chr>   
    ##  1 "Start Date" "End Date" "Respo… "IP Addre… "Progre… "Duration (in s… "Finish…
    ##  2 "{\"ImportI… "{\"Impor… "{\"Im… "{\"Impor… "{\"Imp… "{\"ImportId\":… "{\"Imp…
    ##  3 "10/9/20 10… "10/9/20 … "IP Ad…  <NA>      "100"    "2196"           "TRUE"  
    ##  4 "10/9/20 10… "10/9/20 … "IP Ad…  <NA>      "100"    "2655"           "TRUE"  
    ##  5 "10/9/20 10… "10/9/20 … "IP Ad…  <NA>      "100"    "1515"           "TRUE"  
    ##  6 "10/9/20 10… "10/9/20 … "IP Ad…  <NA>      "100"    "2699"           "TRUE"  
    ##  7 "10/9/20 10… "10/9/20 … "IP Ad…  <NA>      "100"    "1727"           "TRUE"  
    ##  8 "10/9/20 10… "10/9/20 … "IP Ad…  <NA>      "100"    "2614"           "TRUE"  
    ##  9 "10/9/20 10… "10/9/20 … "IP Ad…  <NA>      "100"    "2010"           "TRUE"  
    ## 10 "10/9/20 10… "10/9/20 … "IP Ad…  <NA>      "100"    "2365"           "TRUE"  
    ## # … with 36 more rows, and 275 more variables: RecordedDate <chr>,
    ## #   ResponseId <chr>, RecipientLastName <chr>, RecipientFirstName <chr>,
    ## #   RecipientEmail <chr>, ExternalReference <chr>, LocationLatitude <chr>,
    ## #   LocationLongitude <chr>, DistributionChannel <chr>, UserLanguage <chr>,
    ## #   Q119 <chr>, CheckQ1 <chr>, CheckQ1Again <chr>, CheckQ2 <chr>,
    ## #   CheckQ2Again <chr>, CheckQ3 <chr>, CheckQ3Again <chr>, Catch <chr>,
    ## #   1_LorRB1 <chr>, 1_VividB1_1 <chr>, 1_QuestionB1_1 <chr>, …

As we can see, this data frame has 282 columns, many of which carry
repeated observations of the same question per participant. You might
also notice that Qualtrics always reserves the first two rows to display
the text shown to participants and some internal information about the
question ID. Not the best.

### Removing personal identifiable information

This isn’t technically part of the data-wrangling process, but one
extremely important step is to make sure that your data does not carry
any information which can be used to identify the participants in your
study (especially if your data will be posted publicly online through
e.g. GitHub). For Qualtrics data in particular, you should be sure to
delete the data in the columns `IPAddress`, `RecipientLastName`,
`RecipientFirstName`, `RecipientEmail`, `ExternalReference`,
`LocationLatitude`, `LocationLongitude`. Making this data public likely
violates the ethical guidelines set by your IRB, and you won’t need it
anyway for most experiments since Qualtrics assigns each response an
anonymous unique ID.

### Slicing rows

The first thing we should do is get rid of those first two junk rows in
our data. Although we can do this with subscripting in base `R` as shown
in the comment, the `tidyverse` way to do this is with the `slice`
function:

``` r
## this is the same as doing this in base R:
## raw_data <- raw_data[-c(1, 2), ]

raw_data <- raw_data %>% slice(-1, -2)
raw_data
```

    ## # A tibble: 44 × 282
    ##    StartDate     EndDate   Status  IPAddress Progress `Duration (in se… Finished
    ##    <chr>         <chr>     <chr>   <chr>     <chr>    <chr>             <chr>   
    ##  1 10/9/20 10:27 10/9/20 … IP Add… <NA>      100      2196              TRUE    
    ##  2 10/9/20 10:26 10/9/20 … IP Add… <NA>      100      2655              TRUE    
    ##  3 10/9/20 10:46 10/9/20 … IP Add… <NA>      100      1515              TRUE    
    ##  4 10/9/20 10:30 10/9/20 … IP Add… <NA>      100      2699              TRUE    
    ##  5 10/9/20 10:47 10/9/20 … IP Add… <NA>      100      1727              TRUE    
    ##  6 10/9/20 10:33 10/9/20 … IP Add… <NA>      100      2614              TRUE    
    ##  7 10/9/20 10:49 10/9/20 … IP Add… <NA>      100      2010              TRUE    
    ##  8 10/9/20 10:46 10/9/20 … IP Add… <NA>      100      2365              TRUE    
    ##  9 10/9/20 10:59 10/9/20 … IP Add… <NA>      100      1637              TRUE    
    ## 10 10/9/20 11:00 10/9/20 … IP Add… <NA>      100      1847              TRUE    
    ## # … with 34 more rows, and 275 more variables: RecordedDate <chr>,
    ## #   ResponseId <chr>, RecipientLastName <chr>, RecipientFirstName <chr>,
    ## #   RecipientEmail <chr>, ExternalReference <chr>, LocationLatitude <chr>,
    ## #   LocationLongitude <chr>, DistributionChannel <chr>, UserLanguage <chr>,
    ## #   Q119 <chr>, CheckQ1 <chr>, CheckQ1Again <chr>, CheckQ2 <chr>,
    ## #   CheckQ2Again <chr>, CheckQ3 <chr>, CheckQ3Again <chr>, Catch <chr>,
    ## #   1_LorRB1 <chr>, 1_VividB1_1 <chr>, 1_QuestionB1_1 <chr>, …

Here the `slice` function slices out rows of your data frame. It takes
indices corresponding to the rows to slice out: positive numbers mean
that you only want those rows, but negative numbers means that you want
all the rows *besides* those ones. So we can see that we’ve taken out
those first two needless rows.

P.S., if you haven’t seen the pipe `%>%` before, it’s just another way
of writing the same code like this:

``` r
raw_data <- slice(raw_data, -1, -2)
```

Right now it might seem silly to use the pipe over the traditional
syntax. But once we’re all done, the pipe will make it easy to chain all
of our data cleaning steps together in a nice, readable manner.

### Selecting columns

The next thing we’ll want to do is to get rid of any needless columns:
we can do this using the function `select`. Again, the negative signs
mean that we want to take these columns *out*. If we want to use only
the specified columns, we can take away the negative signs. Another
useful thing about `select` is that in addition to column numbers, we
can also use the column names, or any of the convenient [selection
operators](https://tidyselect.r-lib.org/reference/language.html), which
let you select all the columns starting with, ending with, containing,
or matching a particular pattern. Since we have so many columns to deal
with, let’s just take out the ones that we don’t want:

``` r
## this is the same as doing this in base R:
##raw_data <- subset(raw_data,
##                   select=-c(1:5, 7:8, 10:18, LorR,
##                             PROLIFIC_PID, STUDY_ID, SESSION_ID))

raw_data <- raw_data %>%
    select(-c(1:5, 7:8, 10:18),-LorR, -PROLIFIC_PID, -STUDY_ID, -SESSION_ID)
raw_data
```

    ## # A tibble: 44 × 262
    ##    `Duration (in s… ResponseId CheckQ1 CheckQ1Again CheckQ2 CheckQ2Again CheckQ3
    ##    <chr>            <chr>      <chr>   <chr>        <chr>   <chr>        <chr>  
    ##  1 2196             R_1QcKka5… Think … <NA>         Think … <NA>         Think …
    ##  2 2655             R_1K3lQMR… Think … <NA>         Think … <NA>         Think …
    ##  3 1515             R_3lxA7oc… Think … <NA>         Think … <NA>         Think …
    ##  4 2699             R_vc9p5Yz… Think … <NA>         Think … <NA>         Think …
    ##  5 1727             R_e2QJ1rg… Think … <NA>         Think … <NA>         Think …
    ##  6 2614             R_21gO8x8… Think … <NA>         Think … <NA>         Think …
    ##  7 2010             R_Z5119oa… Think … <NA>         Think … <NA>         Think …
    ##  8 2365             R_SAxC9m2… Think … <NA>         Think … <NA>         Think …
    ##  9 1637             R_31EiTJU… Think … <NA>         Think … <NA>         Think …
    ## 10 1847             R_1fZ7rZp… Think … <NA>         Think … <NA>         Think …
    ## # … with 34 more rows, and 255 more variables: CheckQ3Again <chr>, Catch <chr>,
    ## #   1_LorRB1 <chr>, 1_VividB1_1 <chr>, 1_QuestionB1_1 <chr>,
    ## #   1_ConfidenceB1_1 <chr>, 1_CheckB1 <chr>, 2_LorRB1 <chr>, 2_VividB1_1 <chr>,
    ## #   2_QuestionB1_1 <chr>, 2_ConfidenceB1_1 <chr>, 2_CheckB1 <chr>,
    ## #   3_LorRB1 <chr>, 3_VividB1_1 <chr>, 3_QuestionB1_1 <chr>,
    ## #   3_ConfidenceB1_1 <chr>, 3_CheckB1 <chr>, 4_LorRB1 <chr>, 4_VividB1_1 <chr>,
    ## #   4_QuestionB1_1 <chr>, 4_ConfidenceB1_1 <chr>, 4_CheckB1 <chr>, …

### Renaming columns

Now that the junk is cleared out, we can see that some of the column
names are a bit clunky (like `Duration (in seconds)`). So, our next step
is going to be to rename any of the columns we want, but have clunky
names. Not surprisingly, the `rename` function does just that:

``` r
## this is the same as doing this in base R:
## names(raw_data)[names(raw_data) == 'Duration (in seconds)'] <- 'duration'
## names(raw_data)[names(raw_data) == 'ResponseId'] <- 'id'
## ...
## names(raw_data)[names(raw_data) == 'VorV_5'] <- 'visual_verbal'

raw_data <- raw_data %>%
    rename(duration=`Duration (in seconds)`,
           id=ResponseId,
           catch=Catch,
           attn_check=AttnCheck,
           condition=Condition,
           gender=Gender,
           gender_text=Gender_4_TEXT,
           race=Race,
           race_text=Race_7_TEXT,
           hispanic=`Hispanic?`,
           education=Education,
           age=Age,
           feedback=Feedback,
           display=Display,
           visual_verbal=VorV_5)
raw_data
```

    ## # A tibble: 44 × 262
    ##    duration id    CheckQ1 CheckQ1Again CheckQ2 CheckQ2Again CheckQ3 CheckQ3Again
    ##    <chr>    <chr> <chr>   <chr>        <chr>   <chr>        <chr>   <chr>       
    ##  1 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  2 2655     R_1K… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  3 1515     R_3l… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  4 2699     R_vc… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  5 1727     R_e2… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  6 2614     R_21… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  7 2010     R_Z5… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  8 2365     R_SA… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  9 1637     R_31… Think … <NA>         Think … <NA>         Think … <NA>        
    ## 10 1847     R_1f… Think … <NA>         Think … <NA>         Think … <NA>        
    ## # … with 34 more rows, and 254 more variables: catch <chr>, 1_LorRB1 <chr>,
    ## #   1_VividB1_1 <chr>, 1_QuestionB1_1 <chr>, 1_ConfidenceB1_1 <chr>,
    ## #   1_CheckB1 <chr>, 2_LorRB1 <chr>, 2_VividB1_1 <chr>, 2_QuestionB1_1 <chr>,
    ## #   2_ConfidenceB1_1 <chr>, 2_CheckB1 <chr>, 3_LorRB1 <chr>, 3_VividB1_1 <chr>,
    ## #   3_QuestionB1_1 <chr>, 3_ConfidenceB1_1 <chr>, 3_CheckB1 <chr>,
    ## #   4_LorRB1 <chr>, 4_VividB1_1 <chr>, 4_QuestionB1_1 <chr>,
    ## #   4_ConfidenceB1_1 <chr>, 4_CheckB1 <chr>, 5_LorRB1 <chr>, …

Not all of these are totally necessary (I just like having things in
lowercase), but it’s good to do all of this at once if you can. You can
also see that a bunch of the later columns all end with “`_1`” for some
reason (thanks Qualtrics). To rename them all at the same time, let’s
use `rename_with`:

``` r
## this is the same as doing this in base R:
## names(raw_data) <- gsub('_1$', '', names(raw_data))

raw_data <- raw_data %>%
    rename_with(~ str_remove(., '_1'), ends_with('_1'))
raw_data
```

    ## # A tibble: 44 × 262
    ##    duration id    CheckQ1 CheckQ1Again CheckQ2 CheckQ2Again CheckQ3 CheckQ3Again
    ##    <chr>    <chr> <chr>   <chr>        <chr>   <chr>        <chr>   <chr>       
    ##  1 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  2 2655     R_1K… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  3 1515     R_3l… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  4 2699     R_vc… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  5 1727     R_e2… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  6 2614     R_21… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  7 2010     R_Z5… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  8 2365     R_SA… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  9 1637     R_31… Think … <NA>         Think … <NA>         Think … <NA>        
    ## 10 1847     R_1f… Think … <NA>         Think … <NA>         Think … <NA>        
    ## # … with 34 more rows, and 254 more variables: catch <chr>, 1_LorRB1 <chr>,
    ## #   1_VividB1 <chr>, 1_QuestionB1 <chr>, 1_ConfidenceB1 <chr>, 1_CheckB1 <chr>,
    ## #   2_LorRB1 <chr>, 2_VividB1 <chr>, 2_QuestionB1 <chr>, 2_ConfidenceB1 <chr>,
    ## #   2_CheckB1 <chr>, 3_LorRB1 <chr>, 3_VividB1 <chr>, 3_QuestionB1 <chr>,
    ## #   3_ConfidenceB1 <chr>, 3_CheckB1 <chr>, 4_LorRB1 <chr>, 4_VividB1 <chr>,
    ## #   4_QuestionB1 <chr>, 4_ConfidenceB1 <chr>, 4_CheckB1 <chr>, 5_LorRB1 <chr>,
    ## #   5_VividB1 <chr>, 5_QuestionB1 <chr>, 5_ConfidenceB1 <chr>, …

There are three tricks going on here. First, the function `str_remove`
removes pieces of strings (like our “`_1`”) and comes from the package
`stringr`, which is a member of the `tidyverse`. Second, the funny
syntax with the `~` and the `.` creates an anonymous function that gets
called on all of the column names. `~` is a stand-in telling `R` that
this is a function, and the `.` is a stand-in for the argument passed to
that function (in our case, the column name). Finally, the function
`ends_with` lets us only rename the columns that end with “`_1`”.

### Pivoting to a longer format

Our next problem is that we have a bunch of columns with similar names.
In this experiment, participants completed 48 trials of the same set of
questions under different sets of conditions, split up into four blocks
of 12 trials. So, a bunch of our columns are formatted like `4_VividB1`,
where the `4` is the trial number, `Vivid` is the name of the question,
and `B1` signifies the first block of trials. Ideally, instead of having
a separate column for each presentation of each question, we would have
a row for each trial, with columns for each question type. The format we
have is called a *wide* format, and the format we want is a *long*
format, for obvious reasons.

The `pivot_longer` function converts data frames from wide to long
format. To give you a clearer picture of what this means, imagine we
have this tiny data set:

``` r
tiny_data <- data.frame(id=c('P1', 'P2'), Q1=c(1, 2), Q2=c(3, 4), Q3=c(5, 6))
tiny_data
```

    ##   id Q1 Q2 Q3
    ## 1 P1  1  3  5
    ## 2 P2  2  4  6

This format is “wide” because we have more columns than rows. If we call
`pivot_longer` on this data, instead of having one row per participant,
we will get a row per question:

``` r
tiny_data %>% pivot_longer(Q1:Q3, names_to='question', values_to='response')
```

    ## # A tibble: 6 × 3
    ##   id    question response
    ##   <chr> <chr>       <dbl>
    ## 1 P1    Q1              1
    ## 2 P1    Q2              3
    ## 3 P1    Q3              5
    ## 4 P2    Q1              2
    ## 5 P2    Q2              4
    ## 6 P2    Q3              6

Here the argument `Q1:Q3` specifies the range of columns we want to
pivot, `names_to` is the name of the column containing the old column
names, and `values_to` is the name of the column containing all of the
values stored in our old columns. As we can see, long format is a less
compact form of the data (it duplicates some information), but it is the
kind of data you typically need for statistical analyses, and really,
long format is often easier to think about than wide format. Now let’s
try to pivot our data into long format:

``` r
## it's not even worth trying to do this in base R...

raw_data <- raw_data %>%
    pivot_longer(`1_LorRB1`:`12_CheckB4`,
                 names_pattern='([[:digit:]]+)_(.+)B([[:digit:]]+)',
                 names_to=c('loop', 'question', 'block'))
raw_data
```

    ## # A tibble: 10,560 × 26
    ##    duration id    CheckQ1 CheckQ1Again CheckQ2 CheckQ2Again CheckQ3 CheckQ3Again
    ##    <chr>    <chr> <chr>   <chr>        <chr>   <chr>        <chr>   <chr>       
    ##  1 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  2 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  3 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  4 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  5 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  6 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  7 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  8 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  9 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ## 10 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ## # … with 10,550 more rows, and 18 more variables: catch <chr>, gender <chr>,
    ## #   gender_text <chr>, age <chr>, hispanic <chr>, race <chr>, race_text <chr>,
    ## #   education <chr>, visual_verbal <chr>, attn_check <chr>, feedback <chr>,
    ## #   condition <chr>, other <chr>, display <chr>, loop <chr>, question <chr>,
    ## #   block <chr>, value <chr>

There’s a lot going on here, so let’s unpack. The first argument to
`pivot_longer` is the same as before: it is just the range of columns we
want to pivot. Normally `pivot_longer` would give us a column with all
of those column names in it. But since these column names all follow a
particular pattern (loops of questions in blocks), we can use
`names_pattern` to extract the loop number, the question name, and the
block number for us. I won’t go into details here, but that nasty string
is what’s called a regular expression (or regex for short). All you need
to know is that the three sets of parentheses in this string correspond
to the three pieces of information we’re getting from that one column
name: the loop, the question, and the block. As we can see, we get a new
column for each of these three, as well as a column `value` for the
responses to each question.

### Pivoting to a wider format

Sadly, this format is a little *too* long for us: the `value` column
contains different data types (numbers, strings) from different
questions. To get a single row per trial (not per question), we need to
pivot to a slightly wider format:

``` r
## again, good luck doing this in base R

raw_data <- raw_data %>%
    pivot_wider(names_from=question, values_from=value, names_repair='unique') %>%
    rename(lr=LorR,
           rating=Question,
           vividness=Vivid,
           confidence=Confidence,
           check=Check)
raw_data
```

    ## # A tibble: 2,112 × 29
    ##    duration id    CheckQ1 CheckQ1Again CheckQ2 CheckQ2Again CheckQ3 CheckQ3Again
    ##    <chr>    <chr> <chr>   <chr>        <chr>   <chr>        <chr>   <chr>       
    ##  1 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  2 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  3 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  4 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  5 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  6 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  7 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  8 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  9 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ## 10 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ## # … with 2,102 more rows, and 21 more variables: catch <chr>, gender <chr>,
    ## #   gender_text <chr>, age <chr>, hispanic <chr>, race <chr>, race_text <chr>,
    ## #   education <chr>, visual_verbal <chr>, attn_check <chr>, feedback <chr>,
    ## #   condition <chr>, other <chr>, display <chr>, loop <chr>, block <chr>,
    ## #   lr <chr>, vividness <chr>, rating <chr>, confidence <chr>, check <chr>

Hopefully this is pretty understandable in relation to `pivot_longer`:
instead of stretching columns out into rows, we’re squashing the rows
into columns. The names of the new columns are the values in the old
`question` column, and the values in the new column are the values in
the old `value` column. Afterwards, I renamed some of the new columns
that just popped up. As we hoped for, we now have a data frame with one
row per trial. This is a much more manageable 33 columns instead of 282
columns.

### Joining data frames

At this point we’re at a pretty good spot: we can see all of the data by
trial. One thing that isn’t great is that we don’t have any of the
information about experimental conditions within each loop. In
Qualtrics, you can assign each loop a different experimental condition,
and Qualtrics will make sure to display them in random order. Since we
only have 12 loops, it is easy enough to just write out the assigned
conditions for each loop:

``` r
conditions <- data.frame(loop=as.character(1:12),
                         outcome=rep(c('Score', 'Miss'), 2, each=3),
                         cue=rep(c('Remember', 'What If?', 'Cause'), 4))
conditions
```

    ##    loop outcome      cue
    ## 1     1   Score Remember
    ## 2     2   Score What If?
    ## 3     3   Score    Cause
    ## 4     4    Miss Remember
    ## 5     5    Miss What If?
    ## 6     6    Miss    Cause
    ## 7     7   Score Remember
    ## 8     8   Score What If?
    ## 9     9   Score    Cause
    ## 10   10    Miss Remember
    ## 11   11    Miss What If?
    ## 12   12    Miss    Cause

We can see that each loop has a unique outcome (score or miss) and a
unique cue. To import this information into `raw_data`, we can use the
function `left_join`, which keeps all of the rows from the first data
frame, and adds columns from the right data frame:

``` r
## this is the same as doing this in base R:
## raw_data$outcome <- conditions$outcome[sapply(raw_data$loop, function(l) which(l == conditions$loop))]
## raw_data$cue <- conditions$cue[sapply(raw_data$loop, function(l) which(l == conditions$loop))]

raw_data <- raw_data %>% left_join(conditions)
```

`tidyverse` tells us that it’s joining our data frames by the `loop`
column, and it gives us what we want: our old data frame, with new
columns for the outcome and cue for the corresponding loop in that row.

### Mutating columns

One of the last weird things about our data frame is that all of the
columns are characters. This is an unfortunate consequence of those two
junk rows from earlier, which contained strings in every column. To fix
that, we need to change the data types of all of the incorrectly-typed
columns. The `mutate` function lets us change existing columns as well
as add new columns:

``` r
## this is the same as doing this in base R:
## raw_data$loop <- as.numeric(raw_data$loop)
## raw_data$block <- as.numeric(raw_data$block)
## raw_data$display <- ifelse(raw_data$block < 3, 'up', 'down')
## raw_data$condition <- word(raw_data$condition, 2)
## raw_data$lr_other <- ifelse(raw_data$outcome=='Miss', lr, ifelse(raw_data$lr=='right', 'left', 'right'))

raw_data <- raw_data %>%
    mutate(loop=as.numeric(loop),
           block=as.numeric(block),
           display=ifelse(block < 3, 'up', 'down'),
           condition=word(condition, 2),
           lr_other=ifelse(outcome=='Miss', lr, ifelse(lr=='right', 'left', 'right')))
raw_data
```

    ## # A tibble: 2,112 × 32
    ##    duration id    CheckQ1 CheckQ1Again CheckQ2 CheckQ2Again CheckQ3 CheckQ3Again
    ##    <chr>    <chr> <chr>   <chr>        <chr>   <chr>        <chr>   <chr>       
    ##  1 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  2 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  3 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  4 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  5 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  6 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  7 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  8 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ##  9 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ## 10 2196     R_1Q… Think … <NA>         Think … <NA>         Think … <NA>        
    ## # … with 2,102 more rows, and 24 more variables: catch <chr>, gender <chr>,
    ## #   gender_text <chr>, age <chr>, hispanic <chr>, race <chr>, race_text <chr>,
    ## #   education <chr>, visual_verbal <chr>, attn_check <chr>, feedback <chr>,
    ## #   condition <chr>, other <chr>, display <chr>, loop <dbl>, block <dbl>,
    ## #   lr <chr>, vividness <chr>, rating <chr>, confidence <chr>, check <chr>,
    ## #   outcome <chr>, cue <chr>, lr_other <chr>

It isn’t really important what these new columns are, what matters is
that `mutate` can both add columns and change existing ones at the same
time.

### Relocating columns

Finally, I like to have all of the columns describing participant
IDs/condition names first, followed by the responses each participant
makes, and finally any remaining columns storing things like demographic
information or attention checks. You can put your columns in any order
that makes sense, but it’s nice to stick to a system. We can use the
function `relocate` to reorder the columns in this way:

``` r
## this is the same as doing this in base R:
## raw_data <- raw_data[,c('id', 'condition', 'other', 'block', 'display', 'loop', 'outcome', 'cue',
##                        'lr', 'vividness', 'rating', 'confidence', 'check', 'lr_other',
##                        'duration', 'gender', 'gender_text', 'age', 'race', 'race_text',
##                        'hispanic', 'education', 'visual_verbal', 'feedback', 'CheckQ1', 'CheckQ1Again',
##                        'CheckQ2', 'CheckQ2Again', 'CheckQ3', 'CheckQ3Again', 'catch', 'attn_check')]

raw_data <- raw_data %>%
    relocate(id, condition, other, block, display, loop, outcome, cue,
             lr, vividness, rating, confidence, check, lr_other,
             duration, gender, gender_text, age, race, race_text,
             hispanic, education, visual_verbal, feedback, CheckQ1, CheckQ1Again,
             CheckQ2, CheckQ2Again, CheckQ3, CheckQ3Again, catch, attn_check)
raw_data
```

    ## # A tibble: 2,112 × 32
    ##    id        condition other  block display  loop outcome cue    lr    vividness
    ##    <chr>     <chr>     <chr>  <dbl> <chr>   <dbl> <chr>   <chr>  <chr> <chr>    
    ##  1 R_1QcKka… goalie    the b…     1 up          1 Score   Remem… right 80.139   
    ##  2 R_1QcKka… goalie    the b…     1 up          2 Score   What … right 73.52    
    ##  3 R_1QcKka… goalie    the b…     1 up          3 Score   Cause  right 96.055   
    ##  4 R_1QcKka… goalie    the b…     1 up          4 Miss    Remem… right 96.617   
    ##  5 R_1QcKka… goalie    the b…     1 up          5 Miss    What … left  94.505   
    ##  6 R_1QcKka… goalie    the b…     1 up          6 Miss    Cause  left  86.336   
    ##  7 R_1QcKka… goalie    the b…     1 up          7 Score   Remem… right 98.872   
    ##  8 R_1QcKka… goalie    the b…     1 up          8 Score   What … right 91.97    
    ##  9 R_1QcKka… goalie    the b…     1 up          9 Score   Cause  right 73.802   
    ## 10 R_1QcKka… goalie    the b…     1 up         10 Miss    Remem… left  99.716   
    ## # … with 2,102 more rows, and 22 more variables: rating <chr>,
    ## #   confidence <chr>, check <chr>, lr_other <chr>, duration <chr>,
    ## #   gender <chr>, gender_text <chr>, age <chr>, race <chr>, race_text <chr>,
    ## #   hispanic <chr>, education <chr>, visual_verbal <chr>, feedback <chr>,
    ## #   CheckQ1 <chr>, CheckQ1Again <chr>, CheckQ2 <chr>, CheckQ2Again <chr>,
    ## #   CheckQ3 <chr>, CheckQ3Again <chr>, catch <chr>, attn_check <chr>

### Writing to a file

The last thing to do, of course, is to save our nice and clean data into
an output file:

``` r
## this is the same as doing this in base R:
## write.csv(raw_data, '2021-09-24-clean-data.csv')

raw_data %>% write_csv('2021-09-24-clean-data.csv')
```

### Putting it all together

Remember when I said that using pipes will make sense sooner or later?
Well the time has come. Now that we have our full data wrangling
pipeline set up, we can write it out all together like so:

``` r
read_csv('2021-09-24-raw-data.csv') %>%
    ## subset rows/columns
    slice(-1, -2) %>%
    select(-c(1:5, 7:8, 10:18),-LorR, -PROLIFIC_PID, -STUDY_ID, -SESSION_ID) %>%

    ## rename columns
    rename(duration=`Duration (in seconds)`,
           id=ResponseId,
           catch=Catch,
           attn_check=AttnCheck,
           condition=Condition,
           gender=Gender,
           gender_text=Gender_4_TEXT,
           race=Race,
           race_text=Race_7_TEXT,
           hispanic=`Hispanic?`,
           education=Education,
           age=Age,
           feedback=Feedback,
           display=Display,
           visual_verbal=VorV_5) %>%
    rename_with(~ str_remove(., '_1'), ends_with('_1')) %>%

    ## convert to one row per trial
    pivot_longer(`1_LorRB1`:`12_CheckB4`,
                 names_pattern='([[:digit:]]+)_(.+)B([[:digit:]]+)',
                 names_to=c('loop', 'question', 'block')) %>%
    pivot_wider(names_from=question, values_from=value, names_repair='unique') %>%
    rename(lr=LorR,
           rating=Question,
           vividness=Vivid,
           confidence=Confidence,
           check=Check) %>%

    ## add condition information
    left_join(conditions) %>%
    mutate(loop=as.numeric(loop),
           block=as.numeric(block),
           display=ifelse(block < 3, 'up', 'down'),
           condition=word(condition, 2),
           lr_other=ifelse(outcome=='Miss', lr, ifelse(lr=='right', 'left', 'right'))) %>%

    ## reorder columns
    relocate(id, condition, other, block, display, loop, outcome, cue,
             lr, vividness, rating, confidence, check, lr_other,
             duration, gender, gender_text, age, race, race_text,
             hispanic, education, visual_verbal, feedback, CheckQ1, CheckQ1Again,
             CheckQ2, CheckQ2Again, CheckQ3, CheckQ3Again, catch, attn_check) %>%
    write_csv('2021-09-24-clean-data.csv')
```

Having your data wrangling pipeline written out like this is nice
because it is relatively easy to follow all of the steps one-by-one to
see what’s going on, and it can easily be used to wrangle similar
datasets in the future. As I said earlier, I usually keep this kind of
code in a file separate from my analyses, so that my analysis code can
just load the cleaned data and get to work.

## Bonus: excluding and pre-processing data

After your data has been wrangled, you still might not be ready to do
your analyses. Typically, you will also need to exclude bad data and
pre-process some of the columns. You could decide to do this in your
data-wrangling script, or to do it in your analysis code. Either way,
let’s try it out as a treat.

### Filtering out bad data

Like all things, `tidyverse` makes filtering out data easy with the
`filter` function. Besides your data frame, this function takes one or
more arguments, which are conditions that your data needs to meet in
order to pass through the filter. For instance, `raw_data` contains a
column `catch`, which corresponds to a question intended to catch bots
(this question involves simply reading text from an image). Let’s get
only the data that passes this (and other) checks:

``` r
raw_data <- raw_data %>%
    filter(catch == 'IM_74Ef0wh1bD6qdZb' & attn_check == 'Yes')
raw_data
```

    ## # A tibble: 1,776 × 32
    ##    id        condition other  block display  loop outcome cue    lr    vividness
    ##    <chr>     <chr>     <chr>  <dbl> <chr>   <dbl> <chr>   <chr>  <chr> <chr>    
    ##  1 R_1QcKka… goalie    the b…     1 up          1 Score   Remem… right 80.139   
    ##  2 R_1QcKka… goalie    the b…     1 up          2 Score   What … right 73.52    
    ##  3 R_1QcKka… goalie    the b…     1 up          3 Score   Cause  right 96.055   
    ##  4 R_1QcKka… goalie    the b…     1 up          4 Miss    Remem… right 96.617   
    ##  5 R_1QcKka… goalie    the b…     1 up          5 Miss    What … left  94.505   
    ##  6 R_1QcKka… goalie    the b…     1 up          6 Miss    Cause  left  86.336   
    ##  7 R_1QcKka… goalie    the b…     1 up          7 Score   Remem… right 98.872   
    ##  8 R_1QcKka… goalie    the b…     1 up          8 Score   What … right 91.97    
    ##  9 R_1QcKka… goalie    the b…     1 up          9 Score   Cause  right 73.802   
    ## 10 R_1QcKka… goalie    the b…     1 up         10 Miss    Remem… left  99.716   
    ## # … with 1,766 more rows, and 22 more variables: rating <chr>,
    ## #   confidence <chr>, check <chr>, lr_other <chr>, duration <chr>,
    ## #   gender <chr>, gender_text <chr>, age <chr>, race <chr>, race_text <chr>,
    ## #   hispanic <chr>, education <chr>, visual_verbal <chr>, feedback <chr>,
    ## #   CheckQ1 <chr>, CheckQ1Again <chr>, CheckQ2 <chr>, CheckQ2Again <chr>,
    ## #   CheckQ3 <chr>, CheckQ3Again <chr>, catch <chr>, attn_check <chr>

We can also get this same result two other ways, if you like one of
these better:

``` r
raw_data %>%
    filter(catch == 'IM_74Ef0wh1bD6qdZb', attn_check == 'Yes')

raw_data %>%
    filter(catch == 'IM_74Ef0wh1bD6qdZb') %>%
    filter(attn_check == 'Yes')
```

This same method works for all kinds of exclusions (pretty much anything
you would need).

### Pre-processing data

Another thing you might need to do is pre-process your data in some way.
For instance, some people like to z-score their data, which gives it a
mean of 0 and a standard deviation of 1. In other cases, you might do
some averaging, smoothing, convolutions/filtering, etc. In my case, I
typically just want to re-scale the slider ratings from their default
0-100 range to the range 0-1. In any case, we can simply use the
`mutate` function as above:

``` r
raw_data <- raw_data %>%
    mutate(vividness=as.numeric(vividness)/100,
           rating=as.numeric(rating)/100,
           confidence=as.numeric(confidence)/100)
raw_data
```

    ## # A tibble: 1,776 × 32
    ##    id        condition other  block display  loop outcome cue    lr    vividness
    ##    <chr>     <chr>     <chr>  <dbl> <chr>   <dbl> <chr>   <chr>  <chr>     <dbl>
    ##  1 R_1QcKka… goalie    the b…     1 up          1 Score   Remem… right     0.801
    ##  2 R_1QcKka… goalie    the b…     1 up          2 Score   What … right     0.735
    ##  3 R_1QcKka… goalie    the b…     1 up          3 Score   Cause  right     0.961
    ##  4 R_1QcKka… goalie    the b…     1 up          4 Miss    Remem… right     0.966
    ##  5 R_1QcKka… goalie    the b…     1 up          5 Miss    What … left      0.945
    ##  6 R_1QcKka… goalie    the b…     1 up          6 Miss    Cause  left      0.863
    ##  7 R_1QcKka… goalie    the b…     1 up          7 Score   Remem… right     0.989
    ##  8 R_1QcKka… goalie    the b…     1 up          8 Score   What … right     0.920
    ##  9 R_1QcKka… goalie    the b…     1 up          9 Score   Cause  right     0.738
    ## 10 R_1QcKka… goalie    the b…     1 up         10 Miss    Remem… left      0.997
    ## # … with 1,766 more rows, and 22 more variables: rating <dbl>,
    ## #   confidence <dbl>, check <chr>, lr_other <chr>, duration <chr>,
    ## #   gender <chr>, gender_text <chr>, age <chr>, race <chr>, race_text <chr>,
    ## #   hispanic <chr>, education <chr>, visual_verbal <chr>, feedback <chr>,
    ## #   CheckQ1 <chr>, CheckQ1Again <chr>, CheckQ2 <chr>, CheckQ2Again <chr>,
    ## #   CheckQ3 <chr>, CheckQ3Again <chr>, catch <chr>, attn_check <chr>

## Conclusions

If you’re new to `tidyverse` or to `R` in general, hopefully this post
convinced you that cleaning data manually in Excel isn’t the way to go.
It might take some initial investment, but doing things the tidy way is
sure to save you time and effort in the long run. Happy wrangling!
