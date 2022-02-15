```
  _________ __          __  .__
 /   _____//  |______ _/  |_|__| ________ __   ____
 \_____  \\   __\__  \\   __\  |/ ____/  |  \_/ __ \
 /        \|  |  / __ \|  | |  < <_|  |  |  /\  ___/
/_______  /|__| (____  /__| |__|\__   |____/  \___  >
        \/           \/            |__|           \/
```

# Statique

![Ruby](https://github.com/pusewicz/statique/actions/workflows/main.yml/badge.svg)
[![Gem Version](https://badge.fury.io/rb/statique.svg)](https://badge.fury.io/rb/statique)

Statique is a static site generator written in [Ruby](https://www.ruby-lang.org/) and utilising [Roda](https://roda.jeremyevans.net/) for the Rack middleware. By default, it comes with support for [Slim](http://slim-lang.com/) and [Markdown](https://daringfireball.net/projects/markdown/).

## Installation

Install it as a [Whalebrew](https://github.com/whalebrew/whalebrew) package (recommended):

    $ whalebrew install pusewicz/statique

Install it as a Docker image:

    $ docker pull pusewicz/statique

Install it as a Ruby gem:

    $ gem install statique

## Usage

### Generate your new Statique website

#### Whalebrew package, Ruby gem

    $ statique init my-website

#### Docker

    $ docker run -it --rm -v "$PWD":/workdir -w /workdir pusewicz/statique init my-website

### Start the Statique server

First, change into your new Statique website directory:

    $ cd my-website

#### Whalebrew package, Ruby gem

    $ statique server

#### Docker

    $ docker run -it --rm -p 3000:3000 -v "$PWD":/workdir -w /workdir pusewicz/statique server

### Build your Statique website

The final step before deploying your website to your preferred host is to build it. By default, the built website will be available in the `dist/` subdirectory.

First, change into your new Statique website directory:

    $ cd my-website

#### Whalebrew package, Ruby gem

    $ statique build

#### Docker

    $ docker run -it --rm -v "$PWD":/workdir -w /workdir pusewicz/statique build

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pusewicz/statique. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pusewicz/statique/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Statique project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pusewicz/statique/blob/main/CODE_OF_CONDUCT.md).
