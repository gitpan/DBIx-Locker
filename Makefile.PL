
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'DBIx-Locker',
  NAME      => 'DBIx::Locker',
  AUTHOR    => 'Ricardo\ SIGNES\ \<rjbs\@cpan\.org\>',
  ABSTRACT  => 'locks for db resources that might not be totally insane',
  VERSION   => '0.091340',
  EXE_FILES => [ qw(bin/dbix_locker_purge) ],
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "Data::GUID" => '0',
    "Log::Dispatchouli" => '0',
    "Sub::Install" => '0',
    "Getopt::Long::Descriptive" => '0',
    "JSON::XS" => '0',
    "Sys::Hostname" => '0',
    "DBI" => '0',
  },
);
