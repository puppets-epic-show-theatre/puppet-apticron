# == Class: apticron::params
#
class apticron::params {
  case $facts['os']['name'] {
    /(Debian|Ubuntu)/ : {
      $apticron_package_name = 'apticron'
      $apticron_config_dir   = '/etc/apticron'
      $apticron_config_file  = 'apticron.conf'
    }
    default: {
      fail("Module apticron is not supported on ${facts['os']['name']}")
    }
  }
}
