class TreeNode < ActiveRecord::Base
  include Parentry

  parentry cache_depth: true, strategy: ENV.fetch('STRATEGY', 'ltree')
end

class OneDepthTreeNode < ActiveRecord::Base
  include Parentry

  parentry depth_offset: 1, strategy: ENV.fetch('STRATEGY', 'ltree')
end

class TouchTreeNode < ActiveRecord::Base
  include Parentry

  parentry touch: true, strategy: ENV.fetch('STRATEGY', 'ltree')
end
