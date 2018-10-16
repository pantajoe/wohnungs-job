# Images

There are three possible use cases for images:

1. as a foreground image
2. as a background image
3. as an icon sprite


## Foreground image

These images are placed as `<img />`-elements directly in the markup.

Use this for larger `.jpg` or `.png-files` and don't forget to define a proper `alt`-attribute.


## Background image

These images are placed inside our stylesheets with the `background` syntax. If possible, use SVG files to take advantage of sharp outlines on all screens.

Use this for decorative images.


## Icon sprite

We use SVG files for all our icons. They'll be combined in one SVG icon sprite.

Use this technique if you want to manipulate the size, fill-color or something else of your icon.


### Requirements

- [SVGEEZ](https://github.com/jgarber623/svgeez) – A Ruby gem for automatically generating an SVG sprite from a folder of SVG icons.
- [SVGO](https://github.com/svg/svgo/) – SVG Optimizer is a Nodejs-based tool for optimizing SVG vector graphics files.

SVGEEZ will be automatically installed via *bundler*. SVGO however needs to be installed separately by `npm install -g svgo`


### Getting started

You have two options to generate the SVG icon sprite.

The **build** command
`bundle exec svgeez build --source app/assets/images/svg-icons/ --destination app/assets/images/icon-sprite.svg --with-svgo`

The **watch** command
`bundle exec svgeez watch --source app/assets/images/svg-icons/ --destination app/assets/images/icon-sprite.svg --with-svgo`

I would prefer the **watch** command, which runs silently in the background once it's started.

Now just put your svg files, e.g. `arrow.svg` inside the svg-icons-folder. SVGEEZ will generate a `<symbol>` inside `icon-sprite.svg` which will be assigned an `id` value of `icon-sprite-arrow`.

Inside the template the `icon-sprite.svg` is lazyloaded via javascript to be able to cache it and to avoid including it as inline svg-code.

```
:javascript
  var ajax = new XMLHttpRequest();
  ajax.open("GET", "#{image_path 'icon-sprite.svg'}", true);
  ajax.send();
  ajax.onload = function(e) {
    var div = document.createElement("div");
    div.innerHTML = ajax.responseText;
    document.body.insertBefore(div, document.body.childNodes[0]);
  }
```

To place the icon in your markup, just use:

```
%svg
  %use{"xlink:href" => "#icon-sprite-arrow"}
```
