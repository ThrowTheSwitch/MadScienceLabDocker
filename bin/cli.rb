require 'thor'

module FileGeneratorTasks

  class CLI < Thor
    # Ensure we bail out with non-zero exit code if the command line is wrong
    def self.exit_on_failure?() true end

    # Intercept construction to extract configuration and injected dependencies
    def initialize(args, config, options)
      super(args, config, options)

      @handler = options[:objects][:handler]
    end

    desc "dockerfile TEMPLATE DEST", "Create a new Dockerfile from components"
    method_option :dir, :type => :string, :repeatable => true, :required => true, :desc => "Directory to inspect"
    method_option :variant, :type => :string, :required => true, :desc => "Dockerfile variant (corresponds to directory"
    method_option :debug, :type => :boolean, :default => false, :desc => "Set debug logging"
    long_desc <<-LONGDESC
    `filegen dockerfile` creates a Dockerfile from a template and contributing files.

    `filegen dockerfile` inspects each provided directory (in order) looking for files whose content will be expanded 
    in the locations within the template file referencing their contents.

    TEMPLATE is a required filepath to the source Dockerfile ERB template.

    DEST is a required output filepath for the final Dockerfile.

    Flags:

    • `--dir` lists directories to inspect (1 or more flags required).

    • `--variant` provides variant name (corresponds to a directory).

    • `--debug` optionally enables debug output (primarily stack traces).
    LONGDESC
    def dockerfile(template, dest)
      @handler.dockerfile( template, dest, options )
    end

    desc "welcome TEMPLATE DEST", "Create a welcome file from components"
    method_option :dir, :type => :string, :repeatable => true, :required => true, :desc => "Directory to inspect"
    method_option :version, :type => :string, :required => true, :desc => "Version string"
    method_option :debug, :type => :boolean, :default => false, :desc => "Set debug logging"
    long_desc <<-LONGDESC
    `filegen welcome` creates a welcome file from a template and directory contents files.

    `filegen welcome` inspects each provided directory and assembles contents (in order) from any discovered contents files.
    The collected contents are expanded within the template into a welcome file for a Docker container shell.

    TEMPLATE is a required filepath to the source welcome file ERB template.

    DEST is a required output filepath for the final welcome file.

    Flags:

    • `--dir` lists directories to inspect (1 or more flags required).

    • `--version` provides a version string for the text of the welcome file (required).

    • `--debug` optionally enables debug output (primarily stack traces).
    LONGDESC
    def welcome(template, dest)
      @handler.welcome( template, dest, options )
    end

  end

end