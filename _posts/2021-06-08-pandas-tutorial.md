---
title: "Data Wrangling with Python + Pandas"
author: nathan
image: https://pandas.pydata.org/static/img/pandas_secondary.svg
categories: [ programming ]
hidden: false
featured: false
---

# **1.   Introduction**
<div align="center"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/Pandas_logo.svg/1200px-Pandas_logo.svg.png" width=250px><img src="https://static.thenounproject.com/png/1640432-200.png" width=100px><img width=15px><img src="https://www.publicdomainpictures.net/pictures/220000/nahled/pandas.jpg" width=150px border-radius=50>
</div>

What's up, everyone! We're going to go over how to use `pandas`, a super nifty package for data wrangling in Python. And, no, unfortunately the package name has nothing to do with the adorable herbivorous bear: it's a portmanteau of "panel" + "data"—the econometric equivalent of "longitudinal data" in psychological research. Eh.

To be clear, this is not an exhaustive guide on the package. For that, you would need to reference the official [documentation](https://pandas.pydata.org/pandas-docs/stable/user_guide/index.html) itself which, thankfully, is actually incredibly well organized and user-friendly.

The purpose of this tutorial, rather, is to capture the most important functionalities of the package to get you on your feet and running: to provide an intermediate level of proficiency that will likely suffice as a useful guide for most tasks you will encounter.


## **1.1   What is (are?) pandas?**

`pandas` (always all lowercase) is an industry standard for basically everything you could possibly want to do in data science. It's open-source, well-maintained through non-profit sponsorship, and one of the most widely used packages—all factors which ensure it will continue to be around for a long time!

According to their official website:

*   "`pandas` aims to be the fundamental high-level building block for doing practical, real world data analysis in Python."
*   "Additionally, it has the broader goal of becoming the most powerful and flexible open source data analysis / manipulation tool available in any language."

Indeed, it lives up to this reputation as a *very* useful tool that will save you lots of time once you work past the initial learning curve. Since the way `pandas` works is intentionally quite analogous to the functionality provided by R, having some R chops beforehand will certainly help (although this is not necessary).



## **1.2   Objectives**

Before we get started, I'd like you to consider the matter of *why* one would choose to use `pandas`. Why not just use a GUI like Microsoft Excel to open a tabular datafile, run the required transformations, and then close it all without writing and compiling any scripts?

At least anecdotally, it can certainly be tempting to use them for data preprocessing instead of learning the more complex syntax. While I don't mean to discourage your measured use of them—they can be powerful and efficient in their own right–one ought not become reliant on them in unwarranted circumstances.

My point, then, is to prove to you here that `pandas` is just as effective as industry standard GUIs (and R!) in getting the same types of tasks done.

|      | Pros | Cons |
| :--- | :--- | :--- |
| Microsoft Excel | {::nomarkdown}<ul><li>GUI: easy to click and drag selections</li><li>Customizable full visual display of dataset</li></ul>{:/} | {::nomarkdown}<ul><li>Increased chance for human error</li><li>Cannot handle large datasets</li><li>Slower performance</li></ul>{:/} |
| `pandas` | {::nomarkdown}<ul><li>Can assemble a reproducible pipeline for data analysis</li><li>Can automate vectorized operations on a massive scale</li><li>Reduced chance for human error</li></ul>{:/} | {::nomarkdown}<ul><li>Takes time to learn and apply full functionality</li></ul>{:/} |

# **2.   How to Be a Power User**

It's kind of a tongue-in-cheek humorous term, but "power user" is basically what you'd call someone who prioritizes trying to optimize the (not-that-useful) functionalities of whatever software or code tickles their fancy.

I'd like to present several useful tips and tricks you can implement in vanilla (i.e., regular old) Python, `pandas`, and other packages!

## **2.1   Anaconda Distribution**

If you're a research scientist working in Python, I strongly advise that you install the [Anaconda Distribution](https://www.anaconda.com/products/individual) before you do anything else. It's an exceptional tool that provides bundles together package management and virtual environment support while also pre-installing many useful data science packages for you. 


## **2.2   IDE vs. Text Editor**

When programming in Python, you can choose between two umbrella categories of tools, integrated development environments (IDEs) and text editors. These interfaces almost always represent standalone software and need to be installed on your system separately from Python itself. Python comes bundled with the code editor IDLE, but this GUI is, in my view, woefully inadequate compared to the suite of freely available alternatives.

There's not really a right answer here, but it's important to understand the differences between these tools. An IDE is always going to be a beefed up version of a text editor, giving you high-powered tools that allow for debugging, compiling, building and deploying, and more. A text editor is, at its core, simply a space for scripting code that you'll run sometime somewhere. There's a spectrum between these, and the advantage of greater functionality generally comes at the cost of greater resource allocation (CPU and RAM). More complex by design, IDEs can also sometimes spontaneously crash.

Personally, I use the following tools for web development and data science:

*   [Atom](https://atom.io/)
*   [JetBrains](https://www.jetbrains.com/)
*   [RStudio](https://www.rstudio.com/)
*   Jupyter Notebook (...which you're using right now!)

## **2.3   Choosing a Typeface**

A good typeface goes a very long way for readability and reduced eyestrain when programming projects drag on. By a longshot, my personal favorite monospace font has got to be [JetBrains Mono](https://www.jetbrains.com/lp/mono/). Not only is it open-source, but it also supports 100+ ligatures:

<br>


![image.png](data:image/png;base64,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)

## **2.4   Keyboard Shortcuts**

Keyboard shortcuts/hotkeys are probably a divisive topic. While there are commonly used preset key mappings, you know the saying:<br> <i>"Different (key)strokes for different folks."</i> Also, it's just burdensome to go through a long, comprehensive list to identify the ones you'll actually end up using. Still, for the majority of users, I believe there are a couple of need-to-know practices you may have overlooked. In the table below, I've included my picks of the bunch. If you do end up making it a habit of using these shortcuts, I can guarantee you they will do wonders for your productivity.

| | Windows | Mac |
| :- | :- | :- |
| Switch between <br> open windows | `Alt + Tab` | `⌘ + Tab` |
| Switch between <br> open windows (in reverse) | `Alt + Shift + Tab` | `⌘ + Shift + Tab` |
| Switch between <br> open tabs | `Ctrl + Tab` |  |
| Switch between <br> open tabs (reverse) | `Ctrl + Shift + Tab` |  |
| Comment out highlighted <br> code block or inline <br> code at cursor position | `Ctrl + /` | `⌘ + /` |
| Move cursor left/right by word | `Ctrl + ←` <br> `Ctrl + →` | `⌥ + ←` <br> `⌥ + →` |
| Select by moving cursor <br> left/right by character | `Shift + ←` <br> `Shift + →` |
| Select by moving cursor <br> left/right by word | `Ctrl + Shift + ←` <br> `Ctrl + Shift + →` | `⌥ + Shift + ←` <br> `⌥ + Shift + →` |

## **2.5   Vectorization**

We always want to optimize our code for memory efficiency and speed to yield a quick compile. Because dataframe objects are already quite expensive in storage, a reliable rule of thumb is to always attempt to vectorize any operations one performs on them.

Vectorization is a superior alternative to writing explicit `for` and `while` loops because it accelerates compile time astronomically and is almost always more concise. We'll go into this in more detail later on, but I'd like to introduce the idea before we move on of applying an operation to an entire array at one time instead of the constituent components piecemeal.

On a mechanistic level, vectorization transfers the burden of looping to the precompiled C code on which Python is built.

## **2.6   PEP8**

The last thing I must mention is [PEP8](https://www.python.org/dev/peps/pep-0008/): this is to Python what APA7 is to psychology researchers. It's a style guide that exhaustively covers all the formatting rules and best practices for programming in the language.

PEP stands for Python Enhancement Proposals, and the style guide is only one of many hundreds of meticulously curated documents addressing every last detail of how to best write and distribute code. I would only recommend that you reference it on an as-needed basis because it's basically an unlimited well of information. Still, it's a powerful resource that every Python programmer should be know.

# **3.   Getting Started**

Let's get started! As you'll begin to see if you haven't already, `pandas` and `numpy` (**Num**erical **Py**thon) go together like bread and butter. Where you see one, you'll surely see the other. We will always be importing both as "aliases" or abbreviations (like many, but not all, other packages!) because:

> _"All things being equal, the simplest [readable] solution tends to be the best one [holding memory efficiency and compile time relatively equal]."_
> <p align=right color=green>—Occam's CS Razor<sup> [citation needed]</sup></p>
> <div><img src="https://cdn.pixabay.com/photo/2012/04/24/23/17/laptop-41070_1280.png" width=80px><img width=10px><img src="https://media.snl.no/media/50353/standard_William_of_Ockham.png" width=75px></div>




```python
from google.colab import drive  # let's initialize colab
import pandas as pd  # this is standard import aliasing, always use it
import numpy as np  # this is standard import aliasing, always use it

drive.mount('/content/drive', force_remount=True)

data_dir = "drive/MyDrive/2020-10-21-dragon-data.csv"
```

    Mounted at /content/drive
    

## **3.1   Reading in Data**

Alright, so to begin, we're going to start with an example. Looking at dragons again! Yay! 🐉

Let's say we have a `.csv` file—you know, that handy file type that almost always ends up being what holds all of your good good experiment data. That's not to say, however, that you can't open up tabular datafiles of other types. Other common ones are `.tsv` (tab-separated) and `.xlsx` (Microsoft Excel), but the list goes on:

*  SPSS
*  SQL
*  Pickle (yes, this is a real type of data storage—and an efficient one as well! 🥒)
*  ...and many, many more!


```python
dragons_df = pd.read_csv(data_dir)  # read
print(dragons_df)  # let's see what it looks like!

# Let's see how Python classifies this new object and its columns
print('Object type: ' + str(type(dragons_df)) + '\n')
print('Object column type(s): \n' + str(dragons_df.dtypes))

# ----------------------------------------------------- #
# If data_dir were a .tsv file, you'd have two options: #
# ----------------------------------------------------- #
# dragons_df = pd.read_table(data_dir) 
# dragons_df = pd.read_csv(data_dir, sep='\t')

# ------------------------------- #
# If data_dir were an .xlsx file: #
# ------------------------------- #
# dragons_df = pd.read_excel(data_dir)
```

         testScore  bodyLength mountainRange   color        diet  breathesFire
    0     0.000000  175.512214      Bavarian    Blue   Carnivore             1
    1     0.742914  190.640959      Bavarian    Blue   Carnivore             1
    2     2.501825  169.708778      Bavarian    Blue   Carnivore             1
    3     3.380430  188.847204      Bavarian    Blue   Carnivore             1
    4     4.582095  174.221700      Bavarian    Blue   Carnivore             0
    ..         ...         ...           ...     ...         ...           ...
    475  41.806995  186.132578      Southern  Yellow  Vegetarian             0
    476  42.650015  192.272043      Southern  Yellow  Vegetarian             0
    477  44.582490  184.038015      Southern  Yellow  Vegetarian             1
    478  47.795914  189.814408      Southern  Yellow  Vegetarian             0
    479  55.486722  189.661989      Southern  Yellow   Carnivore             0
    
    [480 rows x 6 columns]
    Object type: <class 'pandas.core.frame.DataFrame'>
    
    Object column type(s): 
    testScore        float64
    bodyLength       float64
    mountainRange     object
    color             object
    diet              object
    breathesFire       int64
    dtype: object
    

Woohoo! Our data has been successfully loaded into Python as a DataFrame object. Plus, we confirmed this by calling the base `type()` function and then identified the type of data in each column by accessing this stored information via `.dtypes`.

As you can see, Python does not print out the entire dataframe by default. That being said, it still gives you a decent sense of your data with dimensions, header names, and the first/last couple rows. If we had many more columns in this dataset, the `...` would also appear in a pseudo-column to represent the columns not displayed between the first/last couple columns.

If, however, you would like to inspect a greater proportion of your data visually within Python, you can call the `.option_context()` command and customize the number of rows to be displayed:


```python
# feel free to play around with the numbers in the below statement!
with pd.option_context('display.max_rows', 8, 'display.max_columns', 8):
  print(dragons_df)
```

         testScore  bodyLength mountainRange   color        diet  breathesFire
    0     0.000000  175.512214      Bavarian    Blue   Carnivore             1
    1     0.742914  190.640959      Bavarian    Blue   Carnivore             1
    2     2.501825  169.708778      Bavarian    Blue   Carnivore             1
    3     3.380430  188.847204      Bavarian    Blue   Carnivore             1
    ..         ...         ...           ...     ...         ...           ...
    476  42.650015  192.272043      Southern  Yellow  Vegetarian             0
    477  44.582490  184.038015      Southern  Yellow  Vegetarian             1
    478  47.795914  189.814408      Southern  Yellow  Vegetarian             0
    479  55.486722  189.661989      Southern  Yellow   Carnivore             0
    
    [480 rows x 6 columns]
    

### **3.1.1   Heads, Tails, and Duplicates**

A nifty option you have is to ask `pandas` to only display the top or bottom few rows by calling: `df.head()` or `df.tail()`

Another particularly useful method will remove duplicate rows (according to specified column values):
`df.drop_duplicates()`


```python
print(dragons_df.head(14))  # prints the first (leading) n rows
print(dragons_df.tail(2))  # prints the last (trailing) n rows

print(dragons_df.drop_duplicates('testScore'))  
# drops all rows with the same test score
```

        testScore  bodyLength mountainRange color       diet  breathesFire
    0    0.000000  175.512214      Bavarian  Blue  Carnivore             1
    1    0.742914  190.640959      Bavarian  Blue  Carnivore             1
    2    2.501825  169.708778      Bavarian  Blue  Carnivore             1
    3    3.380430  188.847204      Bavarian  Blue  Carnivore             1
    4    4.582095  174.221700      Bavarian  Blue  Carnivore             0
    5   12.453635  183.081931      Bavarian  Blue  Carnivore             1
    6   16.176758  174.839935      Bavarian  Blue  Carnivore             1
    7   16.249164  182.876708      Bavarian  Blue  Carnivore             1
    8   16.852420  177.820550      Bavarian  Blue   Omnivore             1
    9   18.452767  176.740267      Bavarian  Blue  Carnivore             1
    10  20.484229  182.921515      Bavarian  Blue  Carnivore             1
    11  20.489804  170.686850      Bavarian  Blue  Carnivore             1
    12  22.563014  179.574357      Bavarian  Blue  Carnivore             1
    13  24.148017  180.063446      Bavarian  Blue  Carnivore             1
         testScore  bodyLength mountainRange   color        diet  breathesFire
    478  47.795914  189.814408      Southern  Yellow  Vegetarian             0
    479  55.486722  189.661989      Southern  Yellow   Carnivore             0
         testScore  bodyLength mountainRange   color        diet  breathesFire
    0     0.000000  175.512214      Bavarian    Blue   Carnivore             1
    1     0.742914  190.640959      Bavarian    Blue   Carnivore             1
    2     2.501825  169.708778      Bavarian    Blue   Carnivore             1
    3     3.380430  188.847204      Bavarian    Blue   Carnivore             1
    4     4.582095  174.221700      Bavarian    Blue   Carnivore             0
    ..         ...         ...           ...     ...         ...           ...
    475  41.806995  186.132578      Southern  Yellow  Vegetarian             0
    476  42.650015  192.272043      Southern  Yellow  Vegetarian             0
    477  44.582490  184.038015      Southern  Yellow  Vegetarian             1
    478  47.795914  189.814408      Southern  Yellow  Vegetarian             0
    479  55.486722  189.661989      Southern  Yellow   Carnivore             0
    
    [470 rows x 6 columns]
    

Now, that's all fine and dandy. We did what we set out to do, and, for all intents and purposes, that's basically all we're going to have to write out to get the data sitting in a tabular datafile into Python.

But, it's important to note that you have a much greater amount of flexibility in deciding how you want to read in your data. In fact, the options are honestly overwhelming. Just check out the list of parameters you could technically tweak to your heart's desire for *one* function call: everything here represents default parameters, which means they're like nonsignificant zeroes: you only have to explicitly state these if you're deviating from their preset values.

```
pandas.read_csv(filepath_or_buffer, 
                sep=<object object>, 
                delimiter=None, 
                header='infer', 
                names=None, 
                index_col=None, 
                usecols=None, 
                squeeze=False, 
                prefix=None, 
                mangle_dupe_cols=True, 
                dtype=None, 
                engine=None,
                converters=None, 
                true_values=None, 
                false_values=None, 
                skipinitialspace=False, 
                skiprows=None, 
                skipfooter=0, 
                nrows=None, 
                na_values=None, 
                keep_default_na=True, 
                na_filter=True, 
                verbose=False, 
                skip_blank_lines=True, 
                parse_dates=False, 
                infer_datetime_format=False, 
                keep_date_col=False, 
                date_parser=None, 
                dayfirst=False, 
                cache_dates=True,
                iterator=False, 
                chunksize=None, 
                compression='infer', 
                thousands=None, 
                decimal='.', 
                lineterminator=None, 
                quotechar='"', 
                quoting=0, 
                doublequote=True, 
                escapechar=None, 
                comment=None, 
                encoding=None, 
                dialect=None, 
                error_bad_lines=True, 
                warn_bad_lines=True, 
                delim_whitespace=False, 
                low_memory=True, 
                memory_map=False, 
                float_precision=None, 
                storage_options=None)
```
Visually a little much, eh? This is why being told to "just go read the documentation" can often be so discouraging—if you've just stepped in the shallow end, how do you even know where to start?

## **3.2   Selecting Data**



### **3.2.1   Slicing and Dicing**
We select (or subset) our data of interest from the master dataframe either by name (label) or by index (position). Because a `pandas` dataframe is a 2D object, we have to specify two arguments: one for the rows and the other for the columns we want. This is just like R syntax!

*   To select by label: `df.loc[row_names, col_names]`<br>
  *   In this case, **both** start and stop rows/columns **are included** in the slice!
*   To select by position: `df.iloc[row_indices, col_indices]`<br>
  *   In this case, just like in vanilla Python, the end stop is not included in the slice.


```python
# Selecting by label:
print(dragons_df.loc[:,'bodyLength':'breathesFire'])  # all rows, some columns

# Selecting by position:
print(dragons_df.iloc[:, 0])  # all rows, first column
print(dragons_df.iloc[:, 0:2])  # all rows, first two columns
print(dragons_df.iloc[0:2, :])  # first two rows, all columns
print(dragons_df.iloc[0:2, 0:2])  # first two rows, first and second columns
```

         bodyLength mountainRange   color        diet  breathesFire
    0    175.512214      Bavarian    Blue   Carnivore             1
    1    190.640959      Bavarian    Blue   Carnivore             1
    2    169.708778      Bavarian    Blue   Carnivore             1
    3    188.847204      Bavarian    Blue   Carnivore             1
    4    174.221700      Bavarian    Blue   Carnivore             0
    ..          ...           ...     ...         ...           ...
    475  186.132578      Southern  Yellow  Vegetarian             0
    476  192.272043      Southern  Yellow  Vegetarian             0
    477  184.038015      Southern  Yellow  Vegetarian             1
    478  189.814408      Southern  Yellow  Vegetarian             0
    479  189.661989      Southern  Yellow   Carnivore             0
    
    [480 rows x 5 columns]
    0       0.000000
    1       0.742914
    2       2.501825
    3       3.380430
    4       4.582095
             ...    
    475    41.806995
    476    42.650015
    477    44.582490
    478    47.795914
    479    55.486722
    Name: testScore, Length: 480, dtype: float64
         testScore  bodyLength
    0     0.000000  175.512214
    1     0.742914  190.640959
    2     2.501825  169.708778
    3     3.380430  188.847204
    4     4.582095  174.221700
    ..         ...         ...
    475  41.806995  186.132578
    476  42.650015  192.272043
    477  44.582490  184.038015
    478  47.795914  189.814408
    479  55.486722  189.661989
    
    [480 rows x 2 columns]
       testScore  bodyLength mountainRange color       diet  breathesFire
    0   0.000000  175.512214      Bavarian  Blue  Carnivore             1
    1   0.742914  190.640959      Bavarian  Blue  Carnivore             1
       testScore  bodyLength
    0   0.000000  175.512214
    1   0.742914  190.640959
    

### **3.2.2   Single Column Extraction** 
If you're just looking to access one column, you have two options: 
*   Index operator, `df[col_name]`
*   Attribute operator, `df.colname`
  *   Notice, however, that these two only work for labels, not for indices.
  *   You can think of these as offering the same functionality as `df$colname` in R.


```python
# Selecting a single column by label:
print(dragons_df['bodyLength'])  # index operator []
print(dragons_df.bodyLength)  # attribute operator . and does not include " "

# Attempting unsuccesfully to select a single column by index
# print(dragons_df.0)
# print(dragons_df[0])
```

    0      175.512214
    1      190.640959
    2      169.708778
    3      188.847204
    4      174.221700
              ...    
    475    186.132578
    476    192.272043
    477    184.038015
    478    189.814408
    479    189.661989
    Name: bodyLength, Length: 480, dtype: float64
    0      175.512214
    1      190.640959
    2      169.708778
    3      188.847204
    4      174.221700
              ...    
    475    186.132578
    476    192.272043
    477    184.038015
    478    189.814408
    479    189.661989
    Name: bodyLength, Length: 480, dtype: float64
    

There is one caveat, however, to implementing an index operator with indices: if you use a slice, you'll end up getting the corresponding rows. This happens because `pandas` is only recognizing the slice in one direction—by rows. If you're looking to slice columns, you'll need to use the `.iloc` format.


```python
print(dragons_df[0:1])  # this does work, but only for sliced rows
```

       testScore  bodyLength mountainRange color       diet  breathesFire
    0        0.0  175.512214      Bavarian  Blue  Carnivore             1
    

### **3.2.3   Boolean Indexing** 
We can subset using conditional truth statements using boolean operators: 
*   Greater than: `>` 
*   Less than: `<`
*   Greater than or equal to: `>=`
*   Less than or equal to: `<=`
*   Equal to: `==`
*   Unequal to: `!=`

To filter by row values, we use the `.isin()` method that accepts a list-like object.


```python
# Subset only the rows for the dragons that received a passing score
print(dragons_df[dragons_df['testScore'] > 65])

# Filter out and keep only the rows for the dragons who cannot breathe fire
print(dragons_df[dragons_df['breathesFire'].isin([0])])  # must enclose in list
```

         testScore  bodyLength mountainRange   color        diet  breathesFire
    33   67.382720  212.229895       Central    Blue    Omnivore             1
    34   71.080284  214.752198       Central    Blue    Omnivore             1
    35   73.119070  213.582062       Central    Blue    Omnivore             1
    36   75.757683  204.952743       Central    Blue  Vegetarian             1
    37   76.930157  215.294360       Central    Blue    Omnivore             1
    ..         ...         ...           ...     ...         ...           ...
    455  76.515129  212.282806       Sarntal  Yellow    Omnivore             0
    456  77.152326  215.961638       Sarntal  Yellow    Omnivore             0
    457  81.883610  211.153312       Sarntal  Yellow    Omnivore             0
    458  87.413974  205.694126       Sarntal  Yellow    Omnivore             0
    459  94.106096  216.727091       Sarntal  Yellow    Omnivore             0
    
    [136 rows x 6 columns]
         testScore  bodyLength mountainRange   color        diet  breathesFire
    4     4.582095  174.221700      Bavarian    Blue   Carnivore             0
    14   25.201276  182.353952      Bavarian    Blue   Carnivore             0
    25   51.768306  210.940255       Central    Blue  Vegetarian             0
    32   59.540570  215.965209       Central    Blue  Vegetarian             0
    42   24.651235  206.677342      Emmental    Blue   Carnivore             0
    ..         ...         ...           ...     ...         ...           ...
    474  41.045542  190.352825      Southern  Yellow  Vegetarian             0
    475  41.806995  186.132578      Southern  Yellow  Vegetarian             0
    476  42.650015  192.272043      Southern  Yellow  Vegetarian             0
    478  47.795914  189.814408      Southern  Yellow  Vegetarian             0
    479  55.486722  189.661989      Southern  Yellow   Carnivore             0
    
    [229 rows x 6 columns]
    

### **3.2.4   Scalar Value Selection** 
There are actually quicker versions of the aforementioned `.loc()` and `.iloc()` methods that you can use when you're only interested in retrieving a scalar value, and they work the same way:
*   Scalar access by label: `.at()`
*   Scalar access by position: `.iat()`


```python
# Setting by label:
print(dragons_df.at[0,'bodyLength'])  # first row, first column

# Setting by position:
print(dragons_df.iat[0, 0])  # first row, first column
```

    175.5122137
    0.0
    

### **3.2.5   Ordered and Random Selection** 

Whether for ease of data review or because you're setting up a subsequent calculation, you can also order a subset of rows in either ascending or descending order:

*   Select and sort greatest to least n entries: `df.nlargest(n, 'colnames')`
*   Select and sort least to greatest n entries: `df.nsmallest(n, 'colnames')`

If, instead of an ordered sample, you'd like to obtain a random sample of n rows, you could use the following: df.sample(n)


```python
print(dragons_df.nlargest(50, 'testScore'))
print(dragons_df.nsmallest(50, 'testScore'))

print(dragons_df.sample(100))
```

          testScore  bodyLength mountainRange   color        diet  breathesFire
    79   100.000000  209.490674        Julian    Blue    Omnivore             1
    119  100.000000  198.874616      Maritime    Blue    Omnivore             1
    299  100.000000  193.423645       Sarntal     Red    Omnivore             1
    359  100.000000  200.182169       Central  Yellow    Omnivore             0
    436  100.000000  191.248929      Maritime  Yellow    Omnivore             0
    437  100.000000  192.917439      Maritime  Yellow    Omnivore             0
    438  100.000000  196.546624      Maritime  Yellow    Omnivore             0
    439  100.000000  200.272381      Maritime  Yellow    Omnivore             0
    435   99.605642  199.100041      Maritime  Yellow    Omnivore             0
    78    98.499816  215.733178        Julian    Blue    Omnivore             1
    239   97.647935  216.177762        Julian     Red    Omnivore             1
    279   95.106090  204.671957      Maritime     Red  Vegetarian             0
    298   94.545010  195.590678       Sarntal     Red    Omnivore             1
    77    94.116335  230.650417        Julian    Blue    Omnivore             1
    459   94.106096  216.727091       Sarntal  Yellow    Omnivore             0
    118   92.760852  202.011059      Maritime    Blue    Omnivore             1
    238   92.632400  214.918855        Julian     Red    Omnivore             1
    434   91.094122  195.293005      Maritime  Yellow    Omnivore             0
    199   90.031156  209.131404       Central     Red   Carnivore             1
    433   89.961323  208.371043      Maritime  Yellow    Omnivore             1
    358   89.915472  214.406738       Central  Yellow    Omnivore             0
    117   89.815497  202.899173      Maritime    Blue    Omnivore             1
    399   89.042531  232.513680        Julian  Yellow    Omnivore             0
    116   88.550200  192.770727      Maritime    Blue    Omnivore             1
    458   87.413974  205.694126       Sarntal  Yellow    Omnivore             0
    432   87.371212  204.092492      Maritime  Yellow   Carnivore             0
    278   87.201463  209.072897      Maritime     Red    Omnivore             1
    297   86.984696  193.414687       Sarntal     Red    Omnivore             1
    76    85.499126  220.173495        Julian    Blue    Omnivore             1
    398   85.072554  227.324594        Julian  Yellow    Omnivore             0
    431   84.767627  193.269179      Maritime  Yellow  Vegetarian             0
    59    84.272785  216.582753      Emmental    Blue    Omnivore             1
    296   84.269416  187.589529       Sarntal     Red    Omnivore             1
    237   84.192600  210.784914        Julian     Red    Omnivore             1
    277   83.969242  194.153313      Maritime     Red    Omnivore             1
    115   83.941677  200.733784      Maritime    Blue    Omnivore             1
    236   83.497061  202.689625        Julian     Red    Omnivore             0
    235   83.168146  209.188844        Julian     Red    Omnivore             1
    295   82.853902  195.131278       Sarntal     Red    Omnivore             0
    276   82.251778  199.007122      Maritime     Red    Omnivore             0
    259   82.127343  204.082620      Ligurian     Red    Omnivore             0
    294   82.012468  187.591883       Sarntal     Red    Omnivore             1
    457   81.883610  211.153312       Sarntal  Yellow    Omnivore             0
    39    81.471137  220.156269       Central    Blue    Omnivore             1
    114   81.470769  202.537720      Maritime    Blue    Omnivore             1
    38    81.138248  201.321573       Central    Blue    Omnivore             1
    113   80.892279  196.908408      Maritime    Blue    Omnivore             1
    75    80.448654  219.178612        Julian    Blue    Omnivore             0
    74    80.412169  217.214241        Julian    Blue  Vegetarian             1
    139   80.292789  201.469309       Sarntal    Blue    Omnivore             1
         testScore  bodyLength mountainRange   color        diet  breathesFire
    0     0.000000  175.512214      Bavarian    Blue   Carnivore             1
    140   0.000000  173.532588      Southern    Blue   Carnivore             1
    200   0.000000  189.605685      Emmental     Red   Carnivore             1
    300   0.000000  171.050730      Southern     Red   Carnivore             1
    1     0.742914  190.640959      Bavarian    Blue   Carnivore             1
    2     2.501825  169.708778      Bavarian    Blue   Carnivore             1
    160   2.557890  169.619382      Bavarian     Red   Carnivore             0
    460   2.599976  184.135925      Southern  Yellow   Carnivore             0
    161   3.282949  179.000774      Bavarian     Red   Carnivore             1
    3     3.380430  188.847204      Bavarian    Blue   Carnivore             1
    162   3.597530  167.510430      Bavarian     Red   Carnivore             1
    163   3.875730  164.416273      Bavarian     Red   Carnivore             0
    4     4.582095  174.221700      Bavarian    Blue   Carnivore             0
    164   6.038333  165.882952      Bavarian     Red   Carnivore             1
    400   6.411029  224.721753      Ligurian  Yellow   Carnivore             1
    165   7.358565  179.606068      Bavarian     Red   Carnivore             1
    320  10.825361  191.932215      Bavarian  Yellow   Carnivore             0
    5    12.453635  183.081931      Bavarian    Blue   Carnivore             1
    120  13.080916  199.999325       Sarntal    Blue   Carnivore             1
    321  14.013776  193.244146      Bavarian  Yellow   Carnivore             0
    141  14.381638  175.438152      Southern    Blue   Carnivore             1
    461  14.488204  196.060398      Southern  Yellow  Vegetarian             0
    80   14.565634  206.029133      Ligurian    Blue   Carnivore             1
    360  14.916917  220.749686      Emmental  Yellow   Carnivore             0
    462  14.999489  193.616367      Southern  Yellow   Carnivore             0
    81   15.042811  214.375613      Ligurian    Blue   Carnivore             1
    40   15.399484  211.185196      Emmental    Blue   Carnivore             1
    401  15.606387  225.451337      Ligurian  Yellow   Carnivore             0
    463  15.923599  188.993337      Southern  Yellow   Carnivore             0
    166  16.147309  165.548520      Bavarian     Red   Carnivore             1
    6    16.176758  174.839935      Bavarian    Blue   Carnivore             1
    7    16.249164  182.876708      Bavarian    Blue   Carnivore             1
    167  16.285131  170.819319      Bavarian     Red   Carnivore             1
    361  16.829491  222.505211      Emmental  Yellow   Carnivore             0
    8    16.852420  177.820550      Bavarian    Blue    Omnivore             1
    142  17.633001  176.474214      Southern    Blue   Carnivore             1
    168  18.442801  175.970409      Bavarian     Red   Carnivore             1
    9    18.452767  176.740267      Bavarian    Blue   Carnivore             1
    169  18.467754  169.770832      Bavarian     Red   Carnivore             1
    301  18.578797  169.845711      Southern     Red   Carnivore             1
    170  18.838821  167.685525      Bavarian     Red   Carnivore             1
    302  18.961916  168.670439      Southern     Red   Carnivore             1
    322  19.095881  192.895791      Bavarian  Yellow    Omnivore             0
    464  20.010852  187.867885      Southern  Yellow   Carnivore             0
    201  20.017659  196.343091      Emmental     Red  Vegetarian             0
    465  20.030181  191.637876      Southern  Yellow   Carnivore             0
    171  20.108537  170.053440      Bavarian     Red   Carnivore             1
    362  20.122821  217.988338      Emmental  Yellow   Carnivore             0
    172  20.242590  171.093272      Bavarian     Red   Carnivore             1
    323  20.462621  185.663441      Bavarian  Yellow   Carnivore             0
         testScore  bodyLength mountainRange   color        diet  breathesFire
    189  42.823690  213.113375       Central     Red  Vegetarian             1
    61   53.393965  222.517254        Julian    Blue  Vegetarian             1
    186  40.080020  216.481476       Central     Red  Vegetarian             1
    134  71.095966  200.127441       Sarntal    Blue    Omnivore             1
    11   20.489804  170.686850      Bavarian    Blue   Carnivore             1
    ..         ...         ...           ...     ...         ...           ...
    258  58.694412  205.190403      Ligurian     Red  Vegetarian             0
    197  67.121844  201.348759       Central     Red    Omnivore             0
    479  55.486722  189.661989      Southern  Yellow   Carnivore             0
    93   47.656285  210.898075      Ligurian    Blue  Vegetarian             1
    292  71.861195  187.583061       Sarntal     Red    Omnivore             1
    
    [100 rows x 6 columns]
    

### **3.2.6   Compound Selection** 
We can also subset data that fits multiple conditions:
*   Conjunctive ("and") logic: `&`
*   Disjunctive ("or") logic: `|`
*   Exclusive or ("xor") logic: `^`
  *   If this is confusing, you can decompose it into the following:

      `a ^ b = (a | b) & (~a | ~b)`

      `a ^ b = (a & ~b) | (~a & b)`
*   Not: `~`
  *   Make sure to wrap individual conditions in `()`


```python
# Subset rows for which both conditions are true
print(dragons_df[(dragons_df['testScore'] > 65) & 
                 (dragons_df['breathesFire'].isin([0]))])

# Subset rows for which at least one condition is true
print(dragons_df[(dragons_df['testScore'] > 65) | 
                 (dragons_df['breathesFire'].isin([0]))])

# Subset rows for which the first condition is true and the second is false
print(dragons_df[(dragons_df['testScore'] > 65) & 
                 ~(dragons_df['breathesFire'].isin([0]))])

# Subset rows for which there is a mismatch in truth values of conditions
print(dragons_df[(dragons_df['testScore'] > 65) ^ 
                 (dragons_df['breathesFire'].isin([0]))])
```

         testScore  bodyLength mountainRange   color      diet  breathesFire
    75   80.448654  219.178612        Julian    Blue  Omnivore             0
    110  70.153055  204.432935      Maritime    Blue  Omnivore             0
    196  66.766388  201.759702       Central     Red  Omnivore             0
    197  67.121844  201.348759       Central     Red  Omnivore             0
    227  66.689827  207.957300        Julian     Red  Omnivore             0
    ..         ...         ...           ...     ...       ...           ...
    455  76.515129  212.282806       Sarntal  Yellow  Omnivore             0
    456  77.152326  215.961638       Sarntal  Yellow  Omnivore             0
    457  81.883610  211.153312       Sarntal  Yellow  Omnivore             0
    458  87.413974  205.694126       Sarntal  Yellow  Omnivore             0
    459  94.106096  216.727091       Sarntal  Yellow  Omnivore             0
    
    [71 rows x 6 columns]
         testScore  bodyLength mountainRange   color        diet  breathesFire
    4     4.582095  174.221700      Bavarian    Blue   Carnivore             0
    14   25.201276  182.353952      Bavarian    Blue   Carnivore             0
    25   51.768306  210.940255       Central    Blue  Vegetarian             0
    32   59.540570  215.965209       Central    Blue  Vegetarian             0
    33   67.382720  212.229895       Central    Blue    Omnivore             1
    ..         ...         ...           ...     ...         ...           ...
    474  41.045542  190.352825      Southern  Yellow  Vegetarian             0
    475  41.806995  186.132578      Southern  Yellow  Vegetarian             0
    476  42.650015  192.272043      Southern  Yellow  Vegetarian             0
    478  47.795914  189.814408      Southern  Yellow  Vegetarian             0
    479  55.486722  189.661989      Southern  Yellow   Carnivore             0
    
    [294 rows x 6 columns]
          testScore  bodyLength mountainRange   color        diet  breathesFire
    33    67.382720  212.229895       Central    Blue    Omnivore             1
    34    71.080284  214.752198       Central    Blue    Omnivore             1
    35    73.119070  213.582062       Central    Blue    Omnivore             1
    36    75.757683  204.952743       Central    Blue  Vegetarian             1
    37    76.930157  215.294360       Central    Blue    Omnivore             1
    ..          ...         ...           ...     ...         ...           ...
    297   86.984696  193.414687       Sarntal     Red    Omnivore             1
    298   94.545010  195.590678       Sarntal     Red    Omnivore             1
    299  100.000000  193.423645       Sarntal     Red    Omnivore             1
    433   89.961323  208.371043      Maritime  Yellow    Omnivore             1
    452   73.617034  209.306230       Sarntal  Yellow    Omnivore             1
    
    [65 rows x 6 columns]
         testScore  bodyLength mountainRange   color        diet  breathesFire
    4     4.582095  174.221700      Bavarian    Blue   Carnivore             0
    14   25.201276  182.353952      Bavarian    Blue   Carnivore             0
    25   51.768306  210.940255       Central    Blue  Vegetarian             0
    32   59.540570  215.965209       Central    Blue  Vegetarian             0
    33   67.382720  212.229895       Central    Blue    Omnivore             1
    ..         ...         ...           ...     ...         ...           ...
    474  41.045542  190.352825      Southern  Yellow  Vegetarian             0
    475  41.806995  186.132578      Southern  Yellow  Vegetarian             0
    476  42.650015  192.272043      Southern  Yellow  Vegetarian             0
    478  47.795914  189.814408      Southern  Yellow  Vegetarian             0
    479  55.486722  189.661989      Southern  Yellow   Carnivore             0
    
    [223 rows x 6 columns]
    

### **3.2.7   Complex Boolean Logic** 
For more advanced logical operations designed specifically for dataframes, you also have the following two complementary options:

*   Check if **at least one value** in each dataframe column is `True`:
  *   `df.any()`
*   Check if **all** the values in each dataframe column are `True`:
  *   `df.all()`

Any given `pandas` element will be `True` by default. The only time they will be identified as `False` is when the element is equal to zero or missing.


```python
print(dragons_df.any())
print(dragons_df.all())
```

    testScore        True
    bodyLength       True
    mountainRange    True
    color            True
    diet             True
    breathesFire     True
    dtype: bool
    testScore        False
    bodyLength        True
    mountainRange     True
    color             True
    diet              True
    breathesFire     False
    dtype: bool
    

## **3.3   Data Types** 
There are two object types that `pandas` works with: `DataFrame` and `Series`. 

Now, I don't know about you, but the un-R-esque capital letters annoy me. Unfortunately, that's just what we have to work with. So how are they different? A `Series` is 1D while the `DataFrame` is 2D and built out of a collection of `Series`. However, a `Series` is more specifically a *labeled* 1D array, which means you can think of it as a single column with corresponding row labels preserved.

If we check the type of a single extracted column, we see that it is a `Series`. However, if we take a bunch of columns together, they're still grouped together as one `DataFrame` object. However, it's also totally possible to have a single-column `DataFrame` object.


```python
print(type(dragons_df))  # type of the entire dataframe
print(type(dragons_df['bodyLength']))  # type of a single column
print(type(dragons_df.iloc[:, 0:5]))  # type of a slice of several columns
```

    <class 'pandas.core.frame.DataFrame'>
    <class 'pandas.core.series.Series'>
    <class 'pandas.core.frame.DataFrame'>
    

### **3.3.1   Type Conversion**

Just like with vanilla Python type conversion functions (`list()`, `str()`, `int()`, etc.), we can directly convert any existing array-like object to a `Series` or a `DataFrame` by using corresponding constructors: `pd.Series()` and `pd.DataFrame()`.


```python
lst = [1, 2, 3, 'hello world']
tup = (1, 2, 3, 'hello world')

ser = pd.Series(lst)  # convert list to a pandas Series object
print(type(ser))
print(ser)

df = pd.DataFrame(ser)  # convert Series to a pandas DataFrame object
print(type(df))
print(df)

```

    <class 'pandas.core.series.Series'>
    0              1
    1              2
    2              3
    3    hello world
    dtype: object
    <class 'pandas.core.frame.DataFrame'>
                 0
    0            1
    1            2
    2            3
    3  hello world
    

As you can see in the above compile, Python automatically assigns indices (starting from 0) if you do not provide them. This happens for the 1D `Series` as well as the 2D `DataFrame`. However, you can also manually them, which we'll see in the next section.

## **3.4   Making pandas Objects from Scratch** 

We now know how to view and subset preformatted tabular data that we loaded! But what about when we need to create a `Series` or a `DataFrame` from scratch in Python? We have options, and I'll explain what I think are the most useful ones below.

In some cases, the input format will by nature already furnish column header labels. However, in other cases, you will have to manually rename the column header labels from the indices they default to, and the same is true for rows.


*   To set column names:
```
pd.DataFrame(data, columns = ['colname_1', 'colname_2', ..., 'colname_n'])
```
*   To set row (index) names:
```
pd.DataFrame(data, index = ['colname_1', 'colname_2', ..., 'colname_n'])
```

### **3.4.2   Dictionary → DataFrame** 


```python
my_exotic_fruits = {
    'fruit': ['cassabanana', 'rambutan', 'mangosteen', 'kiwano', 'atemoya'], 
    'outside_color': ['burgundy', 'red', 'purple', 'yellow', 'green'],
    'inside_color': ['yellow', 'white', 'white', 'green', 'white']}
             
print(pd.DataFrame(my_exotic_fruits,
                   index = ['fruit0', 'fruit1', 'fruit2', 'fruit3', 'fruit4']))
```

                  fruit outside_color inside_color
    fruit0  cassabanana      burgundy       yellow
    fruit1     rambutan           red        white
    fruit2   mangosteen        purple        white
    fruit3       kiwano        yellow        green
    fruit4      atemoya         green        white
    

### **3.4.1   Lists of Lists → DataFrame** 




```python
my_exotic_fruits = [['cassabanana', 'burgundy', 'yellow'], 
             ['rambutan', 'red', 'white'], 
             ['mangosteen', 'purple', 'white'], 
             ['kiwano', 'yellow', 'green'],
             ['atemoya', 'green', 'white']]  # each nested list is a row

no_labels_df = pd.DataFrame(my_exotic_fruits)
all_labels_df = pd.DataFrame(my_exotic_fruits, 
                       columns = ['fruit', 'outside_color', 'inside_color'],
                       index = ['fruit0', 
                                'fruit1',
                                'fruit2', 
                                'fruit3', 
                                'fruit4'])

print(no_labels_df)  # defaults to indices (0, 1, 2, ..., n)
print(all_labels_df)  # aligns with supplied column and row labels
```

                 0         1       2
    0  cassabanana  burgundy  yellow
    1     rambutan       red   white
    2   mangosteen    purple   white
    3       kiwano    yellow   green
    4      atemoya     green   white
                  fruit outside_color inside_color
    fruit0  cassabanana      burgundy       yellow
    fruit1     rambutan           red        white
    fruit2   mangosteen        purple        white
    fruit3       kiwano        yellow        green
    fruit4      atemoya         green        white
    

### **3.4.3   List of Dictionaries → DataFrame**


```python
my_exotic_fruits = [{'fruit': 'cassabanana', 
                     'outside_color': 'burgundy', 
                     'inside_color': 'yellow'},
                    {'fruit': 'rambutan', 
                     'outside_color': 'red', 
                     'inside_color': 'white'},
                    {'fruit': 'mangosteen', 
                     'outside_color': 'purple', 
                     'inside_color': 'white'},
                    {'fruit': 'kiwano', 
                     'outside_color': 'yellow', 
                     'inside_color': 'green'},
                    {'fruit': 'atemoya', 
                     'outside_color': 'green', 
                     'inside_color': 'white'}]  
                     # each nested dictionary is a row (with column headers)

print(pd.DataFrame(my_exotic_fruits,
                   index = ['fruit0', 'fruit1', 'fruit2', 'fruit3', 'fruit4']))
```

                  fruit outside_color inside_color
    fruit0  cassabanana      burgundy       yellow
    fruit1     rambutan           red        white
    fruit2   mangosteen        purple        white
    fruit3       kiwano        yellow        green
    fruit4      atemoya         green        white
    

# **4.   Data Cleaning**


## **4.1   Setting Data** 

We've talked about pulling out columns and rows, but what about adding them in or replacing existing values? In both cases, you just (re)assign a value to that table cell or group of cells.

### **4.1.1   Adding Data**

Let's say that there's a Goldilocks effect where dragons with a body length closer to 190 feet are nicer than those which are either too long or too short. If we assign this formula to a new column label, voilà, the new column is added for us! 


```python
print(dragons_df)
dragons_df['friendliness'] = (190 - abs(dragons_df['bodyLength'] - 190))/190
print(dragons_df)

```

         testScore  bodyLength mountainRange   color        diet  breathesFire
    0     0.000000  175.512214      Bavarian    Blue   Carnivore             1
    1     0.742914  190.640959      Bavarian    Blue   Carnivore             1
    2     2.501825  169.708778      Bavarian    Blue   Carnivore             1
    3     3.380430  188.847204      Bavarian    Blue   Carnivore             1
    4     4.582095  174.221700      Bavarian    Blue   Carnivore             0
    ..         ...         ...           ...     ...         ...           ...
    475  41.806995  186.132578      Southern  Yellow  Vegetarian             0
    476  42.650015  192.272043      Southern  Yellow  Vegetarian             0
    477  44.582490  184.038015      Southern  Yellow  Vegetarian             1
    478  47.795914  189.814408      Southern  Yellow  Vegetarian             0
    479  55.486722  189.661989      Southern  Yellow   Carnivore             0
    
    [480 rows x 6 columns]
         testScore  bodyLength  ... breathesFire friendliness
    0     0.000000  175.512214  ...            1     0.923748
    1     0.742914  190.640959  ...            1     0.996627
    2     2.501825  169.708778  ...            1     0.893204
    3     3.380430  188.847204  ...            1     0.993933
    4     4.582095  174.221700  ...            0     0.916956
    ..         ...         ...  ...          ...          ...
    475  41.806995  186.132578  ...            0     0.979645
    476  42.650015  192.272043  ...            0     0.988042
    477  44.582490  184.038015  ...            1     0.968621
    478  47.795914  189.814408  ...            0     0.999023
    479  55.486722  189.661989  ...            0     0.998221
    
    [480 rows x 7 columns]
    

### **4.1.2   Replacing Data**

Uh oh...more research has shown that dragons with a body length of 180 feet are actually the most friendly—looks like we messed up! If we change the formula for the Goldilocks number but still assign it to the same column label, we get our correct values.



```python
print(dragons_df)
dragons_df['friendliness'] = (180 - abs(dragons_df['bodyLength'] - 180))/180
print(dragons_df)
```

         testScore  bodyLength  ... breathesFire friendliness
    0     0.000000  175.512214  ...            1     0.923748
    1     0.742914  190.640959  ...            1     0.996627
    2     2.501825  169.708778  ...            1     0.893204
    3     3.380430  188.847204  ...            1     0.993933
    4     4.582095  174.221700  ...            0     0.916956
    ..         ...         ...  ...          ...          ...
    475  41.806995  186.132578  ...            0     0.979645
    476  42.650015  192.272043  ...            0     0.988042
    477  44.582490  184.038015  ...            1     0.968621
    478  47.795914  189.814408  ...            0     0.999023
    479  55.486722  189.661989  ...            0     0.998221
    
    [480 rows x 7 columns]
         testScore  bodyLength  ... breathesFire friendliness
    0     0.000000  175.512214  ...            1     0.975068
    1     0.742914  190.640959  ...            1     0.940884
    2     2.501825  169.708778  ...            1     0.942827
    3     3.380430  188.847204  ...            1     0.950849
    4     4.582095  174.221700  ...            0     0.967898
    ..         ...         ...  ...          ...          ...
    475  41.806995  186.132578  ...            0     0.965930
    476  42.650015  192.272043  ...            0     0.931822
    477  44.582490  184.038015  ...            1     0.977567
    478  47.795914  189.814408  ...            0     0.945476
    479  55.486722  189.661989  ...            0     0.946322
    
    [480 rows x 7 columns]
    

### **4.1.3   Renaming Columns**

We will very often need to rename columns to enhance readability. To do this, we use the following method:

*   `df.rename(columns={'old_name': 'new_name'})`



```python
dragons_df = dragons_df.rename(columns={'friendliness': 'passiveness'})
print(dragons_df)
```

         testScore  bodyLength mountainRange  ...        diet breathesFire  passiveness
    0     0.000000  175.512214      Bavarian  ...   Carnivore            1     0.975068
    1     0.742914  190.640959      Bavarian  ...   Carnivore            1     0.940884
    2     2.501825  169.708778      Bavarian  ...   Carnivore            1     0.942827
    3     3.380430  188.847204      Bavarian  ...   Carnivore            1     0.950849
    4     4.582095  174.221700      Bavarian  ...   Carnivore            0     0.967898
    ..         ...         ...           ...  ...         ...          ...          ...
    475  41.806995  186.132578      Southern  ...  Vegetarian            0     0.965930
    476  42.650015  192.272043      Southern  ...  Vegetarian            0     0.931822
    477  44.582490  184.038015      Southern  ...  Vegetarian            1     0.977567
    478  47.795914  189.814408      Southern  ...  Vegetarian            0     0.945476
    479  55.486722  189.661989      Southern  ...   Carnivore            0     0.946322
    
    [480 rows x 7 columns]
    

## **4.2   Missing Data** 

Missing data is automatically filled in as `np.nan`: numpy "**N**ot **a** **N**umber" (`NaN`) values. While R identifies two distinct values for missing and empty data [(the difference is quite nuanced)](https://www.r-bloggers.com/2010/04/r-na-vs-null/), NA and NULL, respectively, Python collapses these two into one. 

Let's pull up that table of exotic fruits from a while ago and plug in a missing value to play around.



```python
my_exotic_fruits_df = pd.DataFrame(my_exotic_fruits)
my_exotic_fruits_df.loc[0, 'fruit'] = np.nan

print(my_exotic_fruits_df)
```

            fruit outside_color inside_color
    0         NaN      burgundy       yellow
    1    rambutan           red        white
    2  mangosteen        purple        white
    3      kiwano        yellow        green
    4     atemoya         green        white
    

### **4.2.1   Dropping Missing Data**

A common problem in research is getting rid of bad or missing data. To quickly clear your dataset of such occurrences, we use the following command: `df.dropna(how="any")`


```python
print(my_exotic_fruits_df.dropna(how='any'))
```

            fruit outside_color inside_color
    1    rambutan           red        white
    2  mangosteen        purple        white
    3      kiwano        yellow        green
    4     atemoya         green        white
    

### **4.2.2   Renaming Missing Data**

On the contrary, what if we wanted to keep our missing data but assign a different placeholder name? We can do this by using the following command: `df.fillna(value='foo')` (by the way, 'foo' is a common placeholder you'll see)


```python
print(my_exotic_fruits_df.fillna(value='unknown_fruit_data'))
```

                    fruit outside_color inside_color
    0  unknown_fruit_data      burgundy       yellow
    1            rambutan           red        white
    2          mangosteen        purple        white
    3              kiwano        yellow        green
    4             atemoya         green        white
    

### **4.2.3   Locating Missing Data**

Another crucial function when dealing with missing data is finding where the holes are actually located. We have three options:

*   `pd.isna(df)`
*   `pd.isnull(obj)`
*   `pd.notna(obj)`
*   `pd.notnull(obj)`
  *   Note that these are two functionally identical pairs with the vestigial syntactical difference carrying over from R

For each of these functions, Python will return what's called a "boolean mask," a version of the dataframe or object we inputted that has all its values masked to reflect whether the value is missing or not.


```python
print(pd.isna(my_exotic_fruits_df))
print(pd.isnull(my_exotic_fruits_df))

print(pd.notna(my_exotic_fruits_df))
print(pd.notnull(my_exotic_fruits_df))
```

       fruit  outside_color  inside_color
    0   True          False         False
    1  False          False         False
    2  False          False         False
    3  False          False         False
    4  False          False         False
       fruit  outside_color  inside_color
    0   True          False         False
    1  False          False         False
    2  False          False         False
    3  False          False         False
    4  False          False         False
       fruit  outside_color  inside_color
    0  False           True          True
    1   True           True          True
    2   True           True          True
    3   True           True          True
    4   True           True          True
       fruit  outside_color  inside_color
    0  False           True          True
    1   True           True          True
    2   True           True          True
    3   True           True          True
    4   True           True          True
    

# **5.   Statistical Calculations**

## **5.1   Descriptives**

`pandas` offers a relatively comprehensive suite of functions for pulling together descriptive statistics:

*   `.sum()`
*   `.count()`
*   `.max()`
*   `.min()`
*   `.median()`
*   `.quantile([0.25, 0.75)`
*   `.mean()`
*   `.var()`
*   `.std()`
*   `.value_counts()`
*   `.nunique()`

Each of the functions/methods above returns a single value. Alternatively, you could run `df.describe` to provide a full output in `Series` format.


```python
bodl = dragons_df['bodyLength']

print(bodl.sum())
print(bodl.count())
print(bodl.max())
print(bodl.min())
print(bodl.median())
print(bodl.quantile([0.25, 0.75]))
print(bodl.mean())
print(bodl.var())
print(bodl.std())
print('\n')

print(bodl.value_counts())  # frequency table
print('\n')

print(bodl.nunique())  # count of total unique values
print('\n')

print(bodl.describe())  # full(er) descriptives table
```

    96631.9015289
    480
    236.36245290000002
    162.3266403
    202.91298255
    0.25    191.762141
    0.75    213.136002
    Name: bodyLength, dtype: float64
    201.3164615185418
    262.83612105632886
    16.212221348610093
    
    
    195.131278    1
    187.226044    1
    198.559975    1
    204.092492    1
    170.686850    1
                 ..
    208.055977    1
    234.915029    1
    172.626085    1
    200.156521    1
    209.373511    1
    Name: bodyLength, Length: 480, dtype: int64
    
    
    480
    
    
    count    480.000000
    mean     201.316462
    std       16.212221
    min      162.326640
    25%      191.762141
    50%      202.912983
    75%      213.136002
    max      236.362453
    Name: bodyLength, dtype: float64
    

## **5.1   Custom Functions**

Depending on the complexity of your data manipulations, you may very well like to apply far more intricate functions onto your dataframe columns. For this, we have the `.apply()` method.

While this method might initially appear to be a panacea, it should never be your first choice because it is fundamentally non-vectorized. What this means is that whatever function you apply to your dataframe column will be run on each row iteratively: in other words, highly inefficiently.


```python
dragons_df['diet'] = dragons_df['diet'].apply(lambda diet : 'Pesce-Pollotarian' 
                                              if diet == 'Omnivore' else 'Vegan'
                                              )
print(dragons_df['diet'].value_counts()) 
```

    Vegan                313
    Pesce-Pollotarian    167
    Name: diet, dtype: int64
    

# **6.   Data Transformations**

We're now going to talk about really awesome ways you can quickly combine and pivot your data! 

## **6.1   Combining Data**

When you're looking to add data to an existing dataframe, you can either to choose to append more rows or more columns. The method is the same for both transformations, and all you need to do is specify the axis of interest:

*   Add more rows:
  *   `pd.concat([df1,df2])`
*   Add more columns:
  *   `pd.concat([df1,df2], axis=1)`

The axis parameter always defaults to `axis=0`, so it is unnecessary to declare it unless you're working on the separate axis (sideways). Note that the concatenation function requires the input dataframes to be enclosed in an array-like object.


```python
my_new_exotic_fruits_df = pd.DataFrame(
    {'fruit': 
     ['ice cream bean', 'caviar lime', 'granadilla', 'tamarillo', 'sapodilla'],
     'outside_color': 
     ['green', 'green', 'yellow', 'red', 'tan'],
      'inside_color': 
     ['white', 'clear', 'grey', 'orange', 'tan']
    }
)

print(pd.concat([my_exotic_fruits_df, my_new_exotic_fruits_df], 
                ignore_index=True))  
# if we set ignore_index to True, the index incrementer does not get all wonky

print(pd.concat([my_exotic_fruits_df, my_new_exotic_fruits_df], axis=1, 
                ignore_index=True))  
# if we set ignore_index to True, the index incrementer does not get all wonky

```

                fruit outside_color inside_color
    0             NaN      burgundy       yellow
    1        rambutan           red        white
    2      mangosteen        purple        white
    3          kiwano        yellow        green
    4         atemoya         green        white
    5  ice cream bean         green        white
    6     caviar lime         green        clear
    7      granadilla        yellow         grey
    8       tamarillo           red       orange
    9       sapodilla           tan          tan
                0         1       2               3       4       5
    0         NaN  burgundy  yellow  ice cream bean   green   white
    1    rambutan       red   white     caviar lime   green   clear
    2  mangosteen    purple   white      granadilla  yellow    grey
    3      kiwano    yellow   green       tamarillo     red  orange
    4     atemoya     green   white       sapodilla     tan     tan
    

## **6.2   Pivoting Data**

To pivot data long to wide (increase columns, decrease rows):
*   `pd.pivot(index='idx', columns='var', values='val')`

To pivot data wide to long (increase rows, decrease columns):
*   `pd.melt(df)`

  *   Note that these are inverse operations, but they will not necessarily cancel each other out



```python
my_exotic_fruits_df['rarity'] = \
  ['rare', 'common', 'uncommon', 'uncommon', 'rare']
print(my_exotic_fruits_df)

my_exotic_fruits_pvt_df = my_exotic_fruits_df.pivot(
    index='rarity', columns='fruit', values='inside_color')
print(my_exotic_fruits_pvt_df)

my_exotic_fruits_pvt_df = pd.melt(
    my_exotic_fruits_pvt_df)
print(my_exotic_fruits_pvt_df)
```

## **6.3   Stacking Data**

We can also aggregate data into groups by using `df.stack()`. This is reversible by `df.unstack()`.


```python
print(my_exotic_fruits_df.stack())
print(my_exotic_fruits_df.stack().unstack())
```


## **6.4   Indices**

Okay, I've admittedly beaten around the bush for this one: what even are the row labels, the so-called "indices?"

They are an immutable object that stores axis data.

### **6.3.1   Re(setting) Indices**


```python
print(my_exotic_fruits_df)
my_exotic_fruits_df = my_exotic_fruits_df.set_index('fruit')
print(my_exotic_fruits_df)  # new set of indices along which to reference

my_exotic_fruits_df = my_exotic_fruits_df.reset_index()
print(my_exotic_fruits_df)  # indices returned to default
```

### **6.3.2   Multi-Indexing**

It's actually also possible to have a multi-index since you can set an index to be pairs of data rather than single values.


```python
index = pd.MultiIndex.from_tuples([('exotic', 'tropical'),
                                   ('exotic', 'desert'),
                                   ('non-exotic', 'deciduous')],
                                  names=['n','v'])

print(index)
```

    MultiIndex([(    'exotic',  'tropical'),
                (    'exotic',    'desert'),
                ('non-exotic', 'deciduous')],
               names=['n', 'v'])
    

## **6.4   Merging Data**

While we've already covered methods for combining data, we haven't yet addressed a more nuanced alternative to forcing data on top of or next to each other.

This is where the adaptable `pd.merge()` method comes into the picture:

*    `pd.merge(df1, df2, how='direction', on='colname')`


```python
print(pd.merge(my_exotic_fruits_df, my_new_exotic_fruits_df,
         how='left', on='fruit'))  # Join corresponding rows by first df

print(pd.merge(my_exotic_fruits_df, my_new_exotic_fruits_df,
         how='right', on='fruit'))  # Join corresponding rows by second df

print(pd.merge(my_exotic_fruits_df, my_new_exotic_fruits_df,
         how='inner', on='fruit'))  # Keep rows shared across both sets

print(pd.merge(my_exotic_fruits_df, my_new_exotic_fruits_df,
         how='outer', on='fruit'))  # Keep all rows and values
```

            fruit outside_color_x inside_color_x outside_color_y inside_color_y
    0         NaN        burgundy         yellow             NaN            NaN
    1    rambutan             red          white             NaN            NaN
    2  mangosteen          purple          white             NaN            NaN
    3      kiwano          yellow          green             NaN            NaN
    4     atemoya           green          white             NaN            NaN
                fruit outside_color_x inside_color_x outside_color_y inside_color_y
    0  ice cream bean             NaN            NaN           green          white
    1     caviar lime             NaN            NaN           green          clear
    2      granadilla             NaN            NaN          yellow           grey
    3       tamarillo             NaN            NaN             red         orange
    4       sapodilla             NaN            NaN             tan            tan
    Empty DataFrame
    Columns: [fruit, outside_color_x, inside_color_x, outside_color_y, inside_color_y]
    Index: []
                fruit outside_color_x inside_color_x outside_color_y inside_color_y
    0             NaN        burgundy         yellow             NaN            NaN
    1        rambutan             red          white             NaN            NaN
    2      mangosteen          purple          white             NaN            NaN
    3          kiwano          yellow          green             NaN            NaN
    4         atemoya           green          white             NaN            NaN
    5  ice cream bean             NaN            NaN           green          white
    6     caviar lime             NaN            NaN           green          clear
    7      granadilla             NaN            NaN          yellow           grey
    8       tamarillo             NaN            NaN             red         orange
    9       sapodilla             NaN            NaN             tan            tan
    

## **6.5   Pipelines** 

A common occurrence in tidyverse-powered R scripts is the useful `maggritr` pipeline symbol, `%>%`. Thankfully, this functionality can be recreated in Python with ease by simply chaining together statements with a newline break after each successive function:

```
df = pd.melt(df)
       .rename(columns={'variable' : 'var',
                'value' : 'val'})
       .rename(columns={'var1' : 'var2',
                'value2' : 'va2'})
```

# **7.   Conclusion and Additional Resources**

Phew—that was a lot! As I mentioned previously, this tutorial only goes so far in covering the full spectrum of functionality afforded by `pandas`. Once you're familiar with the above techniques, you can certainly dive deeper into the documentation at your leisure.

Below, I've included links to several resources that I've found helpful and referenced for this walkthrough:

*   Official Website
  *   [10 Minutes to pandas](https://pandas.pydata.org/pandas-docs/stable/user_guide/10min.html)
  *   [pandas Cookbook](https://pandas.pydata.org/pandas-docs/stable/user_guide/cookbook.html#cookbook)
  *   [pandas Cheatsheet](https://pandas.pydata.org/Pandas_Cheat_Sheet.pdf)
*   Learndatasci.com
  *   [pandas: A complete introduction](https://www.learndatasci.com/tutorials/python-pandas-tutorial-complete-introduction-for-beginners/)


