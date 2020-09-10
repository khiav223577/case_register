# CaseRegister

[![Gem Version](https://img.shields.io/gem/v/case_register.svg?style=flat)](http://rubygems.org/gems/case_register)
[![Build Status](https://travis-ci.com/khiav223577/case_register.svg?branch=master)](https://travis-ci.org/khiav223577/case_register)
[![RubyGems](http://img.shields.io/gem/dt/case_register.svg?style=flat)](http://rubygems.org/gems/case_register)
[![Code Climate](https://codeclimate.com/github/khiav223577/case_register/badges/gpa.svg)](https://codeclimate.com/github/khiav223577/case_register)
[![Test Coverage](https://codeclimate.com/github/khiav223577/case_register/badges/coverage.svg)](https://codeclimate.com/github/khiav223577/case_register/coverage)

Provide a design pattern to manage switch statements by mapping it to methods which are dynamically defined in advance.

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

### Define your cases

First, `include CaseRegister` in your class. Then register some cases for it by calling `register_case`. 

```rb
class MyClass
  include CaseRegister

  register_case('Foo'){ 'foo' }
  register_case('Bar'){ 'bar' }
end

instance = MyClass.new
```

### invoke the case

Use `invoke_case` method to call the registerd cases.

```rb
instance.invoke_case('Foo')
# => foo

instance.invoke_case('Bar')
# => bar

instance.invoke_case('FooBar')
# => RuntimeError (Undefined case `FooBar` for MyClass)
```

### Check available cases

Use `may_invoke_case` to check if a case exists.

```rb
instance.may_invoke_case?('Foo')
# => true

instance.may_invoke_case?('Bar')
# => true

instance.may_invoke_case?('FooBar')
# => false
```

## Use cases
### Refactor case statements

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

Or use `CaseRegister` to register cases. Then, you are able to invoke the case directly without using switch-statements. 
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

### Isolate methods

Let you have an api that allows the frontend to pass params to determetine which information it wants.

Since you have to use `send` to call the methods in user model dynamically, it will cause security issues if you do not use a whitelist to limit the methods it can access.   

```rb
class User < ApplicationRecord
  def money_info
    { value: money, rate: gain_money_rate }
  end

  def notification_info
    { msg_count: new_msgs_count, last_recieved_at: last_recieved_at }
  end
end

class UserController
  METHOD_WHITE_LIST = [:money_info, :notification_info]
 
  def refresh
    result = params[:needs].slice(METHOD_WHITE_LIST).index_with{|method| current_user.send(method)  }
    render json: result 
  end
end
```

You may use if-statements or switch-statments to call the desired method. But you will find you repeat writing similiar things and it seems redundant to have a same word appearing 3 times on the same line.

```rb
class UserController
  def refresh
    result = {}
    result[:money_info] = current_user.money_info if params[:needs][:money_info]
    result[:notification_info] = current_user.notification_info if params[:needs][:notification_info]
    # ...

    render json: result 
  end
end
```

In this case, you can use `CaseRegister` to DRYing up and isolate the methods to prevent unsafely calling `send`, which can access all the methods defined in the model.

```rb
class RefreshHelper
  include CaseRegister

  def initialize(user)
    @user = user
  end

  register_case 'money_info' do
    { value: @user.money, rate: @user.gain_money_rate }
  end

  register_case 'notification_info' do
    { msg_count: @user.new_msgs_count, last_recieved_at: @user.last_recieved_at }
  end
end

class UserController
  def refresh
    helper = RefreshHelper.new(current_user)
    result = params[:needs].index_with{|need| helper.invoke_case(need) }
    render json: result 
  end
end
```

### Check invalid cases

Sometimes, you may want to check if a case is valid or not, and return error message if not.

It can be accomplish by using `may_invoke_case?` method. See the following example:

```rb
class UserController
  def refresh
    helper = RefreshHelper.new(current_user)
    invalid_needs = params[:needs].select{|need| !helper.may_invoke_case?(need) }
    return render json: { invalid_needs: invalid_needs } if invalid_needs.any?
    # ...
  end
end
```

## Code Reuse

In case-statement, it is impossible to exec the code in other cases since there is no way to jump out of current case. We will have to move the code out and define a method, then call it in cases.

With `CaseRegister`, every case is a method, We can call it directly in one case. 

For example, if we want to define three kinds of skill: `Shock`, `Flame Shock` and `Thunder Shock`. All of them are `Shock`, the difference is that the `Flame Shock` is a `Shock` with fire effect and the `Thunder Shock` is a `Shock` with thunder effect. We would like to reuse the code in `Shock` and set fire effect for `Flame Shock` (Like Inheritance). In this case, we can reuse the code in `Shock` by calling `invoke_case('Shock')`.

```rb
class Skill
  include CaseRegister

  register_case 'Shock' do
    @debuff = Debuff::Shock.new(duration: 5.seconds)
  end

  register_case 'Flame Shock' do
    invoke_case('Shock')

    @atk_effect.set_fire_effect!
  end

  register_case 'Thunder Shock' do
    invoke_case('Shock')
    
    @atk_effect.set_thunder_effect!
  end
end
```

### Fallthrough

Case-statement in ruby doesn't have fallthrough behavior. There are many other ways you can do to simulate fallthrough behavior.

`CaseRegister` provides another way to simulate the behavior.

```js
switch(type){
  case 'A': console.log("a"); break;
  case 'B': console.log("b"); // fallthrough
  case 'C': console.log("c"); // fallthrough
  case 'D': console.log("d"); break;
}
```

```rb
class MyClass
  include CaseRegister

  register_case('A'){ p 'a' }
  register_case('B'){ p 'b'; invoke_case('C') }
  register_case('C'){ p 'c'; invoke_case('D') }
  register_case('D'){ p 'd' }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/khiav223577/case_register. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

