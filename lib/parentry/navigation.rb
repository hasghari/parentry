module Parentry
  module Navigation
    def root_id
      path_ids[0]
    end

    def root
      unscoped_find(root_id)
    end

    def root?
      parent_id.nil?
    end

    def path_ids
      parse_parentry
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
      children.empty?
    end
    alias childless? leaf?

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
      siblings.size.positive?
    end

    def only_child?
      !siblings?
    end

    def subtree_ids(scopes = {})
      subtree(scopes).pluck(:id)
    end

    def subtree(scopes = {})
      with_depth_scopes(scopes) do
        parentry_scope.where(subtree_conditions)
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
      return depth_offset if root?
      return parent.depth + 1 if changes[:parent_id].present?

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
