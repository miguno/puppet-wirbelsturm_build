class wirbelsturm_build::install inherits wirbelsturm_build {

  group { $group:
    ensure => $group_ensure,
    gid    => $gid,
  }

  user { $user:
    ensure     => $user_ensure,
    home       => $user_home,
    shell      => $shell,
    uid        => $uid,
    comment    => $user_description,
    gid        => $group,
    managehome => $user_managehome,
    require    => Group[$group],
  }

  file { 'rpm-macros':
    ensure  => file,
    path    => "$user_home/.rpmmacros",
    content => template("${module_name}/rpmmacros.erb"),
    owner   => $user,
    group   => $group,
    mode    => '0644',
    require => User[$user],
  }

  file { 's3cmd-configuration':
    ensure => file,
    path   => "$user_home/.s3cfg",
    source => "puppet:///modules/${module_name}/s3cfg",
    owner   => $user,
    group   => $group,
    mode    => '0644',
    require => User[$user],
  }

  file { 'user-gnupg-dir':
    path         => $gpg_path,
    ensure       => directory,
    owner        => $user,
    group        => $group,
    mode         => '0700',
    recurse      => true,
    recurselimit => 0,
    require      => User[$user],
  }

  file { $build_base_dir:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
  }

  file { '/etc/motd':
    content => $motd,
  }

  # TODO: Tie this devel version of JDK (for builds) with the actual JRE/JDK version we use in Wirbelsturm deployments
  package { 'java-development-kit':
    name   => $java_package_name,
    ensure => 'installed',
    alias  => 'java-jdk-devel',
  }

  $build_packages = [
    'cmake',
    'createrepo',
    'gcc',
    'gcc-c++',
    'git',
    'gnupg2',
    'libtool',
    'libuuid-devel',
    'rpm-build',
    'ruby',
    'ruby-devel',
    's3cmd',
    'snappy-devel',
    'tcl',
    'unzip',
    'xz-devel',
    'zlib-devel',
  ]

  package { $build_packages:
    ensure => 'installed',
  }

  $utils_packages = [
    'tree',
  ]

  package { $utils_packages:
    ensure => 'installed',
  }

  package { 'fpm':
    ensure   => 'installed',
    provider => gem,
    require  => Package['ruby-devel'],
  }

}
