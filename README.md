# YAKC: Yet another Kafka (0.8) consumer

YAKC is a generic Kavka 0.8 consumer based on the now-dead Poseidon (i know, i know). It will listen to as many topics as you specify and hand them off via the handler to consumer classes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yakc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yakc

## Usage

There are 2 main componets:

### Message Handler

This is the bit of code that handles what to do with the messages once they are received. You can write your own, but the default one translates and broadcasts them using an AvroTranslator and the in-process [Yeller](/gaorlov/yeller) gem.

To set it up:

```ruby
  handler = YAKC::MessageBroadcaster.new pubsub: MyBroadcaster, translator: MyTranslator
  # or, if you are okay with my defaults
  handler = YAKC::MessageBroadcaster.new
```

And now you're ready to init the [reader](#reader)


#### Broadcaster Interface

The broadcaster interface is pretty simple: it has to respond to `broadcast message, topic)`. See [the default broadcaster](/gaorlov/yakc/lib/yack/message_broadcaster.rb) for reference

#### Translator Interface

The translator is brick simple: It is a class with one self method you have to define: `handle( message )`. See [the avro translator](/gaorlov/yakc/lib/yack/translator/avro_translator.rb) for reference.

### Reader





## Setup

You will need to set up your message handler and a translator(there's already one you can use: Avro)

It's pretty straight forward:



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gaorlov/yakc.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

