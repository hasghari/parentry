module Parentry
  module ClassMethods
    def parentry(options = {})
      self.parentry_strategy = options.fetch(:strategy, 'ltree').to_s
      self.parentry_column = options.fetch(:parentry_column, 'parentry')
      self.depth_offset = options.fetch(:depth_offset, 0)
      self.cache_depth = options.fetch(:cache_depth, false)
      self.touch_ancestors = options.fetch(:touch, false)

      include Strategy::Ltree if parentry_strategy == 'ltree'
      include Strategy::Array if parentry_strategy == 'array'
    end

    # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    def arrange(options = {})
      scope =
        if (order = options.delete(:order))
          base_class.order_by_parentry.order(order)
        else
          base_class.order_by_parentry
        end

      scope.where(options).each_with_object(Hash.new { |h, k| h[k] = {} }) do |node, memo|
        insert_node = node.ancestor_ids.reduce(memo) do |subtree, ancestor_id|
          match = subtree.find { |parent, _children| parent.id == ancestor_id }
          match ? match[1] : subtree
        end
        insert_node[node] = {}
      end
    end
    # rubocop:enable Metrics/AbcSize,Metrics/MethodLength
  end
end
