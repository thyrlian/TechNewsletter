require 'nokogiri'
require_relative 'constants'

module Newsletter
  class MLParserWrapper
    class << self
      def default_dir
        return Constants.templates_directory
      end

      def parse_html(filename)
        return File.open(default_dir + filename) { |f| Nokogiri::HTML(f) }
      end

      def parse_fragment(filename)
        return Nokogiri::HTML::DocumentFragment.parse(File.read(default_dir + filename))
      end

      def parse_xsl(filename)
        return Nokogiri::XSLT(File.read(default_dir + 'pretty-printer.xsl'))
      end
    end

    private_class_method :new, :default_dir
  end
end
