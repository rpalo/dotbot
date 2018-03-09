require "thor"
require "yaml"

require_relative "config"
require_relative "dotty"

module Dotty
  # CLI for Dotty
  class CLI < Thor
    def self.start(args)
      @@config = get_config
      super
    rescue DottyError => err
      exit(1)
    end

    def self.get_config
      dotfile = File.join(ENV["HOME"], ".dotty")
      if File.exist?(dotfile)
        contents = YAML.load_from_file(dotfile)
        Config.new(contents["dir"])
      elsif ENV["DOTTY_DIR"]
        Config.new(ENV["DOTTY_DIR"])
      else
        raise NoConfigError.new
      end
    end

    desc "track FILE", "Add FILE to Dotty's repo"
    option :git, type: :boolean
    def track(filepath)
      Dotty::track(filepath, @@config, options[:git])
    end

    desc "update", "Update's Dotty's repo"
    def update
      Dotty::update(@@config)
    end
  end
end