module Newsletter
  class Parser
    INDENT_SIZE = 2
    TAG_BEGINNING_DELIMITER = '⇥'
    TAG_ENDING_DELIMITER = '⇤'

    def initialize(file, &block)
      if (!File.exist?(file))
        fail(RuntimeError, "#{file} doesn't exist.")
      end

      File.readlines(file).each do |line|
        line = self.class.normalize(line)
        yield(line)
      end
    end

    class << self
      def analyze(file, &block)
        new(file, &block)
      end

      def obtain_clean_match_content(regex, line)
        match_data = regex.match(line)
        if match_data
          md = match_data[1].strip
          return md.empty? ? nil : md
        else
          return nil
        end
      end

      def get_tag(line)
        obtain_clean_match_content(/^\s*?#{TAG_BEGINNING_DELIMITER}(.+)#{TAG_ENDING_DELIMITER}/, line)
      end

      def get_value(line)
        obtain_clean_match_content(/^\s*?#{TAG_BEGINNING_DELIMITER}.+#{TAG_ENDING_DELIMITER}\s*?(.+)/, line)
      end

      def get_indent(line)
        regex = /^(\s+)\S*?/
        match_data = regex.match(line)
        return match_data ? match_data[1].length / INDENT_SIZE : 0
      end

      def normalize(line)
        regex = /^\t+/
        match_data = regex.match(line)
        if match_data
          return line.gsub(regex, "\s" * INDENT_SIZE * match_data[0].split('').length)
        else
          return line
        end
      end

      def is_at_root?(line)
        return get_indent(line) == 0
      end
    end

    private_class_method :new, :obtain_clean_match_content
  end
end
