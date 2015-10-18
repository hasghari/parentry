module Parentry
  module Navigation
    def root_id
      path_ids[0]
    end

    def root
      unscoped_find(root_id)
    end

    def root?
      root_id == id
    end

    def path_ids
      parentry.split('.').map(&:to_i)
    end

    def path(scopes = {})
      with_depth_scopes(scopes) do
        parentry_scope.where(id: path_ids).order_by_parentry
      end
    end

    def ancestor_ids
      path_ids[0..-2]
    end

    def ancestors(scopes = {})
      with_depth_scopes(scopes) do
        parentry_scope.where(id: ancestor_ids).order_by_parentry
      end
    end

    def leaf?
      children.size == 0
    end
    alias_method :childless?, :leaf?

    def children?
      !leaf?
    end

    def sibling_ids
      siblings.pluck(:id)
    end

    def siblings
      parentry_scope.where.not(id: id).where.not(parent_id: nil).where(parent_id: parent_id)
    end

    def siblings?
      siblings.size > 0
    end

    def only_child?
      !siblings?
    end

    def subtree_ids(scopes = {})
      subtree(scopes).pluck(:id)
    end

    def subtree(scopes = {})
      with_depth_scopes(scopes) do
        parentry_scope.where("#{parentry_column} <@ ?", parentry)
      end
    end

    def descendant_ids(scopes = {})
      descendants(scopes).pluck(:id)
    end

    def descendants(scopes = {})
      with_depth_scopes(scopes) do
        subtree.where.not(id: id)
      end
    end

    def depth
      path_ids.size - 1 + depth_offset
    end

    private

    def unscoped_find(id)
      parentry_scope.unscoped { parentry_scope.find(id) }
    end

    def with_depth_scopes(scopes)
      scopes.reduce(yield) do |memo, (scope, depth)|
        memo.send(scope, depth)
      end
    end
  end
end
