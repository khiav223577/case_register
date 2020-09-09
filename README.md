# CaseRegister

[![Gem Version](https://img.shields.io/gem/v/case_register.svg?style=flat)](http://rubygems.org/gems/case_register)
[![Build Status](https://travis-ci.com/khiav223577/case_register.svg?branch=master)](https://travis-ci.org/khiav223577/case_register)
[![RubyGems](http://img.shields.io/gem/dt/case_register.svg?style=flat)](http://rubygems.org/gems/case_register)
[![Code Climate](https://codeclimate.com/github/khiav223577/case_register/badges/gpa.svg)](https://codeclimate.com/github/khiav223577/case_register)
[![Test Coverage](https://codeclimate.com/github/khiav223577/case_register/badges/coverage.svg)](https://codeclimate.com/github/khiav223577/case_register/coverage)

## Supports
- Ruby 1.8 ~ 2.7

## Installation

```ruby
gem 'case_register'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install case_register

## Usage

### Refactoring case statements

Take the examples from this [article](http://bobnadler.com/articles/2010/08/02/refactoring-case-statements-in-ruby.html). Let you have a method like this:

```rb
def output(data, format)
  case format
  when :html
    return "<p>#{data}</p>"
  when :text
    return data
  when :pdf
    return "<pdf>#{data}</pdf>" # pseudocode -- obviously not valid PDF output
  else
    raise ArgumentError, "Invalid format (#{format})."
  end
end

output('Hi', :html)
# => "<p>Hi</p>"
```

You can refactor it by using a hash table to map the input, like what the article says.

Or use `CaseRegister` to register cases. Then, you are able to invoke the case directly without using switch statements. 
```rb
class MyFormatter
  include CaseRegister

  def initialize(text)
    @text = text
  end

  register_case(:pdf){ "<pdf>#{@text}</pdf>" }
  register_case(:text){ @text }
  register_case(:html){ "<p>#{@text}</p>" }
end

MyFormatter.new('Hi').invoke_case(:html)
# => "<p>Hi</p>"
``` 



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/khiav223577/case_register. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

