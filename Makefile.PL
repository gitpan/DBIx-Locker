
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "locks for db resources that might not be totally insane",
  "AUTHOR" => "Ricardo SIGNES <rjbs\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "DBIx-Locker",
  "EXE_FILES" => [
    "bin/dbix_locker_purge"
  ],
  "LICENSE" => "perl",
  "NAME" => "DBIx::Locker",
  "PREREQ_PM" => {
    "Carp" => 0,
    "DBD::SQLite" => 0,
    "DBI" => 0,
    "Data::GUID" => 0,
    "Getopt::Long::Descriptive" => 0,
    "JSON" => 2,
    "Log::Dispatchouli" => 0,
    "Sub::Install" => 0,
    "Sys::Hostname" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Test::More" => "0.96"
  },
  "VERSION" => "0.100116",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "DBD::SQLite" => 0,
  "DBI" => 0,
  "Data::GUID" => 0,
  "Getopt::Long::Descriptive" => 0,
  "JSON" => 2,
  "Log::Dispatchouli" => 0,
  "Sub::Install" => 0,
  "Sys::Hostname" => 0,
  "Test::More" => "0.96",
  "strict" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



