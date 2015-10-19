module Parentry
  module InstanceMethods
    def parentry_scope
      self.class.base_class
    end

    def prevent_circular_parentry
      computed = parse_parentry(compute_parentry)
      errors.add(:parentry, 'contains a circular reference') unless computed.uniq == computed
    end

    def commit_parentry
      update_column(parentry_column, compute_parentry)
    end

    def assign_parentry
      write_attribute(parentry_column, compute_parentry)
    end

    def cache_parentry_depth
      write_attribute(:parentry_depth, depth)
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

    def parse_parentry(input = parentry)
      input.to_s.split('.').map(&:to_i)
    end

    def touch_ancestors_callback
      return unless touch_ancestors
      return if touch_callbacks_disabled?

      parentry_scope.where(id: ancestor_ids_was + ancestor_ids).each do |ancestor|
        ancestor.without_touch_callbacks { ancestor.touch }
      end
    end

    def without_touch_callbacks
      @disable_touch_callbacks = true
      yield
      @disable_touch_callbacks = false
    end

    def touch_callbacks_disabled?
      @disable_touch_callbacks
    end

    def ancestor_ids_was
      return [] unless changes[parentry_column]
      parse_parentry(changes[parentry_column][0]).tap(&:pop)
    end
  end
end
