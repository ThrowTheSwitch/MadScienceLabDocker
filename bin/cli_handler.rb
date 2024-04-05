require 'yaml'
require 'erb'
require 'fileutils'

module DockerGeneratorTasks

  class Handler

    FILENAME_PACKAGES = 'packages.yml'
    FILENAME_CONTENTS = 'contents.yml'
    FILENAME_SETUP_BLOCKS = 'Dockerfile-setup'
    FILENAME_ASSET_BLOCKS = 'Dockerfile-assets'
    FILENAME_BUILD_BLOCKS = 'Dockerfile-build'
    FILENAME_USER_BLOCKS = 'Dockerfile-user'

    def initialize(objects)
      @dockerfile_data = objects[:dockerfile_data]
    end

    def dockerfile(template, dest, options)
      set_debug( options[:debug] )

      puts ( 'Generating Dockerfile...' )

      dirs = options[:dir]

      # Validate directories
      dirs.each do |dir|
        raise "Directory '#{dir}' not found" if !File.directory?( dir )
      end

      @dockerfile_data.variant = options[:variant]

      # Process all components in batches across all directories
      ingest_setup_blocks( dirs, FILENAME_SETUP_BLOCKS )
      ingest_packages( dirs, FILENAME_PACKAGES )
      ingest_asset_blocks( dirs, FILENAME_ASSET_BLOCKS )
      ingest_build_blocks( dirs, FILENAME_BUILD_BLOCKS )
      ingest_user_blocks( dirs, FILENAME_USER_BLOCKS )

      template = ERB.new( File.read( template ), trim_mode:'<>-' )

      FileUtils.mkdir_p( File.dirname( dest ) )

      File.write(
        dest,
        template.result( @dockerfile_data.get_binding() ),
        mode:'w'
      )

      puts( "📦 Wrote Dockerfile to #{dest}" )
    end


    def welcome(template, dest, options)
      set_debug( options[:debug] )

      puts ( 'Generating welcome file...' )

      dirs = options[:dir]

      version = options[:version]
      @version = ''
      if !version.empty?
        @version = "v#{version}" if !(version =~ /latest/i)
      end

      # Validate directories
      dirs.each do |dir|
        raise "Directory '#{dir}' not found" if !File.directory?( dir )
      end

      @contents = []

      msg = 'welcome file contents'

      ingest_components(
        dirs, FILENAME_CONTENTS, msg ) { |filepath|
          @contents += YAML.load( File.read( filepath ) )
        }

      template = ERB.new( File.read( template ), trim_mode:'<>-' )

      FileUtils.mkdir_p( File.dirname( dest ) )

      File.write(
        dest,
        template.result( binding ),
        mode:'w'
      )

      puts( "👋 Wrote welcome file to #{dest}" )
    end

    ### Private ###

    private

    def set_debug(debug)
      # Create global constant PROJECT_DEBUG
      Object.module_eval("PROJECT_DEBUG = debug")
      PROJECT_DEBUG.freeze()
    end

    def ingest_setup_blocks(dirs, filename)
      ingest_components(
        dirs, filename, 'setup handling blocks' ) { |filepath|
          @dockerfile_data.add_setup_block( File.read( filepath ) )
        }
    end

    def ingest_packages(dirs, filename)
      ingest_components(
        dirs, filename, 'packages to add to image' ) { |filepath|
          @dockerfile_data.add_packages( YAML.load( File.read( filepath ) ) )
        }
    end

    def ingest_asset_blocks(dirs, filename)
      ingest_components(
        dirs, filename, 'asset handling blocks' ) { |filepath|
          @dockerfile_data.add_asset_block( File.read( filepath ) )
        }
    end

    def ingest_build_blocks(dirs, filename)
      ingest_components(
        dirs, filename, 'build & installation handling blocks' ) { |filepath|
          @dockerfile_data.add_build_block( File.read( filepath ) )
        }
    end

    def ingest_user_blocks(dirs, filename)
      ingest_components(
        dirs, filename, 'user account handling blocks' ) { |filepath|
          @dockerfile_data.add_user_block( File.read( filepath ) )
        }
    end

    def ingest_components(dirs, filename, msg, &block)
      dirs.each do |dir|
        filepath = File.join( dir, filename )

        if File.exist?( filepath )
          block.call(filepath)
          puts ( "+ Ingested #{msg} from #{dir}/" )
        end
      end
    end

  end

end
