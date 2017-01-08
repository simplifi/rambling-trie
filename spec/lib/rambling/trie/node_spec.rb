require 'spec_helper'

describe Rambling::Trie::Node do
  let(:node) { Rambling::Trie::Node.new }

  describe '#root?' do
    context 'when the node has a parent' do
      before do
        node.parent = double :parent
      end

      it 'returns false' do
        expect(node).not_to be_root
      end
    end

    context 'when the node does not have a parent' do
      before do
        node.parent = nil
      end

      it 'returns true' do
        expect(node).to be_root
      end
    end
  end

  describe '.new' do
    let(:node) { Rambling::Trie::Node.new }

    it 'does not have any letter' do
      expect(node.letter).to be_nil
    end

    it 'includes no children' do
      expect(node.children.size).to eq 0
    end

    it 'is not a terminal node' do
      expect(node).not_to be_terminal
    end

    it 'returns empty string as its word' do
      expect(node.as_word).to be_empty
    end
  end

  describe '#terminal!' do
    it 'forces the node to be terminal' do
      expect(node).not_to be_terminal
      node.terminal!

      expect(node).to be_terminal
    end

    it 'returns the node' do
      expect(node.terminal!).to eq node
    end
  end

  describe 'delegates and aliases' do
    it 'delegates `#[]` to its children tree' do
      expect(node.children_tree).to receive(:[]).with(:key).and_return('value')
      expect(node[:key]).to eq 'value'
    end

    it 'delegates `#[]=` to its children tree' do
      expect(node.children_tree).to receive(:[]=).with(:key, 'value')
      node[:key] = 'value'
    end

    it 'delegates `#has_key?` to its children tree' do
      expect(node.children_tree).to receive(:has_key?).with(:present_key).and_return(true)
      expect(node).to have_key(:present_key)

      expect(node.children_tree).to receive(:has_key?).with(:absent_key).and_return(false)
      expect(node).not_to have_key(:absent_key)
    end

    it 'delegates `#children` to its children tree values' do
      children = [double(:child_1), double(:child_2)]
      expect(node.children_tree).to receive(:values).and_return(children)
      expect(node.children).to eq children
    end
  end

  describe '#==' do
    let(:node_1) { Rambling::Trie::RawNode.new }
    let(:node_2) { Rambling::Trie::RawNode.new }

    context 'when the nodes do not have the same letter' do
      before do
        node_1.letter = :a
        node_2.letter = :b
      end

      it 'returns false' do
        expect(node_1).not_to eq node_2
      end
    end

    context 'when the nodes have the same letter and no children' do
      before do
        node_1.letter = :a
        node_2.letter = :a
      end

      it 'returns true' do
        expect(node_1).to eq node_2
      end
    end

    context 'when the nodes have the same letter and the same children' do
      before do
        node_1.letter = :t
        node_1.add 'hese'
        node_1.add 'hree'
        node_1.add 'hings'

        node_2.letter = :t
        node_2.add 'hese'
        node_2.add 'hree'
        node_2.add 'hings'
      end

      it 'returns true' do
        expect(node_1).to eq node_2
      end
    end

    context 'when the nodes have the same letter and the same children' do
      before do
        node_1.letter = :t
        node_1.add 'hese'
        node_1.add 'wo'

        node_2.letter = :t
        node_2.add 'hese'
        node_2.add 'hree'
        node_2.add 'hings'
      end

      it 'returns false' do
        expect(node_1).not_to eq node_2
      end
    end
  end
end
