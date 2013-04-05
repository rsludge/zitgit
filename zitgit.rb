require 'sinatra/base'
require 'grit'
require 'slim'

class Zitgit < Sinatra::Base
  get '/' do
    repo = Grit::Repo.new('')
    current_branch = Grit::Head.current(repo)
    commits = repo.commits(current_branch.name, 200)
    slim :index, :locals => { current_branch: current_branch, commits: commits }
  end

  run! if app_file == $0
end
