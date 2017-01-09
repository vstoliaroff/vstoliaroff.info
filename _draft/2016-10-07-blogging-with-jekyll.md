---
title: "Blogging with Jekyll - A few notes"
layout: post
comments: true
tags: Jekyll
---



### 0. Introduction

#### Credits

Every Information detailled in this post were found in one of the following ressources:

<http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html>  
<https://github.com/yihui/knitr-jekyll>  
<http://yihui.name/knitr-jekyll/2014/09/jekyll-with-knitr.html>  
<https://brendanrocks.com/blogging-with-rmarkdown-knitr-jekyll/>  
<https://nicolewhite.github.io/2015/02/07/r-blogging-with-rmarkdown-knitr-jekyll.html>   
<http://jekyllbootstrap.com/>  
<https://www.smashingmagazine.com/2014/08/build-blog-jekyll-github-pages/>  
<http://jekyll.tips/>  
<https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/>  


#### What is Jekyll

<http://jekyllbootstrap.com/> 
<http://jekyllbootstrap.com/lessons/jekyll-introduction.html>

#### Jekyll's value added

<http://www.carlboettiger.info/2014/10/28/jekyll-free.html> 
Jekyll or rmarkdown website only? They are much more Templates for jekyll as for rmarkdown

#### The Jekyll workflow

-   Create a jekyll compliant directory+file structure. It will be your input
-   Build the website (locally or on GitHub)
-   Upload it on the internet (Hosting)

On GitHub the last 2 steps are done simultanously except if you explicitely prevent the Build on github (?)

Practically:
- Fork the repo of a github page you like (for example: <http://nicolewhite.github.io>)
- Make your changes
- `jekyll serve --watch`

Careful that the change to your _config file are only taken into account if you stop the server (Ctrl+D)


### 1. Building the website

There are different ways:

-   ***Fork and Build on GitHub*** an existing repo in your GitHub account, make change and let GitHub build. You don't need a local Ruby installation etc... Tutorial [here](https://www.smashingmagazine.com/2014/08/build-blog-jekyll-github-pages/#1-fork-a-starting-point) using `jekyll-now`
-   ***Clone and build locally***: Clone an existing repo locally, build locally and serve it.
-   ***Build from scratch locally***: use command line `jekyll new`. Requires a few configuration effort...

#### Environment induced differences
Compile Rmd within Rstudio, 
Compile Rmd with knitr::render
Build with servr
Build with bash jekyll serve...

Differences in engine (pandoc...), and css 

### 2. Hosting

#### On GitHub

There are 2 options:  
- user website. Project saved in your `username.github.io` repository  
- project website: requires to set up a gh-pages branch in your repository `myproject`. The Website will be published under the adress `http://username.github.io/myproject`

#### On Other platforms

### 3. The Input Files in Detail

#### Content (where you put your text/images etc)

Either a post or a page

-   Post: go in the `_post` directory
-   Pages: go in the root directory (example: file index.html, sitemap.html etc...)

#### Templates

Go in the `_layouts` directory They are written in HTML with Liquid code ***and a YAML Front Matter*** Include files (in the `_includes` folder are not templates)

#### Directory Structure and File organisation

### 4. The Build Process in Detail ("Crunching the input")

2 Parsing occur:

-   for the content (with markdown or textile)
-   for the template (with the liquid language)

More specifically: (Credit: <http://jekyllbootstrap.com/> for the blockquote under)

    How Jekyll Generates the Final Static Files.

    Ultimately, Jekyll's job is to generate a static representation of your website. The following is an outline of how that's done:

        Jekyll collects data.
        Jekyll scans the posts directory and collects all posts files as post objects. It then scans the layout assets and collects those and finally scans other directories in search of pages.

        Jekyll computes data.
        Jekyll takes these objects, computes metadata (permalinks, tags, categories, titles, dates) from them and constructs one big site object that holds all the posts, pages, layouts, and respective metadata. At this stage your site is one big computed ruby object.

        Jekyll liquifies posts and templates.
        Next jekyll loops through each post file and converts (through markdown or textile) and liquifies the post inside of its respective layout(s). Once the post is parsed and liquified inside the the proper layout structure, the layout itself is "liquified".
        Liquification is defined as follows: Jekyll initiates a Liquid template, and passes a simpler hash representation of the ruby site object as well as a simpler hash representation of the ruby post object. These simplified data structures are what you have access to in the templates.

        Jekyll generates output.
        Finally the liquid templates are "rendered", thereby processing any liquid syntax provided in the templates and saving the final, static representation of the file.

    Notes.
    Because Jekyll computes the entire site in one fell swoop, each template is given access to a global site hash that contains useful data. It is this data that you'll iterate through and format using the Liquid tags and filters in order to render it onto a given page.

    Remember, in Jekyll you are an end-user. Your API has only two components:

        The manner in which you setup your directory.
        The liquid syntax and variables passed into the liquid templates.

    All the data objects available to you in the templates via Liquid are outlined in the API Section of Jekyll-Bootstrap. You can also read the original documentation here: http://jekyllrb.com/docs/variables/

### . A few tricks

#### Img inclusion 

- Reference, legend 
use captioner http://derekogle.com/fishR/2015-09-17-Figure-Table-Captions-in-Markdown

- Directory structure, combination with Liquid
https://eduardoboucas.com/blog/2014/12/07/including-and-managing-images-in-jekyll.html

- Center Img with custom css
http://rmarkdown.rstudio.com/html_document_format.html
https://nsaunders.wordpress.com/2012/08/27/custom-css-for-html-generated-using-rstudio/
https://thornelabs.net/2014/11/30/centering-images-with-jekyll-and-markdown.html

Do not forget the to compile the following r chunk if you use custom css and output your html doc in Rstudio
options(rstudio.markdownToHTML =
          function(inputFile, outputFile) {
            require(markdown)
            markdownToHTML(inputFile, outputFile,
                           stylesheet='/usr/lib/rstudio/resources/vstoliaroff.css')
          }
)



