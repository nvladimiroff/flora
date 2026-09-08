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

## Lilac

Lilac is Flora's DSL for writing HTML. Tags are just methods named the same as the tag, and children of tags are put inside blocks.

Looking for a way to make reusable components? Write a function! For example:

```ruby
# lib/my_helpers.rb
module MyHelpers

  def cool_title(text)
    div(class: 'title') do
      h1 do
        text
      end
    end
  end

end

# _config.rb
extend_view(MyHelpers)

# index.rb
html do
  body do
    cool_title('My blog')
  end
end
```

## The Flora way

Flora is an opinionated static site generator, and you should generally follow those opinions when making a site in Flora.

### Static only

Flora will only ever generate static websites. If you need dynamic content, look elsewhere!

### A Ruby-first approach

Flora prefers Ruby and you should too. Configuration and HTML-generation code is in Ruby. Not everything makes sense as Ruby (you should write content-heavy pages in Markdown, for example), but it's the default option for solving problems in a Flora project.

### File-based routing

Flora doesn't have a routes file. Instead, requests are routed by convention based on your file's path. While this is the default, some things--like the Redirector plugin--can subvert this opinion when needed.

### Unopinionated but pluggable

Flora is a generic static site generator and doesn't favor any particular use case. Making Flora do specific things better is achieved using plugins. Flora ships with a few plugins for common use cases like blogs and handling static files.
