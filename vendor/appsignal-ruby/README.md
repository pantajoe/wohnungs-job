# Appsignal

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/appsignal`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'appsignal'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install appsignal

## Usage

Build an 'Appsignal'-Client with an App-ID from your App at Appsinal, from which you wish to receive
performance data.

    appsignal = Appsignal::Client.build(app_id: 'your_app_id',
                                        token: 'your_authentication_token')

After this, you can run this command to get your performance data:

    appsignal.graphs.data

  Optional Parameters:

    action_name:  Here you can specify a certain action of your app, for which you only get the data.

                    e.g. 'ActionController#index'

    exception:    If you have specified an action_name, you can also specify an exception for your action.

                    e.g. 'Mongoid::RecordNotFound'

    from/to:      You can either specify from and/or to timestamps or the timeframe parameter.
                  If you do not specify any, the default value for timestamp is "month".
                  For for and time, you can use any Date/DateTime/Time Object.
                  The timeframe parameter can be "hour" / "day" / "month" / "year".

    fields:       This parameter is an array containing all the data, you want to receive.
                  It can be ['mean', 'count', 'ex', 'ex_rate', 'pct'].
                  If you do not specify this, its default is ['mean', 'count', 'ex', 'ex_rate'].

                    'mean' is the mean response time

                    'count' is the number of requests

                    'ex' is the number of errors

                    'ex_rate' is the exception rate (percentage of exceptions from count)

                    'pct' is the 90 percentile (for slow requests only)

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/appsignal.
