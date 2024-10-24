---
title: "Intro to Reference Managers"
author: kaylee
categories: [ tutorial ]
<<<<<<< HEAD
image: assets/images/2024-10-11-reference-managers/zotero_logo.jpg
=======
image: assets/images/2024-10-11-reference-managers"/zotero_logo.jpg
>>>>>>> 1049563c19fd38b3574d80869ae8692c4408c322
featured: false
hidden: false
output:
  html_document: default
  pdf_document: default
  md_document:
    variant: gfm
    preserve_yaml: TRUE
---

<<<<<<< HEAD
=======
# Intro to Reference Managers
>>>>>>> 1049563c19fd38b3574d80869ae8692c4408c322
Ok, so you’re a student who’s trying to sort through the pile of research papers in preparation for starting a new project, writing your MAP, or adding on to your dissertation.

How do you even begin to navigate the confusing landscape that is academic journals? How do you keep track of the papers you’ve read, the papers you’d like to read, the papers that are related to specific topics, etc.? That’s where reference managers come in! There are lots of tutorials online for the different reference managers, but how do you know which manager to use? Here, I’ll be going into detail for four of the most popular managers: Zotero, Mendeley, EndNote, and Google Notebook to hopefully give you a better idea of which one will be best suited to your needs. None of the reviews here will be super comprehensive, but it should hopefully point you in the right direction for which one you’d like to learn more about/play around with. 


## **Zotero**

