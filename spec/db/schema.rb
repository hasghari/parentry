ActiveRecord::Schema.define(version: 0) do
  enable_extension 'ltree'

  create_table :tree_nodes, force: true do |t|
    t.integer :parent_id
    t.ltree :parentry
    t.integer :parentry_depth
    t.integer :rank

    t.timestamps null: false
  end

  create_table :one_depth_tree_nodes, force: true do |t|
    t.integer :parent_id
    t.ltree :parentry

    t.timestamps null: false
  end

  create_table :touch_tree_nodes, force: true do |t|
    t.integer :parent_id
    t.ltree :parentry

    t.timestamps null: false
  end
end
