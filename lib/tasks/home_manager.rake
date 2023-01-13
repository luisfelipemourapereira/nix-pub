module Nix
  module HomeManager
    class << self
      def install
        system %(nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager)
        system %(nix-channel --update)
        system %(nix-shell '<home-manager>' -A install)
      end

      def flake
        system %(home-manager switch --flake '.##{ENV.fetch(%(USER), nil)}')
      end
    end
  end
end

namespace :home do
  desc %(install home-manager)
  task :install do
    Nix::HomeManager.install
  end

  desc %(run local flake environment)
  task :flake do
    Nix::HomeManager.flake
  end
end

desc %(install dotfiles with nix)
task :dotfiles do
  Rake::Task[%(home:flake)].invoke
end
