require 'parentry/version'
require 'parentry/strategy'

module Parentry
  autoload :InstanceMethods, 'parentry/instance_methods'
  autoload :Navigation, 'parentry/navigation'
  autoload :ClassMethods, 'parentry/class_methods'

  def self.included(base)
    base.class_eval do
      mattr_accessor :parentry_strategy, :parentry_column, :depth_offset, :cache_depth, :touch_ancestors

      belongs_to :parent, class_name: base_class.name
      has_many :children, class_name: base_class.name, foreign_key: :parent_id, dependent: :destroy

      validate do
        unless parent.blank? || parent.persisted?
          errors.add(:parent, 'must be persisted')
        end
      end

      validate :prevent_circular_parentry

      after_create :commit_parentry
      before_update :assign_parentry, if: proc { changes[:parent_id].present? }
      after_update :cascade_parentry, if: proc { changes[parentry_column].present? }

      before_validation :cache_parentry_depth, if: proc { cache_depth }
      before_save :cache_parentry_depth, if: proc { cache_depth }

      after_save :touch_ancestors_callback
      after_touch :touch_ancestors_callback
      after_destroy :touch_ancestors_callback

      scope :order_by_parentry, -> { order(parentry_depth_function) }

      scope :before_depth, ->(depth) { where("#{parentry_depth_function} - 1 < ?", depth + depth_offset) }
      scope :to_depth, ->(depth) { where("#{parentry_depth_function} - 1 <= ?", depth + depth_offset) }
      scope :at_depth, ->(depth) { where("#{parentry_depth_function} - 1 = ?", depth + depth_offset) }
      scope :from_depth, ->(depth) { where("#{parentry_depth_function} - 1 >= ?", depth + depth_offset) }
      scope :after_depth, ->(depth) { where("#{parentry_depth_function} - 1 > ?", depth + depth_offset) }

      scope :roots, -> { where("#{parentry_depth_function} = 1") }
      scope :ancestors_of, ->(node) { where(node.ancestor_conditions).where.not(id: node.id) }
      scope :children_of, ->(node) { where(parent_id: node.id) }
      scope :descendants_of, ->(node) { subtree_of(node).where.not(id: node.id) }
      scope :subtree_of, ->(node) { where(node.subtree_conditions) }
      scope :siblings_of, ->(node) { where(parent_id: node.parent_id).where.not(id: node.id) }
    end

    base.send :include, Navigation
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end
end
