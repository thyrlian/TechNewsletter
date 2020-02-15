module Newsletter
  class Holder
    # It is an ordered tree
    # Each node can have data, child(ren), or both
    # New node should always be added to the end (but proper level)

    def initialize
      @tree = {}
    end

    def insert(tree, tag, data, indent)
      last_tag = tree.keys.last
      if last_tag.nil?
        tree[tag] = {data: data, indent: indent}
      elsif last_tag == :children
        insert(tree[last_tag], tag, data, indent)
      else
        last_indent = tree[last_tag][:indent]
        if indent == last_indent
          tree[tag] = {data: data, indent: indent}
        elsif indent == last_indent + 1
          insert_to_parent(tree[last_tag], tag, data, indent)
        elsif indent > last_indent + 1
          insert(tree[last_tag], tag, data, indent)
        end
      end
    end

    def insert_to_parent(parent, tag, data, indent)
      unless parent.has_key?(:children)
        parent[:children] = {}
      end
      parent[:children][tag] = {data: data, indent: indent}
    end

    def add(tag, data, indent)
      insert(@tree, tag, data, indent)
    end

    def traverse(tree, &block)
      # Depth-first search
      tree.each do |key, value|
        if value.is_a?(Hash)
          yield(key, value)
          if value.has_key?(:children)
            traverse(value[:children], &block)
          end
        end
      end
    end

    def rinse
      # Final step, remove all unnecessary indent info
    end

    private :insert, :insert_to_parent, :traverse
  end
end