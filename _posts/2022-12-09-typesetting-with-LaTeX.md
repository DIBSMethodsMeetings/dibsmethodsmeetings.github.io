---
title: "Typesetting with LaTeX"
author: nathan
categories: [ programming ]
image: https://www.latex-project.org/img/latex-project-logo.svg
featured: true
---

<div align="center">
<img src="https://www.latex-project.org/img/latex-project-logo.svg" width=500px><br/>
<font size='6'>
<strong>Typesetting with $$\LaTeX$$</strong></font></div>
<div align="center"><font size='4'>Author: Nathan Liang</font></div>

# **Introduction**

## **A Brief History of Typesetting**

**Manual Typesetting**<br>
(1000/1450 CE–Late 1800s)
<div align=center>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Handsatz.jpg/1200px-Handsatz.jpg" width=200px><br>
Composing stick and type cases
</div>
<p>
For the longest time, printing text required authors ("compositors") to line up metal character molds ("sorts") one by one to form words, lines, and then pages on metal racks ("composing sticks").
</p><br>


**Hot Metal Typesetting**<br>
(Late 1800s–Early 1900s)
<div align=center>
<img src="https://upload.wikimedia.org/wikipedia/commons/3/32/Linotype-vorne-deutsches-museum-annotated.jpg" width=200px><br>
Linotype Model 5cS
</div>
<p>
Instead of manually assembling by hand text to be printed character by character, people were finally able to type in the letter sequences they wanted to form. Still, the text wasn't directly imprinted on each keypress. Rather, the characters would be entered into a queue forming a "matrix" to be cast as a sequence of characters on one big metal block called a "slug."
</p><br>

**Phototypesetting**<br>
(1960s–1980s)
<div align=center>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Linotype_CRTronic_360.jpg/1280px-Linotype_CRTronic_360.jpg" width=200px><br>
Linotype CRTronic 360
</div>
<p>
Characters from font sets inscribed on glass strips were transcribed by light exposure onto light-sensitive paper. The process was conducted first via punched tape before the introduction of computers.
</p><br>


**TeX and LaTeX**<br>
(1970s–Present Day)
<div align=center>
<img src="https://images.ctfassets.net/nrgyaltdicpt/5dTnhJWWRVNgYyAODYkgV/adcfdfa3f58ad885d808ed4abca2748d/Tex_Live_Colour_Emojis_Code_Example.png" width=200px><br>
Overleaf
</div>
<p>
The TeX typesetting system was developed and then popularized through the LaTeX macro package. Today, people generally prepare documents in LaTeX using GUIs.
</p><br>


**WYSIWYG**<br>
(1980s–Present Day)
<div align=center>
<img src="https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE3ByzZ?ver=f85f&q=90&m=2&h=768&w=1024&b=%23FFFFFFFF&aim=true" width=200px><br>
Microsoft Word
</div>
<p>
The invention of intuitive word processing systems enabled desktop publishing for straightforward document preparation. While these types of software do not offer the same amount of fine-grain control over typography as TeX/LaTeX, they get the job done with very little onboarding.
</p><br>


## **What is $\LaTeX$?**
<div align="center">
<img src="https://highxtar.com/wp-content/uploads/2022/03/highxtar-kim-kardashian-es-pro-latex-10-702x1024.jpg" width="250px"></br>
<font size=2>Mind the case-sensitive spelling (and pronunciation).</font>
</div>

$\LaTeX$ is an open-source typesetting **software** for styling plain-text with markup conventions. It's a direct alternative to "what you see is what you get" (literally: "WYSIWYG") document preparation software—which is usually proprietary like MS Word, although not *always* (e.g., Google Docs). In other words, it's a programmatic way to format a document (articles and presentations).

It's most commonly either pronounced "LAH-teck" (/ˈlɑːtɛx/) or the equally acceptable "LAY-teck" (/ˈleɪtɛk/)—the latter being my preferred choice for clarity's sake, although *technically* it should be the first. I've also heard of "luh-TECK", but that might be a one-off...

