require_relative "zitgit/version"
require 'bundler'
Bundler.setup
require 'sinatra/base'
require 'grit'
require 'slim'
require 'zurb-foundation'
require 'compass'

module Zitgit
  class Zitgit < Sinatra::Base
    configure do
      set :scss, Compass.sass_engine_options
      set :views, ['views', 'scss']
    end

    helpers do
      def find_template(views, name, engine, &block)
        views.each { |v| super(v, name, engine, &block) }
      end
    end

    get '/' do
      repo = Grit::Repo.new('/home/2_2_28/site_htc_meetup')
      current_branch = Grit::Head.current(repo)
      commits = repo.commits(current_branch.name, 200)
      repo_name = File.basename(repo.working_dir)
      branches = repo.heads    
      slim :index, :locals => { 
        current_branch: current_branch, 
        commits: commits, 
        repo_name: repo_name,
        branches: branches,
        last_commit: commits[0]
      }
    end

    get "/branch/:branch_name" do |branch_name|
      repo = Grit::Repo.new('')
      commits = repo.commits(branch_name, 200)
      slim :branch, :locals => { commits: commits }, :layout => false
    end

    get "/stylesheets/*.css" do |path|
      content_type "text/css", charset: "utf-8"
      scss :"#{path}"
    end

    run! if app_file == $0
  end
end
