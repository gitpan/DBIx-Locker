use strict;
use warnings;
use 5.008;
# ABSTRACT: a live resource lock

package DBIx::Locker::Lock;
our $VERSION = '0.091340';



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
  for my $attr (qw(locker lock_id expires locked_by)) {
    Sub::Install::install_sub({
      code => sub { $_[0]->{$attr} },
      as   => $attr,
    });
  }
}


sub guid { $_[0]->locked_by->{guid} }


sub unlock {
  my ($self) = @_;

  my $dbh   = $self->locker->dbh;
  my $table = $self->locker->table;

  my $rows = $dbh->do("DELETE FROM $table WHERE id=?", undef, $self->lock_id);

  die('error releasing lock') unless $rows == 1;
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

version 0.091340

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

=head2 expires

=head2 locked_by

These are accessors for data supplied to L</new>.

=head2 guid

This method returns the lock's globally unique id.

=head2 unlock

This method unlocks the lock, deleting the semaphor record.  This method is
automatically called when locks are garbage collected.

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