<div align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/ViewsIceberg.svg/1920px-ViewsIceberg.svg.png" width="500px"></br>
<font size=2>A model of content authoring. We love our Freudian icebergs.</font>
</div>

I understand that this supposed "definition" might be quite confusing at first blush, so I think a much better way to conceptualize this is through examples:<br>
* LaTeX (Source Code) → Markdown (WYSIWYM) → Microsoft Word/PowerPoint (WYSIWYG)
* HTML (Source Code) → Wix/Squarespace/WordPress (WYSIWYG)

Just as a website contains plain text—just the actual characters you see on the screen—that has been styled with CSS and JavaScript, LaTeX involves styling plain text with commands known technically as *macros* (more on this later).

## **Why (Not) Use $\LaTeX$?**

The million dollar question. There's generally a clear answer for when you could (and, as TeX users will argue, therefore, <em>should</em>) or shouldn't use LaTeX, but there's also some limited grey area in between where it'll be up to your discretion whether to opt for a WYSIWYG editor instead.<br><br>

**Advantages:**
* Produces the highest quality PDF documents
* Separates content and formatting
* By far the best system for formatting complex mathematical formulas
* Highly effective for managing bibliographies
* More frequently used in the natural sciences
* Open-source (free), huge support community, and thousands of packages
* Old, so 99.9% of questions have already been answered online
* Built on the ideal of backcompatibility
* Modular, can quickly format repeated sections
* Great for:
  * Manuscripts
  * CVs and Resumes
  * Poster Presentations
  * Slideshows
  * Exams<br><br>

**Disadvantages:**
* Tough initial learning curve
* Modifying document layout is not just a click away—it wasn't designed for this purpose!
* Complicates collaboration as it is not as commonly used by social scientists or the general populace
* (Generally) not great for:
  * Flyers
  * Advertisements
  * Visually complex presentations (e.g., animations)<br><br>

**\*MS Word vs. LaTeX**
* Collaborators
  * What's best for you may very well depend on what's best for your collaborators. Science is a team sport, and it would never make sense to insist on using something as fancy as LaTeX to draft a manuscript unless everyone were comfortable with it.
  * If everyone on your team wants to use LaTeX, however, there are platforms which readily support real-time collaboration on TeX files—the most popular of these being Overleaf.
* Functionality
  * LaTeX was designed for typesetting professional documents. If you're creating a promotional flyer with a freeform layout, I would absolutely not recommend turning to LaTeX. In fact, I would recommend turning to the other extreme with even more WYSIWYG alternatives than MS Office such as Figma.
* Efficiency
  * While MS Word allows you to quickly edit a document and get it "up and running" with drag and drop GUI functionality, formatting can become messy, disorganized, and difficult to reproduce at scale with increasing complexity.
  * There are hundreds upon hundreds of freely reusable templates posted online, so unless you're starting from scratch, you should always check to see if someone has already done the first few steps for you.<br><br>

\*I use MS Word as the canonical WYSIWYG comparison exemplar, but LaTeX offers general parallel (although not necessarily specialized) functionality to a wide range of other software such as MS PowerPoint, Adobe XD, etc.

<br>
<div align=center>
<img src="https://www.pinteric.com/pic/miktex.gif"><br>
LaTeX is almost certainly harder to learn from the get-go than portrayed here, but the trend is arguably quite accurate.
</div>

## **Why is LaTeX stylized as $\LaTeX$?**

> "[...] it's important to notice another thing about TeX's name: The E is out of kilter. This displaced E is a reminder that TeX is about typesetting, and it distinguishes TeX from other system names. In fact, TEX (pronounced tecks) is the admirable Text EXecutive processor developed by Honeywell Information Systems. Since these two system names are pronounced quite differently, they should also be spelled differently. The correct way to refer to TeX in a computer file, or when using some other medium that doesn't allow lowering of the E, is to type TeX. Then there will be no confusion with similar names, and people will be primed to pronounce everything properly."

<div align=right>
―Donald Knuth
</div>

