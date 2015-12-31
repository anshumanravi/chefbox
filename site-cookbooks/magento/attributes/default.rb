default['magento']['main_user'] = 'ubuntu'
default['magento']['main_users'] = [ 'siteuser' ]
default['magento']['main_groups'] = [ 'www-data', 'siteuser' ]
default['magento']['known_hosts'] = ['github.com']
default['magento']['magento_instances_databag_name'] = 'magento-sites'

default['magento']['packages'] = [
   'unzip', 'graphicsmagick', 'jq', 'tig', 'git', 'pv', 'realpath',
   'apache2',
   'mysql-server-5.6', 'mysql-client-5.6',
   'php5', 'php5-curl', 'php5-gd', 'php5-mcrypt', 'php5-redis', 'php5-mhash', 'php5-cli', 'php5-mysql', 'php5-gd', 'php5-intl', 'php5-common', 'php5-xsl'
]

default['magento']['apache_modules'] = [ 'headers', 'rewrite' ]
default['magento']['php5_modules'] = [ 'mcrypt' ]