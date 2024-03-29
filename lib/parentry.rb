require 'parentry/version'
require 'parentry/strategy'

require 'active_support/concern'

module Parentry
  autoload :InstanceMethods, 'parentry/instance_methods'
  autoload :Navigation, 'parentry/navigation'
  autoload :ClassMethods, 'parentry/class_methods'

  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    include Navigation
    include InstanceMethods

    mattr_accessor :parentry_strategy, :parentry_column, :depth_offset, :cache_depth, :touch_ancestors

    belongs_to :parent, class_name: base_class.name, optional: true
    has_many :children, class_name: base_class.name, foreign_key: :parent_id, dependent: :destroy

    validate do
      errors.add(:parent, 'must be persisted') unless parent.blank? || parent.persisted?
    end

    validate :prevent_circular_parentry

    after_create :commit_parentry
    before_update :assign_parentry, if: proc { changes[:parent_id].present? }
    after_update :cascade_parentry, if: proc { saved_changes[parentry_column].present? }

    before_validation :cache_parentry_depth, if: proc { cache_depth }
    before_save :cache_parentry_depth, if: proc { cache_depth }

    after_save :touch_ancestors_callback
    after_touch :touch_ancestors_callback
    after_destroy :touch_ancestors_callback

    scope :order_by_parentry, -> { order(parentry_depth_function) }

    {
      before_depth: Arel::Nodes::LessThan,
      to_depth: Arel::Nodes::LessThanOrEqual,
      at_depth: Arel::Nodes::Equality,
      from_depth: Arel::Nodes::GreaterThanOrEqual,
      after_depth: Arel::Nodes::GreaterThan
    }.each do |name, node|
      scope name, ->(depth) { where(node.new(parentry_depth_function, depth + depth_offset + 1)) }
    end

    scope :roots, -> { where(Arel::Nodes::Equality.new(parentry_depth_function, 1)) }
    scope :ancestors_of, ->(node) { where(node.ancestor_conditions).where.not(id: node.id) }
    scope :children_of, ->(node) { where(parent_id: node.id) }
    scope :descendants_of, ->(node) { subtree_of(node).where.not(id: node.id) }
    scope :subtree_of, ->(node) { where(node.subtree_conditions) }
    scope :siblings_of, ->(node) { where(parent_id: node.parent_id).where.not(id: node.id) }
  end
  # rubocop:enable Metrics/BlockLength
end
