class wirbelsturm_build(
  $build_base_dir    = $wirbelsturm_build::params::build_base_dir,
  $gid               = $wirbelsturm_build::params::gid,
  $gpg_bin           = $wirbelsturm_build::params::gpg_bin,
  $gpg_name          = $wirbelsturm_build::params::gpg_name,
  $gpg_path          = $wirbelsturm_build::params::gpg_path,
  $group             = $wirbelsturm_build::params::group,
  $group_ensure      = $wirbelsturm_build::params::group_ensure,
  $java_package_name = $wirbelsturm_build::params::java_package_name,
  $motd              = $wirbelsturm_build::params::motd,
  $shell             = $wirbelsturm_build::params::shell,
  $uid               = $wirbelsturm_build::params::uid,
  $user              = $wirbelsturm_build::params::user,
  $user_description  = $wirbelsturm_build::params::user_description,
  $user_ensure       = $wirbelsturm_build::params::user_ensure,
  $user_home         = $wirbelsturm_build::params::user_home,
  $user_managehome   = hiera('wirbelsturm_build::user_managehome', $wirbelsturm_build::params::user_managehome),
) inherits wirbelsturm_build::params {

  validate_absolute_path($build_base_dir)
  if !is_integer($gid) { fail('The $gid parameter must be an integer number') }
  validate_absolute_path($gpg_bin)
  validate_string($gpg_name)
  validate_absolute_path($gpg_path)
  validate_string($group)
  validate_string($group_ensure)
  validate_string($java_package_name)
  validate_string($motd)
  validate_absolute_path($shell)
  if !is_integer($uid) { fail('The $uid parameter must be an integer number') }
  validate_string($user)
  validate_string($user_description)
  validate_string($user_ensure)
  validate_absolute_path($user_home)
  validate_bool($user_managehome)

  include '::wirbelsturm_build::install'

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up. You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'wirbelsturm_build::begin': }
  anchor { 'wirbelsturm_build::end': }

  Anchor['wirbelsturm_build::begin'] -> Class['::wirbelsturm_build::install'] -> Anchor['wirbelsturm_build::end']
}
