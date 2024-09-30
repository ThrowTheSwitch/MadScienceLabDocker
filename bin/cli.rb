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

    desc "welcome TEMPLATE WELCOMEFILE_PATH", "Create a welcome file from components"
    method_option :dir, :type => :string, :repeatable => true, :required => true, :desc => "Directory to inspect"
    method_option :debug, :type => :boolean, :default => false, :desc => "Set debug logging"
    long_desc <<-LONGDESC
    `filegen welcome` creates a welcome file from a template and directory contents files.

    `filegen welcome` inspects each provided directory and assembles contents (in order) from any discovered contents files.
    The collected contents are expanded within the template into a welcome file for a Docker container shell.

    WELCOMEFILE_PATH is a required filepath to the source welcome file ERB template.

    DEST is a required output filepath for the final welcome file.

    Flags:

    • `--dir` lists directories to inspect (1 or more flags required).

    • `--debug` optionally enables debug output (primarily stack traces).
    LONGDESC
    def welcome(template, welcomefile_path)
      @handler.welcome( template, welcomefile_path, options )
    end

    desc "dockerfile TEMPLATE DOCKERFILE_PATH", "Create a new Dockerfile from components"
    method_option :dir, :type => :string, :repeatable => true, :required => true, :desc => "Directory to inspect"
    method_option :version, :type => :string, :required => true, :desc => "Version string (Docker image tag)"
    method_option :variant, :type => :string, :required => false, :default => "", :desc => "Docker image variant"
    method_option :debug, :type => :boolean, :default => false, :desc => "Set debug logging"
    long_desc <<-LONGDESC
    `filegen dockerfile` creates a Dockerfile from a template and contributing files.

    `filegen dockerfile` inspects each provided directory (in order) looking for files whose content will be
    expanded within the template file referencing their contents. The final path in this list is the home of
    the variant being assembled. Earlier paths are contributors to the final output.

    TEMPLATE is a required filepath to the source Dockerfile ERB template.

    DOCKERFILE_PATH is a required output filepath for the generated Dockerfile.

    Flags:

    • `--dir` lists directories to inspect (1 or more flags required).

    • `--variant` provides the Docker image variant name.

    • `--version` provides version (Docker image tag).

    • `--debug` optionally enables debug output (primarily stack traces).
    LONGDESC
    def dockerfile(template, dockerfile_path)
      @handler.dockerfile( template, dockerfile_path, options )
    end

  end

end