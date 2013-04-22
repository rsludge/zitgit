require_relative "zitgit/version"
require 'bundler'
Dir.chdir(File.dirname(__FILE__)) do
  Bundler.setup
end
require 'sinatra/base'
require 'grit'
require 'slim'

module Zitgit
  class Zitgit < Sinatra::Base
    configure do
      set :root, File.expand_path('..', File.dirname(__FILE__))
    end

    helpers do
      def heads(commit)
        repo = Grit::Repo.new('.')
        repo.heads.select{|head| head.commit.id == commit.id}
      end

      def remotes(commit)
        repo = Grit::Repo.new('.')
        repo.remotes.select{|head| head.commit.id == commit.id}
      end

      def tags(commit)
        repo = Grit::Repo.new('.')
        repo.tags.select{|head| head.commit.id == commit.id}
      end
    end

    get '/' do
      repo = Grit::Repo.new('.')
      current_branch = Grit::Head.current(repo)
      commits = repo.commits(current_branch.name, 200)
      repo_name = File.basename(repo.working_dir)
      @branches = repo.heads    
      @remotes = repo.remotes
      @tags = repo.tags
      slim :index, :locals => { 
        current_branch: current_branch, 
        commits: commits, 
        repo_name: repo_name,
        last_commit: commits[0]
      }
    end

    get "/ref/:ref_name" do |ref_name|
      repo = Grit::Repo.new('')
      commits = repo.commits(ref_name, 200)
      slim :branch, :locals => { commits: commits }, :layout => false
    end

    run! if app_file == $0
  end
end
