---
author: raphael
featured: true
categories: [ programming ]
image: assets/images/2023-04-21-intro-psychopy/psychopyLogo.png
title: Introduction to behavioral Experiments in PsychoPy
---

Experimentalists often find themselves needing to present carefully controlled stimuli to participants, control and catalog stimulus conditions, responses, reaction times, and other empirically variables of interest. While tools such as Qualtrics, [which we have covered previously](https://dibsmethodsmeetings.github.io/online-data-collection/), are quick and easy for building surveys, to build more traditional tasks that collect responses requires a proper programming language. Python always being an excellent choice, we today cover **experiment creation in psychopy**.

## Brief Intro To Running Python Files in a Conda Environment

Before we get started with the actual task design, a quick disclaimer regarding python and package management is necessary. PsychoPy, while useful, is not rigorously updated, and so you might encounter some dependency issues if you're python version is too up to date. For this reason, you should always run your code from a virtual environment. I recommend installing [anaconda](https://www.anaconda.com/) for this purpose. Either in terminal  (mac) or Anaconda Prompt (windows), creating a conda environment that will allow us to control the packages that are available and their versions.

```
(base) >> conda create --name psychopy python=3.8
(base) >> conda activate psychopy
(psychopy) >> pip install psychopy
(psychopy) >> conda list
```

with conda list letting us see that psychopy is indeed installed correctly. Numpy should be available as well, we'll need it.

## Creating our First Python File

In the editor of your choice (Anaconda comes pre-equipped with GUIs such as Spyder and PyCharm, I also recommend Visual Studio Code or Atom (deprecated)), create a new python file `main.py` in some code repository. Make sure you are cd'd into this folder in terminal/Anaconda Prompt, and from then on simply call `python main.py` whenever you would like to run the script. make sure that your conda environment is activated!

## Our First Psychopy Window

First and foremost, let us install the psychopy modules we'll need. We'll get to them in turn.

``` Python
from psychopy import visual, core, event
import numpy as np
```

PsychoPy involves drawing stimuli, text, and other visual to a "Window". We can initialize this window using the visual module. We'll add a `core.wait` call to simply wait a few seconds before closing the file again.

``` python
win = visual.Window()

core.wait(3)

win.close()
```

Let's run our file from terminal (`python main.py`) and verify a window opens and then promptly closes again. Success!

## Basics of Clean Programming

Before we proceed, we need to cover an important standard of clean code. Namely, scaffolding. What I mean is that we should first create a scaffold for our task design and define the functions before we actually write them. This is different than how programming is often taught, where people first write really messy code and then later clean it up. This new method is faster, cleaner, and leads to better code overall.

What is our task design? We are going to be creating a random dot kinematogram (RDK) task. In this task, participants view a field of randomly moving dots, with some subset of dots moving in the same direction (usually left or right). The task is to identify in which direction those dots are moving.

An important feature of an RDK task is the coherence of the dots. That is, what percent of the dots are moving in the same direction. It makes intuitive sense that the more dots are moving randomly (the fewer dots are moving in a clear direction), the more difficult the task ought to be. We can assume this means reduced accuracy and increased reaction times. We can start by imagining an experiment where we vary the coherence between high and low, and comparing performance between these tasks.

Here is the task flow of our experiment:

First, we will display a fixation cross ('+') for 0.5 seconds.

Next, a kinematogram stimulus will appear, with either high or low coherence, and with the motion of the signal dots moving either to the left or to the right. The stimulus will remain on the screen until a response is made, with a maximum time of 2 seconds. Participants will respond 'z' if they think the dots are moving the left and 'm' if they are moving to the right.

Finally, participants will see feedback. Either "correct" or "incorrect" if the response matches the direction of the stimulus dots, and "Too Slow" if no responses is made before the stimulus disappears. Feedback will last for 1 second.

Given these details, what might a potential scaffold for our experiment look like?

``` python
nTrials = 3
for trial in range(nTrials):

  print(f'Trial: {trial + 1}')

  drawFixation()

  core.wait(0.5)

  drawKinematogram()

  core.wait(2)

  drawFeedback()

  core.wait(1)

```

We can also go ahead and define these functions in our code, such that these functions print to terminal when they are called.

``` python

def drawFixation():
    print('Drawing Fixation')

def drawKinematogram():
    print('Drawing Kinematogram')

def drawFeedback():
    print('Drawing Feedback')  

```

And just like that, we can run our experiment and confirm that a) these functions are being called correctly and b) the task is processing at the speed it should via the core.waits.

