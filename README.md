# Flora

A static site generator.

## Quickstart

Make a new directory with a Gemfile that looks like this:

```ruby
source "https://rubygems.org"

gem 'flora'
```

Make a new `index.rb` file that looks like this:

```ruby
html do
  body do
    h1 do
      'Hello world!'
    end
  end
end
```

Install everything with `bundle install`, and then run `bundle exec flora serve` and open up http://localhost:3000!
