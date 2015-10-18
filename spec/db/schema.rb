ActiveRecord::Schema.define(version: 0) do
  enable_extension 'ltree'

  create_table :tree_nodes, force: true do |t|
    t.integer :parent_id
    t.ltree :parentry
    t.integer :parentry_depth
    t.integer :rank
  end

  create_table :one_depth_tree_nodes, force: true do |t|
    t.integer :parent_id
    t.ltree :parentry
  end
end
