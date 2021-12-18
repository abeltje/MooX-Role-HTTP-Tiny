#! perl -w -I.
use t::Test::abeltje;
use Test::MockObject;

package TestClass {
    use Moo;
    with 'MooX::Role::HTTP::Tiny';

    sub call {
        my $self = shift;
        return \@_;
    }
    1;
}

{
    my $client = TestClass->new(base_uri => 'http://localhost/');
    isa_ok($client, 'TestClass');
    isa_ok($client->ua, 'HTTP::Tiny');
    isa_ok($client->base_uri, 'URI::http');
}

{
    (   my $ua = Test::MockObject->new(
        )
    )->set_isa('HTTP::Tiny');
    my $client = TestClass->new(
        base_uri => 'http://localhost/',
        ua       => $ua,
    );
    isa_ok($client, 'TestClass');

    my @arguments = (GET => '', {param => 'blah'});
    my $response = $client->call(@arguments);
    is_deeply($response, \@arguments, "->call() works");
}

abeltje_done_testing();
