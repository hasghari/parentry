[![Build Status](https://travis-ci.org/hasghari/parentry.svg?branch=master)](https://travis-ci.org/hasghari/parentry)

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

This gem requires 2 columns for each table: `parentry` and `parent_id`. A sample migration would look like:

```ruby
add_column :my_table, :parentry, :ltree
add_column :my_table, :parent_id, :integer
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hasghari/parentry. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org/) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

