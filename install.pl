#!/usr/bin/perl
use strict;

use File::Copy;
use Digest::MD5 qw(md5_hex);
use Term::ReadKey;
use YAML;

my $sysdir = '/var/sysync';
my $editor = $ENV{EDITOR} || 'vi';

die "may only be ran as root\n" unless $< == 0;

sub main
{
    # grab options
        #die "sysync is already installed\n" if -d $sysdir;

    mkdir("$sysdir");
    mkdir("$sysdir/users");
    mkdir("$sysdir/groups");
    mkdir("$sysdir/hosts");
    mkdir("$sysdir/files");
    mkdir("$sysdir/.stage/");
    mkdir("$sysdir/keys");
    chmod 700, "$sysdir/keys";

    system(q[ssh-keygen -N "" -f /var/sysync/keys/sysync_rsa]);

    copy('./bin/sysync', '/usr/sbin/sysync');
    chmod 700, '/usr/sbin/sysync';

    open(F, ">$sysdir/hosts.conf");
    print F q[hosts:
   hostnamehere:
      - server.address.here
];
    close(F);


    open(F, ">$sysdir/hosts/default.conf");
    print F q[users:
   - uid: 0 
     username: root
     homedir: /root
     shell: /bin/bash
     password: '$6$928b679b70731fc7$OjB.vI0hI4PWC9ObsudW3ITZMBjo7Rfs6Dd5vQ80XZM0A6NU6EQqIVQAI3T90T5Bz3K9Vfha0cp176IAHaNQQ.'
     #ssh_keys:
     #    - here
   - { uid: 1, username: daemon, homedir: /usr/sbin, shell: /bin/sh }
   - { uid: 2, username: bin, homedir: /bin, shell: /bin/sh }
   - { uid: 3, username: sys, homedir: /dev, shell: /bin/sh }
   - { uid: 8, username: mail, homedir: /var/mail, shell: /bin/sh }
   - { uid: 10, username: uucp, homedir: /var/spool/uucp, shell: /bin/sh }
   - { uid: 33, username: www-data, homedir: /var/www, shell: /bin/sh }
   - { uid: 34, username: backup, homedir: /var/backups, shell: /bin/sh }
   - { uid: 65534, username: nobody, homedir: /nonexistent, shell: /bin/sh }
   - { uid: 100, gid: 101,  username: libuuid, homedir: /var/lib/libuuid, shell: /bin/sh }
   - { uid: 101, gid: 103, username: syslog, homedir: /home/syslgo, shell: /bin/false }
   - { uid: 102, username: sshd, homedir: /var/run/sshd, shell: /usr/sbin/nologin }
   - { uid: 103, username: ntpd, homedir: /var/run/openntpd:, shell: /bin/false }
groups:
   - { gid: 4, groupname: adm }
   - { gid: 5, groupname: tty }
   - { gid: 6, groupname: disk }
   - { gid: 7, groupname: lp }
   - { gid: 15, groupname: kmem }
   - { gid: 24, groupname: cdrom }
   - { gid: 25, groupname: floppy }
   - { gid: 30, groupname: dip }
   - { gid: 37, groupname: operator }
   - { gid: 40, groupname: src }
   - { gid: 42, groupname: shadow }
   - { gid: 43, groupname: utmp }
   - { gid: 44, groupname: video }
   - { gid: 45, groupname: sasl }
   - { gid: 46, groupname: plugdev }
   - { gid: 50, groupname: staff }
   - { gid: 100, groupname: users }
   - { gid: 101, groupname: libuuid }
   - { gid: 103, groupname: crontab }
   - { gid: 104, groupname: ssh }
   - { gid: 65534, groupname: nogroup }
files:
   - remote_path: '/etc/ssh/sshd_config'
     file: 'defaults/sshd_config'
# only import users from the follow groups
# use all for all users
user_groups:
   - all
];



}


exit __PACKAGE__->main;

