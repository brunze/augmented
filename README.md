# Augmented

TODO: Write a gem description

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
using Augmented::Objects
using Augmented::Hashes
using Augmented::Symbols
# etc.
```

Or you can load just the method you need:

```ruby
using Augmented::Objects::Pickable
using Augmented::Symbols::Arguable
using Augmented::Procs::Chainable
# etc.
```

## Quick Examples

##### `Enumerator#index_by`

Builds an index of all elements of an enumerator according to the given criterion.

```ruby
['a', 'bb', 'ccccc'].to_enum.index_by(&:length)
# {1=>"a", 2=>"bb", 5=>"ccccc"}
```

##### `Hash#polymorph`

Creates an object from an Hash.

```ruby
class Sheep
  def initialize attributes
    @sound = attributes[:sound]
  end

  def speak
    puts @sound
  end
end

{ type: 'Sheep', sound: 'meeehh' }.polymorph.speak
# meeehh
```

##### `Hash#transform`, `Hash#transform!`

Recursively applies functions to a tree of hashes.

```ruby
tree = { lorem: 'ipsum', dolor: [ { sit: 10}, { sit: 20 } ] }
triple =  -> i { i * 3 }

tree.transform({ lorem: :upcase, dolor: { sit: triple } })
# {:lorem=>"IPSUM", :dolor=>[{:sit=>30}, {:sit=>60}]}
```

##### `Object#pick`

Calls a bunch of methods on an object and collects the results.

```ruby
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
Object.new.tack(id: 11, greet: -> { puts "hello I'm #{id}" }).greet
# hello I'm 11
```

##### `Object#thru`

Applies a function to an object and returns the result.

```ruby
filter_words = -> s { s.gsub(/bad/, '').squeeze(' ').strip }

'BAD WORDS, BAD WORDS'.downcase.thru(&filter_words).capitalize
# Words, words
```

##### `Proc#|`

Chains several procs together so they execute from left to right.

```ruby
sub_two = -> i { i - 2 }
triple = -> i { i * 3 }
add_twenty = -> i { i + 20 }

(sub_two | triple | add_twenty)[5]
# 29
```

##### `Symbol#with`

Like [`Symbol#to_proc`](http://ruby-doc.org/core-2.3.0/Symbol.html#method-i-to_proc) but allows you to pass some arguments along.

```ruby
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

1. Fork it ( https://github.com/brunze/augmented/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
