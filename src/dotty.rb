require "fileutils"

require_relative "errors"

# Dotfile tracker
module Dotty
  def self.track(filepath, config, git)
    original_full_path = File.expand_path(filepath)
    raise DoesNotExistError.new(filepath) unless File.exist?(original_full_path)

    dotty_dir = File.expand_path(config.dir)
    FileUtils.cp(original_full_path, dotty_dir)
    FileUtils.rm(original_full_path)
    new_full_path = File.join(dotty_dir, File.basename(filepath))
    FileUtils.ln_s(new_full_path, original_full_path)

    if git
      Dir.chdir(config.dir)
      `git add #{new_full_path}`
      `git commit -m "Dotty added #{File.basename(filepath)} to the repo"`
      `git push`
    end

    raise GitError.new("track") unless $? == 0

    puts "👾  : #{filepath} is now tracked!"
  end

  def self.update(config)
    dotty_dir = File.expand_path(config.dir)
    Dir.chdir(dotty_dir)
    `git pull`
    raise GitError.new("update") unless $? == 0
    puts "👾  : Dotfiles updated!"
  end
end
