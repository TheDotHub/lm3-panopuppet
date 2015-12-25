# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require 'yaml'
@servers = YAML.load_file('.servers.yml') 
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  @servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      srv.vm.box          = servers["box"]
      srv.vm.boot_timeout = 1600
      srv.vm.hostname     = servers["hostname"]
      srv.vm.provider :virtualbox do |v|
        v.gui    = true
        v.name   = servers["name"]
        v.memory = servers["ram"]
        v.cpus   = 2
      end

      srv.vm.network "forwarded_port", guest: 80, host: 8090, auto_correct: true

      srv.vm.provision "puppet" do |puppet|
        puppet.module_path   = ["development/modules"]
        puppet.environment = "development"
        puppet.hiera_config_path = "hiera.yaml"
        puppet.working_directory = "/tmp/vagrant-puppet/environments"
        puppet.environment_path = "."
        puppet.options = "--verbose"
      end
    end
  end
end
