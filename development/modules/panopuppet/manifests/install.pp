# == Class:  panopuppet::install
#
#
class panopuppet::install{

  case $osfamily {

  'RedHat': {

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
  } ->

  exec { 'collect-static':
    command   => "bash -c 'source /srv/.virtualenvs/panopuppet/bin/activate; python manage.py collectstatic --noinput'",
    logoutput => true,
    cwd       => '/srv/repo/panopuppet',
    path      => ['/usr/bin','/bin'],
  } ->

  exec { 'migrate':
    creates   => '/srv/repo/panopuppet/db.sqlite3',
    command   => "bash -c 'source /srv/.virtualenvs/panopuppet/bin/activate; python manage.py migrate'",
    logoutput => true,
    cwd       => '/srv/repo/panopuppet',
    path      => ['/usr/bin','/bin'],
  } ->

  exec { 'update-permissions':
    command     => "chown -R apache:apache /srv/repo/panopuppet",
    logoutput   => true,
    cwd         => '/srv/repo/panopuppet',
    path        => ['/usr/bin','/bin'],
    refreshonly => true,
    notify      => Service['httpd'],
  }
  }
    default: { fail("Module ${module_name} is not supported on ${::operatingsystem} ${::operatingsystemrelease}") }
  }
}
