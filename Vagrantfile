# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = "fail2ban-berkshelf"
  config.omnibus.chef_version = :latest
  config.vm.box = "chef/ubuntu-12.04"
  config.vm.network :forwarded_port, guest: 80, host: 11180
  config.berkshelf.enabled = true
  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
        "recipe[apt]",
        "recipe[fail2ban]"
    ]
    chef.json = {
      "fail2ban" => {
        "jails" => {
          "nginx-sms" => {
            "enabled" => "true",
            "bantime" => "86400",
            "findtime" => "3600",
            "maxretry" => "5",
            "port" => "80,443",
            "logpath" => "/var/log/syslog",
            "banaction" => "ufw-new",
            "filter" => "nginx-http-auth"
          }
        }
      }
    }
  end
end