The font, by the way, is called "Computer Modern" and was designed by Donald Knuth himself. If you see any documents formatted online with this earmark typography, you'll know it was formatted in LaTeX!

## **$\TeX$ vs. $\LaTeX$**

The distinction between TeX and LaTeX is of the utmost confusion to a lot of people—for good reason! As long as you understand *what* TeX is, you'll almost certainly never have to deal with it. LaTeX was designed specifically to harness TeX functionality in a more user-friendly way. In other words, TeX controls underlying layout, LaTeX determines content preparation.

To understand this relationship, we can again turn to a more familiar example:
* LaTeX is built on TeX macros → Python Standard Library is built on C

> "Think of LaTeX as a house built with the lumber and nails provided by TeX. You don't need lumber and nails to live in a house, but they are handy for adding an extra room. Most LaTeX users never need to know any more about TeX commands than they can learn from this book."

<div align=right>
―Leslie Lamport
</div>

## **The Men Behind the Madness**
<div align=center>
<img src="https://www.brandeis.edu/magazine/2017/fall/images/07WebFeatures/02Lamport/Lamport265.jpg" height=200px style="border-radius: 50%">
<img src="https://static01.nyt.com/images/2018/12/18/science/18SCI-KNUTH2/merlin_148140651_0cac5ef1-2369-42fb-8bdf-597b8d02e7e7-jumbo.jpg" height=200px><br>
<div width=100px>
Leslie Lamport (Turing Award, 2013) & Donald Knuth (Turing Award, 1974)
</div>
</div>

**Donald Knuth** set out to develop TeX during his sabbatical, but he ended up taking nearly a decade to complete the project. He was motivated to do so after receiving from the publisher a very poorly formatted second edition for one of his books.

**Leslie Lamport** independently wrote his own macros for TeX which he was convinced to document and package into LaTeX. Today, however, basically everyone today actually uses a version called LATEX2ε subsequently released and updated by a team of developers.

The "TeX" portion of the name LaTeX comes from the Ancient Greek word "$$τέχνη$$" meaning "art," "craft," or "workmanship." The "La" comes from Leslie Lamport's surname, so it's a portmanteau of "Lamport" + "TeX" = (**La**)mport's (**TeX**) = **LaTeX**

## **A Note on Gatekeeping and Necessity**

Before we progress through the rest of this tutorial, I just want to note: no matter what "experts" may furiously argue on online forums, LaTeX is entirely **not** something you *need* to learn, even as neuroscientists. Is it a great tool that can help you tremendously with scientific writing? Absolutely. But, this in no way means that you *must* learn how to do everything in LaTeX that you could otherwise also do with other technology (e.g., manuscripts in Word, poster presentations in PowerPoint). Learning LaTeX is quite the investment, and it may or may not be worth the time and effort for *you*.

I self-studied LaTeX when I had plenty of down time during the pandemic because I bought into the hype while getting more into computational cognitive science and thought I *needed* to learn it. This isn't to say that I regret my decision—I don't, because I actually do think that it's been useful for various reasons, like sharpening my debugging skills—but my time might also have been more productively used elsewhere. I ended up spending hours upon hours poring over Stack Overflow/TeX Exchange and reading docs that I really didn't *need* for anything I was trying to do.

In almost every online article describing the supposedly innumerable benefits of LaTeX—however subtly or with as much chagrin as it might be done—you will inevitably hear the argument that one ought to use it because it "looks impressive [on your CV]" or "will make you stand out." Be that as it may, that should never be your *primary* motivation.

On TeX forums, you'll frequently hear people describing why LaTeX is objectively superior to MS Word: how the latter is an ugly, useless, basic software. Frankly, these are usually nothing more than thinly veiled attempts to flex. MS Word is a great technology, and I believe its merits are not mutually exclusive of those of LaTeX.

Ironically, while one might think that proprietary software would stand more starkly in opposition to the spirit of good science, the complexity of open-source LaTeX can also discourage people from trying to learn it. In many ways, LaTeX is just like Vim: for most, it's at first counterintuitive, hard to pick up, and at the end of the day, also unnecessary for 99.9% of everyday typesetting needs. Of course, that doesn't stop people from trying to gatekeep...
<br><br>

