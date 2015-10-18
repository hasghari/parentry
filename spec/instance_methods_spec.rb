require 'spec_helper'

describe Parentry::InstanceMethods do
  it { expect(TreeNode.new.parentry_column).to eq 'parentry' }

  it 'should persist parentry path after create' do
    parent = TreeNode.create
    node = TreeNode.create parent: parent
    expect(node.parentry).to eq "#{parent.id}.#{node.id}"
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
    expect(node.parentry).to eq "#{parent.id}.#{node.id}"
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
      node.update_attributes(parent: new_parent)
      expect(node.parentry).to eq "#{new_parent.parentry}.#{node.id}"
    end

    it 'should cascade changes to children' do
      old_parent = TreeNode.create
      node = TreeNode.create parent: old_parent
      child = TreeNode.create parent: node

      new_parent = TreeNode.create
      node.update_attributes(parent: new_parent)
      expect(child.reload.parentry).to eq "#{node.parentry}.#{child.id}"
    end
  end
end
