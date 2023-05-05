---
author: Trevor
featured: True
categories: [programming,professional development]
image: "https://upload.wikimedia.org/wikipedia/commons/0/04/ChatGPT_logo.svg"
title: "A new frontier of coding: Effectively using LLMs technologies to help you code better: Featuring ChatGPT"
---

<style>
.bordered-table {
	border: 1px white solid;
	background-color: #00539B;
}

.bordered-table td {
	border: 1px white solid;
	padding: 10px;
}

.bordered-table th {
	border: 1px white solid;
	padding: 10px;
}

.bordered-table tbody tr:nth-child(odd) {
	background-color: #012169;
}
</style>

# History: The Evolution of Coding 

Humans have been coding since the begining of time (1950s). The first programmers wrote code in low-level languages such as machine code, which was difficult to understand and time-consuming to write. After that, the first high  level languages  were developed in the 1950s and 60s (FORTRAN and COBOL), programming became more accessible to a wider range of users.

In this era of programming, learning how to code often involved reading lengthy programming manuals or taking formal classes. Programmers had to rely **soley** on their own knowledge and experience to write code,  and debugging often involved manually tracing through lines of code to identify errors. All of which is still true to an extent to this day!

With the rise of the internet, programmerss gained access to online resources such as forums and communities where they could ask for help and get feedback on their code. Websites like Stack Overflow, GitHub, Codecademy, have all became safe havens for programmers seeking guidance and collaboration.

As such, it is now common for many programmers to use these online resources to supplement their knowledge and to quickly find solutions to programming problems. They may not memorize every line of code or programming syntax, but instead rely on their ability to search for solutions and adapt them to their own projects.


Today, a new way of programming has risen in popularity and is all but certained to change the way we code. This module is meant to discuss the benefits,limitations, and ethics of using llms to help us write our code, specifically [Chat GPT](https://chat.openai.com/). Welcome to this brand new fronteir: using learning langague models to help us code!

**TLDR**: The history of how programmers code has evolved from a primarily manual and knowledge-based process to one that incorporates online communities and resources, to incorporate LLMs to help us code.

# Introduction

Language learning models have revolutionized the field of natural language processing, allowing machines to understand and generate human language with unprecedented accuracy. However, these models have also shown promise in other fields, including computer programming. By applying the same principles of language processing to code, machine learning models can help users effectively code better. For the purpose of this talk, and to stay on track, we will primarily be focusing on how these models can help us code better (yes it can do other impressive stuff but that’s beyond the scope of today’s discussion). By using language learning models, users can identify errors in their code more quickly, improve code readability and efficiency, and even generate new code based on existing examples. In this introduction, we will explore how language learning models(specifically ChatGPT) can be used to help users effectively code better, and how this technology is transforming the field of software development.

# Limitations/Disclaimers

While ChatGPT is a powerful language model that can generate human-like responses, it has limitations when it comes to assisting in coding. By ChatGPTs own claim the limitations include:

1) Lack of domain-specific knowledge: ChatGPT has been trained on a broad range of texts but it may not have the same level of expertise in coding as a human programmer. As a result, its ability to provide accurate and reliable solutions to coding problems may be limited.

2) Inability to understand context: ChatGPT may not always understand the context of a coding problem, which can lead to inaccurate or incomplete solutions. This is especially true for complex coding problems that require a deep understanding of the codebase and the programming language being used.

3) Limited ability to handle ambiguity: ChatGPT may struggle with ambiguous programming concepts and may not be able to provide clear and concise solutions to coding problems. This can be especially challenging for beginner programmers who may not have a solid grasp of programming concepts themselves.

