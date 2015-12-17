# == Class:  panopuppet::webserver
#
# Apache configuration
#
#
class panopuppet::webserver(){

  package { ['httpd', 'python33-mod_wsgi']:
    ensure => present,
  }

  service { 'httpd':
    ensure => running,
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => present,
    content => template('panopuppet/httpd.conf.erb'),
    owner   => 'root',
    group   => 'root',
    notify  => Service['httpd'],
  }

}
