module Newsletter
  class SocialMediaPrinter < Printer
    class << self
      def print(doc, node)
        fragment_social_media_script = MLParserWrapper.parse_fragment('social-media-script.html')
        doc.at('head').add_child(fragment_social_media_script)
        fragment_social_media = MLParserWrapper.parse_fragment('social-media.html')
        social_media_section = fragment_social_media.css('#social-media').first
        node[:children].each do |media, username|
          element = SocialMedia.send("create_#{media.downcase}_link", username[:data])
          social_media_section.add_child(element)
        end
        doc.at('#content').add_next_sibling(fragment_social_media)
      end
    end
  end
end
