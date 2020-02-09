require 'spec_helper'

describe Parentry do
  fixtures :tree_nodes

  it 'has a version number' do
    expect(Parentry::VERSION).not_to be nil
  end

  it 'responds to parentry' do
    expect(TreeNode).to respond_to :parentry
  end

  describe 'scopes' do
    it { expect(TreeNode.before_depth(1).pluck(:id)).to match_array [1, 5] }
    it { expect(TreeNode.before_depth(2).pluck(:id)).to match_array [1, 2, 3, 5, 6] }

    it { expect(TreeNode.to_depth(1).pluck(:id)).to match_array [1, 2, 3, 5, 6] }
    it { expect(TreeNode.to_depth(2).pluck(:id)).to match_array [1, 2, 3, 4, 5, 6, 7] }

    it { expect(TreeNode.at_depth(0).pluck(:id)).to match_array [1, 5] }
    it { expect(TreeNode.at_depth(1).pluck(:id)).to match_array [2, 3, 6] }
    it { expect(TreeNode.at_depth(2).pluck(:id)).to match_array [4, 7] }

    it { expect(TreeNode.from_depth(0).pluck(:id)).to match_array [1, 2, 3, 4, 5, 6, 7, 8] }
    it { expect(TreeNode.from_depth(1).pluck(:id)).to match_array [2, 3, 4, 6, 7, 8] }
    it { expect(TreeNode.from_depth(2).pluck(:id)).to match_array [4, 7, 8] }

    it { expect(TreeNode.after_depth(0).pluck(:id)).to match_array [2, 3, 4, 6, 7, 8] }
    it { expect(TreeNode.after_depth(1).pluck(:id)).to match_array [4, 7, 8] }
    it { expect(TreeNode.after_depth(2).pluck(:id)).to match_array [8] }

    it { expect(TreeNode.roots.pluck(:id)).to match_array [1, 5] }

    it { expect(TreeNode.ancestors_of(tree_nodes(:n1_n2_n4)).pluck(:id)).to match_array [1, 2] }

    it { expect(TreeNode.children_of(tree_nodes(:n1)).pluck(:id)).to match_array [2, 3] }

    it { expect(TreeNode.descendants_of(tree_nodes(:n1)).pluck(:id)).to match_array [2, 3, 4] }

    it { expect(TreeNode.subtree_of(tree_nodes(:n1)).pluck(:id)).to match_array [1, 2, 3, 4] }

    it { expect(TreeNode.siblings_of(tree_nodes(:n1_n2)).pluck(:id)).to match_array [3] }
  end

  describe '::arrange' do
    def collect_keys(hash, memo = [])
      hash.each_with_object(memo) do |(key, children), m|
        m << key.id
        collect_keys(children, m)
      end
    end

    # rubocop:disable RSpec/ExampleLength
    it 'arranges nodes by depth' do
      expect(TreeNode.arrange).to eq(
        tree_nodes(:n1) => {
          tree_nodes(:n1_n2) => {
            tree_nodes(:n1_n2_n4) => {}
          },
          tree_nodes(:n1_n3) => {}
        },
        tree_nodes(:n5) => {
          tree_nodes(:n5_n6) => {
            tree_nodes(:n5_n6_n7) => {
              tree_nodes(:n5_n6_n7_n8) => {}
            }
          }
        }
      )
    end
    # rubocop:enable RSpec/ExampleLength

    it 'sorts by additional order argument' do
      arranged = TreeNode.arrange(order: :rank)
      expect(collect_keys(arranged)).to eq [1, 3, 2, 4, 5, 6, 7, 8]
    end

    # rubocop:disable RSpec/ExampleLength
    it 'arranges subtree' do
      expect(TreeNode.from_depth(1).arrange).to eq(
        tree_nodes(:n1_n2) => {
          tree_nodes(:n1_n2_n4) => {}
        },
        tree_nodes(:n1_n3) => {},
        tree_nodes(:n5_n6) => {
          tree_nodes(:n5_n6_n7) => {
            tree_nodes(:n5_n6_n7_n8) => {}
          }
        }
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