<div align=center>
<img src="https://preview.redd.it/jt0tq1u6izq51.jpg?width=640&crop=smart&auto=webp&s=6ea9cf46b9091fbf7ca19dc5bd70711bfbfc5af3" width=250px><br>
The dreaded tech bro strikes again.
</div>


# **Under the Hood**

## **The Wonderful World of $$*$$-$$\TeX$$**


<div align="center">
<h2><strong>Hierarchical Schematic</strong></h2>
<h3>
Distributions<br>(<code>MiKTeX</code>, <code>Tex Live</code>)<br>
↓<br>
Engines<br>(<code>TeX</code>, <code>pdfTeX</code>, <code>XeTeX</code>, <code>LuaTeX</code>)<br>
↓<br>
Formats<br>(<code>LaTeX</code>, <code>pdfLaTeX</code>, <code>XeLaTeX</code>, <code>LuaLaTeX</code>)<br>
↓<br>
Packages<br>(<code>fontspec</code>, <code>geometry</code>, <code>hyperref</code>)<br>
↓<br>
"Commands"<br>(<code>\chapter</code>, <code>\section</code>, <code>\newcommand{\R}{\mathbb{R}}</code>)
</h3>
*<em>Not exactly a nesting doll relationship; "commands" is used as a non-technical term here.</em><br><br>

<h2><strong>Relational Schematic</strong></h2>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/LaTeX_diagram.svg/650px-LaTeX_diagram.svg.png">
</div>

LaTeX predates modern document output formats such as Portable Document Format (PDF), which is why it must be converted first from PostScript (the ancestor of PDF) and DeVice Independent (DVI) file formats.

While DVI to PDF has functional limitations, there are also merits to keeping each of these output formats the way they are. DVI to PDF produces a much smaller file size because it compacts the font. Also, DVI to SVG, for example, maintains hyperlinks. PostScript, on the other hand, is optimized for printing.

## **The Little Engines that Could**

LaTeX is compiled using an **engine**. The act of compilation is called a **format** (e.g., XeTeX). There are various flavors of TeX each with their own benefits/downsides, but in terms of functionality ordered from least to most powerful, it would be: `TeX`, `pdfTeX`, `XeTeX`, and then `LuaTeX`.

Engine (Binary Executable) | Description | Advantages/Disadvantages
---: | :--- | :---
`TeX` | Knuth's original TeX | Most basic engine, you're probably never going to use it
`e-TeX` | Added several primitives to TeX | Functionality has been incorporated into newer engines anyway, so need to use it
`pdfTeX` | eTeX plus pdf-relevant primitives | Default engine of contemporary TeX systems
`XeTeX` | eTeX plus some pdfTeX primitives and supports Unicode | Best option for formatting custom fonts
`LuaTeX` | XeTeX plus embedded Lua scripting functionality | Useful if you're going to script in Lua
`(u)pTeX` | pTeX is for vertically written Japanese, upTeX is a further extension that supports Unicode | Unless, of course, you're writing in Japanese, you're not going to use this

# Quick Math

## **Quick Maths**
<div align=center>
<img src="https://i.ytimg.com/vi/N1TetLavxuA/maxresdefault.jpg" width=500px><br>
LaTeX is renowned for its quick, easy, and beautiful formatting of mathematical formulae
</div>



## **Math Mode**

Everything in this section will be written in *math mode*, a set of environments for formatting mathematical formulae. There are three subsets of math mode:

Inline (Default) Math Environment
* `\begin{math} ... \end{math}`
* `\( ... \)`
* `$ ... $`

Display Math Environment
* `\begin{displaymath} ... \end{displaymath}`
* `\[ ... \]`
* `$$ ... $$` (Not recommended in LaTeX2ε)

* $$P(A \mid B) = \frac{P(B \mid A) \, P(A)}{P(B)}$$

