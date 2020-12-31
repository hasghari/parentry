require 'spec_helper'

describe Parentry::Navigation do
  fixtures :tree_nodes, :one_depth_tree_nodes

  describe '#root_id' do
    it { expect(tree_nodes(:n1).root_id).to eq 1 }
    it { expect(tree_nodes(:n1_n2_n4).root_id).to eq 1 }
  end

  describe '#root' do
    it { expect(tree_nodes(:n1).root).to eq tree_nodes(:n1) }
    it { expect(tree_nodes(:n1_n2_n4).root).to eq tree_nodes(:n1) }
  end

  describe '#root?' do
    it { expect(tree_nodes(:n1).root?).to be true }
    it { expect(tree_nodes(:n1_n2_n4).root?).to be false }
  end

  describe '#path_ids' do
    it { expect(tree_nodes(:n1).path_ids).to eq [1] }
    it { expect(tree_nodes(:n1_n2_n4).path_ids).to eq [1, 2, 4] }
  end

  describe '#path' do
    it { expect(tree_nodes(:n1).path).to eq [tree_nodes(:n1)] }
    it { expect(tree_nodes(:n1_n2_n4).path).to eq [tree_nodes(:n1), tree_nodes(:n1_n2), tree_nodes(:n1_n2_n4)] }

    it { expect(tree_nodes(:n5_n6_n7_n8).path(from_depth: 1).map(&:id)).to eq [6, 7, 8] }
    it { expect(tree_nodes(:n5_n6_n7_n8).path(from_depth: 1, to_depth: 2).map(&:id)).to eq [6, 7] }
  end

  describe '#ancestor_ids' do
    it { expect(tree_nodes(:n1).ancestor_ids).to eq [] }
    it { expect(tree_nodes(:n1_n2_n4).ancestor_ids).to eq [1, 2] }
  end

  describe '#ancestors' do
    it { expect(tree_nodes(:n1).ancestors).to eq [] }
    it { expect(tree_nodes(:n1_n2_n4).ancestors).to eq [tree_nodes(:n1), tree_nodes(:n1_n2)] }
  end

  describe '#children' do
    it { expect(tree_nodes(:n1).children).to eq [tree_nodes(:n1_n2), tree_nodes(:n1_n3)] }
    it { expect(tree_nodes(:n1_n2).children).to eq [tree_nodes(:n1_n2_n4)] }
  end

  describe '#child_ids' do
    it { expect(tree_nodes(:n1).child_ids).to match_array [2, 3] }
    it { expect(tree_nodes(:n1_n2).child_ids).to eq [4] }
  end

  describe '#children?' do
    it { expect(tree_nodes(:n1).children?).to be true }
    it { expect(tree_nodes(:n1_n2).children?).to be true }
    it { expect(tree_nodes(:n1_n2_n4).children?).to be false }
  end

  describe '#leaf?' do
    it { expect(tree_nodes(:n1).leaf?).to be false }
    it { expect(tree_nodes(:n1_n2).leaf?).to be false }
    it { expect(tree_nodes(:n1_n2_n4).leaf?).to be true }
  end

  describe '#sibling_ids' do
    it { expect(tree_nodes(:n1).sibling_ids).to eq [] }
    it { expect(tree_nodes(:n1_n2).sibling_ids).to eq [3] }
    it { expect(tree_nodes(:n1_n2_n4).sibling_ids).to eq [] }
  end

  describe '#siblings' do
    it { expect(tree_nodes(:n1).siblings).to eq [] }
    it { expect(tree_nodes(:n1_n2).siblings).to eq [tree_nodes(:n1_n3)] }
    it { expect(tree_nodes(:n1_n2_n4).siblings).to eq [] }
  end

  describe '#siblings?' do
    it { expect(tree_nodes(:n1).siblings?).to be false }
    it { expect(tree_nodes(:n1_n2).siblings?).to be true }
    it { expect(tree_nodes(:n1_n2_n4).siblings?).to be false }
  end

  describe '#only_child?' do
    it { expect(tree_nodes(:n1).only_child?).to be true }
    it { expect(tree_nodes(:n1_n2).only_child?).to be false }
    it { expect(tree_nodes(:n1_n2_n4).only_child?).to be true }
  end

  describe '#subtree_ids' do
    it { expect(tree_nodes(:n1).subtree_ids).to match_array [1, 2, 3, 4] }
    it { expect(tree_nodes(:n1_n2).subtree_ids).to match_array [2, 4] }
    it { expect(tree_nodes(:n1_n2_n4).subtree_ids).to eq [4] }
    it { expect(tree_nodes(:n5).subtree_ids).to match_array [5, 6, 7, 8] }
  end

  describe '#subtree' do
    it { expect(tree_nodes(:n1).subtree.map(&:id)).to match_array [1, 2, 3, 4] }
    it { expect(tree_nodes(:n1_n2).subtree.map(&:id)).to match_array [2, 4] }
    it { expect(tree_nodes(:n1_n2_n4).subtree.map(&:id)).to eq [4] }
    it { expect(tree_nodes(:n5).subtree.map(&:id)).to match_array [5, 6, 7, 8] }
  end

  describe '#descendant_ids' do
    it { expect(tree_nodes(:n1).descendant_ids).to match_array [2, 3, 4] }
    it { expect(tree_nodes(:n1_n2).descendant_ids).to eq [4] }
    it { expect(tree_nodes(:n1_n2_n4).descendant_ids).to eq [] }
    it { expect(tree_nodes(:n5).descendant_ids).to match_array [6, 7, 8] }
  end

  describe '#descendants' do
    it { expect(tree_nodes(:n1).descendants.map(&:id)).to match_array [2, 3, 4] }
    it { expect(tree_nodes(:n1_n2).descendants.map(&:id)).to eq [4] }
    it { expect(tree_nodes(:n1_n2_n4).descendants.map(&:id)).to eq [] }
    it { expect(tree_nodes(:n5).descendants.map(&:id)).to match_array [6, 7, 8] }
  end

  describe '#depth' do
    it { expect(tree_nodes(:n1).depth).to eq 0 }
    it { expect(tree_nodes(:n1_n2).depth).to eq 1 }
    it { expect(tree_nodes(:n1_n2_n4).depth).to eq 2 }
    it { expect(tree_nodes(:n5).depth).to eq 0 }

    it { expect(one_depth_tree_nodes(:odtn1).depth).to eq 1 }
    it { expect(one_depth_tree_nodes(:odtn1_odtn2).depth).to eq 2 }
    it { expect(one_depth_tree_nodes(:odtn1_odtn2_odtn3).depth).to eq 3 }
  end
end
