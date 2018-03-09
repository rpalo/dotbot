# All the custom errors for this dotfile manager
module Dotbot
  class DotbotError < StandardError; 
    def initialize(message=nil)
      STDERR.puts help_text(message)
      super
    end

    def help_text(message=nil)
      "A generic Dotbot Error has occurred."
    end
  end

  class NoConfigError < DotbotError
    def help_text(message=nil)
      <<~HEREDOC
        💀  No configuration found!  💀
        -----------------------

        Dotbot looks for configuration first in ~/.dotbot.  This is a YAML
        file.  See the docs for more info.  If no ~/.dotbot is found,
        it also looks for environment variables starting with DOTBOT, such
        as DOTBOT_DIR.

      HEREDOC
    end
  end

  class DoesNotExistError < DotbotError
    def help_text(filename)
      <<~HEREDOC
        💀  Target file not found!  💀
        -----------------------

        It looks like #{filename} couldn't be found.

      HEREDOC
    end
  end

  class GitError < DotbotError
    def help_text(message=nil)
      <<~HEREDOC
        💀  Git experienced an issue  💀
        ----------------------------

        For some reason git was unable to complete the '#{message}' operation.
        Make sure your configured Dotbot directory is a git repo that has
        a remote configured.  Make sure you can git push and git pull from
        that directory before running '#{message}' again.
      
      HEREDOC
    end
  end
end
