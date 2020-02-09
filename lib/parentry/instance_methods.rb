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

    def parentry
      read_attribute(parentry_column)
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
      return [] unless saved_changes[parentry_column]

      parse_parentry(saved_changes[parentry_column][0]).tap(&:pop)
    end
  end
end
