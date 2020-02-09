ActiveRecord::Schema.define(version: 0) do
  enable_extension 'ltree'

  def parentry_options
    case ENV['STRATEGY']
    when 'array'
      [:parentry, :integer, array: true]
    else
      %i(parentry ltree)
    end
  end

  create_table :tree_nodes, force: true do |t|
    t.integer :parent_id
    t.column(*parentry_options)
    t.integer :parentry_depth
    t.integer :rank

    t.timestamps null: false
  end

  create_table :one_depth_tree_nodes, force: true do |t|
    t.integer :parent_id
    t.column(*parentry_options)

    t.timestamps null: false
  end

  create_table :touch_tree_nodes, force: true do |t|
    t.integer :parent_id
    t.column(*parentry_options)

    t.timestamps null: false
  end
end
