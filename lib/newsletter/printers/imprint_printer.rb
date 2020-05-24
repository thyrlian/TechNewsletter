require_relative 'printer'

module Newsletter
  class ImprintPrinter < Printer
    class << self
      def print(doc, node)
        fragment_imprint = MLParserWrapper.parse_fragment('imprint.html')
        if node[:data]
          fragment_imprint.css('#imprint').first.add_child("<span>#{node[:data]}</span>")
        elsif node[:children]
          imprints = []
          node[:children].each_value do |value|
            imprints.push(value[:data])
          end
          imprints.each do |i|
            fragment_imprint.css('#imprint').first.add_child("<span>#{i}</span>").first.add_next_sibling('<br/>')
          end
        end
        (doc.at('#social-media') || doc.at('#content')).add_next_sibling(fragment_imprint)
      end
    end
  end
end
