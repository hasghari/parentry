module Parentry
  module Strategy
    module Ltree
      module ClassMethods
        def parentry_depth_function
          Arel.sql("nlevel(#{parentry_column})")
        end
      end
    end
  end
end
