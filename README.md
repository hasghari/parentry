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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hasghari/parentry. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

