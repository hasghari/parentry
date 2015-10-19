class TreeNode < ActiveRecord::Base
  include Parentry
  parentry cache_depth: true
end

class OneDepthTreeNode < ActiveRecord::Base
  include Parentry
  parentry depth_offset: 1
end

class TouchTreeNode < ActiveRecord::Base
  include Parentry
  parentry touch: true
end
