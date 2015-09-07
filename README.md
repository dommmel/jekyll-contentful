# Jekyll-Contentful

Generate Pages for Contentful Entries

## Installation

Add this line to your Gemfile:

```ruby
group :jekyll_plugins do
  gem "jekyll-contentful"
end
```

And then execute:

    $ bundle

Alternatively install the gem yourself as:

    $ gem install jekyll-contentful

and put this in your ``_config.yml`` 

```yaml
gems: [jekyll-contentful]
 # This will require each of these gems automatically.
```

## Configuration

Configure in your _config.yml file


```yaml
contentful:
  preview: No 
  production_access_token: 'YOUR_PRODUCTION_TOKEN'
  preview_access_token: 'YOUR_PREVIEW_TOKEN'
  space: 'YOUR_SPACE'
  content_types:
   - "First Content Type"
   - "Second Content Type"
  published_locales_field: "published_languages"
  localization:
  - locale: en-US
    url_prefix: ""
    lang: "English"
  - locale: de-DE
    url_prefix: "de/"
    lang: "Deutsch"
```


### Translations
You can globally specify the languages/locales that you want to generate pages for.
See the ``localization`` array in the ``_config.yml`` example above. You need to set the ``locale``, a string that this locale's urls will be prefixed with (``url_prefix``) and the language name (``lang``). The ``lang`` setting is used by the language switcher.

#### Language switcher
you can use the tag ``{% language_switcher %}`` in your templates to insert a link to the translations of the current page.

#### Selective Translations
By default the plugin will – for every entry – generate a page for every locale you specified in your ``_config.yml``.

You can also **specify** which **locales** should be published **on the entry level**:

1. Add a Content Type called "Languages" to your space (you can name it differently).
2. Add a field called "locale" to that content type (this field has to be called "locale" and nothing else).
3. Add an entry of that content type for every locale you have enabled in your space. Set those entries' "locale" field accordingly.
4. Add a reference field (many) to the content type you want to selectively translate. Call it "published_languages" (you can name it differently but it has to match the name in the next step). Set the validations to allow only the content type "Languages" to be referenced.
5. Add ``published_locales_field: "published_languages"`` in the ``contentful:``section of your ``_config.yml``

Now for every entry you can specify the languages you want to generate pages for by adding them to your entries "published_languages" list.

#### Content Fields:

All Entry fields can be used inside the layout templates as {{ page.contentful_fields.fieldname }}.
The plugin adds two more fields to pages generated from Contentful entries: ``{ page.contentful_id }}`` and ``{{ page.contentful_locale }}``.

#### ULRs and Layouts: 
  
Let's say you have a content type named "Blog Post" with an entry that has its title field set to "Awesome Title".
The plugin will generate a page using the "blog-post.html" layout at the url: /en/blog-post/awesome-title/index.html

If no layout named "blog-post.html" can be found the plugin will fallback to use the "default.html" layout.

## Minimal Layout Example

the following example assumes a content type with two fields. A long text field named "body" and a short text field named "title".

```liquid
<!DOCTYPE html>
<html>
<body>
  <header>
    <div>
      {% for p in site.pages %}
        {% if p.title and page.contentful_locale == p.contentful_locale %}
          {% if p.url == page.url %}
            <span>{{ p.title }}</span>
          {% else %}
            <a href="{{ p.url | prepend: site.baseurl }}">{{ p.title }}</a>
          {% endif %}
        {% endif %}
      {% endfor %}
    </div>
  </header>
  <article>
    <h1>{{ page.title }}</h1>
    <p>{{ page.body | markdownify  }}</p>
  </article>
  {% language_switcher %}
</body>
</html>
```

You can find a more comprehensive example over at [github.com/dommmel/jekyll-contentful-example](https://github.com/dommmel/jekyll-contentful-example).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).