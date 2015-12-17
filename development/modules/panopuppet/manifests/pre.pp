# == Class:  panopuppet::pre
#
#
class panopuppet::pre(){

  package{ 'git':
    ensure => present,
  }

  package {'epel-release':
    ensure => present,
  } ->

  yumrepo { "IUS":
    baseurl  => "http://dl.iuscommunity.org/pub/ius/stable/$operatingsystem/$operatingsystemrelease/$architecture",
    descr    => 'IUS Community repository',
    enabled  => 1,
    gpgcheck => 0
  } ->

  package { [ 'python33',
              'python33-devel',
              'openldap-devel',
              'cyrus-sasl-devel',
              'gcc',
              'make',
              'python-virtualenv',       #TODO: remove in the future
              'python-virtualenvwrapper' #TODO: remove in the future
            ] :
    ensure  => present,
  }
}
