module Newsletter
  class Holder
    # It is an ordered tree
    # Each node can have value, child(ren), or both
    # New node should always be added to the end (but proper level)

    def initialize
      @tree = {}
    end

    def insert(tree, tag, value, indent)
      last_tag = tree.keys.last
      if last_tag.nil?
        tree[tag] = {value: value, indent: indent}
      elsif last_tag == :children
        insert(tree[last_tag], tag, value, indent)
      else
        last_indent = tree[last_tag][:indent]
        if indent == last_indent
          tree[tag] = {value: value, indent: indent}
        elsif indent == last_indent + 1
          insert_to_parent(tree[last_tag], tag, value, indent)
        elsif indent > last_indent + 1
          insert(tree[last_tag], tag, value, indent)
        end
      end
    end

    def insert_to_parent(parent, tag, value, indent)
      unless parent.has_key?(:children)
        parent[:children] = {}
      end
      parent[:children][tag] = {value: value, indent: indent}
    end

    def add(tag, value, indent)
      insert(@tree, tag, value, indent)
    end

    def rinse
      # Final step, remove all unnecessary indent info
    end

    private :insert, :insert_to_parent
  end
end
