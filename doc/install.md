# Installation

To run this application you need at least:

* Bundler
* Ruby 2.5.1
* Postgresql 9.3


## Getting started

1. Checkout master branch `git clone git@github.com:zweitag/hosting-reporter.git`
2. `cd hosting-reporter`
3. Run `bundle`
4. Copy .env.development.sample to .env.development and customize
5. Copy .env.test.sample to .env.test and customize
6. Run `bin/rake db:create:all`
8. Run `bin/rake db:migrate`
9. Run `bin/rake db:migrate RAILS_ENV=test`
10. Run `bin/rake db:seed`
11. Start development server `bin/rails s`

Further steps:

* `bin/rspec` to check if everything works
* `guard` for continuous testing

## Environment

This project uses environment variables for configuration. Have a look at the [`.env.development.sample`](.env.development.sample) to get some clues. See http://12factor.net/config for a rationale.
