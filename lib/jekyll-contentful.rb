require "jekyll"
require "contentful"
require "jekyll-contentful/version"
require "jekyll-contentful/language_switcher_tag"

module Jekyll
  class ContentfulEntryPage < Page
    def initialize(site, entry, content_type_name, prefix)
      
      @site = site
      @base = site.source
      @name = 'index.html'
      
      content_type_slug = Utils.slugify content_type_name

      layout_filename = site.layouts.key?(content_type_slug) ? "#{content_type_slug}.html" : "default.html"
      self.read_yaml(File.join(@base, '_layouts'), layout_filename)

      # stringify hash keys
      fields = entry.fields.inject({}){|x,(k,v)| x[k.to_s] = v; x}

      # merge data
      self.data.merge!(fields)

      self.data["contentful_id"] = entry.id
      self.data["locale"] = entry.locale

      # If there is a title fields make it the url
      page_title_slug = Utils.slugify(self.data["title"] || "")
      @dir = "/#{prefix}#{content_type_slug}/#{page_title_slug}"
      
      self.process(@name)
    end
  end

  class ContentfulEntryPageGenerator < Generator
    safe true

    def generate(site)

      if site.config['contentful']['preview']
        api_url = 'preview.contentful.com'
        access_token =  site.config['contentful']['preview_access_token']
      else 
        api_url = 'cdn.contentful.com'
        access_token =  site.config['contentful']['production_access_token']
      end

      client = ::Contentful::Client.new(
        access_token: access_token,
        space: site.config['contentful']['space'],
        api_url: api_url
      )

      # Loop over all content types
      site.config['contentful']['content_types'].each do |content_type_name|
        # Get ID for content type name
        content_type = client.content_types(name: content_type_name).first

        throw "Content_type \'#{content_type_name}\' does not exist." if content_type.nil? 

        
        localization = site.config['contentful']['localization'] || [{locale: nil, url_prefix: ""}]
        localization.each do |loc|

          entries = client.entries(content_type: content_type.id, locale: loc["locale"], limit: 1000)

          entries.each do |entry|
              next if entry.fields.nil?
              
              pub_langs = entry.fields[site.config['contentful']['published_locales_field'].to_sym]

              if pub_langs.nil? or pub_langs.map{|x| x.fields[:locale]}.include?(loc["locale"])
                site.pages << ContentfulEntryPage.new(site, entry, content_type_name, "#{loc['url_prefix']}")
              end
               
          end
        end

      end
    end
  end

end