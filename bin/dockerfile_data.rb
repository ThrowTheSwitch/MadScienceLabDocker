
# Dockerfile template data class.
class DockerfileData

  attr_accessor :variant

  def initialize()
    @setup = []
    @packages = []
    @assets = []
    @build = []
    @user = []

    @variant = ''
  end

  def add_setup_block( block )
    @setup << block_strip( block )
  end

  def add_packages( packages )
    @packages += packages
    @packages.sort!
    @packages.uniq!
  end

  def add_asset_block( block )
    @assets << block_strip( block )
  end

  def add_build_block( block )
    @build << block_strip( block )
  end

  def add_user_block( block )
    @user << block_strip( block )
  end

  # Support templating of member data.
  def get_binding
    binding
  end

  ### Private ###

  private

  def block_strip(block)
    # Remove leading blank lines (but not leading whitespace on first line)
    # Remove trailing whitespace
    return block.gsub(/^$\n/, '').rstrip()
  end

end