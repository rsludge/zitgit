# Zitgit

Simple sinatra-based web-interface to view git repository history

## Installation

Add this line to your application's Gemfile:

    gem 'zitgit'

or install from GitHub:

    gem 'zitgit', git: 'https://github.com/rsludge/zitgit.git'

And then execute:

    $ bundle install

Or install with:

    $ gem install zitgit

## Usage

Just run `zitgit` from git repo folder and view your repository history on http://localhost:5555

Or you can run it on different port with `zitgit -p <port_number>`

## Develop

Clone repository from GitHub and run `bundle install`. Launch guard to manage assets.
