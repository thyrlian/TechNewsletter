require_relative 'printer'
require_relative '../ml_parser_wrapper'

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
