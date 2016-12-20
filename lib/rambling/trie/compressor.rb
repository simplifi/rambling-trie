module Rambling
  module Trie
    # Responsible for the compression process of a Trie data structure.
    class Compressor
      # Compresses a Trie data structure.
      # @param [RawNode] root the root of the Trie data structure
      # @return [CompressedNode] root the root of the Trie data structure
      def compress root
        new_root = Rambling::Trie::CompressedNode.new

        root.children.each do |child|
          compress_child child, new_root
        end

        new_root
      end

      private

      def compress_child node, parent = nil
        new_node = Rambling::Trie::CompressedNode.new parent

        if node.compressable?
          merged_node = compress_child node.children.first

          new_node.letter = node.letter.to_s << merged_node.letter.to_s
          new_node.terminal = merged_node.terminal?

          merged_node.children.each { |c| c.parent = new_node }
          new_node.children_tree = merged_node.children_tree
        else
          new_node.letter = node.letter
          new_node.terminal = node.terminal?

          node.children.map do |child|
            compress_child child, new_node
          end
        end

        new_node
      end
    end
  end
end
