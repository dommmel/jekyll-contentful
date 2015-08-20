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
  localization:
  - locale: en-US
   url_prefix: ""
  - locale: de-DE
   url_prefix: "de/"
```       
  
#### Content Fields:
All Entry fields can be used inside the layout templates as {{ page.fieldname }}
  
#### ULRs and Layouts: 
  
Let's say you have a content type named "Blog Post" with an entry that has its title field set to "Awesome Title".
The plugin will generate a page using the "blog-post.html" layout at the url: /en/blog-post/awesome-title/index.html

If no layout named "blog-post.html" can be found the plugin will fallback to use the "default.html" layout.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).