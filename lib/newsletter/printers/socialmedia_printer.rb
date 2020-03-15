module Newsletter
  class SocialMediaPrinter < Printer
    class << self
      def print(doc, node)
        fragment_social_media = MLParserWrapper.parse_fragment('social-media.html')
        social_media_section = fragment_social_media.css('#social-media').first
        type = (node[:data] || 'SVG').upcase
        klass = Object.const_get("SocialMedia#{type}")
        node[:children].each do |media, username|
          element = klass.send("create_#{media.downcase}_link", username[:data])
          social_media_section.add_child(element)
        end
        doc.at('#content').add_next_sibling(fragment_social_media)
      end
    end
  end
end
