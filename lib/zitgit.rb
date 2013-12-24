require_relative 'zitgit/version'
require_relative 'zitgit/helpers/views'
require_relative 'zitgit/helpers/git'
require 'grit'
require_relative 'grit/status'
require 'sinatra/base'
require 'slim'
require 'base64'

module Zitgit
  class Zitgit < Sinatra::Base
    configure do
      set :server, :puma
      set :root, File.expand_path('..', File.dirname(__FILE__))
    end
    helpers ViewsHelpers
    helpers GitHelpers

    get '/' do
      @repo = Grit::Repo.new('.')
      @current_branch = Grit::Head.current(@repo)
      @commits = @repo.commits(@current_branch.name, 200)
      @last_commit = @commits[0]
      @repo_name = File.basename(@repo.working_dir)
      @branches = @repo.heads    
      @remotes = @repo.remotes
      @tags = @repo.tags
      @index = @repo.index
      slim :index
    end

    get "/ref/:ref_name" do |ref_name|
      @repo = Grit::Repo.new('.')
      commits = @repo.commits(ref_name, 200)
      slim :branch, :locals => { commits: commits }, :layout => false
    end

    get "/status/" do
      @repo = Grit::Repo.new('.')
      slim :'status/list', :locals => {repo: @repo}, :layout => false
    end

    get "/diff/:sha/:blob_type/:blob_id" do |sha, blob_type, blob_id|
      @repo = Grit::Repo.new('.')
      @diff = @repo.commit(sha).diffs.select{|diff| diff.send(blob_type) and diff.send(blob_type).id == blob_id}.first
      slim :'diffs/text', :locals => {diff: @diff}, :layout => false
    end

    get "/commit/:sha" do |sha|
      @repo = Grit::Repo.new('.')
      @commit = @repo.commit(sha)
      slim :'diffs/list', :locals => {diffs: @commit.diffs, commit: @commit}, :layout => false
    end

    run! if app_file == $0
  end
end
