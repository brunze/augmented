# Augmented

`Augmented` is a library with some core-type utility methods that I frequently find myself copying across projects. It uses refinements instead of class modification for maximum control and an easy sleep at night.

Many of the methods in `Augmented` facilitate a more functional style of programming and cover a few tiny gaps in Ruby's solid functional support.


## Installation

In your Gemfile:

```ruby
gem 'augmented'
```

Or:

    $ gem install augmented


## Usage

You have 3 ways of loading the refinements. You can load all of them at once:

```ruby
using Augmented
```

You can load all refinements for just one type:

```ruby
using Augmented::Arrays
using Augmented::Enumerators
using Augmented::Exceptions
using Augmented::Hashes
using Augmented::Modules
using Augmented::Objects
using Augmented::Procs
using Augmented::Strings
using Augmented::Symbols
# etc.
```

Or you can load just the methods you need:

```ruby
using Augmented::Objects::Pickable
using Augmented::Procs::Chainable
using Augmented::Symbols::Arguable
# etc.
```


## Quick Examples

#### `Augmented::Arrays`

##### `Array#tie`

Weaves an object between the elements of an array. Like `join` but without flattening the array into a string.

```ruby
using Augmented::Arrays::Tieable

[1, 2, 3].tie(:hello)
# [1, :hello, 2, :hello, 3]

[1, 5, 12].tie{ |a, b| a + b }
# [1, 6, 5, 17, 12]
```


#### `Augmented::Enumerators`

##### `Enumerator#index_by`

Builds an index of all elements of an enumerator according to the given criterion. Last element wins.

```ruby
using Augmented::Enumerators::Indexing

['a', 'bb', 'c', 'ddddd'].to_enum.index_by(&:length)
# {1=>"c", 2=>"bb", 5=>"ddddd"}
```


#### `Augmented::Exceptions`

##### `Exception#chain`

Returns an enumerator over the exception's causal chain, starting with the exception itself.

```ruby
using Augmented::Exceptions::Chain

begin
  begin
    begin
      raise 'first'
    rescue
      raise 'second'
    end
  rescue
    raise 'third'
  end
rescue => error
  error.chain.map(&:message)
end
# ["third", "second", "first"]
```


##### `Exception#details`, `Exception#details=`, `Exception#detailed`

Attach a hash of details to any exception.

```ruby
using Augmented::Exceptions::Detailed

exception = RuntimeError.new('oops!').detailed(foo: 10, bar: { baz: 30 })
exception.details
# {:foo=>10, :bar=>{:baz=>30}}
exception.details = { bam: 40 }
exception.details
# {:bam=>40}
```


##### `Exception#to_h`

Serializes an exception into a Hash including its backtrace, details and causal chain.

```ruby
using Augmented::Exceptions::Serializable
using Augmented::Exceptions::Detailed

begin
  begin
    raise RuntimeError.new('first').detailed(foo: 10)
  rescue
    raise RuntimeError.new('second').detailed(bar: 20)
  end
rescue => error
  error.to_h
end
# {
#   :class => "RuntimeError",
#   :message => "second",
#   :details => { :bar => 20 },
#   :backtrace => [ ... ],
#   :cause => {
#     :class => "RuntimeError",
#     :message => "first",
#     :details => { :foo => 10 },
#     :backtrace => [ ... ],
#     :cause => nil
#   }
# }
```


#### `Augmented::Hashes`

##### `Hash#map_values`

Returns a new hash with the same keys but transformed values.

```ruby
using Augmented::Hashes::Mappable

{ aa: 11, bb: 22 }.map_values{ |i| i * 3 }
# {:aa=>33, :bb=>66}
```

##### `Hash#map_keys`

Returns a new hash with the same values but transformed keys.

```ruby
using Augmented::Hashes::Mappable

{ aa: 11, bb: 22 }.map_keys{ |k| k.to_s[0] }
# {"a"=>11, "b"=>22}
```

##### `Hash#polymorph`

Creates an object from a Hash.

```ruby
using Augmented::Hashes::Polymorphable

class Sheep
  def initialize attributes
    @speak = attributes[:speak]
  end

  def speak
    puts @speak
  end
end

{ type: 'Sheep', speak: 'baaaah' }.polymorph.speak
# baaaah
```

##### `Hash#transform`, `Hash#transform!`

Recursively applies functions to a tree of hashes.

```ruby
using Augmented::Hashes::Transformable

tree = { lorem: 'ipsum', dolor: [ { sit: 10}, { sit: 20 } ] }
triple =  -> i { i * 3 }

tree.transform({ lorem: :upcase, dolor: { sit: triple } })
# {:lorem=>"IPSUM", :dolor=>[{:sit=>30}, {:sit=>60}]}
```


#### `Augmented::Modules`

##### `Module#refined`

Makes it less verbose to create small refinements.

