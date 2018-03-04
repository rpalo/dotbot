require "fileutils"

# Dotfile tracker
module Dotty
  def self.track(filepath, force: nil, noop: nil, verbose: nil)
    original_full_path = File.expand_path(filepath)
    dotty_dir = File.expand_path(ENV["DOTTY_DIR"])
    FileUtils.cp(original_full_path, dotty_dir, noop: noop, verbose: verbose)
    FileUtils.rm(original_full_path, force: force, noop: noop, verbose: verbose)
    new_full_path = File.join(dotty_dir, File.basename(filepath))
    FileUtils.ln_s(new_full_path, original_full_path,
                   force: force,
                   noop: noop,
                   verbose: verbose
    )
    puts "👾  : #{filepath} is now tracked!"
  end
end
