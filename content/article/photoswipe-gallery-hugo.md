+++
date = "2014-12-27"
draft = false
title = "Gallery in Hugo with PhotoSwipe and shortcodes"
image = "gallery.png"
categories = ["Hugo"]
galleryprefix = "http://res.cloudinary.com/thehome-dk/image/upload"
galleryfolder = "gallery-1"
gallerythumbnail = "t_thumbnail"
+++

In this article I will show how to implement a gallery based on PhotoSwipe (http://photoswipe.com) a really cool vanilla javascript image gallery with responsive behaviour, touch gestures, animations, zoom, sharing links and browser history. The browser history support makes it possible to link to a [specific image](?#&gid=1&pid=2), usefull when sharing. It's possible to implement responsive image loading with PhotoSwipe, but I haven't done this yet.

{{% gallery title="Example gallery" %}}
{{% galleryimage file="DSC_1283" size="1280x885" caption="This is me in Rome" copyrightHolder="Rasmus Helmer Hansen" %}}
{{% galleryimage file="DSC_1350" size="993x1280" caption="This is Andrea in Rome" copyrightHolder="Tom Helmer Hansen" %}}
{{% galleryimage file="DSC_1648" size="1280x857" caption="Rain reservoir in the hall." copyrightHolder="Tom Helmer Hansen" %}}
{{% /gallery %}}


It's possible to initialize the gallery from DOM, so I don't need to handle any JSON objects. I have build the DOM based on [Schema.org markup for image gallery](http://schema.org/ImageGallery) with the two shortcodes: "gallery" and "galleryimage". A third shortcode "galleryinit" adds the relevant javascript/css and initializes the galleries on the page (multiple galleries on the same page is supported).

## How to add gallery to content

I use Cloudinary to serve the images and these three settings from the page frontmatter is used by the shortcodes:

	galleryprefix = "http://res.cloudinary.com/thehome-dk/image/upload"
	galleryfolder = "gallery-1"
	gallerythumbnail = "t_thumbnail"

The shortcodes for the example gallery on this page looks like this ( an extra space is added before % so the codes aren't rendered):

	{{ % gallery title="Example gallery" %}}
	{{ % galleryimage file="DSC_1283" size="1280x885" caption="This is me in Rome" copyrightHolder="Rasmus Helmer Hansen" %}}
	{{ % galleryimage file="DSC_1350" size="993x1280" caption="This is Andrea in Rome" copyrightHolder="Tom Helmer Hansen" %}}
	{{ % galleryimage file="DSC_1648" size="1280x857" caption="Rain reservoir in the hall." copyrightHolder="Tom Helmer Hansen" %}}
	{{ % /gallery %}}

	{{ % galleryinit %}}

The image sizes are needed by PhotoSwipe.

## How to set it up
- Copy "photoswipe.min.js" and "photoswipe-ui-default.min.js" from PhotoSwipe (https://github.com/dimsemenov/PhotoSwipe/tree/master/dist) to your static/js folder.
- Copy "photoswipe.css" and "default-skin" folder from PhotoSwipe (https://github.com/dimsemenov/PhotoSwipe/tree/master/dist) to your static/css folder. (or you can use the scss files from PhotoSwipe)
- Copy [Modified DOM initialization script](/js/initphotoswipe.js) to your static/js folder (slightly modified from the photoswipe example to ignore extra paragraph tags inserted by hugo when rendering paired shortcodes.
- Add shortcode gallery.html:

	 	<div class="gallery" itemscope itemtype="http://schema.org/ImageGallery">
		{{ .Inner }}
		<div class="title">{{ .Get "title" }}</div>
		</div>

- Add shortcode galleryimage.html:

		{{ $galleryprefix := .Page.Params.galleryprefix }}
		{{ $galleryfolder := .Page.Params.galleryfolder }}
		{{ $gallerythumbnail := .Page.Params.gallerythumbnail }}
		<figure itemscope itemtype="http://schema.org/ImageObject">
		  <a href="{{ $galleryprefix }}/{{ $galleryfolder }}/{{ .Get "file" }}" itemprop="contentUrl" data-size="{{ .Get "size" }}">
		      <img src="{{ $galleryprefix }}/{{ $gallerythumbnail }}/{{ $galleryfolder }}/{{ .Get "file" }}" itemprop="thumbnail" alt="{{ .Get "caption" }}" />
		  </a>

		  <figcaption itemprop="caption description">
		    {{ .Get "caption" }}
		    <span itemprop="copyrightHolder">{{ .Get "copyrightHolder" }}</span>
		  </figcaption>
		</figure>

- Add shortcode galleryinit.html:

		<link rel="stylesheet" href="/css/photoswipe.css">
		<link rel="stylesheet" href="/css/default-skin/default-skin.css">
		<script src="/js/photoswipe.min.js"></script>
		<script src="/js/photoswipe-ui-default.min.js"></script>
		<script src="/js/initphotoswipe.js"></script>

		<!-- Root element of PhotoSwipe. Must have class pswp. -->
		<div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">
	    <!-- Background of PhotoSwipe.
	         It's a separate element, as animating opacity is faster than rgba(). -->
	    <div class="pswp__bg"></div>
	    <!-- Slides wrapper with overflow:hidden. -->
	    <div class="pswp__scroll-wrap">
	        <!-- Container that holds slides.
	          PhotoSwipe keeps only 3 of them in DOM to save memory.
	          Don't modify these 3 pswp__item elements, data is added later on. -->
	        <div class="pswp__container">
	          <div class="pswp__item"></div>
	          <div class="pswp__item"></div>
	          <div class="pswp__item"></div>
	        </div>
	        <!-- Default (PhotoSwipeUI_Default) interface on top of sliding area. Can be changed. -->
	        <div class="pswp__ui pswp__ui--hidden">
            <div class="pswp__top-bar">
              <!--  Controls are self-explanatory. Order can be changed. -->
              <div class="pswp__counter"></div>
              <button class="pswp__button pswp__button--close" title="Close (Esc)"></button>
              <button class="pswp__button pswp__button--share" title="Share"></button>
              <button class="pswp__button pswp__button--fs" title="Toggle fullscreen"></button>
              <button class="pswp__button pswp__button--zoom" title="Zoom in/out"></button>
              <!-- Preloader demo http://codepen.io/dimsemenov/pen/yyBWoR -->
              <!-- element will get class pswp__preloader--active when preloader is running -->
              <div class="pswp__preloader">
                <div class="pswp__preloader__icn">
                  <div class="pswp__preloader__cut">
                    <div class="pswp__preloader__donut"></div>
                  </div>
                </div>
              </div>
            </div>
            <div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
              <div class="pswp__share-tooltip"></div>
            </div>
            <button class="pswp__button pswp__button--arrow--left" title="Previous (arrow left)">
            </button>
            <button class="pswp__button pswp__button--arrow--right" title="Next (arrow right)">
            </button>
            <div class="pswp__caption">
              <div class="pswp__caption__center"></div>
            </div>
	        </div>
		    </div>
		</div>

		<style>
			.gallery { float: right; }
			.gallery img { width: 100%; height: auto; }
			.gallery figure { display: block; float: left; margin: 0 5px 5px 0; width: 80px; }
			.gallery figcaption { display: none; }
			span[itemprop="copyrightHolder"] { color : #888; float: right; }
			span[itemprop="copyrightHolder"]:before { content: "Foto: "; }
		</style>

		<script>initPhotoSwipeFromDOM('.gallery');</script>

Todo:

- Use image size property to get image transformation
- Make it configurable if image should be shown in thumbnails
- Clean up CSS, move it to SASS
- Implement responsive images


{{% galleryinit %}}