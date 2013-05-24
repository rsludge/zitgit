module GitHelpers
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

  def merge_commit?(commit)
    commit.parents.count > 1
  end

  def large_commit?(commit)
    commit.diffs.count > 20
  end

  def large_diff?(diff)
    diff.diff.lines.count > 200
  end

  def is_head_ref(ref)
    ref.name.split('/').index('HEAD')
  end

  def is_image(diff)
    image_exts = ['.jpg', '.jpeg', '.png', '.gif']
    image_exts.include?(File.extname(diff.a_path)) or image_exts.include?(File.extname(diff.b_path))
  end
end
