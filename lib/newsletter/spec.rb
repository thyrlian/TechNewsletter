module Newsletter
  class Spec
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
          insert_child(tree, tag, data, indent)
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
      insert_child(parent[:children], tag, data, indent)
    end

    def insert_child(tree, tag, data, indent)
      num = 0
      new_tag = tag
      while tree.has_key?(new_tag)
        num += 1
        new_tag = tag + num.to_s
      end
      tree[new_tag] = {data: data, indent: indent}
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

    def iterate(&block)
      traverse(@tree) do |key, value|
        yield(key, value)
      end
    end

    def rinse!
      # Final step, remove all unnecessary indent info
      traverse(@tree) do |key, value|
        value.delete(:indent)
      end
    end

    private :insert, :insert_to_parent, :insert_child, :traverse
  end
end
