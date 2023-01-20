require "vagrant"

module VagrantPlugins
  module HostArch
    class Host < Vagrant.plugin("2", :host)
      def detect?(env)
        File.exist?("/etc/arch-release") and not File.exist?("/etc/artix-release")
      end
    end
  end
end
