# MATLAB basics and regression
\matlabheading{![](2024-03-01-matlab-regression_images/)}
# 0. Why MATLAB?


MATLAB is a proprietary programming language and computing enviorment developed by MathWorks. It is specifically desinged for engineers and scientists who work with data matrices of large sizes. Some of its advantages over other options (e.g., R, Python) include:



   -  having a graphical user interface (GUI) 
   -  (relatively) easy-to-understand data types 
   -  comprehensive tried-and-tested built-in functions 
   -  various toolboxes for brain research and beyond 



Here are some famous/useful fMRI packages that you might use:


\begin{tabular} {|p{50pt}|p{382.2285461425781pt}|}\hline


[SPM](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/)


 & 

one of the most popular packages for preprocessing and analyzing neuroimaging data, besides FSL and AFNI


\\
\hline


[CONN](https://web.conn-toolbox.org/)


 & 

MATLAB- and SPM-based interactive toolbox for analyzing brain connectivity 


\\
\hline


[EEGLAB](https://sccn.ucsd.edu/eeglab/index.php)


 & 

interactive toolbox for processing EEG, MEG, and other electrophysiological data


\\
\hline


[FieldTrip](https://www.fieldtriptoolbox.org/)


 & 

non-interactive toolbox for processing MEG, EEG, and iEEG data


\\
\hline


[PsychToolbox](http://psychtoolbox.org/)


 & 

toolbox for controling visual and auditory stimulus presentation 


\\
\hline
\end{tabular}
  


And here are some previous DIBS Methods Meeting posts that used MATLAB to some extent: 



   -  [MATLAB basics](https://dibsmethodsmeetings.github.io/matlab-basics/) 
   -  [Multivariate pattern analysis](https://dibsmethodsmeetings.github.io/multivariate-pattern-analysis/) 
   -  [EEG Preprocessing using EEGLAB](https://dibsmethodsmeetings.github.io/eeg-analysis/)  
   -  [Decomposing Fourier transforms](https://dibsmethodsmeetings.github.io/fourier-transforms/) 

# 1. Getting started


Let's get started! If you haven't installed MATLAB or want to familiarize yourself with the GUI, please refer to [my earlier post on MATLAB basics](https://dibsmethodsmeetings.github.io/matlab-basics/) OR try out the online version here: [https://matlab.mathworks.com/.](https://matlab.mathworks.com)


# 2. Data types and operations


This was covered in a bit more depths in [my earlier post](https://dibsmethodsmeetings.github.io/matlab-basics/), but I thought I would do a quick review of some important things here because they are going to come up later as we talk about regression.


### Numeric types

\hfill \break


```matlab:Code
% double	Double-precision arrays (64-bit) <-- MATLAB default
% single	Single-precision arrays (32-bit)
% int8	    8-bit signed integer arrays
% uint8	    8-bit unsigned integer arrays
% ...
% for example:
class(1) % use the function class to check data types
```


```text:Output
ans = 'double'
```


```matlab:Code
% use space or comma to separate columns
% use semicolon to separate rows
% use square brackets [ ] to put things together
a = [1    2,    NaN;
    .5    Inf   nan] % this is a 2 x 3 double array
```


```text:Output
a = 2x3    
    1.0000    2.0000       NaN
    0.5000       Inf       NaN

```


```matlab:Code
% note the two special numbers: Inf and NaN (not a number)
class(a) % the data type is still 'double'
```


```text:Output
ans = 'double'
```

### Characters and Strings

\hfill \break


```matlab:Code
% use single quotes for characters
char1 = 'a';
char2 = 'abc';
% use double quotes for strings
str1 = "a";
str2 = "abc";
% check data types
class(char1);
class(str1);
% difference
length(char2)
```


```text:Output
ans = 3
```


```matlab:Code
length(str2)
```


```text:Output
ans = 1
```


```matlab:Code
% if we want to concatnate different things
[char1 char2] % correctly concatenated character array
```


```text:Output
ans = 'aabc'
```


```matlab:Code
str1 + str2 % correctly concatenated strings
```


```text:Output
ans = "aabc"
```


```matlab:Code
char1 + char2 % data type converted to numeric for addition
```


```text:Output
ans = 1x3    
   194   195   196

```


```matlab:Code
[char1 str2] % character coerced to string
```


```text:Output
ans = 1x2 string    
"a"          "abc"        

```

### Tables

\hfill \break


```matlab:Code
T = table;
T.col1 = [1; 2];
T.col2 = ["hello"; "world"];
T
```

| |col1|col2|
|:--:|:--:|:--:|
|1|1|"hello"|
|2|2|"world"|


```matlab:Code
% dimensions must match
T.col3 = repmat(3, height(T), 1);
try T.col4 = 4; catch err; disp(err); end
```


```text:Output
  MException with properties:

    identifier: 'MATLAB:table:RowDimensionMismatch'
       message: 'To assign to or create a variable in a table, the number of rows must match the height of the table.'
         cause: {}
         stack: [2x1 struct]
    Correction: []
```


```matlab:Code
% data type must be consistent within each row
T.col2(2) = 1;
T % see how 1 is coerced into "1"
```

| |col1|col2|col3|
|:--:|:--:|:--:|:--:|
|1|1|"hello"|3|
|2|2|"1"|3|


```matlab:Code
class(T.col2)
```


```text:Output
ans = 'string'
```

### Cell Arrays

\hfill \break


```matlab:Code
% use curly brackets to put together things of different sizes and types
C = {42, "abcd"; table(nan), [1 2 3]; Inf, {}}
```

| |1|2|
|:--:|:--:|:--:|
|1|42|"abcd"|
|2|1x1 table|[1,2,3]|
|3|Inf|0x0 cell|


```matlab:Code
C(2) % paratheses indexing retrieves the cell 
```


```text:Output
ans = 
    {1x1 table}

```


```matlab:Code
C{2} % curly braces indexing retrieves the cell *content*
```

| |Var1|
|:--:|:--:|
|1|NaN|



Arrays are effcient, but make sure you access the in the correct order.



```matlab:Code
% double arrays are indexed with parentheses
a = [11 12 13; 21 23 24]; % 2 x 3 double array
a
```


```text:Output
a = 2x3    
    11    12    13
    21    23    24

```


```matlab:Code
a(1, 2) % row 1, column 2
```


```text:Output
ans = 12
```


```matlab:Code
a(1:end, 2) % all rows, column 2
```


```text:Output
ans = 2x1    
    12
    23

```


```matlab:Code
a(2, :) % row 2, all columns
```


```text:Output
ans = 1x3    
    21    23    24

```


```matlab:Code
% here's something that may seem odd
a(4) % 4th entry
```


```text:Output
ans = 23
```


```matlab:Code
a(:) % all entries
```


```text:Output
ans = 6x1    
    11
    21
    12
    23
    13
    24

```



In Python and R, array data is stored **row-wise**. In contrast, MATLAB arrays are stored **column-wise**, even though they are easily defined row-wise. 




┑(￣Д ￣)┍ 


### Structures

\hfill \break


```matlab:Code
% group data using fields
% each field can be of any data type, including structures
S = struct;
S.field1_struct = struct;
S.field2_cell = C;
S.field3_table = T;
S.field4_char = char1;
S
```


```text:Output
S = 
    field1_struct: [1x1 struct]
      field2_cell: {3x2 cell}
     field3_table: [2x3 table]
      field4_char: 'a'

```

# 3. Regression


Let's talk about regression! Through the official [Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html), we have access to several built-in MATLAB functions for regression. 




First, let's load some data. We are going to use an [open dataset on Kaggle on life expectancy](https://www.kaggle.com/datasets/kumarajarshi/life-expectancy-who). The original data came from the World Health Organization (WHO), who has been keeping track of the life expectancy and many other health factors of all countries. The final dataset consists of 20 predictor variables and 2938 rows, containing information for 193 countries between 2000 and 2015.



```matlab:Code
data_table = readtable("2024-03-01-matlab-regression-Life-Expectancy.csv", ...
    "VariableNamingRule", "preserve"); % preserve white space in column names for readability
head(data_table);
```


```text:Output
        Country        Year        Status        Life expectancy    Adult Mortality    infant deaths    Alcohol    percentage expenditure    Hepatitis B    Measles    BMI     under-five deaths    Polio    Total expenditure    Diphtheria    HIV/AIDS     GDP      Population    thinness  1-19 years    thinness 5-9 years    Income composition of resources    Schooling
    _______________    ____    ______________    _______________    _______________    _____________    _______    ______________________    ___________    _______    ____    _________________    _____    _________________    __________    ________    ______    __________    ____________________    __________________    _______________________________    _________

    {'Afghanistan'}    2015    {'Developing'}           65                263               62           0.01               71.28                65          1154      19.1            83             6            8.16               65          0.1       584.26    3.3736e+07            17.2                   17.3                        0.479                   10.1   
    {'Afghanistan'}    2014    {'Developing'}         59.9                271               64           0.01              73.524                62           492      18.6            86            58            8.18               62          0.1        612.7    3.2758e+05            17.5                   17.5                        0.476                     10   
    {'Afghanistan'}    2013    {'Developing'}         59.9                268               66           0.01              73.219                64           430      18.1            89            62            8.13               64          0.1       631.74    3.1732e+07            17.7                   17.7                         0.47                    9.9   
    {'Afghanistan'}    2012    {'Developing'}         59.5                272               69           0.01              78.184                67          2787      17.6            93            67            8.52               67          0.1       669.96     3.697e+06            17.9                     18                        0.463                    9.8   
    {'Afghanistan'}    2011    {'Developing'}         59.2                275               71           0.01              7.0971                68          3013      17.2            97            68            7.87               68          0.1       63.537    2.9786e+06            18.2                   18.2                        0.454                    9.5   
    {'Afghanistan'}    2010    {'Developing'}         58.8                279               74           0.01              79.679                66          1989      16.7           102            66             9.2               66          0.1       553.33    2.8832e+06            18.4                   18.4                        0.448                    9.2   
    {'Afghanistan'}    2009    {'Developing'}         58.6                281               77           0.01              56.762                63          2861      16.2           106            63            9.42               63          0.1       445.89    2.8433e+05            18.6                   18.7                        0.434                    8.9   
    {'Afghanistan'}    2008    {'Developing'}         58.1                287               80           0.03              25.874                64          1599      15.7           110            64            8.33               64          0.1       373.36    2.7294e+06            18.8                   18.9                        0.433                    8.7   
```



Let's validate the information in the description above.



```matlab:Code
fprintf( ...
    "Number of rows = %d \n" + ...
    "Number of years = %d \n" + ...
    "Number of countries = %d \n", ...
    height(data_table), ...
    length(unique(data_table.Year)), ...
    length(unique(data_table.Country)));
```


```text:Output
Number of rows = 2938 
Number of years = 16 
Number of countries = 193 
```



For simplicity, we are going to focus on the most recent complete sample (year 2014) and on the following variables:



   -  Life expectancy (in years) 
   -  Status: "Developed", "Developing" 
   -  Total expenditure: General government expenditure on health as a percentage of total government expenditure (%) 


```matlab:Code
data_2014 = data_table(data_table.Year==2014, ["Country" "Status" "Total expenditure" "Life expectancy"]);
head(data_2014);
```


```text:Output
            Country                Status        Total expenditure    Life expectancy
    _______________________    ______________    _________________    _______________

    {'Afghanistan'        }    {'Developing'}          8.18                59.9      
    {'Albania'            }    {'Developing'}          5.88                77.5      
    {'Algeria'            }    {'Developing'}          7.21                75.4      
    {'Angola'             }    {'Developing'}          3.31                51.7      
    {'Antigua and Barbuda'}    {'Developing'}          5.54                76.2      
    {'Argentina'          }    {'Developing'}          4.79                76.2      
    {'Armenia'            }    {'Developing'}          4.48                74.6      
    {'Australia'          }    {'Developed' }          9.42                82.7      
```



Before actually fitting a linear regression model, let's plot the data.



```matlab:Code
close all
figure
gscatter( ...
    data_2014.("Total expenditure"), ... x-axis
    data_2014.("Life expectancy"), ... y-axis
    data_2014.Status ... color
    );
title("Life Expectancy against Healthcare Expenditure in 2014")
```


![](2024-03-01-matlab-regression_images/)



We make 3 observations:



   1.  There are much fewer developed countries (orange) than developing countries (blue).  
   1.  Developed countries tend to have higher life expectancy than developing countries. 
   1.  Life expectance MAYBE is positively correlated with heathcare expenditure for developing countries, but less so for developed countries. 



Now let's fit some linear regression models! 




We're going to use the [`fitlm`](https://www.mathworks.com/help/stats/linear-regression-model-workflow.html) function in MATLAB. This function provides very detailed outputs. 



```matlab:Code
data_2014.Status = categorical(data_2014.Status, ["Developing" "Developed"]); %%% note the order
data_2014.LE = data_2014.("Life expectancy");
data_2014.TE = data_2014.("Total expenditure");
m1 = fitlm(data_2014, "LE ~ TE * Status");
% anova(m1, "component", 3) %%% Type III anova
m1 %%% regression coefficients and stats
```


```text:Output
m1 = 
Linear regression model:
    LE ~ 1 + Status*TE

Estimated Coefficients:
                           Estimate      SE        tStat       pValue  
                           ________    _______    _______    __________

    (Intercept)              65.288     1.5208      42.93    1.6594e-95
    Status_Developed         15.824     3.6356     4.3525    2.2717e-05
    TE                      0.73836    0.24142     3.0584     0.0025709
    Status_Developed:TE    -0.73511    0.45121    -1.6292       0.10505

Number of observations: 181, Error degrees of freedom: 177
Root Mean Squared Error: 7.15
R-squared: 0.307,  Adjusted R-Squared: 0.295
F-statistic vs. constant model: 26.1, p-value = 5.11e-14
```



Note that it's critically important to know how to correctly interpret these results, e.g., what is the "Intercept" and whether "TE" is a simple effect or a main effect. See more in [Kevin's post on *Interpreting Regression Coefficients*](https://dibsmethodsmeetings.github.io/contrasts/). Briefly, the order of the categorical variable AND whether the continuous variable is mean-centered matters. Let's see:



```matlab:Code
data_2014.Status_rev = categorical(data_2014.Status, ["Developed" "Developing"]);
data_2014.TE_mc = data_2014.TE - mean(data_2014.TE, "omitmissing");
m2 = fitlm(data_2014, "LE ~ TE_mc * Status");
m3 = fitlm(data_2014, "LE ~ TE_mc * Status_rev");
m1.Coefficients
```

| |Estimate|SE|tStat|pValue|
|:--:|:--:|:--:|:--:|:--:|
|1 (Intercept)|65.2878|1.5208|42.9296|0|
|2 Status_Developed|15.8237|3.6356|4.3525|0|
|3 TE|0.7384|0.2414|3.0584|0.0026|
|4 Status_Developed:T...|-0.7351|0.4512|-1.6292|0.1050|


```matlab:Code
m2.Coefficients
```

| |Estimate|SE|tStat|pValue|
|:--:|:--:|:--:|:--:|:--:|
|1 (Intercept)|69.8664|0.5929|117.8317|0|
|2 Status_Developed|11.2652|1.5557|7.2414|0|
|3 TE_mc|0.7384|0.2414|3.0584|0.0026|
|4 Status_Developed:T...|-0.7351|0.4512|-1.6292|0.1050|


```matlab:Code
m3.Coefficients
```

| |Estimate|SE|tStat|pValue|
|:--:|:--:|:--:|:--:|:--:|
|1 (Intercept)|81.1316|1.4382|56.4102|0|
|2 Status_rev_Develop...|-11.2652|1.5557|-7.2414|0|
|3 TE_mc|0.0032|0.3812|0.0085|0.9932|
|4 Status_rev_Develop...|0.7351|0.4512|1.6292|0.1050|



Let's quickly plot the effects of TE (with 95% confidence intervals) on LE, separately for developed and developing countries. This is essentially doing `plot(ggemmeans(m, \textasciitilde{} TE + Status))` in R.



```matlab:Code
plotSlice(m2); %%% alternative syntax: `m2.plotSlice;` 
```


![](2024-03-01-matlab-regression_images/)



However, If we need to fit a large number of models and don't really need detailed statistics from each model, we can use the [`regress`](https://www.mathworks.com/help/stats/regress.html) function to trade comprehensiveness for speed. 



```matlab:Code
% define outcome variable
y = data_2014.LE;
% define predictor variables
X = nan(length(y), 4); %%% initialize 3 columns
X(:, 1) = 1; %%% constant term is NOT automatically put into the model!
X(:, 2) = double(data_2014.Status=="Developing"); %%% manually code the categorical variable
X(:, 3) = data_2014.("Total expenditure") - mean(data_2014.("Total expenditure"), "omitmissing");
X(:, 4) = X(:, 2) .* X(:, 3); %%% interaction term
[b, bint, r, rint, stats] = regress(y, X);
b
```


```text:Output
b = 4x1    
   81.1316
  -11.2652
    0.0032
    0.7351

```


```matlab:Code
m3.Coefficients
```

| |Estimate|SE|tStat|pValue|
|:--:|:--:|:--:|:--:|:--:|
|1 (Intercept)|81.1316|1.4382|56.4102|0|
|2 Status_rev_Develop...|-11.2652|1.5557|-7.2414|0|
|3 TE_mc|0.0032|0.3812|0.0085|0.9932|
|4 Status_rev_Develop...|0.7351|0.4512|1.6292|0.1050|


```matlab:Code
all(m3.Coefficients.Estimate == b)
```


```text:Output
ans = 
   1

```



Ta-da! As we can see the regression coefficients we obtained using `regress` are exactly the same as what we had from `fitlm` earlier, though we no longer have the nice-looking table filled with stats. However, the (very crude) test below shows that `regress` is indeed a lot faster than `fitlm`.



```matlab:Code
tic
for i=1:500
    y = data_2014.LE;
    % define predictor variables
    X = nan(length(y), 4); %%% initialize 3 columns
    X(:, 1) = 1; %%% constant term is NOT automatically put into the model!
    X(:, 2) = double(data_2014.Status=="Developing"); %%% manually code the categorical variable
    X(:, 3) = data_2014.("Total expenditure") - mean(data_2014.("Total expenditure"), "omitmissing");
    X(:, 4) = X(:, 2) .* X(:, 3); %%% interaction term
    [b, bint, r, rint, stats] = regress(y, X);
end
toc
```


```text:Output
Elapsed time is 0.201044 seconds.
```


```matlab:Code
tic
for i=1:500
    m = fitlm(data_2014, "LE ~ TE_mc * Status_rev");
end
toc
```


```text:Output
Elapsed time is 5.250400 seconds.
```

# 4. Conclusion


We've made it to the end of MATLAB basics and regression (yay!), though this is just the tip of the iceberge of regression models out in the wild world, such as regularized regression, nonlinear regression, and mixed-effects regression. Feel free to check out how they are can be implemented in MATLAB [here](https://www.mathworks.com/help/stats/introduction-to-parametric-regression-analysis.html). 




Enjoying MATLAB-ing!


