# Zitgit

Simple sinatra-based web-interface to view git repository history

## Installation

Add this line to your application's Gemfile:

    gem "grit", '~> 2.5.0', git: 'https://github.com/gitlabhq/grit.git', ref: '42297cdcee16284d2e4eff23d41377f52fc28b9d'
    gem 'zitgit'

And then execute:

    $ bundle install

You can not just run gem install zitgit because it has dependencies from GitHub

## Usage

Just run `zitgit` from git repo folder
