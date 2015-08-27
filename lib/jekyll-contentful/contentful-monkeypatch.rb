# Make asset arrays work in liquid templates
# e.g. 
# 
#  {% for pic in page.gallery %}
#    {{ pic.title }}
#    <img src="{{ pic.file.url }}" />
#  {% endfor %}
#  

module Contentful
  class Asset
    def to_liquid
      Jekyll::Utils.stringify_hash_keys(self.fields)
    end
  end
  class File
    def to_liquid
      Jekyll::Utils.stringify_hash_keys(self.properties)
    end
  end
end