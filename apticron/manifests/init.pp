# == Class: apticron
#
# === Parameters
#
# [*package*]
#   Whether to install the apticron package. Can be true (install), false 
#   (purge), or 'latest' (ensure latest version is installed).
#
# [*email*]
# Set EMAIL to a space separated list of addresses which will be notified of
# impending updates
#
# [*diff_only*]
#   Set DIFF_ONLY to "1" to only output the difference of the current run
#   compared to the last run (ie. only new upgrades since the last run). If
#   there are no differences, no output/email will be generated. By default,
#   apticron will output everything that needs to be upgraded.
#
# [*listchanges_profile*]
#   Set LISTCHANGES_PROFILE if you would like apticron to invoke apt-listchanges
#   with the --profile option. You should add a corresponding profile to
#   /etc/apt/listchanges.conf
#
# [*all_fqdns*]
#   From hostname manpage: "Displays  all FQDNs of the machine. This option
#   enumerates all configured network addresses on all configured network
#   interfaces, and translates them to DNS domain names. Addresses that cannot
#   be translated (i.e. because they do not have an appropriate  reverse DNS
#   entry) are skipped. Note that different addresses may resolve to the same
#   name, therefore the output may contain duplicate entries. Do not make any
#   assumptions about the order of the output."
#
# [*system*]
#   Set SYSTEM if you would like apticron to use something other than the output
#   of "hostname -f" for the system name in the mails it generates. This option
#   overrides the ALL_FQDNS above.
#
# [*ipaddressnum*]
#    Set IPADDRESSNUM if you would like to configure the maximal number of IP
#    addresses apticron displays. The default is to display 1 address of each
#    family type (inet, inet6), if available.
#
# [*ipaddresses*]
#   Set IPADDRESSES to a whitespace separated list of reachable addresses for
#   this system. By default, apticron will try to work these out using the "ip"
#   command
#
# [*notify_holds*]
#   Set NOTIFY_HOLDS="0" if you don't want to be notified about new versions of
#   packages on hold in your system. The default behavior is downloading and
#   listing them as any other package.
#
# [*notify_new*]
#   Set NOTIFY_NEW="0" if you don't want to be notified about packages which are
#   not installed in your system. Yes, it's possible! There are some issues
#   related to systems which have mixed stable/unstable sources. In these cases
#   apt-get will consider for example that packages with "Priority:
#   required"/"Essential: yes" in unstable but not in stable should be
#   installed, so they will be listed in dist-upgrade output.
#
# [*notify_no_updates*]
#   Set NOTIFY_NO_UPDATES="0" if you don't want to be notified when there is no
#   new versions. Set to 1 could assure you that apticron works well.
#
# [*custom_subject*]
#    Set CUSTOM_SUBJECT if you want to replace the default subject used in the
#    notification e-mails. This may help filtering/sorting client-side e-mail.
#    If you want to use internal vars please use single quotes here. Ex:
#    $CUSTOM_SUBJECT='[apticron] $SYSTEM: $NUM_PACKAGES package update(s)'
#
# [*custom_no_updates_subject*]
#   Set CUSTOM_NO_UPDATES_SUBJECT if you want to replace the default subject
#   used in the no update notification e-mails. This may help filtering/sorting
#   client-side e-mail. If you want to use internal vars please use single
#   quotes here. Ex: $CUSTOM_NO_UPDATES_SUBJECT='[apticron] $SYSTEM: no updates'
#
# [*custom_from*]
#   Set CUSTOM_FROM if you want to replace the default sender by changing the
#   'From:' field used in the notification e-mails.
#
class apticron (
  Variant[Boolean, Enum['latest']] $package = true,
  # Defaults for apticron
  String $email = "root@${facts['networking']['domain']}",
  Integer[0,1] $diff_only = 1,
  Optional[String] $listchanges_profile = undef,
  Optional[String] $all_fqdns = undef,
  String $system = $facts['networking']['hostname'],
  Optional[Integer] $ipaddressnum = undef,
  Optional[String] $ipaddresses = undef,
  Optional[Integer[0,1]] $notify_holds = undef,
  Optional[Integer[0,1]] $notify_new = undef,
  Optional[Integer[0,1]] $notify_no_updates = undef,
  Optional[String] $custom_subject = undef,
  Optional[String] $custom_no_updates_subject = undef,
  String $custom_from = "apticron@${facts['networking']['domain']}"
) inherits apticron::params {
  $apticron_package_name = $apticron::params::apticron_package_name
  $apticron_config_dir   = $apticron::params::apticron_config_dir
  $apticron_config_file  = $apticron::params::apticron_config_file

  case $package {
    true     : { $ensure_package = 'present' }
    false    : { $ensure_package = 'purged' }
    'latest' : { $ensure_package = 'latest' }
    default  : { fail('package must be true, false or lastest') }
  }

  package { $apticron_package_name: ensure => $ensure_package, }

  if ($package == true) or ($package == 'latest') {
    file { "${apticron_config_dir}/${apticron_config_file}":
      ensure  => 'file',
      path    => "${apticron_config_dir}/${apticron_config_file}",
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('apticron/apticron.conf.erb'),
      require => Package[$apticron_package_name],
    }
  }
}
