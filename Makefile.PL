
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



WriteMakefile(
  DISTNAME  => 'DBIx-Locker',
  NAME      => 'DBIx::Locker',
  AUTHOR    => "Ricardo\ SIGNES\ \<rjbs\@cpan\.org\>",
  ABSTRACT  => "locks\ for\ db\ resources\ that\ might\ not\ be\ totally\ insane",
  VERSION   => '0.100111',
  EXE_FILES => [ "bin\/dbix_locker_purge" ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "DBD::SQLite" => '0',
    "ExtUtils::MakeMaker" => '6.11',
    "Data::GUID" => '0',
    "Log::Dispatchouli" => '0',
    "Sub::Install" => '0',
    "JSON" => '2',
    "Getopt::Long::Descriptive" => '0',
    "Sys::Hostname" => '0',
    "DBI" => '0',
  },
  test => {TESTS => 't/*.t'}
);



