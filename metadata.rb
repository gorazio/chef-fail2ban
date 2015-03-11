name              'fail2ban'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache 2.0'
description       'Installs and configures fail2ban'
version           '2.3.0'

depends 'yum', '~> 3.0'
depends 'yum-epel'

%w{ debian ubuntu redhat centos scientific amazon oracle fedora}.each do |os|
  supports os
end
