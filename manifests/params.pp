class wirbelsturm_build::params {
  $build_base_dir    = '/tmp/build'
  $gid               = 54001
  $gpg_bin           = '/usr/bin/gpg2'
  $gpg_name          = '<yum@michael-noll.com>'
  $gpg_path          = '/home/build/.gnupg' # should be under $user_home
  $group             = 'build'
  $group_ensure      = 'present'
  $java_package_name = 'java-1.6.0-openjdk-devel'
  $motd              = "Welcome to the Wirbelsturm build server.

Getting started
---------------
Use the 'build' user for all build activities.

  $ sudo su - build
  $ cd /tmp/build

Signing RPMs
------------
1. Make sure the GPG signing key pair is stored in the keyring under ~/.gnupg/
   of the build user.  For instance, copy pubring.gpg and secring.gpg to this
   directory.
2. Sign RPMs via 'rpm --resign foo.rpm'.
3. Verify that signature was added via 'rpm --qpi foo.rpm'.
4. Verify signature correctness via 'rpm --checksig foo.rpm'
   (look for 'pgp' or 'gpg' entry).

Uploading RPMs to the public Wirbelsturm S3 yum repository
----------------------------------------------------------
1. Replace CHANGEME_AWS_ACCESS_KEY and CHANGEME_AWS_SECRET_KEY in ~/.s3cfg
   with the correct values.  This AWS key pair must be allowed to modify the
   contents of the S3 bucket that backs the Wirbelsturm yum repository.
2. Copy the `wirbelsturm-s3-data` git repo to this machine and place *all*
   RPMs into the sub-directory `bigdata/redhat/6/x86_64/`.
3. Allow the build user to modify the contents of the `wirbelsturm-s3-data`
   checkout:

    $ sudo chown -R build:build /path/to/wirbelsturm-s3-data

4. Run `./deploy.sh` in the top-level wirbelsturm-s3-data directory.
   *** CAUTION: *** The deploy script will REMOVE any RPMs from the S3 repo
   that are not part of the RPM set that you are uploading.  So if you run
   the deploy script without any RPM in the x86_64 directory, for example,
   you will WIPE the S3 yum repo completely and thus prevent deployments
   for all users relying on this yum repository!
"
  $shell             = '/bin/bash'
  $uid               = 54001
  $user              = 'build'
  $user_description  = 'Build user'
  $user_ensure       = 'present'
  $user_home         = '/home/build'
  $user_managehome   = true
}