4. Limited ability to interact with code: ChatGPT can provide text-based responses to coding questions, but it cannot interact directly with code. This means that users may have to manually implement the solutions suggested by ChatGPT, which can be time-consuming and error-prone. 
   - Other sources like [Github Co-Pilot](https://github.com/features/copilot) might directly give you suggestions as you code though kind of like a spell check


Overall, while ChatGPT can be a useful tool for assisting with coding, it should be used as a complementary resource rather than a replacement for human programmers.

Also note: while the longterm accessibility of the ChatGPT interface is not guaranteed, it is almost certain the LLMs and technology like it are here to stay for a long time (so might as well use it).

# Demo 

Ok for this audience I carefully thought of some low and high level problems a ccn student might face and how chatgpt can help. In this demon I will go over a few scenarios and prompts one might ask the program to do at a variety of level of coding
Afterwards, we can incorporate more prompts based off the group present today and I will post them onto the site for later use as well as the responses.

Example Prompts to ask it:

We will be using the following data as reference:
```python

import pandas as pd

# Create a dictionary of data for 10 people
data = {
    'Name': ['Alice', 'Bob', 'Charlie', 'David', 'Emma', 'Frank', 'Grace', 'Henry', 'Ivy', 'Jack'],
    'Age': [25, 32, 41, 28, 36, 22, 29, 33, 24, 27],
    'Gender': ['Female', 'Male', 'Male', 'Male', 'Female', 'Male', 'Female', 'Male', 'Female', 'Male'],
    'Occupation': ['Engineer', 'Teacher', 'Doctor', 'Designer', 'Journalist', 'Programmer', 'Lawyer', 'Salesperson', 'Artist', 'Writer'],
    'Hometown': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Francisco'],
    'Salary': [75000, 55000, 110000, 65000, 80000, 50000, 90000, 60000, 45000, 70000]
}

# Create a DataFrame from the data dictionary
df = pd.DataFrame(data)

# Print the DataFrame
print(df)

```
1. Sorting Data
   - What is an array?
   - What is a dataframe?
   - How to access elements in a dataframe?
   - How to access elements of a specific range in dataframe
   - How to get all elements of a specific range in two columns of a given dataframe
   -	Write an exception for element of a specific set value.
   - How to get all elements of a specific range in a variable number of columns in a given dataframe 
      - Now keep in mind it altered the function from two threads ago…also a thing? 
2. Plotting Data
   - How to plot 2 dimensional array? Where one array is on the x axis and the other array is on the y axis?
   - How to plot two lines with the plot command from an individual 2 dimensional array
   - How to add color
   - how to normalize all elements of an array
   - how to plot two subplots side to side
      - Note: if you plotted data enough all of this probably seems fairly trivial? If that is you, what is something you would like to see coded up that can definetly save you time.

3. Say you want to know how to run a script from the command line to call upon specific data entries
4. Learning how to do something in another common syntax
5.	Apparently it can debug snippets of code for you 
6. What elese can it do?

   ![Alt Text](https://y.yarn.co/bc02da9a-0957-42b3-a222-864478755120_text.gif)




**Now could you have done all this without chatgpt?** 


**Yes obviously. But the speed and efficiency if you don’t fully know everything can’t be understated.**


# Good use cases for chat gpt in coding:
1) An effective teaching model 
2) For relatively simple things you know should exist but might not have in your working memory. 
   - For those of you who already code this is where using the internet as an external resource comes in handy
   - chatgpt has some layer of remembering what you just asked it so you can get some small level of context by constantly building on your question: (as i showed you already)

## Here's what ChatGPT Claims it can do:

3)	Generating code snippets: ChatGPT can generate code snippets based on natural language descriptions of the desired functionality. This can be useful for beginners who are learning to code and need assistance with syntax and structure.
4)	Identifying errors: ChatGPT can help identify errors in code by analyzing the code and providing suggestions for correction. This can be helpful for both beginners and experienced programmers who are debugging their code
5)	Providing explanations: ChatGPT can provide explanations for programming concepts and terminology, which can be useful for beginners who are still learning the basics.
6)	Suggesting optimizations: ChatGPT can suggest optimizations for code, such as replacing loops with vectorized operations or using more efficient algorithms. This can be helpful for experienced programmers who are looking to improve the performance of their code.
7)	Generating documentation: ChatGPT can generate documentation for code by analyzing the code and producing natural language descriptions of its functionality. This can be useful for programmers who need to document their code for future reference or for other team members. ( Ir did not try this)

Overall, while ChatGPT may have limitations when it comes to assisting with coding, it can still be a valuable tool for generating code snippets, identifying errors, providing explanations, suggesting optimizations, and generating documentati

## My personal suggestions: 
   As stated before this should be a complementary resource rather than a full replacement. There is still base knowledge you should know. Whats an array the general syntax, etc. etc. Now granted chatgpt might be able to teach you it or you can use youtube or any number of free resources to help you understand the basics but needing to clearly state your objective is important. Also this will not help you build a large scale coding program but it can help build small pieces of it that make the overall workload more effecient. Like turning a 1000 piece puzzle to a 150 piece puzzle cause it merges a few of the components already, making it easier and efficient.

# Ethical Considerations:

1. How was this data trained? 
2. How is human layer potentially being exploited.
3. What are potential societal problems with this new technology


# Final thoughts 
   Regardless of what form this LLM takes, its within good reason to believe this technology is here to stay for a long time. Its a change, and change can be scary or exciting. Its like how the rise of wikipedia was to our teachers, or the birth of smartphones, when we were warned we wouldn't have access to calculators/internet all the time. As late millenials, we have all seen the rise of several technological advances in our lifetimes and adapted accordingly. This time is no different, so I think we should embrace it with an open mind.
