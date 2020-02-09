require 'spec_helper'

describe Parentry::InstanceMethods do
  def parse(parentry)
    TreeNode.new.parse_parentry(parentry)
  end

  it { expect(TreeNode.new.parentry_column).to eq 'parentry' }

  it 'persists parentry path after create' do
    parent = TreeNode.create
    node = TreeNode.create parent: parent
    expect(parse(node.parentry)).to eq [parent.id, node.id]
  end

  it 'is not valid when parent not persisted' do
    parent = TreeNode.new
    expect(TreeNode.new(parent: parent)).not_to be_valid
  end

  it 'cannot create circular path' do
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

  context 'when creating children through association' do
    let(:parent) { TreeNode.create }
    let!(:node) { parent.children.create }

    it 'sets the correct parent for node' do
      expect(node.parent).to eq parent
    end

    it 'creates correct hierarchy' do
      expect(parse(node.parentry)).to eq [parent.id, node.id]
    end

    it 'caches correct depth for parent' do
      expect(parent.parentry_depth).to eq 0
    end

    it 'caches correct depth for node' do
      expect(node.parentry_depth).to eq 1
    end
  end

  context 'when parent changes' do
    let(:old_parent) { TreeNode.create }
    let(:node) { TreeNode.create parent: old_parent }
    let(:new_parent) { TreeNode.create }

    it 'assigns new parentry path' do
      node.update(parent: new_parent)
      expect(parse(node.parentry)).to eq [new_parent.id, node.id]
    end

    it 'cascades changes to children' do
      child = TreeNode.create parent: node

      node.update(parent: new_parent)
      expect(parse(child.reload.parentry)).to eq [new_parent.id, node.id, child.id]
    end

    describe '#depth' do
      let(:grandparent) { TreeNode.create }
      let(:parent) { grandparent.children.create }
      let(:node) { parent.children.create }

      it 'has correct depth' do
        expect(node.depth).to eq 2
      end

      it 'updates node depth' do
        node.parent = grandparent
        expect(node.depth).to eq 1
      end

      it 'updates persisted depth' do
        node.update(parent: grandparent)
        expect(node.parentry_depth).to eq 1
      end
    end
  end

  context 'with touch ancestors option' do
    context 'when enabled' do
      it 'updates ancestor timestamp' do
        parent = TouchTreeNode.create
        expect do
          parent.children.create
        end.to(change { parent.reload.updated_at })
      end

      context 'when parent changes' do
        let!(:parent) { TouchTreeNode.create }
        let!(:node) { parent.children.create }
        let(:new_parent) { TouchTreeNode.create }

        it 'updates old parent timestamp' do
          expect do
            node.update(parent: new_parent)
          end.to(change { parent.reload.updated_at })
        end

        it 'updates new parent timestamp' do
          expect do
            node.update(parent: new_parent)
          end.to(change { new_parent.reload.updated_at })
        end
      end

      it 'updates parent timestamp when child is deleted' do
        parent = TouchTreeNode.create
        node = parent.children.create

        expect do
          node.destroy
        end.to(change { parent.reload.updated_at })
      end
    end

    context 'when disabled' do
      it 'does not update ancestor timestamp' do
        parent = TreeNode.create
        expect do
          parent.children.create
        end.not_to(change { parent.reload.updated_at })
      end
    end
  end
end
