require 'premailer'

module Newsletter
  class Factory
    def initialize(params = {})
      @doc = MLParserWrapper.parse_html('base.html')
      @inline_css = params.fetch(:inline_css, true)
      @supported_printers = get_supported_printers
    end

    def get_supported_printers
      printers = []
      module_name = self.class.to_s.split('::').first
      regex = /^#{module_name}::(\w+)Printer$/
      ObjectSpace.each_object do |obj|
        if obj.class == Class && regex.match(obj.to_s)
          printers << $1
        end
      end
      return printers
    end

    def print(component, content)
      name = component.gsub(/\d+$/, '')
      if @supported_printers.include?(name)
        puts "✎ Printing #{name}..."
        Object.const_get("#{name}Printer").print(@doc, content)
      end
    end

    def apply_inline_css(html)
      puts "⚘ Applying inline CSS..."
      premailer = Premailer.new(html, :warn_level => Premailer::Warnings::SAFE)
      File.open(html, "w") do |f|
        f.puts premailer.to_inline_css
      end
    end

    def finish(output = 'newsletter.html')
      puts "⚡ Generating #{output}..."
      File.write(output, MLParserWrapper.parse_xsl('pretty-printer.xsl').apply_to(@doc))
      apply_inline_css(output) if @inline_css
      puts '☺ Done!'
    end

    class << self
      def run(params = {})
        new(params)
      end
    end

    private :get_supported_printers, :apply_inline_css
    private_class_method :new
  end
end
