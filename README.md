![](https://github.com/hasghari/parentry/workflows/Ruby/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/cc7180328fffcbdea2bb/maintainability)](https://codeclimate.com/github/hasghari/parentry/maintainability)

# Parentry

Parentry in its current incarnation is an ActiveRecord extension for the [PostgreSQL ltree](http://www.postgresql.org/docs/9.4/static/ltree.html) module.

The API is inspired by the popular [ancestry](https://github.com/stefankroes/ancestry) gem and mirrors (with a few exceptions) the methods available in that gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'parentry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parentry

## Usage

This gem requires 2 columns for each table: `parentry` and `parent_id`, and can leverage either the `ltree` postgresql extension, or else postgres `array` columns. A sample migration would look like:

```ruby
enable_extension 'ltree' # ltree is not turned on by default; skip if you use the array strategy

add_column :my_table, :parent_id, :integer

add_column :my_table, :parentry, :ltree
add_column :my_table, :parentry_depth, :integer, default: 0 # optional

add_index :my_table, :parentry, using: :gist
```

```ruby
class MyTable < ApplicationRecord
  include Parentry
  parentry cache_depth: true
  # to change strategy to array, and avoid dependency on ltree
  # parentry strategy: :array
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hasghari/parentry. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org/) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

