module Parentry
  module InstanceMethods
    def parentry_scope
      self.class.base_class
    end

    def prevent_circular_parentry
      computed = compute_parentry
      errors.add(:parentry, 'contains a circular reference') unless computed.split('.').uniq == computed.split('.')
    end

    def commit_parentry
      update_column(parentry_column, compute_parentry)
    end

    def assign_parentry
      write_attribute(parentry_column, compute_parentry)
    end

    def cache_parentry_depth
      update_column(:parentry_depth, depth)
    end

    def cascade_parentry
      old_path, new_path = changes[parentry_column]
      parentry_scope.where(
        ["#{parentry_column} <@ :ltree AND id != :id", ltree: old_path, id: id]
      ).update_all(
        [
          "#{parentry_column} = :new_path || subpath(#{parentry_column}, nlevel(:old_path))",
          new_path: new_path, old_path: old_path
        ]
      )
    end

    def compute_parentry
      parent.present? ? "#{parent.parentry}.#{id}" : "#{id}"
    end

    def parentry
      read_attribute(parentry_column)
    end
  end
end
