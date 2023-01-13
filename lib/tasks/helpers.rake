module Nix
  class << self
    def build(test)
      system %(nix-build #{test})
    end

    def login(test)
      system %(nix-build -A driverInteractive #{test})
    end
  end
end

module Build
  class << self
    def rio
      Nix.build %(nixos/tests/modules/systems/rio.nix)
    end

    def blackmatter
      Nix.build %(nixos/tests/modules/edge/blackmatter.nix)
    end
  end
end

module Login
  class << self
    include Nix
    def rio
      Nix.login %(nixos/tests/modules/systems/rio.nix)
    end

    def blackmatter
      Nix.login %(nixos/tests/modules/edge/blackmatter.nix)
    end
  end
end
