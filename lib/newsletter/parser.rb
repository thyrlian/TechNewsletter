module Newsletter
  class Parser
    INDENT_SIZE = 2
    TAG_BEGINNING_DELIMITER = '⇥'
    TAG_ENDING_DELIMITER = '⇤'

    class << self
      def read(file)
        if (!File.exist?(file))
          fail(RuntimeError, "#{file} doesn't exist.")
        end
        File.readlines(file).each do |line|
          line = normalize(line)
        end
      end

      def get_tag(line)
        regex = /^\s*?#{TAG_BEGINNING_DELIMITER}(.+)#{TAG_ENDING_DELIMITER}/
        match_data = regex.match(line)
        if match_data
          md = match_data[1].strip
          return md.empty? ? nil : md
        else
          return nil
        end
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
    end
  end
end
