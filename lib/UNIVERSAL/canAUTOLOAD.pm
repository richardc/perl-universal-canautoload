use strict;
package UNIVERSAL::canAUTOLOAD;
use Class::ISA;
our $VERSION = '0.01';

no warnings 'redefine';
sub UNIVERSAL::can {
    my ($referent, $want) = @_;

    my $class = ref $referent || $referent;
    for my $search ( Class::ISA::self_and_super_path( $class ) ) {
        return \&{"$search\::$want"} if exists &{"$search\::$want"};
    }

    for my $search ( Class::ISA::self_and_super_path( $class ) ) {
        next unless exists &{"$search\::AUTOLOAD"};
        my $code = "package $search;".
          'sub { our $AUTOLOAD = "$class\::$want"; goto &AUTOLOAD }';

        return eval $code or die "compiling '$code': $@";
    }

    return;
}

1;
