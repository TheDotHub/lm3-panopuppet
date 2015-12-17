
class panopuppet::configure(){


  file { '/srv/repo/panopuppet/config.yaml': 
    ensure  => present,
    content => template('panopuppet/config.yaml.erb'),
    notify  => Service['httpd'],
  }

}