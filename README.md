# YAKC: Yet another Kafka (0.8) consumer

YAKC is a generic Kavka 0.8 consumer based on the now-dead Poseidon (i know, i know). It will listen to as many topics as you specify and hand them off via a handler to consumer classes.

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

This is the bit of code that handles what to do with the messages once they are received. There are 2 stages to this process:

1. The message is parsed using *your* message parser(inherited from the `YAKC::Message` class) that does the parsing and validity checking. 
2. The parsed message payload is broadcast to the system. You can specify your own publisher, but by default the handler will use [Yeller](http://www.github.com/gaorlov/yeller). It will broadcast 2 messages: "topic::event", and "topic::*"

To set it up:

```ruby
  handler = YAKC::MessageBroadcaster.new publisher: MyBroadcaster, message_class: MyMessageClass
  # or, if you are okay with Yeller
  handler = YAKC::MessageBroadcaster.new message_class: MyMessageClass
```

And now you're ready to init the [reader](#reader)

#### Publisher Interface

If you don't like Yeller, or want something that can talk cross-process, you can implement your own.

The publisher interface is pretty simple: it has to implement
* `broadcast( message, topic )` : This is the function that handles where the messages go.
 
#### Message Interface

The message parser needs to implement:

1. `parse( raw_message )` : This converts the raw Kafka data to the format of your choice
2. `broadcastable?` : This determines whether the message is valid and shoud be broadcast.
3: `event` : The name of the picked up event. This is the name that gets broadcast 

For example if your messages are encoded in Avro and look loosely like:
```json
{ "event": {"name":"myEventName",
            "timestamp":"00:00:00:12/12/12"}},
  "my_field":"value",
  // etc
}
```

Your message parser class would look something like

```ruby
class AvroMessage < YAKC::Message
  
  def broadcastable?
    # an event is probably okay to transmit if we can extract its name
    event["name"]
  end

  def event
    @payload["event"] || {}
  end

  protected

  def parse( message )
    data = StringIO.new(message.value)
    msg = Avro::DataFile::Reader.new(data, Avro::IO::DatumReader.new)
    
  rescue Avro::DataFile::DataFileError => e
    Rails.logger.error e
    {}
  end
end

```


### Reader

The reader does(surprise) the reading and pushes the read rad messages to the handler, which you have to specify.

It implements:

* `read` : an infinite loop that consumes messages on all the specified topics (see [setup](#setup) below) and sends them to the handler

Here's how you would use it:

```ruby
  handler = YAKC::MessageBroadcaster.new message_class: AvroMessage
  reader = YAKC::Reader.new message_handler: handler

  reader.read
```

## Setup

And now for the full setup. You will need to specify the `zookeepers`; the Kafka `brokers`; the `app` and `suffix`, which are used to generate the consumer group name; the topic list; and a logger. 

There are 2 ways of doing this. You can either set those up as ENV vars ("ZOOKEEPERS"(comma separated list), "BROKERS"(comma separated list), "APP", "SUFFIX", "TOPICS") and set up the logger by hand, or, you can do it in ruby, like:

```ruby
  YAKC.configure do |config|
    config.logger     = Rails.logger
    config.zookeepers = ["localhost:9092"]
    config.brokers    = ["localhost:2181"]
    config.app        = "MyApp"
    config.suffix     = Rails.env
    config.topics     = ["clickstream", "logs", "exceptions"] # whatever you're listening for
  end
```

## Example

Here's what a full experience would look like:

The reader would look like
```ruby
  # in your initializer
  YAKC.configure do |config|
    # we'll assume the rest are set up in the env
    config.logger     = Rails.logger
  end
```

In your reader job

```ruby
  handler = YAKC::MessageBroadcaster.new message_class: AvroMessage
  reader = YAKC::Reader.new message_handler: handler

  reader.read
```

And the consumers would listen to the events

Let's say you have an app that listens to exceptions that we pass around in kafka. It then stores them in a DB and passesthem off to Honeybadger. Your `Exception` model could do something like

```ruby
class Exception < ActiveRecord::Base
  include Yaller::Subscribable

  # we don't care about the event type, so we subscribe to "exception::*"
  subscribe with: :from_kafka_event, to: "exception::*"

  def self.from_kafka_event( message )
    create message
    Honeybadger.notify message
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gaorlov/yakc.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