Equation Math Environment
* `\begin{equation} . . . \end{equation}`


## **Operators and Relational Symbols**

| Control Sequence | Output | Control Sequence | Output |
| --- | --- | --- | --- |
| `\times` | $$\times$$ | `\geq` | $$\geq$$ |
| `\cdot` | $$\cdot$$ | `\leq` | $$\leq$$ |
| `\div` | $$\div$$ |  `\neq` | $$\leq$$ |
| `\pm`	| $$\pm$$ | `\approx` |	$$\approx$$ |

"+", "-", and "/" symbols are not explicitly defined because they can be typed via a standard keyboard without `Alt` + `####` (the four-digit Unicode specifiction) in Windows and `option` for Mac. That being said, you could technically just use those symbols directly.

## **Subscript, Superscript, and Fractions**

Subscript characters are preceded by `_`:
* e.g., `x^3` renders as $$x^3$$

Superscript is precded by `^`:
* e.g., `–ONO_2` renders as $$–ONO_2$$

Fractions are preceded by `\frac` and then broken up into numerator and denominator with two groups indicated by braces:
* e.g., `\frac{3}{x}` renders as $$\frac{3}{x}$$

Grouping as a general concept is enabled through braces. If you wanted to apply sub- or superscipt formatting to a group of characters, you would use braces:
* e.g., `x^{x+1}` renders as $$x^{x+1}$$ vs. `x^x+1` renders as $$x^x+1$$

## **Greek Alphabet**
| Control Sequence | Output |
| --- | --- |
| `\alpha` `A` | $$\alpha$$ $$A$$	|
| `\beta` `B` | $$\beta$$ $$B$$	|
| `\gamma` `Gamma` | $$\gamma$$ $$\Gamma$$	|
| `\delta` `Delta` | $$\delta$$ $$\Delta$$	|
| `\epsilon` `E` `\varepsilon` | $$\epsilon$$ $$E$$ $$\varepsilon$$	|
| `\zeta` `Z` | $$\zeta$$ $$Z$$	|
| `\eta` `H` | $$\eta$$ $$H$$	|
| `\theta` `\Theta` `\vartheta` | $$\theta$$ $$\Theta$$ $$\vartheta$$	|
| `\iota` `I` | $$\iota$$ $$I$$ |
| `\kappa` `K` | $$\kappa$$ $$K$$	|
| `\lambda` `\Lambda` | $$\lambda$$ $$\Lambda$$	|
| `\mu` `M` | $$\mu$$ $$M$$	|
| `\nu` `N` | $$\nu$$ $$N$$	|
| `\xi` `\Xi` | $$\xi$$ $$\Xi$$	|
| `\o` `\O` | $$o$$ $$O$$	|
| `\pi` `\Pi` | $$\pi$$ $$\Pi$$	|
| `\rho` `P` `\varrho` | $$\rho$$ $$P$$ $$\varrho$$	|
| `\sigma` `\Sigma` | $$\sigma$$ $$\Sigma$$	|
| `\tau` `T` | $$\tau$$ $$T$$	|
| `\upsilon` `\Upsilon` | $$\upsilon$$ $$\Upsilon$$	|
| `\phi` `\Phi` `\varphi` | $$\phi$$ $$\Phi$$ $$\varphi$$	|
| `\chi` `X`| $$\chi$$ $$X$$ |
| `\phi` `\Psi`| $$\psi$$ $$\Psi$$ |
| `\omega` `\Omega`| $$\omega$$ $$\Omega$$ |

Note the case-sensitive control sequences. Additionally, not all letter-case combinations are implemented as control sequences (e.g., capital A). This is an exhaustive list, although not all websites or online resources will provide it.

# **Additional Resources**
* [TeX Exchange](https://tex.stackexchange.com/)
* [Stack Overflow `LaTeX`](https://stackoverflow.com/questions/tagged/latex)
* [CTAN](https://ctan.org/)
* [Overleaf](https://www.overleaf.com/learn/latex/Learn_LaTeX_in_30_minutes)
* [TUG](https://tug.org/)
