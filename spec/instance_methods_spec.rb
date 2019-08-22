require 'spec_helper'

describe Parentry::InstanceMethods do
  def parse(parentry)
    TreeNode.new.parse_parentry(parentry)
  end

  it { expect(TreeNode.new.parentry_column).to eq 'parentry' }

  it 'should persist parentry path after create' do
    parent = TreeNode.create
    node = TreeNode.create parent: parent
    expect(parse(node.parentry)).to eq [parent.id, node.id]
  end

  it 'should not be valid when parent not persisted' do
    parent = TreeNode.new
    expect(TreeNode.new(parent: parent)).not_to be_valid
  end

  it 'should not be able to create circular path' do
    parent = TreeNode.create
    child = parent.children.create
    parent.parent = child
    parent.save
    expect(parent).not_to be_valid
  end

  it 'assigns parent when persisted' do
    parent = TreeNode.create
    node = TreeNode.new parent: parent
    expect(node.parent).to eq parent
  end

  it 'can create children through association' do
    parent = TreeNode.create
    node = parent.children.create

    expect(node.parent).to eq parent
    expect(parse(node.parentry)).to eq [parent.id, node.id]
  end

  it 'caches parentry depth' do
    parent = TreeNode.create
    node = parent.children.create

    expect(parent.parentry_depth).to eq 0
    expect(node.parentry_depth).to eq 1
  end

  context 'when parent changes' do
    it 'should assign new parentry path' do
      old_parent = TreeNode.create
      node = TreeNode.create parent: old_parent

      new_parent = TreeNode.create
      node.update(parent: new_parent)
      expect(parse(node.parentry)).to eq [new_parent.id, node.id]
    end

    it 'should cascade changes to children' do
      old_parent = TreeNode.create
      node = TreeNode.create parent: old_parent
      child = TreeNode.create parent: node

      new_parent = TreeNode.create
      node.update(parent: new_parent)
      expect(parse(child.reload.parentry)).to eq [new_parent.id, node.id, child.id]
    end

    it 'should have correct depth' do
      grand_parent = TreeNode.create
      parent = grand_parent.children.create
      node = parent.children.create
      expect(node.depth).to eq 2

      node.parent = grand_parent
      expect(node.depth).to eq 1

      node.save

      expect(node.parentry_depth).to eq 1
    end
  end

  context 'touch ancestors option' do
    context 'enabled' do
      it 'should update ancestor timestamp' do
        parent = TouchTreeNode.create
        expect do
          parent.children.create
        end.to change { parent.reload.updated_at }
      end

      context 'parent changes' do
        it 'should update old parent timestamp' do
          parent = TouchTreeNode.create
          node = parent.children.create
          new_parent = TouchTreeNode.create

          expect do
            node.update(parent: new_parent)
          end.to change { parent.reload.updated_at }
        end

        it 'should update new parent timestamp' do
          parent = TouchTreeNode.create
          node = parent.children.create
          new_parent = TouchTreeNode.create

          expect do
            node.update(parent: new_parent)
          end.to change { new_parent.reload.updated_at }
        end
      end

      it 'should update parent timestamp when child is deleted' do
        parent = TouchTreeNode.create
        node = parent.children.create

        expect do
          node.destroy
        end.to change { parent.reload.updated_at }
      end
    end

    context 'disabled' do
      it 'should not update ancestor timestamp' do
        parent = TreeNode.create
        expect do
          parent.children.create
        end.not_to change { parent.reload.updated_at }
      end
    end
  end
end
