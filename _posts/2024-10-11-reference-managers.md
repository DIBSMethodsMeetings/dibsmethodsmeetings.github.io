---
title: "Intro to Reference Managers"
author: kaylee
categories: [ tutorial ]
image: assets/images/2024-10-11-reference-managers"/zotero_logo.jpg
featured: false
output:
  html_document: default
  pdf_document: default
  md_document:
    variant: gfm
    preserve_yaml: TRUE
---

Ok, so you’re a student who’s trying to sort through the pile of research papers in preparation for starting a new project, writing your MAP, or adding on to your dissertation.

How do you even begin to navigate the confusing landscape that is academic journals? How do you keep track of the papers you’ve read, the papers you’d like to read, etc.? That’s where reference managers come in! There are lots of tutorials online for the different reference managers, but how do you know which manager to use? Here, I’ll be going into detail for four of the most popular managers: Zotero, Mendeley, and Google Notebook to hopefully give you a better idea of which one will be best suited to your needs. None of the reviews here will be super comprehensive, but it should hopefully point you in the right direction for which one you’d like to learn more about/play around with. 


### **Zotero**

## **The basics / Navigating the environment:**
		 
			
On the lefthand side, you’ll see your library, which contains your “collections”, which is just a bunch of different folders you create to help you organize your papers into themes. The middle pane is just going to be the contents within each folder. The righthand pane has some fun stuff: you can add notes (I like to summarize the papers or why I decided to save them here). You can also add tags, which you can use to search for later. For instance, if I’m interested in looking for papers relating to a specific part of fMRI (e.g., connectivity studies), I can add the tag. A helpful one I do is to tag review papers as “review”.  You can also attach papers that are related to each other using the related feature. 

Another thing to note is that if a paper fits with multiple collections (e.g., it’s an fMRI paper on identity), you can add a pdf to multiple “collections” without duplicating the pdf. And then, speaking of duplicates, there is a feature that checks for it and automatically gets rid of them for you when you activate it.
	

## **Plug ins and integration with other software:**

Zotero has lots of plugins to explore to help streamline your reference process, including ones for importing metadata items (such as the number of times a paper has been cited), integrating Zotero with your website (i.e., importing citations or bibliographies directly into your website), and managing file attachments (i.e., attach other files to Zotero items). You can find the full list [here]( https://www.zotero.org/support/plugins), but I’ll quickly go over some of the handiest ones, which are of course the ones that integrate your citations when writing papers:

-	Word:
There is a plugin for Word that allows you to quickly and easily cite any paper within your Zotero library (with the citation style of your choice). Something that’s nice about this is that when you use the “add a bibliography” feature, it automatically updates whenever you add new in-text citations. How to install?

-	Google Docs:
If you prefer Google Docs over Word, Zotero also has a plugin for Docs [here]( https://www.zotero.org/download/connectors) that allows you to use the same functions you would with Word. Although, it’s not a plugin specific to Docs; rather, it’s a plugin specific to each web browser (like Safari, Chrome, and Firefox) that Zotero can then use to access Docs. Once you’ve installed the plugin, it should show up automatically in Docs, similar to how it did for Word:
 
-	Overleaf / LaTeX
If you’re a freak and use Overleaf/LaTeX (pointing at you, Kevin), you can also install a plugin for Zotero integration [here]( https://retorque.re/zotero-better-bibtex/installation/). This mainly lets you pull citations from Zotero in BibTex format, which is the format used in the LaTeX .bib file (i.e., the file where you store your bibliography). 


## **Nifty tricks / tips:**

	- exporting highlighted text to notes
You can click “add note from annotations” and it will export anything you highlighted to a separate note file, with the page number for each excerpt.
		
	-  using the Groups feature
You can create private libraries in Zotero, which is very helpful if you’re working in a group on a specific paper. It makes it very easy for everyone to share important articles related to the paper and suggest other ones to read. The one downside is that it can be tricky to keep using the auto-update feature for bibliographies in your papers in Word or Docs if one member of the group doesn’t use Zotero.

- Keeping track of the papers you’ve read vs the ones you still need to read.
The easiest way is to just keep a collection titled “to read” that you download all your new papers to, but that isn’t always super convenient if you want to sort by topic. So, you can install a plugin [here]( https://github.com/Dominic-DallOsto/zotero-reading-list/blob/master/README.md) through Github. It adds an entire column to keep track of what has been read, what you’re in the middle of reading (I like this one a lot), and what you still need to read. 
 


	- RFT feature
        Format the bibliography from citations alone:
          Select the citation style you’d like to recognize, select the file you’d like to scan; it must be saved as a rich-text format file (as opposed to a word doc or pdf), and it will create a bibliography for you using the citations alone

### **Mendeley**
-	Poo poo


### **Google NotebookLM**
-	I’m not here to say whether or not we should be using AI to help us with our research…but I must present what I’ve found. NotebookLM is a bit different, since it’s using advanced AI. The comparison I’d use here is if Zotero or Mendeley are 2-D point and click video games, then NotebookLM is an open world game. You kind of get out what you put into those two, but with NotebookLM, that’s not necessarily the case. There can be more “bang for your buck” when using it.
-	Just like with Zotero or Mendeley, you can organize your papers in “collections”; in this case, they’re simply referred to as different “notebooks” instead.
-	I tried uploading a paper on the self and identity in aging, (what *I’m* interested in) and it quickly gave me a list of options to choose from. 

-	Does any option stand out to you in the picture below?  
 
-	That’s right! You can ask the notebook to create a ***podcast*** from a journal article! That’s crazy! 
-	Also, something that’s worth noting, is that it can also do this with things other than pdfs. You can upload Google Docs, Google Slides, webpage URLs, and youtube URLs.

-	Cons: 
o	So far, there’s no direct interface with Zotero or Mendeley, so you have to upload each pdf one by one, which can quickly get tiring if you’ve got a lot to add.
o	It also doesn’t automatically update the pdf name when you upload it, so if you download a lot of papers that have the characteristic string of random numbers and letters (i.e., “fpsyg-09-00094.pdf”), good luck.
o	The current version only seems to allow 50 sources per notebook.
o	Each notebook is completely separate, so you can’t access information across notebooks (which is a pretty big bummer, if you ask me).

 

### **Consensus?**

```
|                                     |         Storage         |          Versatility         |         Versatility         |
|: ------------------------- | :--------------------: | :------------------------: |:------------------------: |
| Zotero                        |  unlimited local   | this text is left-alig  | this text is left-alig  |
| Mendeley                  |  this text is cent  | this text is left-alig  | this text is left-alig  |
| NotebookLM             |  this text is cent  | this text is left-alig  | this text is left-alig  |


Storage 300 MB for online storage (unlimited for local) on Zotero, 50 sources/200 MB for each notebook, 2 GB for web storage (u
