require_relative 'printer'

module Newsletter
  class AttributionPrinter < Printer
    class << self
      def print(doc, node)
        fragment_attribution = MLParserWrapper.parse_fragment('attribution.html')
        doc.at('body').last_element_child.add_next_sibling(fragment_attribution)
      end
    end
  end
end
