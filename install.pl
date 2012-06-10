#!/usr/bin/perl
# Sysync
# 
# Copyright (C) 2012 Ohio-Pennsylvania Software, LLC.
#
# This file is part of sysync.
# 
# sysync is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
# 
# sysync is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
    chmod 0700, "$sysdir";
    mkdir("$sysdir/users");
    mkdir("$sysdir/groups");
    mkdir("$sysdir/hosts");
    mkdir("$sysdir/files");
    mkdir("$sysdir/stage/");
    mkdir("$sysdir/keys");
    chmod 0700, "$sysdir/keys";

    system(q[ssh-keygen -N "" -f /var/sysync/keys/sysync_rsa])
        unless -e '/var/sysync/keys/sysync_rsa';

    copy('./bin/sysync', '/usr/sbin/sysync');
    chmod 700, '/usr/sbin/sysync';

    copy('./defaults/sysync', '/etc/init.d/sysync');
    chmod 755, '/etc/init.d/sysync';

    # add to rc.d
    symlink('../init.d/sysync', '/etc/rc0.d/K20sysync');
    symlink('../init.d/sysync', '/etc/rc1.d/K20sysync');
    symlink('../init.d/sysync', '/etc/rc2.d/S20sysync');
    symlink('../init.d/sysync', '/etc/rc3.d/S20sysync');
    symlink('../init.d/sysync', '/etc/rc4.d/S20sysync');
    symlink('../init.d/sysync', '/etc/rc5.d/S20sysync');
    symlink('../init.d/sysync', '/etc/rc6.d/K20sysync');

    copy('./defaults/hosts.conf', "$sysdir/hosts.conf")
        unless -e "$sysdir/hosts.conf";
    
    copy('./defaults/default.conf', "$sysdir/hosts/default.conf")
        unless -e "$sysdir/hosts/default.conf";
}

exit __PACKAGE__->main;

