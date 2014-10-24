use strict;
use warnings;
use 5.008;
# ABSTRACT: a live resource lock

package DBIx::Locker::Lock;
{
  $DBIx::Locker::Lock::VERSION = '0.100112';
}

use Carp ();
use Sub::Install ();


sub new {
  my ($class, $arg) = @_;

  my $guts = {
    locker    => $arg->{locker},
    lock_id   => $arg->{lock_id},
    expires   => $arg->{expires},
    locked_by => $arg->{locked_by},
  };

  return bless $guts => $class;
}


BEGIN {
  for my $attr (qw(locker lock_id locked_by)) {
    Sub::Install::install_sub({
      code => sub {
        Carp::confess("$attr is read-only") if @_ > 1;
        $_[0]->{$attr}
      },
      as   => $attr,
    });
  }
}


sub expires {
  my $self = shift;
  return $self->{expires} unless @_;

  my $new_expiry = shift;

  Carp::confess("new expiry must be a Unix epoch time")
    unless $new_expiry =~ /\A\d+\z/;

  my $time_array = [ localtime $new_expiry ];

  my $dbh   = $self->locker->dbh;
  my $table = $self->locker->table;

  my $rows  = $dbh->do(
    "UPDATE $table SET expires = ? WHERE id = ?",
    undef,
    $self->locker->_time_to_string($time_array),
    $self->lock_id,
  );

  my $str = defined $rows ? $rows : 'undef';
  Carp::confess("error updating expiry: UPDATE returned $str") if $rows != 1;

  $self->{expires} = $new_expiry;

  return $new_expiry;
}


sub guid { $_[0]->locked_by->{guid} }


sub unlock {
  my ($self) = @_;

  my $dbh   = $self->locker->dbh;
  my $table = $self->locker->table;

  my $rows = $dbh->do("DELETE FROM $table WHERE id=?", undef, $self->lock_id);

  Carp::confess('error releasing lock') unless $rows == 1;
}

sub DESTROY {
  my ($self) = @_;
  local $@;
  return unless $self->locked_by->{pid} == $$;
  $self->unlock;
}

1;

__END__

=pod

=head1 NAME

DBIx::Locker::Lock - a live resource lock

=head1 VERSION

version 0.100112

=head1 METHODS

=head2 new

B<Calling this method is a very, very stupid idea.>  This method is called by
L<DBIx::Locker> to create locks.  Since you are not a locker, you should not
call this method.  Seriously.

  my $locker = DBIx::Locker::Lock->new(\%arg);

This returns a new lock. 

  locker    - the locker creating the lock
  lock_id   - the id of the lock in the lock table
  expires   - the time (in epoch seconds) at which the lock will expire
  locked_by - a hashref of identifying information

=head2 locker

=head2 lock_id

=head2 locked_by

These are accessors for data supplied to L</new>.

=head2 expires

This method returns the expiration time (as a unix timestamp) as provided to
L</new> -- unless expiration has been changed.  Expiration can be changed by
using this method as a mutator:

  # expire one hour from now, no matter what initial expiration was
  $lock->expired(time + 3600);

When updating the expiration time, if the given expiration time is not a valid
unix time, or if the expiration cannot be updated, an exception will be raised.

=head2 guid

This method returns the lock's globally unique id.

=head2 unlock

This method unlocks the lock, deleting the semaphor record.  This method is
automatically called when locks are garbage collected.

=head1 AUTHOR

Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
