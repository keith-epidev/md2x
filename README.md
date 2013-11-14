md2x
====

Markdown Extended


Another Markdown converter with additional functionality. Still in development, this repository is mainly for backup purposes but feel free to try and adopt. Primarily built and used to write large latex thesis documents, other formats are gradually being added.


Features
========

No trailing spaces required for new paragraphs/line breaks. What you see is what you get.


Define
-------
C like Defines.
```
#Define Title Markdown Extended Documentation

#Title // Will be replaced with 'Markdown Extended Documentation'
```
Will save the remaining line as the second token. Can embed new lines with the literal `\n`

These defines are commonly used when importing predefined templates such as the cover page. Still working out a nice way of letting the user know what defines are required.



Includes
--------
Now allows you to import external markdown files and folders. 
```
![abstract.md]
![folder/something.md]
![design]
```
The first line will include the file in the current directory 'abstract.md', while the second line will import a file that is contained in the folder 'folder'. The final line parses the design folder looking for a 'index.md'. The index.md should contain a list of imports in the required order. This is used as a basic makefile or build script. Generally the entire document starts with an index.md in the root directory that tells the parser which folders to pull in a certain order.

Each first level folder represents a chapter, a folder inside a chapter will be imported as a section and the following would be a subsection and so on.
Currently only 3 levels of recursion is supported.


Templates
---------
There are a few predefined latex templates that are located in the 'templates' folder. They are used for various tasks like theme setting and common elements like table of contents/figures/tables.


Outputs
=======

LaTeX
-----
Currently supports LaTeX using the Thesis template that was created by Steve R. Gunn and modified by Sunil Patel. However, you can still generate basic flat latex documents.

PDF
---
Supported by utilising pdflatex.


HTML
----
Soon to come.
