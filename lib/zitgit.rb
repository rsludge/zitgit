require_relative "zitgit/version"
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

      def strip_message(text, length)
        text.length > length ? text[0, length] + '...' : text
      end

      def merge_commit?(commit)
        commit.parents.count > 1
      end

      def is_head_ref(ref)
        ref.name.split('/').index('HEAD')
      end

      def summ_line(line)
        line.match(/@@\s+-([^\s]+)\s+\+([^\s]+)\s+@@/)
        [Regexp.last_match(1), Regexp.last_match(2)].map{|item|
          parts = item.split(',')
          if parts.count == 2
            parts[0] + '-' + (parts[0].to_i + parts[1].to_i).to_s
          else
            item
          end
        }.join(' -> ')
      end
    end

    get '/' do
      repo = Grit::Repo.new('.')
      @current_branch = Grit::Head.current(repo)
      @commits = repo.commits(@current_branch.name, 200)
      @last_commit = @commits[0]
      @repo_name = File.basename(repo.working_dir)
      @branches = repo.heads    
      @remotes = repo.remotes
      @tags = repo.tags
      @index = repo.index
      slim :index
    end

    get "/ref/:ref_name" do |ref_name|
      repo = Grit::Repo.new('')
      commits = repo.commits(ref_name, 200)
      slim :branch, :locals => { commits: commits }, :layout => false
    end

    run! if app_file == $0
  end
end
