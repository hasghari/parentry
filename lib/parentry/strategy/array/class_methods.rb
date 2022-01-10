module Parentry
  module Strategy
    module Array
      module ClassMethods
        def parentry_depth_function
          Arel::Nodes::NamedFunction.new('array_length', [arel_table[parentry_column], 1])
        end
      end
    end
  end
end
