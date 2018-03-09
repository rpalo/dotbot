module Dotty
  class DottyError < StandardError; 
    def initialize(message=nil)
      STDERR.puts help_text(message)
      super
    end

    def help_text(message=nil)
      "A generic Dotty Error has occurred."
    end
  end

  class NoConfigError < DottyError
    def help_text(message=nil)
      <<~HEREDOC
        💀  No configuration found!  💀
        -----------------------

        Dotty looks for configuration first in ~/.dotty.  This is a YAML
        file.  See the docs for more info.  If no ~/.dotty is found,
        it also looks for environment variables starting with DOTTY, such
        as DOTTY_DIR.

      HEREDOC
    end
  end

  class DoesNotExistError < DottyError
    def help_text(filename)
      <<~HEREDOC
        💀  Target file not found!  💀
        -----------------------

        It looks like #{filename} couldn't be found.

      HEREDOC
    end
  end

  class GitError < DottyError
    def help_text(message=nil)
      <<~HEREDOC
        💀  Git experienced an issue  💀
        ----------------------------

        For some reason git was unable to complete the '#{message}' operation.
        Make sure your configured Dotty directory is a git repo that has
        a remote configured.  Make sure you can git push and git pull from
        that directory before running '#{message}' again.
      
      HEREDOC
    end
  end
end
