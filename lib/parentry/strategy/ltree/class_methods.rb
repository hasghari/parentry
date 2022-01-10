module Parentry
  module Strategy
    module Ltree
      module ClassMethods
        def parentry_depth_function
          Arel::Nodes::NamedFunction.new('nlevel', [arel_table[parentry_column]])
        end
      end
    end
  end
end