### **The basics / navigating the environment:**
![Untitled](/assets/images/2024-10-11-reference-managers"/zotero_general_layout.jpg)	 
			
On the lefthand side, you’ll see your library, which contains your “collections”, which is just a bunch of different folders you create to help you organize your papers into themes. The middle pane is just going to be the contents within each folder. The righthand pane has some fun stuff: you can add notes (I like to summarize the papers or why I decided to save them here). You can also add tags, which you can use to search for later. For instance, if I’m interested in looking for papers relating to a specific part of fMRI (e.g., connectivity studies), I can add the tag. A helpful one I do is to tag review papers as “review”.  You can also attach papers that are related to each other using the related feature. 

Another thing to note is that if a paper fits with multiple collections (e.g., it’s an fMRI paper on identity), you can add a pdf to multiple “collections” without duplicating the pdf. And then, speaking of duplicates, there is a feature that checks for it and automatically gets rid of them for you when you activate it.
	

### **Plugins and integration with other software:**

Zotero has lots of plugins to explore to help streamline your reference process, including ones for importing metadata items (such as the number of times a paper has been cited), integrating Zotero with your website (e.g., importing citations or bibliographies directly into your website), and managing file attachments (e.g., attach other files to Zotero items). You can find the full list [here]( https://www.zotero.org/support/plugins), but I’ll quickly go over some of the handiest ones, which are of course the ones that integrate your citations when writing papers:

-	**Word:**
    - There is a plugin for Zotero that allows you to quickly and easily cite any paper within your Zotero library (with the citation style of your choice) in Microsoft Word. When you download Zotero, the plug in *should* be automatically included, but if for some reason it's not, you can also install it [here](). Something that’s very nice about this integration is that when you use the “add a bibliography” feature, it automatically updates whenever you add new in-text citations. 

![Untitled](/assets/images/2024-10-11-reference-managers"/zotero_word_plugin.png)


-	**Google Docs:**
    - If you prefer Google Docs over Word, Zotero also has a plugin for Docs [here]( https://www.zotero.org/download/connectors) that allows you to use the same functions you would with Word. Although, it’s not a plugin specific to Docs; rather, it’s a plugin specific to each web browser (like Safari, Chrome, and Firefox) that Zotero can then use to access Docs. Once you’ve installed the plugin, it should show up automatically in Docs, similar to how it did for Word:

![Untitled](/assets/images/2024-10-11-reference-managers"/zotero_docs_plugin.jpg)


-	**Overleaf / LaTeX:**
    - If you’re a freak and use Overleaf/LaTeX (pointing at you, Kevin), you can also install a plugin for Zotero integration [here]( https://retorque.re/zotero-better-bibtex/installation/). This mainly lets you pull citations from Zotero in BibTex format, which is the format used in the LaTeX .bib file (i.e., the file where you store your bibliography). 


### **Nifty tricks / tips:**

**- Exporting highlighted text to notes:**
    - When you open the PDF, and highlight the text within Zotero, you can click right click on the file to select “add note from annotations” and it will export anything you highlighted to a separate note file, with the page number for each excerpt.
		
**-  Using the "Groups" feature:**
    - You can create private libraries in Zotero, which is very helpful if you’re working in a group on a specific paper. It makes it very easy for everyone to share important articles related to the paper and suggest other ones to read. There also isn't a limit to the number of private groups you can create. The one downside is that it can be tricky to keep using the auto-update feature for bibliographies in your papers in Word or Docs if one member of the group doesn’t use Zotero.

**- RFT feature**
    - Format the bibliography from citations alone:
     - Select the citation style you’d like to recognize, select the file you’d like to scan; it must be saved as a rich text format file (as opposed to a word doc or pdf), and it will create a bibliography for you using the citations alone. This comes in handy if you are someone with a fantastic memory and know the author and year of the sources off the top of your head, and just want to fill out the bibliography after the fact. 

**- Keeping track of the papers you’ve read vs the ones you still need to read:**
    - The easiest way is to just keep a collection titled “to read” that you download all your new papers to, but that isn’t always super convenient if you want to sort by topic and don't want to have to move a paper into a new folder everytime you've finished reading one. So, you can install a plugin [here]( https://github.com/Dominic-DallOsto/zotero-reading-list/blob/master/README.md) through Github. It adds an entire column to keep track of what has been read, what you’re in the middle of reading (I like this one a lot), and what you still need to read.

![Untitled](/assets/images/2024-10-11-reference-managers"/zotero_reading_list.jpg)


## **Mendeley**
Mendeley is probably the second most popular reference manager, but be warned, a lot of people have switched to Zotero in recent years. In 2013, Elsevier purchased it, and in 2022, they moved from "Mendeley Desktop" to "Mendeley Reference Manager". Basically, they opted to eliminate the local storage option and opt for a cloud / web-based version instead. You get 2 GB of storage with the free version. However, the web-based version doesn't have some of the well-loved features from the original desktop version, making it a tad less user-friendly. For instance, you can't export your annotated PDFs anymore in Mendeley Reference Manager.

**Navigating the environment:**

![Untitled](/assets/images/2024-10-11-reference-managers"/mendeley_layout.png)


Like with Zotero, you can use Mendeley to store references in one place, directly export citations, automate bibliographies and citations, keep notes attached to your sources, and attach different types of files to each source. It also has plugins for web integration, but in general it has a smaller selection to work with. However, it doesn't have Google Docs integration. You can also use a similar "Group" feature to create shared folders with collaborators, but the free version is limited to 1 private group (but has unlimited public groups). In a public group, anyone can see it and add references to it, and you are unable to share file notes/annotations across groups. Whereas in a private group, only invited members can see the references, and notes/annotations can be seen by all group members.

## **EndNote**
EndNote is the reference manager that wins the award for longest to hang around, with the first version coming out almost 20 years before Zotero or Mendeley. It is the reference manager I am least familiar with. EndNote performs many of the same basic functions as Zotero and Mendeley, but I personally found it to be a bit clunkier and less intuitive. Though, I will say that EndNote seems to be great for people who are likely to have a higher number of sources. Their storage is capped at 50,000 files. 

**Navigating the environment:**

![Untitled](/assets/images/2024-10-11-reference-managers"/endnote_layout.png)


Like Zotero, EndNote should be automatically integrated with Word (known as Cite While you Write) and this plugin is also available for Google Docs, which can be found [here](https://workspace.google.com/marketplace/app/endnote_21_cite_while_you_write/948545547135). You can also have shared libraries or groups. The shared libraries can have up to 1,000 members, which is just for sharing sources, and the shared groups are analagous to the private group (Mendeley) and private library (Zotero).

However, EndNote has a free version (EndNote Basic) and a paid version (EndNote Online). Most universities will grant access to EndNote Online for free, but if you aren't currently affiliated with a university, you will have to pay if you don't want to deal with limited storage space or being unable to mark up PDFs within the program.

## **Google NotebookLM**

I’m not here to say whether or not we should be using AI to help us with our research…but I feel compelled to present what I’ve found. NotebookLM is a bit different, since it’s using advanced AI. The comparison I’d use here is if Zotero or Mendeley are 2-D point and click video games, then NotebookLM is more of an open-world game. You kind of get out what you put into those two, but with NotebookLM, that’s not necessarily the case. There can be more “bang for your buck” when using it. Just like with Zotero or Mendeley, you can organize your papers in “collections” (Zotero) or "folders" (Mendeley); in this case, they’re simply referred to as different “notebooks” instead. However, NotebookLM is not going to have any integration with text softwares; you won't be using this to automate citations in your papers, so this is something else that makes it a bit different from typical reference managers. But, I still opted to include it here because while it may not be the *best* reference management tool, it has the potential to be extremely helpful with notetaking and synthesizing your sources.  

**Navigating the environment:**
To start, I began a new notebook and uploaded my first source. I uploaded a paper on the self and identity in aging, (what *I’m* interested in) and it quickly synthesized the source and gave me a list of options to choose from:

![Untitled](/assets/images/2024-10-11-reference-managers"/google_NB_layout.jpg)




For something that's a little more... relatable? I also uploaded a paper on metaphysics:

![Untitled](/assets/images/2024-10-11-reference-managers"/google_NB_farts.jpg)

Does any option stand out to you in the picture above?  
 
That’s right! You can ask the notebook to create a ***podcast*** from a journal article! That’s crazy! And something that’s worth noting is that it can also do this with things other than pdfs. You can upload Google Docs, Google Slides, webpage URLs, and youtube URLs.

**Some Cons:**
- So far, there’s no direct interface with Zotero or Mendeley, so you have to upload each pdf one by one, which can quickly get tiring if you’ve got a lot to add.

- It also doesn’t automatically update the pdf name when you upload it like it does in Zotero or Mendeley, so if you download a lot of papers that have the characteristic string of random numbers and letters (e.g., “fpsyg-09-00094.pdf”), good luck.

- The current version only seems to allow 50 sources per notebook.

- Each notebook is completely separate, so you can’t access information across notebooks (which is a pretty big bummer, if you ask me).

 

## **Consensus?**

![Untitled](/assets/images/2024-10-11-reference-managers"/consensus_table1.png)

Ultimately, if this post has made you curious about one of the other reference managers, you should know that it is *relatively* easy to switch from one to another if you primarily take notes instead of using the annotations features. For all three programs, you can easily export your libraries from one to another. However, if there were citations you had to manually update, you will need to double check that they imported correctly. You should also be warned that if you go to switch from Mendeley to another reference manager, you will lose any annotations or highlights you made to the pdfs directly. While that may be daunting, it will only get worse the longer you wait to make the switch. :)

With that being said, I hope this post has given you the "lay of the land" and that at the very least, if you were already committed to a particular reference manager, that you learned something new about it today! 
