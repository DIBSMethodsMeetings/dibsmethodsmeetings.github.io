---
author: shenyang
categories:
- programming
featured: true
image: assets/images/2022-11-11-biac-cluster/hellskitchen.jpg
output:
  html_document: default
  md_document:
    preserve_yaml: true
    variant: gfm
  pdf_document: default
title: BIAC Cluster
---

This tutorial introduces the computational cluster at the Duke Brain Imaging and Analysis Center (BIAC) and presents a few simple use cases. Hopefully it will make your experience handling/analyzing neural data from BIAC less miserable. 

- [What is a computational cluster](#what-cluster)
- [Set up](#setup)
- [Example 1 - shell script](#eg1)
- [Example 2 - MATLAB](#eg2)
- [Example 3 - qsub](#eg3)

<br>

## What is a computational cluster {#what-cluster}

A computational cluster (also known ask computing cluster, computer cluster, or cluster), put simply, is a group of connected processor, where each processor is capable of a certain amount of computation. In that sense, a cluster is qualitatively not much different from our personal computers; the major difference is the quantity of processors. My desktop has 12, and the BIAC cluster has 720. (Read more about the cluster's [hardware](https://www.biac.duke.edu/facilities/computing-facilities) and [architecture](https://wiki.biac.duke.edu/biac:cluster:architecture).)

<img src="/assets/images/2022-11-11-biac-cluster/cpu.png" style="display: block; margin: auto;" />
<center>Our laptops and desktops also have processors</center>
<br>


To better contextualize what having many processors can do and reason why one might want to utilize the BIAC cluster, let's talk about cooking--as an analogy. Cooking is the process of chopping, combining, and/or heating ingredients in a way that produces food we can--and will--eat. This process is a lot like data analysis: we turn collected raw data (groceries) into some final statistics (cuisine) that we can better digest!


Here is a table of analogous concepts in data analysis and cooking:

{:class="table table-bordered"}
|  Data analysis  |  Cooking  |
|  --------------  |  --------------  |
|  Raw data (e.g., fMRI)  |  raw groceries  |
|  Data storage server (Munin) |  pantry and fridge  |
|  Analysis script  |  recipe  |
|  Software  |  appliance (stove, oven, microwave, etc.)  |
|  Processor  |  chef  |
|  Statistic  |  cuisine  |


Here's a random recipe you might enjoy.
<img src="/assets/images/2022-11-11-biac-cluster/recipe.jpg" style="display: block; margin: auto;" />


Importantly, one processor is capable of handling one process at one time, like a chef who is 100% focused on one dish at a time. Therefore, when you want just one analysis done, having one chef is just enough. Like this:
<img src="/assets/images/2022-11-11-biac-cluster/kitchen.jpg" style="display: block; margin: auto;" />

However, we often need to perform very similar but independent operations over and over again, for example, preprocessing fMRI data for 20 participants, where the process for each participant can take about 1 hour. In those cases, instead of analyzing the subject serially--finish participant 1 and then start participant 2, you may want to applying parallel computing (https://www.wikiwand.com/en/Parallel_computing) -- instruct 10 processors to operate on 10 participants simultaneously (in parallel). While it is possible to use parallelism on personal computers, the BIAC cluster can often finish the operations faster. 
<img src="/assets/images/2022-11-11-biac-cluster/hellskitchen.jpg" style="display: block; margin: auto;" />
<br>


## Set up {#setup}

The BIAC cluster is no doubt a powerful tool for (neural) data analysis, but it takes quite a few annoying steps to set up the connection before anything can happen. 

a) [Request access](https://wiki.biac.duke.edu/biac:accounts) to BIAC computers and experiment folders

b) Get behind the Duke Health Enterprise (DHE) firewall by doing one of the following
  - Use BIAC computers--they are connected to the internet via ethernet cables (e.g., the dear old "Piaget" in MOCK)
  - Use the DHE wireless network at BIAC
  - Use the [DHE VPN](https://dmvpn.duhs.duke.edu/). (If you need help, visit the [Duke Health IT](http://dhts.duke.edu/), not the [Duke OIT](https://oit.duke.edu/)).

c) Map network drives (optional but recommended) 
  - Check out these tutorials: [DIBS IT FAQ](https://dibs.duke.edu/dibs-information-technology-faqs/) and [BIAC wiki](https://wiki.biac.duke.edu/biac:macsmb).

d) [Connect](https://wiki.biac.duke.edu/biac:cluster:access) to the cluster
  - The BIAC wiki page suggests X-Win32 for Windows users, but I found [MobaXterm](https://mobaxterm.mobatek.net/) much easier to use.

e) Find your experiment
  - Enter the interactive mode using the `qinteract` command in order to interact directly with your data on Munin
  - Use command `findexp MemCFT.01` to print the location
  - To get there directly, use ``cd `findexp MemCFT.01` ``

We are now able to use the BIAC cluster to operate on data stored on the Munin server. Here is a list of useful commands:

{:class="table table-bordered"}
|  `ls`  |  list contents of the directory  |
|  `cd`  |  change directory |
|  `mkdir`  |  make directory  |
|  `rm`  |  remove contents |
|  `cp`  |  copy |
|  `sh`  |  run shell scripts |
|  `qstat`  |  check status of current jobs |
|  `qstatall`  |  check status of current jobs from all users |
|  `python`  |  command mode only  |
|  `R`  |  command mode only |
|  `matlab`  |  default is GUI mode; use `-nodesktop` for command mode  |
|  `fsl`  |  default is GUI mode |


Check out what other [packages](https://wiki.biac.duke.edu/biac:cluster:packages) and [modules](https://wiki.biac.duke.edu/biac:cluster:modules) are available on the cluster. 

<br>


## Example 1 - shell script {#eg1}

Here we have a fairly simple shell script [example1.sh](https://raw.githubusercontent.com/DIBSMethodsMeetings/dibsmethodsmeetings.github.io/master/_source/2022-11-11-biac-cluster/example1.sh) that demonstrates a few native functionalities.
```sh
#!/bin/sh
# conditional statement
if [ -e example1_output ]
  # if a folder named 'example1_output' exists
then
  # remove directory with contents
    rm -rf example1_output
    
    # make directory named 'example1_output'
    mkdir example1_output

    # print something to terminal
    echo "delete old output dir; create new output dir \n"
fi

# change directory into the output directory
cd example1_output

# for loop: iterating over i = 1 2 3 4 5
for (( i = 1; i < 6; i++ )); 
do
  echo $i
  echo `date`
  echo
done

# print statement to txt file
echo 'test text 12345' >> test.txt

# copy text file
cp test.txt test_copy.txt

# print directory contents
echo `ls`

# get to the parent directory
cd ..
```

To execute this simple shell script on the cluster, you can use:
```sh
sh example1.sh
```

<br>


## Example 2 - MATLAB {#eg2}

In this example I'm going to show how one can call installed programs, using [MATLAB](https://dibsmethodsmeetings.github.io/matlab-basics/) (ha!) as an example. Here we have a simple MATLAB function [example2.m](https://raw.githubusercontent.com/DIBSMethodsMeetings/dibsmethodsmeetings.github.io/master/_source/2022-11-11-biac-cluster/example2.m) that generates some random figures.
```matlab
function example2
close all
clear
clc
a = rand(5);
disp(a)
figure;
imagesc(a);
colorbar;
```

We can directly ask the cluster to run the above MATLAB script by using one of the following
```sh
# call MATLAB to run example2.m in desktop mode
matlab -r "example2"

# call MATLAB to run example2.m in terminal mode
matlab -nodesktop -r "example2"

# if another version of MATLAB is preferred, specify its path
/usr/local/packages/MATLAB/R2021a/bin/matlab -nodesktop -r "example2"
```

Alternatively, we can create a shell script [example2.sh](https://raw.githubusercontent.com/DIBSMethodsMeetings/dibsmethodsmeetings.github.io/master/_source/2022-11-11-biac-cluster/example2.sh) that saves the above commands and then run that shell script. The extra step here may seem counterintuitive in this example, but you'll see how doing so can make things more convenient in more complex situations (like actual analyses).

<br>


## Example 3 - qsub {#eg3}

The previous two examples demonstrates how one can use the cluster to perform basic tasks with basic shell commands and installed programs. In order to make better use of the cluster resource--the many processors, we need the command `qsub` to submit jobs to the cluster queue. Each job is essentially a set of operations defined in a (shell) script. Importantly, as mentioned before, each processor should operate on one independent job at a time--independent in the sense that the computation does not require any output from other jobs. Thus a common practice is to assign each participant as one job through shell scripting. 

Here we have a slightly more complicated MATLAB function [example3.m](https://raw.githubusercontent.com/DIBSMethodsMeetings/dibsmethodsmeetings.github.io/master/_source/2022-11-11-biac-cluster/example3.m) that takes two input parameters, subject number and session number, and saves the output or errors. 
```matlab
function example3(sub, sess)
close all
clear
clc
path_output = sprintf('example3_output/sub%02d_sess%d', sub, sess);
if exist(path_output, 'dir')    
    mkdir(path_output)
end

try
    if sub > 10
        error('some weird error')
    end
    % do some random operations so we have a better sense of time
    tic
    for i = 1:5000
        a = rand(1000);
    end
    time_spent = toc;
    % save output and record time spent
    fprintf('\nElapsed time is %f seconds.\n\n', time_spent)
    save(fullfile(path_output, 'output'), 'a', 'time_spent')
catch err
    % save error for debugging
    sprintf('error with sub%02d sess%d: %s', sub, sess, err.message)
    save(fullfile(path_output, 'error'), 'err')
end
```

As before, we can ask the cluster to run this MATLAB function directly.
```sh
matlab -nodesktop -nojvm -r "example3(1, 1)" # takes about 15 seconds
matlab -nodesktop -nojvm -r "example3(11, 1)" # will produce an error
```

Let's say we have 10 participants and each of them had 2 scanning sessions, running all those operations serially should take about `10*2*15 = 300` seconds, or 5 minutes. However, if we can take advantage of parallelism, the operation time can be greatly reduced.


Here is the user script portion of the job script [example3.sh](https://raw.githubusercontent.com/DIBSMethodsMeetings/dibsmethodsmeetings.github.io/master/_source/2022-11-11-biac-cluster/example3.sh). Note that a few variables (i.e., `SUB`, `SESS`, and `EXPERIMENT`) need to be passed to this script.
```sh
cd ${EXPERIMENT}/Scripts/tutorial/
echo "running sub-${SUB} sess-${SESS}"
matlab -nodesktop -nojvm -r "example3(${SUB}, ${SESS})"
echo "completed sub-${SUB} sess-${SESS}"  
```

With the job script, we can write another shell script [example3_qsub.sh](https://raw.githubusercontent.com/DIBSMethodsMeetings/dibsmethodsmeetings.github.io/master/_source/2022-11-11-biac-cluster/example3_qsub.sh) for the actual submission of jobs--this is normally done with for loops over a number of cases (subjects and sessions) and submits those jobs to the cluster one-by-one using `qsub`. Note that the *job submission* process is serial, but the actual *jobs* are run in parallel.
```sh
#!/bin/sh

#declare variables
EXPERIMENT=MemCFT.01

for SUB in 1 2 3 4 5 6 7 8 9 10 11 12 13; 
do  
  for SESS in 1 2;
  do
    #submit jobs with variables (needs to be comma separated without spaces), followed by shell script name
    qsub -v "EXPERIMENT=$EXPERIMENT,SUB=$SUB,SESS=$SESS" example3.sh
    curr_job="job submitted for sub-${SUB} sess-${SESS}"
    echo $curr_job
  done
done
```

More examples on the [BIAC wiki](https://wiki.biac.duke.edu/biac:cluster:submit).


Now you have learned how to "cook" on the BIAC cluster, here is a bonus: you actually CAN cook food with a computer. Check this out…
[Can You Fry An Egg On a Computer Processor?](https://www.youtube.com/watch?v=BNDvHokXMho)

