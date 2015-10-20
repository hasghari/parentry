module Parentry
  module Strategy
    module Ltree
      autoload :InstanceMethods, 'parentry/strategy/ltree/instance_methods'
      autoload :ClassMethods, 'parentry/strategy/ltree/class_methods'

      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end
    end
  end
end
