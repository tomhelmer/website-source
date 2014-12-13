+++
title = "Now built by Hugo"
date = "2014-12-13"
draft = false
image = "hugo.png"
categories = ["Hugo"]
tags = ["Themes"]
author = "Tom Helmer Hansen"
+++
This site is built with Hugo, a static website generator written in Go. Hugo’s is extremely fast and takes the fun back into site-building. Writing text in markdown with sublime text and deploying with git is how I as a developer like to make content.

> Hugo is written for speed and performance. Great care has been taken to ensure that Hugo build time is as short as possible. We’re talking milliseconds to build your entire site for most setups.
_http://gohugo.io_

## Ago - my own theme
I have written my own theme for Hugo based on Sass, Bourbon and Neat. The theme has the following features:

- Sass based CSS generation
- 1 breakpoint, mobile and desktop
- 3-level top menu and 1-level mobile menu
- Two taxonomies : Categories and Tags
- Categories has it's own listing with icons and descriptions
- One content-type: Article
- Articles can have an associated image that is several places
- Sitewide config "cdnprefix" allows for local and CDN hosted images
- Google Analytics tracking
- Muut article comments

I host my images on cloudinary, they have a free plan for small sites. I cloudinary you can make named images transformations. Images are inserted by the templates like this :

    <img src="{{ $cdnprefix }}/t_article-square-image/{{ .Params.image }}" alt="Article image">

cndprefix could be a local path eg. "/images" and the different image transformations could be placed in subfolders "t_article-square-image" and so on. It could actually be a fun project to make a build process for local image transformations.


The source for this site is available at https://github.com/tomhelmer/website-source. I will make the theme into a seperate repository and provide it for all Hugo users if anyone ask for it. I still need to move a couple of settings to the site config file so everything can be configured here.
