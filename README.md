# How to use this repository

Taken from DIME's How to Make Nice and Fast Table in Stata Blogpost. I have adapted the way the tables were made to utilize the `threeparttable` package that I personally prefer to use.

---

Readme is the same as the one from [the original repo](https://github.com/worldbank/stata-tables)

### [Blogpost - Nice and fast tables in Stata?](https://blogs.worldbank.org/impactevaluations/nice-and-fast-tables-stata?CID=WBW_AL_BlogNotification_EN_EXT)

## Overview
- Find do-files with example code [here](https://github.com/bbdaniels/stata-tables/tree/master/do)
- Find their outputs [here](https://github.com/bbdaniels/stata-tables/tree/master/outputs)
- Demo with code and tables for LaTeX is [here](https://github.com/bbdaniels/stata-tables/blob/master/LaTeX-tables-demo.pdf)
  - A different approach that results in the same layout can be found in https://github.com/RRMaximiliano/stata-latex-tables

## Adapting code
You can edit the template do-files to test the commands' features or create tables using your own data.
- Click on `Clone or download` at the top right corner of this page
- Download the files to your computer
- Edit the line marked in the do-files to match your computer's file path
- Have fun!

# How to make nice tables in Stata without wasting time formatting?

## Introduction

Since 2018, all DIME working papers go through a pre-publication reproducibility check. With the announcement of the new [AEA policy on data and code](https://www.aeaweb.org/journals/policies/data-code/), we have also started reviewing projects from other teams inside the World Bank. So far, our team at DIME Analytics has reviewed a total of 22 papers before they were publicly released. One frequently observed source of issues is the workflow used to export tables. When incorporating tables into papers, it is a common practice to copy-and-paste results from csv and Excel files, or the Stata window, and then format it in Word. Some setups are more manual than others, but the road from them to sharing results that does not reproduce is short: all you need is to not copy one table, or one line of one table, after updating your specification. Additionally, the habit of formatting tables after they are exported often makes it harder to confirm that the results exported are the same as the ones shown in the paper.

Making tables is one of the most common tasks for researchers, yet these considerations also make it one of the most frustrating. Like most coding tasks, how to do it is going to depend on what you need to do: but there are workflows you can adopt that can minimize the pain. Since a good part of our job is to learn from DIME's data work experiences and share them with the development research community, we have had more time to think about this than the average researcher that just needs to get over this often annoying step so they can focus on the content of their paper. In this post we are going to share our framework for thinking about the task of coding tables, discuss two distinct stages to tackling the problem, and link to Stata code for getting the job done. 

## Two stages for coding tables

There are lots of reasons to export tables somewhere other than the Stata results window, but they don't all justify the same approach. You might be exploring regression results with various specifications, and not want to read them one-by-one. You might be preparing a report or paper for submission or publication. Your journal might require tables inline in Word. (Really.) Depending on what you are doing _now_ and what you might need to do _in the future_, there are some key questions to think about before implementing code. Ask yourself:

- Do I need this output to be immediately shareable without postprocessing?
- Do I need this output to be useful for publication, or just for reading/comparing results?
- Do I need to be able to adjust number formatting and rounding later?
- Will I need to adjust table layout and formatting later?
- What will be the required workflow when I re-produce this table?
- What will happen to the table if I alter models, parameters, or other core components?

Different use cases have different answers to these questions, but most projects fall into one of two broad development stages. In Stage One, you only care about making the information human-readable now, and you are going to use those results to adjust the structure of the table repeatedly. You may adjust the models and parameters, rename the rows and columns, delete or add lines; but you will probably not finalize the output for a while. Therefore, Stage One only requires you to export minimally formatted and annotated tables: just enough to understand what your results are telling you. This should not take long to implement, as formatting is usually the hardest part. And really, you don't want to spend a lot of time making you table look nice, when you may not even use it for the final output.

At some point, you are going to want to share a nice-looking, easy to read table. When moving to Stage Two, be sure that you really need nicely-formatted, reproducible output, ready for publication, that is not going to need many adjustments later. You may think that it is fine to jut copy the results into Word and format them manually, as this is a one-time operation. But we are here to tell you that it never is. You may continue receiving data, or may want to make very minor adjustments that don't require reporting new information, or the journal you are submitting to may require a reproducibility check. So, if the core structure of a table is set, it is worth the one-time investment of formatting it up in Stata code. Once you agree to move to Stage Two, the key thing to keep in mind is that the RA will spend a fair amount of time implementing this, so we recommend only doing it once you have found your core set of results and discussed the best way to present them.

Moving from Stage One to Stage Two means coding both the information and the formatting of the table. It takes some time to set up, as you have to write all the formatting of the table into the Stata code. It is also less flexible to changes in models or parameters, since these will likely affect your formatting, and even adjusting things like the number of columns can require making precise changes to the code to get it to look just right. However, when your changes don't imply formatting adjustments (such as during ongoing data collection), you'll be very happy that your slides or reports are instantly updated to your new results, especially when you have a lot of outputs.

||Stage One|Stage Two|
|-|-|-|
|Amount of coding | Little | Moderate to lots |
|Replicability   | Results replicate but may require copying or post-processing  | Fully replicable  |
|Adjustability of models and parameters | High | Moderate to low |
|Suitability to frequent updates   | Slow   | Fast  |
|Formatting   | Little to none | Complete  |

In practice, the line between Stage One and Stage Two is not always so clear. As are most things in life, this is a balancing act. In this case, the balance is between the amount of formatting needed and the number of times the table will be updated. If a table requires very little formatting, it may be OK to do it quite a few times manually. But if it takes a lot of manual adjustment, the relative cost of coding it instead diminishes every time you export it. The problem is that we tend to underestimate both (a) how many times a table will be recreated, and (b) the time cost of changing formatting via code.

The way you move from Stage One to Stage Two will depend on the output software you plan to use. Here, we will descibe how to work in both LaTex and Excel. LaTeX gives more flexibility with auto-updating tables in reports and presentations; however, there is some fixed cost in learning the formatting language. Excel remains popular (and is preferred by some journals for house styling), but applying formatting in Excel remains a largely manual process, slowing down replication runs.

In all cases, we recommend a simple file structure to help keep organized. Every table has its own file. When tables are in Stage One, these outputs should be named informatively: names like `main-regression.tex`, `robustness-checks.xlsx`, and `balance-tables.tex` are great. During Stage Two, these should change to structural names: `table-01.tex` or `table-A05_robustness.xlsx` are acceptable (note the use of dashes, leading zeros, and underscores to organize semantic content: learn more about [naming things](http://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf)). This ensures that you and your code reviewers can always find things and understand how they are connected both to the code and to the final product. And of course, we recommend to use Git wherever possible to track and store past and alternative specifications, and how they affect your results.

## Coding tables from Stata in LaTeX

Last month, the two most-downloaded packages from SSC were `estout` and `outreg2`, which are used to export tables. Both can create simple tables in TeX, although they will not always look the nicest without formatting. Exporting results to individual `.tex` files for each table and importing them with `input` into a master `.tex` document is the easiest way to create outputs when you are still making changes to the results.

When you are ready to format your tables, you will only need to do it once. Once this is set up in Stata, the individual table `.tex` files will be replaced with the latest version of your regressions and data every time you run Stata. In Stage Two it is ideal to name your files systematically (`table-1.tex`, etc.), so that the outputs are clearly linked to both the code and the master document. The greatest advantage of all this is that you only need to recompile the master document, without any copy-pasting or opening multiple files to see all the new results at once.

As for actually doing this, the `estout` package, by Ben Jann, has lots of options. You can get it to do basically anything you want! The default table is pretty simple, and the [documentation]( http://repec.sowi.unibe.ch/stata/estout/) is *huge*, but we've prepared a few [go-to examples](ADD LINK TO WB REPO) that solve the most common formatting needs for a LaTeX table. The `esttab` command also allows you to export nicely formatted tables to Word, Excel, csv and HTML, but the options vary from one format to the other.

If you're trying to create a _very_ specific table format, the easiest way to do it in a replicable manner is to write the complete LaTeX code for the table. This means saving any number that should be displayed as locals, and hardcoding the LaTeX code for the table. But instead of writing the number themselves, you just call the locals that were previously saved. `filewrite` allows you to write the LaTeX code in a do-file, then have Stata write the text file with the table, and save it as a `.tex` file. You can find an example of how to use it [here](ADD UPDATED LINK).

The two commands above are our go-to solution to exporting tables to LaTeX. However, there are a few other options out there. [`outreg2`](http://repec.org/bocode/o/outreg2.html) also exports tables to `tex` formats, but we've found it harder to use and to find resources than `estout`. [`stata-tex`](https://github.com/paulnov/stata-tex) is another option for custom-tables, but takes some more setting up with Excel and Python. Finally, you can write a whole HTML, word or PDF document using different options for Stata markdown, entirely within Stata. Discussing these options would take yet another blog post, but you can check out the [dynamic documents](https://www.stata.com/new-in-stata/markdown/), [markstat](https://data.princeton.edu/stata/markdown), and [texdoc](http://repec.sowi.unibe.ch/stata/texdoc/) documentation for more information.

## Coding tables from Stata with Excel

Excel remains a popular format for tables for its ease of use and interoperability with other Office products, despite its technical limitations. We'll describe here how to make the most of Excel-based tables when they are preferred or required for any reason. First, nearly everyone is tempted to show off their coding skills and create one big `tables.xlsx` document with everything in the right sheets, but this is not the best way to do it. For one, during Stage One, it becomes very hard to make changes to ordering as there is now a structure imposed on the output. For another, it can become difficult to correctly match each table to its origin in the code, and therefore we still recommend creating each table in a separate original output file, named as described above.

Then, there should still be a master `tables.xlsx` file for use in other materials or submissions, and tables should only ever be formatted and stored as individual sheets in this location. The reason for this is that it must always be possible to quickly regenerate and replace a single table, and therefore you should be able to run only that chunk of the code and replace only that file. Additionally, if necessary, the master location may be used to combine things such as `table-01-A.xlsx` and `table-01-B.xlsx`, if for example it is impossible to put everything for one table in the same place due to the structure of the command.

Moving from Stage One to Stage Two in Excel is a slightly different "formatting in code" task than it is in TeX. When the final formatted `tables.xlsx` file is created, the raw outputs need to be re-coded such that the results are in exactly the same layout as in the final table. This means that the whole table can be updated by copy-paste in one operation per panel, rather than per cell. This may mean changing the export command, or setting up a complex export of a manually-created matrix, to get it just right. This minimizes the risk of error and the time cost for doing it. However, as in applying lots of formatting in TeX, it is costly in terms of coding time, and very costly to change after it is done once.

In Stata, both `estout` and `outreg2` can write to Excel formats, as does `xml_tab` by Zurab Sajaia and Michael Lokshin. Until recently, it was not straightforward to print information into Excel, and each of these softwares dealt with interoperability hurdles in different ways. `outreg2`, for example, writes the literal contents of the cell, including the stars (such as "0.190\*\*\*" or "1.34e-07\*\*"), and by default applies significant-figure standardization rather than decimal place standardization to ensure that there is meaningful information in every cell. `estout` operates similarly. `xml_tab` developed the innovation of using Excel formatting rules to print the full precise values into cells and implement rounding and stars natively, and was for many years a good go-to command for exporting regression results to Excel. However, as the name implies, `xml_tab` writes XML directly, and this out-of-date export process mean that outputs are not fully with modern versions of Office and the associated filetypes (namely XLSX).

To deal with these issues, we have created, `outwrite`, a new command available on SSC. It is an early release that attempts to take the best functionality and defaults from the above commands -- namely, taking multiple regression models (or arbitrary matrices) and writing them out to Excel. The purpose of `outwrite` is to provide full support for two modern Stata features: interactions and categorical expressions (`i.`, `c.`, and `#`) and modern XLSX file output. It is built on top of the regression processing engine from `xml_tab` and uses the new `putexcel` features for output (therefore, Stata 15.1 is required). `outwrite` mimics `xml_tab` in many respects, including using Excel formatting rules to print the full precise values into cells and implement rounding and stars natively; only the global format can be adjusted in Stata syntax, and precise adjustments need to be made by hand in the process of finalizing the table.

But unlike the other commands, `outwrite` is designed to have "minimal syntax". It is specifically designed to make minimally formatted tables that are instantly usable with the view for minimizing the required formatting by hand later. It therefore has almost no additional formatting options available. As a result, in a Stata viewer window, the help file for `xml_tab` takes 727 lines. `outreg2` takes 1147 and `estout` takes 1647 lines -- and much of this is formatting for Excel. As of this writing, the helpfile for `outwrite` takes 67 lines. (This may not be enough – install the current version of the software and let us know!) `outwrite` will also support minimal output to TeX files simply by changing the file extension.

## Keep it reproducible

Whichever software and packages you decide to use, automating your table creation workflow will likely [save you time](https://xkcd.com/1205/), as long as you do it at the right moment. It will also greatly reduce the risk of circulating, submitting or (God forbid) publishing manuscripts with out-of-date results. And if we may plant another seed for debate, this, rather than [aesthetics](https://onlinelibrary.wiley.com/doi/abs/10.1111/joes.12318) is also the main reason to prefer LaTeX over Word for applied work.