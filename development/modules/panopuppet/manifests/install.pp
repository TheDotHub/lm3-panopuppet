# == Class:  panopuppet::install
#
#
class panopuppet::install{

  vcsrepo { '/srv/repo/panopuppet':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/propyless/panopuppet.git',
    revision => 'master',
  } ->

  file { '/srv/.virtualenvs' :
    ensure => directory,
  } ->

  exec { 'set-virtual':
    creates   => '/srv/.virtualenvs/panopuppet',
    command   => 'virtualenv -p /usr/bin/python3 panopuppet',
    cwd       => '/srv/.virtualenvs',
    logoutput => true,
    path      => ['/usr/bin','/bin'],
  } ->
 
  file_line {'replace-django-version':
    path  => '/srv/repo/panopuppet/requirements.txt',
    line  => "Django==${panopuppet::django_version}",
    match => '^Django',
  } ->

  exec { 'enable-virtualenv':
    command   => "bash -c 'source panopuppet/bin/activate; pip install -r /srv/repo/panopuppet/requirements.txt'",
    logoutput => true,
    cwd       => '/srv/.virtualenvs',
    path      => ['/usr/bin','/bin'],
    unless    => "bash -c 'source panopuppet/bin/activate; pip list | grep Django'",
  }
}
