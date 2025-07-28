#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Parameters](#parameters)
6. [Development](#development)

## Overview

This module enables you to install, deploy, and configure apticron.

## Module Description

Apticron is a shell script which generates a mail with a list of all packages
currently pending an upgrade, as well as summary of changes - using
apt-listchanges - to a configurable Email address.

## Setup

```puppet
class { 'apticron':
  email => 'root@example.org',
}
```

## Usage

You can configure all options in the main class.

```puppet
class { 'apticron':
  package                   => true,
  email                     => "root@${facts['networking']['domain']}",
  diff_only                 => 1,
  listchanges_profile       => undef,
  all_fqdns                 => undef,
  system                    => $facts['networking']['hostname'],
  ipaddressnum              => undef,
  ipaddresses               => undef,
  notify_holds              => undef,
  notify_new                => undef,
  notify_no_updates         => undef,
  custom_subject            => undef,
  custom_no_updates_subject => undef,
  custom_from               => "apticron@${facts['networking']['domain']}"
}
```

## Parameters

### `package`
**Data type:** `Variant[Boolean, Enum['latest']]`  
**Default:** `true`

Whether to install the apticron package. Can be:
- `true` - install the package (present)
- `false` - remove the package (purged)  
- `'latest'` - ensure latest version is installed

### `email`
**Data type:** `String`  
**Default:** `"root@${facts['networking']['domain']}"`

Set EMAIL to a space separated list of addresses which will be notified of impending updates.

### `diff_only`
**Data type:** `Integer[0,1]`  
**Default:** `1`

Set DIFF_ONLY to "1" to only output the difference of the current run compared to the last run (ie. only new upgrades since the last run). If there are no differences, no output/email will be generated. By default, apticron will output everything that needs to be upgraded.

### `listchanges_profile`
**Data type:** `Optional[String]`  
**Default:** `undef`

Set LISTCHANGES_PROFILE if you would like apticron to invoke apt-listchanges with the --profile option. You should add a corresponding profile to /etc/apt/listchanges.conf.

### `all_fqdns`
**Data type:** `Optional[String]`  
**Default:** `undef`

From hostname manpage: "Displays all FQDNs of the machine. This option enumerates all configured network addresses on all configured network interfaces, and translates them to DNS domain names."

### `system`
**Data type:** `String`  
**Default:** `$facts['networking']['hostname']`

Set SYSTEM if you would like apticron to use something other than the output of "hostname -f" for the system name in the mails it generates. This option overrides the ALL_FQDNS above.

### `ipaddressnum`
**Data type:** `Optional[Integer]`  
**Default:** `undef`

Set IPADDRESSNUM if you would like to configure the maximal number of IP addresses apticron displays. The default is to display 1 address of each family type (inet, inet6), if available.

### `ipaddresses`
**Data type:** `Optional[String]`  
**Default:** `undef`

Set IPADDRESSES to a whitespace separated list of reachable addresses for this system. By default, apticron will try to work these out using the "ip" command.

### `notify_holds`
**Data type:** `Optional[Integer[0,1]]`  
**Default:** `undef`

Set NOTIFY_HOLDS="0" if you don't want to be notified about new versions of packages on hold in your system. The default behavior is downloading and listing them as any other package.

### `notify_new`
**Data type:** `Optional[Integer[0,1]]`  
**Default:** `undef`

Set NOTIFY_NEW="0" if you don't want to be notified about packages which are not installed in your system.

### `notify_no_updates`
**Data type:** `Optional[Integer[0,1]]`  
**Default:** `undef`

Set NOTIFY_NO_UPDATES="0" if you don't want to be notified when there is no new versions. Set to 1 could assure you that apticron works well.

### `custom_subject`
**Data type:** `Optional[String]`  
**Default:** `undef`

Set CUSTOM_SUBJECT if you want to replace the default subject used in the notification e-mails. This may help filtering/sorting client-side e-mail. If you want to use internal vars please use single quotes here. Ex: `$CUSTOM_SUBJECT='[apticron] $SYSTEM: $NUM_PACKAGES package update(s)'`

### `custom_no_updates_subject`
**Data type:** `Optional[String]`  
**Default:** `undef`

Set CUSTOM_NO_UPDATES_SUBJECT if you want to replace the default subject used in the no update notification e-mails. This may help filtering/sorting client-side e-mail. If you want to use internal vars please use single quotes here. Ex: `$CUSTOM_NO_UPDATES_SUBJECT='[apticron] $SYSTEM: no updates'`

### `custom_from`
**Data type:** `String`  
**Default:** `"apticron@${facts['networking']['domain']}"`

Set CUSTOM_FROM if you want to replace the default sender by changing the 'From:' field used in the notification e-mails.

## Development

Rentabiliweb modules on the Puppet Forge are open projects, and community
contributions are essential for keeping them great. We can't access the huge
number of platforms and myriad of hardware, software, and deployment
configurations that Puppet is intended to serve so feel free to contribute on
GitHub.
