require "thor"
require "yaml"

require "dotbot/config"
require "dotbot"

module Dotbot
  # CLI for Dotty
  class CLI < Thor
    def self.start(args)
      @@config = get_config
      super
    rescue DotbotError => err
      exit(1)
    end

    def self.get_config
      dotfile = File.join(ENV["HOME"], ".dotbot")
      if File.exist?(dotfile)
        contents = YAML.load_from_file(dotfile)
        Config.new(contents["dir"])
      elsif ENV["DOTBOT_DIR"]
        Config.new(ENV["DOTBOT_DIR"])
      else
        raise NoConfigError.new
      end
    end

    desc "track FILE", "Add FILE to Dotbot's repo"
    option :git, type: :boolean
    def track(filepath)
      Dotbot::track(filepath, @@config, options[:git])
    end

    desc "update", "Update's Dotbot's repo"
    def update
      Dotbot::update(@@config)
    end
  end
end