Statique is a static site generator written in [Ruby](https://www.ruby-lang.org/) and uses [Roda](https://roda.jeremyevans.net/) for the Rack middleware. By default, it comes with support for [Slim](http://slim-lang.com/) and [Markdown](https://daringfireball.net/projects/markdown/).

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

### Build your Statique website

The final step before deploying your website to your preferred host is to build it. By default, the built website will be available in the `dist/` subdirectory.

First, change into your new Statique website directory:

    $ cd my-website

#### Whalebrew package, Ruby gem

    $ statique build

#### Docker

    $ docker run -it --rm -v "$PWD":/workdir -w /workdir pusewicz/statique build
