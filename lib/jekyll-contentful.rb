require "jekyll-contentful/version"
require "jekyll"
require "contentful"

#
#  Configure in your _config.yml file
# 
#   contentful:
#     access_token: 'YOUR_TOKEN'
#     space: 'SPACE'
#     content_types:
#       - "First Content Type"
#       - "Second Content Type"
#     localization:
#     - locale: en-US
#       url_prefix: "en"
#     - locale: de-DE
#       url_prefix: "de"
#       
#  
#  Content Fields:
#  
#  All Entry fields can be used inside the layout templates as {{ page.fieldname }}
#  
#  ULRs and Layouts: 
#  
#  Let's say you have a content type named "Blog Post" with an entry that has its title field set to "Awesome Title".
#  The plugin will generate a page using the "blog-post.html" layout at the url: /en/blog-post/awesome-title/index.html
#  
#  If no layout named "blog-post.html" can be found the plugin will fallback to use the "default.html" layout.
#

module Jekyll
  class ContentfulEntryPage < Page
    def initialize(site, fields, content_type_name, prefix)
      
      @site = site
      @base = site.source
      @name = 'index.html'
      
      content_type_slug = Utils.slugify content_type_name

      layout_filename = site.layouts.key?(content_type_slug) ? "#{content_type_slug}.html" : "default.html"
      self.read_yaml(File.join(@base, '_layouts'), layout_filename)

      # stringify hash keys
      fields = fields.inject({}){|x,(k,v)| x[k.to_s] = v; x}

      # merge data
      self.data.merge!(fields)

      # If there is a title fields make it the url
      page_title_slug = Utils.slugify(self.data["title"] || "")
      @dir = "#{prefix}/#{content_type_slug}/#{page_title_slug}"
      
      self.process(@name)
    end
  end

  class ContentfulEntryPageGenerator < Generator
    safe true

    def generate(site)

      client = ::Contentful::Client.new(
        access_token: site.config['contentful']['access_token'],
        space: site.config['contentful']['space']
      )

      # Loop over all content types
      site.config['contentful']['content_types'].each do |content_type_name|
        # Get ID for content type name
        content_type = client.content_types(name: content_type_name).first

        throw "Content_type \'#{content_type_name}\' does not exist." if content_type.nil? 

        
        localization = site.config['contentful']['localization'] || [{locale: nil, url_prefix: ""}]         
        
        # Get all entries of content type
        sync = client.sync(initial: true, type: 'Entry', content_type: content_type.id)

        sync.each_page do |page|
          puts "Generating #{page.items.count} entries of type \'#{content_type_name}\' (#{content_type.id})"

          page.items.each do |item|
            localization.each do |loc|
              fields = loc["locale"].nil? ? item.fields : item.fields(loc["locale"])
              site.pages << ContentfulEntryPage.new(site, fields, content_type_name, "/#{loc['url_prefix']}") unless fields.nil?
            end

          end
        end

      end
    end
  end

end