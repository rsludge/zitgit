require 'sinatra/base'
require 'grit'
require 'slim'
require 'zurb-foundation'
require 'compass'

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
    repo = Grit::Repo.new('')
    current_branch = Grit::Head.current(repo)
    commits = repo.commits(current_branch.name, 200)
    repo_name = File.basename(repo.working_dir)
    slim :index, :locals => { current_branch: current_branch, commits: commits, repo_name: repo_name }
  end

  get "/stylesheets/*.css" do |path|
    content_type "text/css", charset: "utf-8"
    scss :"#{path}"
  end

  run! if app_file == $0
end
