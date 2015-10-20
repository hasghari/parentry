module Parentry
  module Strategy
    module Array
      module ClassMethods
        def parentry_depth_function
          "array_length(#{parentry_column}, 1)"
        end
      end
    end
  end
end
