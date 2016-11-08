# Augmented

`Augmented` is a library with some core-type utility methods that I frequently find myself copying across projects. It uses refinements instead of class modification for maximum control and an easy sleep at night.

Many of the methods in `Augmented` facilitate a more functional style of programming and cover a few tiny gaps in Ruby's solid functional support. See more thoughts on this [blog post](http://blog.brunze.com/2015/using-ruby-refinements-fun-flow/).


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
using Augmented::Hashes
using Augmented::Modules
using Augmented::Objects
using Augmented::Procs
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

[1, 2, 3].tie :hello
# [1, :hello, 2, :hello, 3]

[1, 5, 12].tie{ |a, b| a + b }
# [1, 6, 5, 17, 12]
```


#### `Augmented::Enumerators`

##### `Enumerator#index_by`

Builds an index of all elements of an enumerator according to the given criterion.

```ruby
using Augmented::Enumerators::Indexing

['a', 'bb', 'ccccc'].to_enum.index_by(&:length)
# {1=>"a", 2=>"bb", 5=>"ccccc"}
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
using Augmented::Hashes::Transformable

class TextPage
  using refined String,
    as_phrase: -> { self.strip.capitalize.gsub /\.?\z/, '.' },
    fill:      -> filler { (filler * self.length)[0..length] }

  # ...

  def text
    @strings.map(&:as_phrase).join ' '
  end

  def obscured_text
    text.fill '?'
  end
end
```


#### `Augmented::Objects`

##### `Object#if`, `Object#unless`, `Object#else`

Allows you to conditionally return an object, allowing you to be more concise in some situations.

```ruby
using Augmented::Objects::Iffy

Person.new.eat toast.if(toast.buttered?).else(muffin)
Person.new.eat toast.if(&:buttered?).else(muffin)

Person.new.eat toast.unless(toast.soggy?).else(muffin)
Person.new.eat toast.unless(&:soggy?).else(muffin)
```

##### `Object#pick`

Calls a bunch of methods on an object and collects the results.

```ruby
using Augmented::Objects::Pickable

class MyThing
  def lorem; 'hello'; end
  def ipsum; 'cruel'; end
  def dolor; 'world'; end
end

MyThing.new.pick :lorem, :dolor
# {:lorem=>"hello", :dolor=>"world"}
```

##### `Object#tack`

Appends a bunch of singleton methods to an object.

```ruby
using Augmented::Objects::Tackable

Object.new.tack(id: 11, greet: -> { puts "hello I'm #{id}" }).greet
# hello I'm 11
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

users.find &(:name.eq 'Marianne')
# <User:0x... name='Marianne'>
```


## Contributing

Do you have a method you would like to see added to this library? Perhaps something you keep copying from project to project but always found too small to bother with a gem? Feel free to submit a ticket/pull request with your idea.
