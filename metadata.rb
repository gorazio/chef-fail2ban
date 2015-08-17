name              'fail2ban'
maintainer        'gorazio'
maintainer_email  'gmail@gorazio.com'
license           'Apache 2.0'
description       'Installs and configures fail2ban'
version           '2.3.5'

%w{ debian ubuntu redhat centos scientific amazon oracle fedora}.each do |os|
  supports os
end