Our final code should look like this:

``` python
from psychopy import visual, core, event
import numpy as np

win = visual.Window()

def drawFixation():
    print('Drawing Fixation')

def drawKinematogram():
    print('Drawing Kinematogram')

def drawFeedback():
    print('Drawing Feedback')  

nTrials = 3
for trial in range(nTrials):

    print(f'Trial: {trial + 1}')

    drawFixation()

    core.wait(0.5)

    drawKinematogram()

    core.wait(2)

    drawFeedback()

    core.wait(1)

win.close()
```

Calling the function:

```
(psychopy) >> cd ..../folderName/
(psychopy) >> python main.py
pygame ....
Hello from the pygame community. https://www.pygame.org/contribute.html
Trial: 1
Drawing Fixation
Drawing Kinematogram
Drawing Feedback
Trial: 2
Drawing Fixation
Drawing Kinematogram
Drawing Feedback
Trial: 3
Drawing Fixation
Drawing Kinematogram
Drawing Feedback
3.7542  WARNING   Monitor specification not found. Creating a temporary one...
```

We can comment out function calls and remove core.waits() as needed from now on to speed up programming (so that we don't have to sit through the whole thing each time), but this is an excellent place to start. All that is required is editing the actual functions and we already know that the task flow and logic will work.

## Psychopy Visual.TextStim

Our first challenge is the easiest, drawFixation. This will not change from trial to trial, and drawing text is fairly straightforward.

``` python
def drawFixation(win):
    fixation = visual.TextStim(win, text="+")
    fixation.draw()
    win.flip()


drawFixation(win)
```

Above are the function definition and function call for the drawFixation function. We start by defining a visual.TextStim object (for a full list, see https://psychopy.org/api/visual/index.html), specifying the window that the text is to be draw to and the text value itself.

Next, we draw the text to the "buffer screen" via `fixation.draw()`. Note that this does NOT make the fixation appear on the screen. That only occurs with win.flip, which takes whatever is currently drawn to the buffer and reveals it on the screen. Win.flip() also clears the buffer in this process, so that the subsequent win.flip()s will reveal blank screens unless more things are drawn to them.

Why does psychopy operate like this? The reason is that the exeprimentalists and psychophysicists that use and designed psychopy really care about precise timing, and this means knowing that when I say "the stimulus was shown 4.235s after the experiment started", that the stimulus was indeed shown at that exact moment. The reason for the flipping is that drawing is slow (and laggy), but flipping is FAST. And so we don't care how long it takes to draw (that can be as laggy as it likes), as long as we know when the flip happened everything is grand.

While we're at it, let us define the drawFeedback function as well, since this also requires only visual.TextStim.

``` python
def drawFeedback(win, feedback):
    fixation = visual.TextStim(win, text=feedback)
    fixation.draw()
    win.flip()

drawFeedback(win, "Correct")
```

In a bit we'll amend the input "Correct" to be whatever is appropriate given the response.

> rerun the task via `python main.py to make sure that the fixation and feedback are appearing!`

## Psychopy DotStim

To create our kinematogram, we can make use of another psychopy built in class, namely DotStim.

DotStim work a little differently than other psychopy objects. Rather than being drawn once, they need to be drawn continously, like so:

``` python
dots = visual.DotStim(win=win)

while True:
  dots.draw()
  win.flip()
```

Psychopy handles all of the work of actually moving the dots around on its own. All we have to do is continously draw and flip.

How should we handle timing in this case? Otherwise, our while loop will run forever. An easy way is to use `core.Clock()` which creates a timer (initialzed at 0 when the variable is created), and then subsequent .getTime() calls will tell us how many seconds have passed since the initialization. So, by initializing a clock at the start of the trial, and then waiting till clock is greater than maxWait to break, we alerady have the basics of our kinematrogram function!

``` python
def drawKinematogram(win, maxWait=2):
    dots = visual.DotStim(win=win)
    trialClock = core.Clock()
    while True:

      if runClock.getTime() > maxWait:
        break

      dots.draw()

      win.flip()

drawKinematogram(win, maxWait=2)
```

One last thing is that we need to remove the core.wait after the drawKinematogram call, since it is now doing its own timing.

And just like that, we already have an entire rudimentary experiment working!

Here is the full code currently:

``` python
from psychopy import visual, core, event
import numpy as np

win = visual.Window()

def drawFixation(win):
    fixation = visual.TextStim(win, text="+")
    fixation.draw()
    win.flip()

def drawKinematogram(win, maxWait=2):
    dots = visual.DotStim(win=win)
    trialClock = core.Clock()
    while True:

      if trialClock.getTime() > maxWait:
        break

      dots.draw()

      win.flip()

def drawFeedback(win, feedback):
    fixation = visual.TextStim(win, text=feedback)
    fixation.draw()
    win.flip()

nTrials = 3
for trial in range(nTrials):

  # fixation
  drawFixation(win)
  core.wait(0.5)

  # kinematrogram
  drawKinematogram(win, maxWait=2)

  # feedback
  drawFeedback(win, "Correct")
  core.wait(1)

win.close()
```

## Updating the Kinematogram

Hopefully you are enjoying the ease with which we can update our task code!

The next thing is to improve the kinematogram so that the stimuli look better. Glancing at the documentation (https://www.psychopy.org/api/visual/dotstim.html), some useful attributes are nDots, dotSize, dotLife, and speed. Feel free to play around with these yourself, but for now we will use the following:

``` python
def drawKinematogram(win, maxWait=2):
    dots = visual.DotStim(win=win, nDots=200, dotSize=5, dotLife=-1, speed=1./60)
    ...
```

The last two important attributes are coherence and dir. Coherence takes a value  between 0 and 1, with values closer to 0 being much more difficult. Dir takes a value that is an angle, relative to the dots moving from left to right. So, dir=0 leaves the dots as it, dir=90 rotates them 90 degrees so they are going upwards, and 180 has them going from right to left.

Given that we want the coherence and direction to vary from trial to trial, we'll add these values as inputs to the function.

``` python
def drawKinematogram(win, maxWait=2, coherence=0.1, dir=0):
    dots = visual.DotStim(win=win, nDots=200, dotSize=5, dotLife=-1, speed=1./60, coherence=coherence, dir=dir)
    ...

drawKinematogram(win, maxWait=2, coherence=0.1, dir=0)
```

All that is left is to initialize lists that contain the directions of the stimuli on each trial and the coherences on each trial. We can even go so far as the very the proportion of hard trials and left trials to make things easier to mess around with in the future. We'll initialize these outside of the for loop.

``` python
nTrials = 3

#define coherences
highCoherenceProp = 0.5
nHighs = int(np.floor(nTrials * highCoherenceProp))
nLows = nTrials - nHighs
coherences = [0.3] * nHighs + [0.1] * nLows
np.random.shuffle(coherences)
print(coherences)

#define directions
leftProp = 0.5
nLefts = int(np.floor(nTrials * leftProp))
nRights = nTrials - nLefts
directions = [180] * nLefts + [0] * nRights
np.random.shuffle(directions)
print(directions)
```

Last but not least, we need to call these as inputs to our kinematogram function call. Our final code looks like this:

``` python
from psychopy import visual, core, event
import numpy as np

win = visual.Window()

def drawFixation(win):
    fixation = visual.TextStim(win, text="+")
    fixation.draw()
    win.flip()

def drawKinematogram(win, maxWait=2, coherence=0.1, dir=0):
    dots = visual.DotStim(win=win, nDots=200, dotSize=5, dotLife=-1, speed=1./60, coherence=coherence, dir=dir)
    trialClock = core.Clock()
    while True:

      if trialClock.getTime() > maxWait:
        break

      dots.draw()

      win.flip()

def drawFeedback(win, feedback):
    fixation = visual.TextStim(win, text=feedback)
    fixation.draw()
    win.flip()

nTrials = 3

#define coherences
highCoherenceProp = 0.5
nHighs = int(np.floor(nTrials * highCoherenceProp))
nLows = nTrials - nHighs
coherences = [0.3] * nHighs + [0.1] * nLows
np.random.shuffle(coherences)
print(coherences)

#define directions
leftProp = 0.5
nLefts = int(np.floor(nTrials * leftProp))
nRights = nTrials - nLefts
directions = [180] * nLefts + [0] * nRights
np.random.shuffle(directions)
print(directions)

for trial in range(nTrials):

  drawFixation(win)
  core.wait(0.5)

  drawKinematogram(win, maxWait=2, coherence=coherences[trial], dir=directions[trial])

  drawFeedback(win, "Correct")
  core.wait(1)

win.close()
```

## Responses

This wouldn't be a proper behavioral task if we don't allow for, well, behavior! For this we will allow participants to respond, using either the 'z' or the 'm' key, to indicate if the coherent dots are moving to the left or to the right, respectively.

There are two ways to collect responses, event.waitKeys() and event.getKeys() are the older method (https://psychopy.org/api/event.html), and Keyboard (https://psychopy.org/api/hardware/keyboard.html) is the new way. Although Keyboard offers more functionality, we will stick with event for now as it is generally more straightforward and easier to explain for a tutorial.

Whereas event.waitKeys() pauses code execution until a response is registered, event.getKeys() checks if there is a key being pressed RIGHT NOW (at the time of code execution) and keeps right on going. Which is best depends on what kind of stimulus is being present, and whether it is being presented using event.wait() or a `while True` loop.

Since our drawKinematogram requires ongoing code execution, we will need to use event.getKeys(). waitKeys would pause code execution and thus the dots would stop moving.

All we need to do is initialize an empty list of pressedKeys at the start of each trial (`pressedKeys = []`) and then check if a key has been pressed via the following code.

``` python
def kinematogramTrial(win, dots, coherence, direction, maxWait):
    ...
    pressedKeys = []

    while True:
        ...

        # listen for response
        pressedKeys.extend(event.getKeys(keyList=['z', 'm'], timeStamped=trialClock))
        if len(pressedKeys):
            return pressedKeys
```
getKeys takes as an input a keyList, which is the list of values that will be listened for and count as a key press. timeStamped means that getKeys returns not a string of the response that was made (e.g. ['z'] or ['m']) but rather a tuple that indicates both the key pressed and response time relative to the trialClock (e.g., [['z', 2.1423]])).

Now, since we are returning pressedKeys, we also need to return something if the maxWait exit triggers. Namely:

``` python
if trialClock.getTime() > maxWait:
        return []
```

On the task flow side of things, we can accept the input into a response variable, like so:

``` python
for trial in range(nTrials):

  ...

  response = drawKinematogram(win, maxWait=2, coherence=coherences[trial], dir=directions[trial])

  ...
```

The final thing for our fully working experiment is to check whether the response matches the direction. This is accomplished quite easily via the following code:

``` python
def getFeedback(resp, dir):
    corrResp = 'm' if dir == 0 else 'z'
    if resp:
        return 'Correct' if resp[0][0] == corrResp else 'Incorrect'
    else:
        return 'Too Slow'
```

Our final experiment flow then looks like this:

``` python

from psychopy import visual, core, event
import numpy as np

win = visual.Window()

def drawFixation(win):
    fixation = visual.TextStim(win, text="+")
    fixation.draw()
    win.flip()

def drawKinematogram(win, maxWait=2, coherence=0.1, dir=0):
    dots = visual.DotStim(win=win, nDots=200, dotSize=5, dotLife=-1, speed=1./60, coherence=coherence, dir=dir)
    trialClock = core.Clock()
    pressedKeys = []
    while True:
        #automatically exist after maxWait
        if trialClock.getTime() > maxWait:
            return []

        #listen for a response
        pressedKeys.extend(event.getKeys(keyList=['z', 'm'], timeStamped=trialClock))
        if len(pressedKeys):
            return pressedKeys

        dots.draw()
        win.flip()

def drawFeedback(win, feedback):
    fixation = visual.TextStim(win, text=feedback)
    fixation.draw()
    win.flip()

def getFeedback(resp, dir):
    corrResp = 'm' if dir == 0 else 'z'
    if resp:
        return 'Correct' if resp[0][0] == corrResp else 'Incorrect'
    else:
        return 'Too Slow'

nTrials = 10

#define coherences
highCoherenceProp = 0.5
nHighs = int(np.floor(nTrials * highCoherenceProp))
nLows = nTrials - nHighs
coherences = [0.3] * nHighs + [0.1] * nLows
np.random.shuffle(coherences)
print(coherences)

#define directions
leftProp = 0.5
nLefts = int(np.floor(nTrials * leftProp))
nRights = nTrials - nLefts
directions = [180] * nLefts + [0] * nRights
np.random.shuffle(directions)
print(directions)

for trial in range(nTrials):

  drawFixation(win)
  core.wait(0.5)

  response = drawKinematogram(win, maxWait=2, coherence=coherences[trial], dir=directions[trial])

  feedback = getFeedback(response, directions[trial])

  drawFeedback(win, feedback)
  core.wait(1)

win.close()

```

## Data Logging

The very last feature is to do data logging. At its most rudimentary form, data logging is simply cataloging the  value of all variables of interest (response, RT, direction, condition, etc) for each trial in some sort of list or dictionary, and then saving these out into something like a csv.

To do data logging, we create a list called Data, and for each trial, append a list that has the information for that trial. Observe:

``` python
data = []

...

for trial in range(nTrials):

    ...

    data.append([trial + 1, directions[trial], coherences[trial], response[0][0] if response else None, response[0][1] if response else None])
```

At the end of the experiment, we can use the pandas package (don't forget to import! `import pandas as pd`) to turn it into a data frame and then write to csv.

``` python

df = pd.DataFrame(data, columns = ['Trial', 'Direction', 'Coherence', 'Response', 'RT'])

df.to_csv('rdk_data.csv', index=False)

```

With that, we have finished this tutorial and our final python file is as follows:

``` python
from psychopy import visual, core, event
import pandas as pd
import numpy as np

win = visual.Window()

def drawFixation(win):
    fixation = visual.TextStim(win, text="+")
    fixation.draw()
    win.flip()

def drawKinematogram(win, maxWait=2, coherence=0.1, dir=0):
    dots = visual.DotStim(win=win, nDots=200, dotSize=5, dotLife=-1, speed=1./60, coherence=coherence, dir=dir)
    trialClock = core.Clock()
    pressedKeys = []
    while True:
        #automatically exist after maxWait
        if trialClock.getTime() > maxWait:
            return []

        #listen for a response
        pressedKeys.extend(event.getKeys(keyList=['z', 'm'], timeStamped=trialClock))
        if len(pressedKeys):
            return pressedKeys

        dots.draw()
        win.flip()

def drawFeedback(win, feedback):
    fixation = visual.TextStim(win, text=feedback)
    fixation.draw()
    win.flip()

def getFeedback(resp, dir):
    corrResp = 'm' if dir == 0 else 'z'
    if resp:
        return 'Correct' if resp[0][0] == corrResp else 'Incorrect'
    else:
        return 'Too Slow'

nTrials = 10
data = []

#define coherences
highCoherenceProp = 0.5
nHighs = int(np.floor(nTrials * highCoherenceProp))
nLows = nTrials - nHighs
coherences = [0.3] * nHighs + [0.1] * nLows
np.random.shuffle(coherences)
print(coherences)

#define directions
leftProp = 0.5
nLefts = int(np.floor(nTrials * leftProp))
nRights = nTrials - nLefts
directions = [180] * nLefts + [0] * nRights
np.random.shuffle(directions)
print(directions)

for trial in range(nTrials):

  drawFixation(win)
  core.wait(0.5)

  response = drawKinematogram(win, maxWait=2, coherence=coherences[trial], dir=directions[trial])

  feedback = getFeedback(response, directions[trial])

  drawFeedback(win, feedback)
  core.wait(1)

  data.append([trial + 1, directions[trial], coherences[trial], response[0][0] if response else None, response[0][1] if response else None])

df = pd.DataFrame(data, columns = ['Trial', 'Direction', 'Coherence', 'Response', 'RT'])
df.to_csv('rdk_data.csv', index=False)

win.close()
```

Thanks for reading! Happy programming.
