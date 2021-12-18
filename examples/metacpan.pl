#! /usr/bin/perl -w
use strict;
use lib '../lib', './lib';
use Data::Dumper; $Data::Dumper::Indent = $Data::Dumper::Sortkeys = 1;
use JSON;

package MetaCPAN::Client {
    use Moo;
    with 'MooX::Role::HTTP::Tiny';
    use JSON;

    sub call {
        my $self = shift;
        my ($method, $path, $args) = @_;

        my $uri = $self->base_uri->clone;
        $uri->path($uri->path =~ m{ / $}x ? $uri->path . $path : $path)
            if $path;

        my @params = $args ? ({ content => encode_json($args) }) : ();
        if (uc($method) eq 'GET') {
            my $query = $self->ua->www_form_urlencode($args);
            $uri->query($query);
            shift(@params);
        }

        printf STDERR ">>>>> %s => %s (%s) <<<<<\n", uc($method), $uri, "@params";
        my $response = $self->ua->request(uc($method), $uri, @params);
        if (not $response->{success}) {
            die sprintf "ERROR: %s: %s\n", $response->{reason}, $response->{content};
        }
        return $response;
    }
    1;
}

package MetaCPAN::API {
    use Moo;
    use Types::Standard qw( InstanceOf );
    has client => (
        is       => 'ro',
        isa      => InstanceOf(['MetaCPAN::Client']),
        required => 1,
    );

    sub fetch_release {
        my $self = shift;
        my ($query) = @_;
        return $self->client->call(GET => 'release/_search', $query);
    }
    1;
}

package main;
use MetaCPAN::Client;
use MetaCPAN::API;

my $client = MetaCPAN::Client->new(
    base_uri => ' https://fastapi.metacpan.org/v1/',
);
my $api = MetaCPAN::API->new(client => $client);

if (! @ARGV) {
    print "usage: $0 module-name[ ...]\n";
}
for my $module (@ARGV) {
    (my $query = $module) =~ s{ :: }{-}xg;
    my $response = $api->fetch_release({q => $query});
    print Dumper(decode_json($response->{content})->{hits}{hits}[0]);
}
