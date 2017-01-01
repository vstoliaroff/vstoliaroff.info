---
title: "Displaying tree outlines in R Markdown documents"
layout: post
comments: true
tags: [data.tree, R Markdown, R]
---



## Question of the day 
In the [R Markdown](http://rmarkdown.rstudio.com/) rendering workflow, the processing of Markdown file is preceded by a "knitting" phase of *code chunks* which makes it trivial to embed a wide variaty of language scripts (R, SQL, shell, Python...) and their output in the Markdown file itself.  

Let's take this [stackoverflow](<http://stackoverflow.com/questions/19699059/representing-directory-file-structure-in-markdown-syntax>) question as a case in point. The shell `tree` command produces nice indented listing of files and directories. But the direct encapsulation of the command and its results is not possible in Markdown documents: one must resolve to a tedious copy-paste detour through the shell terminal. With R Makdown and the support of the `knitr` package, it is made straightforward and transparent to the user.   

As an illustration, let's check the content of the `rmarkdown` package directory on my machine, displaying only 2 levels of subdirectories. We would call the following bash chunk 

```bash
tree ~/R/x86_64-pc-linux-gnu-library/3.3/rmarkdown -L 2
```
And get the following output: 

```
/home/vs/R/x86_64-pc-linux-gnu-library/3.3/rmarkdown
├── COPYING
├── DESCRIPTION
├── help
│   ├── aliases.rds
│   ├── AnIndex
│   ├── paths.rds
│   ├── rmarkdown.rdb
│   └── rmarkdown.rdx
├── html
│   ├── 00Index.html
│   └── R.css
├── INDEX
├── Meta
│   ├── hsearch.rds
│   ├── links.rds
│   ├── nsInfo.rds
│   ├── package.rds
│   └── Rd.rds
├── NAMESPACE
├── NEWS
├── NOTICE
├── R
│   ├── rmarkdown
│   ├── rmarkdown.rdb
│   └── rmarkdown.rdx
├── rmarkdown
│   └── templates
└── rmd
    ├── fragment
    ├── h
    ├── ioslides
    ├── latex
    └── slidy

12 directories, 21 files
```

Today, we would like to investigate the options available to display the same kind of output for any tree-based hierarchy (not only directories but also varied ontologies). 

## Tree outline with `data.tree` printing method

We will use the taxonomy of the great Apes (*Hominidae*) as an example. The data are available on the [NCBI](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=Tree&id=9604&lvl=3&lin=f&keep=1&srchmode=1&unlock) website and can be downloaded into a R session using the `children()` function from the `taxize` R package. 
We wrote a quick and dirty `children_n()` version to get different levels of sub-taxa recursively.   


```r
library(dplyr)
library(taxize)
library(tidyr)

children_n<-function(mytaxa,mylevel){
  if (mylevel%in%0) return(mytaxa) else {
    mychildren<-taxize::children(mytaxa$childtaxa_name,
                                 db = "ncbi")
    mychildren.df<-tibble(taxa_name=names(mychildren),
                          to=I(lapply(mychildren,
                                      function(x)x["childtaxa_name"])),
                          rank=I(lapply(mychildren,
                                        function(x)x["childtaxa_rank"]))
                          )%>%
      tidyr::unnest(to,rank)
    mylevel<-mylevel-1
    return(bind_rows(mytaxa%>%
                       filter(!taxa_name%in%"Root"),
                     children_n(mychildren.df,mylevel)))
  }
}
```

The output is a data frame with parents and children relationships which 


```r
mytaxon<-data.frame(taxa_name="Root",
                    childtaxa_name="Hominidae",
                    stringsAsFactors = FALSE)
mytaxon.children<-children_n(mytaxon,4)
head(mytaxon.children)
```

```
  taxa_name childtaxa_name childtaxa_rank
1 Hominidae       Ponginae      subfamily
2 Hominidae      Homininae      subfamily
3  Ponginae          Pongo          genus
4 Homininae           Homo          genus
5 Homininae            Pan          genus
6 Homininae        Gorilla          genus
```

The `data.tree` package has a specialized print method for tree objects which does exactly what we are looking for. 


```r
library(data.tree)

mytaxon.children%>% 
  FromDataFrameNetwork%>% # turn your data into a tree object
  print
```

```
                                             levelName
1  Hominidae                                          
2   ¦--Ponginae                                       
3   ¦   °--Pongo                                      
4   ¦       ¦--Pongo abelii x pygmaeus                
5   ¦       ¦--Pongo abelii                           
6   ¦       °--Pongo pygmaeus                         
7   ¦           °--Pongo pygmaeus pygmaeus            
8   °--Homininae                                      
9       ¦--Homo                                       
10      ¦   ¦--Homo heidelbergensis                   
11      ¦   °--Homo sapiens                           
12      ¦       °--Homo sapiens neanderthalensis      
13      ¦--Pan                                        
14      ¦   ¦--Pan troglodytes                        
15      ¦   ¦   ¦--Pan troglodytes verus x troglodytes
16      ¦   ¦   ¦--Pan troglodytes ellioti            
17      ¦   ¦   ¦--Pan troglodytes vellerosus         
18      ¦   ¦   ¦--Pan troglodytes verus              
19      ¦   ¦   ¦--Pan troglodytes troglodytes        
20      ¦   ¦   °--Pan troglodytes schweinfurthii     
21      ¦   °--Pan paniscus                           
22      °--Gorilla                                    
23          ¦--Gorilla beringei beringei              
24          ¦--Gorilla beringei                       
25          ¦   ¦--Gorilla beringei beringei          
26          ¦   °--Gorilla beringei graueri           
27          ¦--Gorilla gorilla diehli                 
28          ¦--Gorilla gorilla uellensis              
29          ¦--Gorilla beringei graueri               
30          ¦--Gorilla gorilla gorilla                
31          °--Gorilla gorilla                        
32              ¦--Gorilla gorilla diehli             
33              ¦--Gorilla gorilla uellensis          
34              °--Gorilla gorilla gorilla            
```

Off course, you have to format your input data into a tree object first. But the focus of our post here is only on the output from within R Markdown documents.  
For details on the `data.tree` package, check the [introduction](https://cran.r-project.org/web/packages/data.tree/vignettes/data.tree.html) and [application](https://cran.r-project.org/web/packages/data.tree/vignettes/applications.html) vignettes where many nice examples are provided for alternativ visualizations options. Any of the R packages for network plotting are to consider as well (`visNetwork`, `igraph`...)

