# == Class:  panopuppet
#
# Installs/Configures Panopuppet and Prerequisites
#
#
class panopuppet(
  String $django_version =  '1.7'
  ){

  class { 'panopuppet::pre':       } ->
  class { 'panopuppet::install':   } ->
  class { 'panopuppet::configure': } ->
  class { 'panopuppet::webserver': }
}
