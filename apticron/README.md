# rentabiliweb-apticron ![License badge][license-img] [![Puppet badge][puppet-img]][puppet-url]

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Development](#development)

## Overview

The rentabiliweb-apticron module  enables you to install,  deploy, and configure
apticron.

## Module Description

Apticron is a  shell script which generates  a mail with a list  of all packages
currently  pending  an   upgrade,  as  well  as  summary  of   changes  -  using
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
  email                     => "root@${::domain}",
  diff_only                 => 1,
  listchanges_profile       => undef,
  all_fqdns                 => undef,
  system                    => $::hostname,
  ipaddressnum              => undef,
  ipaddresses               => undef,
  notify_holds              => undef,
  notify_new                => undef,
  notify_no_updates         => undef,
  custom_subject            => undef,
  custom_no_updates_subject => undef,
  custom_from               => "apticron@${::domain}"
}
```

## Development

Rentabiliweb  modules on  the  Puppet  Forge are  open  projects, and  community
contributions are  essential for keeping  them great.  We can’t access  the huge
number  of   platforms  and  myriad   of  hardware,  software,   and  deployment
configurations that  Puppet is intended to  serve so feel free  to contribute on
GitHub.

Thanks https://github.com/puppetlabs/ for help to write this README :)

```
    ╚⊙ ⊙╝
  ╚═(███)═╝
 ╚═(███)═╝
╚═(███)═╝
 ╚═(███)═╝
  ╚═(███)═╝
   ╚═(███)═╝
```

[license-img]: https://img.shields.io/badge/license-ISC-blue.svg "License"
[puppet-img]: https://img.shields.io/puppetforge/dt/rentabiliweb/apticron.svg "Puppet Forge"
[puppet-url]: https://forge.puppetlabs.com/rentabiliweb/apticron "Puppet Forge"
