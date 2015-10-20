module Parentry
  module Strategy
    module Array
      autoload :InstanceMethods, 'parentry/strategy/array/instance_methods'
      autoload :ClassMethods, 'parentry/strategy/array/class_methods'

      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end
    end
  end
end