```ruby
using Augmented::Modules::Refined

class TextPage
  using refined String,
    to_phrase: -> { self.strip.capitalize.gsub(/\.?\z/, '.') }

  # ...

  def text
    @lines.map(&:to_phrase).join(' ')
  end
end
```


#### `Augmented::Objects`

##### `Object#if`, `Object#unless`, `Object#else`

Allows you to conditionally return an object, allowing you to be more concise in some situations.

```ruby
using Augmented::Objects::Iffy

Person.new.eat(toast.if(toast.buttered?).else(muffin))
Person.new.eat(toast.if(&:buttered?).else(muffin))

Person.new.eat(toast.unless(toast.soggy?).else(muffin))
Person.new.eat(toast.unless(&:soggy?).else(muffin))
```

##### `Object#pick`

Calls a bunch of methods on an object and collects the results.

```ruby
using Augmented::Objects::Pickable

class MyThing
  def foo; 'lorem'; end
  def bar; 'ipsum'; end
  def baz; 'dolor'; end
end

MyThing.new.pick(:foo, :baz)
# {:foo=>"lorem", :baz=>"dolor"}
```

##### `Object#tack`

Appends a bunch of singleton methods to an object.

```ruby
using Augmented::Objects::Tackable

Object.new.tack(name: 'Alice', greet: -> { puts "hello I'm #{name}" }).greet
# hello I'm Alice
```

##### `Object#tap_if`, `Object#tap_unless`

Like [`tap`](http://ruby-doc.org/core-2.2.3/Object.html#method-i-tap) but only executes the block according to the condition.

```ruby
using Augmented::Objects::Tappable

toast.tap_if(toast.warm?){ |toast| toast.butter }.eat
toast.tap_if(:warm?.to_proc){ |toast| toast.butter }.eat
```

##### `Object#thru`, `Object#thru_if`, `Object#thru_unless`

Applies a function to an object and returns the result. `Object#thru_if` and `Object#thru_unless` do so depending on the condition supplied (if the condition fails, the object is returned untouched).

```ruby
using Augmented::Objects::Thru

filter_words = -> s { s.gsub(/bad/, '').squeeze(' ').strip }

'BAD WORDS, BAD WORDS'.downcase.thru(&filter_words).capitalize
# "Words, words"

config.censor = true
'BAD WORDS, BAD WORDS'.downcase.thru_if(config.censor?, &filter_words).capitalize
# "Words, words"

''.downcase.thru_unless(:empty?.to_proc, &filter_words).capitalize
# ""
```


#### `Augmented::Procs`

##### `Proc#|`

Chains several procs together so they execute from left to right.

```ruby
using Augmented::Procs::Chainable

sub_two = -> i { i - 2 }
triple = -> i { i * 3 }
add_twenty = -> i { i + 20 }

(sub_two | triple | add_twenty)[5]
# 29
```

##### `Proc#rescues`

Wraps a `Proc` to rescue it from certain exceptions while returning a given value.

```ruby
using Augmented::Procs::Rescuable

integerify = proc{ |x| Integer(x) }.rescues(ArgumentError, 42)

['1', '2', 'oops!', '4'].map(&integerify)
# [1, 2, 42, 4]
```


#### `Augmented::Strings`

##### `String#blank?`

Tests if a string is empty or made of whitespace.

```ruby
using Augmented::Strings::Blank

''.blank?
# true
' '.blank?
# true
' hello '.blank?
# false
```


##### `String#truncate`, `String#truncate!`

Returns a prefix of a string up to a given number of characters.

```ruby
using Augmented::Strings::Truncatable

'hello world'.truncate(5)
# "hello"
[(string = 'hello world'), string.truncate!(5)]
# ["hello", "hello"]
```


#### `Augmented::Symbols`

##### `Symbol#with`

Like [`Symbol#to_proc`](http://ruby-doc.org/core-2.3.0/Symbol.html#method-i-to_proc) but allows you to pass some arguments along.

```ruby
using Augmented::Symbols::Arguable

class Eleven
  def add_many *others
    11 + others.reduce(0, :+)
  end
end

:add_many.with(1, 2, 3).call(Eleven.new)
# 17
```

##### `Symbol#eq`, `Symbol#neq`, `Symbol#lt`, `Symbol#lte`, `Symbol#gt`, `Symbol#gte`

Creates functions that compare an object's attribute.

```ruby
using Augmented::Symbols::Comparing

class User
  def initialize name
    @name = name
  end
  attr_reader :name
end

users = [ User.new('Marianne'), User.new('Jeremy') ]

users.find(&:name.eq('Marianne'))
# <User:0x... @name='Marianne'>
```


## Contributing

Do you have a method you would like to see added to this library? Perhaps something you keep copying from project to project but always found too small to bother with a gem? Feel free to submit a ticket/pull request with your idea.
