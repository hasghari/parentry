ActiveRecord::Schema.define(version: 0) do
  enable_extension 'ltree'

  def parentry_column_type
    ENV['STRATEGY'] == 'array' ? :integer : :ltree
  end

  def parentry_column_options
    ENV['STRATEGY'] == 'array' ? { array: true } : {}
  end

  create_table :tree_nodes, force: true do |t|
    t.integer :parent_id
    t.column :parentry, parentry_column_type, **parentry_column_options
    t.integer :parentry_depth
    t.integer :rank

    t.timestamps null: false
  end

  create_table :one_depth_tree_nodes, force: true do |t|
    t.integer :parent_id
    t.column :parentry, parentry_column_type, **parentry_column_options

    t.timestamps null: false
  end

  create_table :touch_tree_nodes, force: true do |t|
    t.integer :parent_id
    t.column :parentry, parentry_column_type, **parentry_column_options

    t.timestamps null: false
  end
end
