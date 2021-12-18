#! perl -w
use strict;
use v5.10.1;

use ExtUtils::MakeMaker 6.55_02;

my %makefile_arguments = (
    NAME          => 'MooX::Role::HTTP::Tiny',
    VERSION_FROM  => 'lib/MooX/Role/HTTP/Tiny.pm',
    ABSTRACT_FROM => 'lib/MooX/Role/HTTP/Tiny.pm',
    AUTHOR        => 'Abe Timmerman <abeltje@cpan.org>',
    LICENSE       => 'perl',

    PREREQ_PM => {
        'HTTP::Tiny'           => '0.012',
        'Moo'                  => '2.003',
        'Types::Standard'      => '1.008',
        'namespace::autoclean' => '0.28',
    },
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '6.55_02',
    },

    BUILD_REQUIRES => {
        'Test::Fatal'      => '0.01',
        'Test::Simple'     => '0.88',    # done_testing()
        'Test::Warnings'   => '0.028',
        'Test::MockObject' => '1.2018',
    },

    MIN_PERL_VERSION => '5.010001',

    META_ADD => {
        'meta-spec' => {
            version    => 2,
        },
#        'resources' => {
#            homepage  => 'https://github.com/abeltje/MooX-Role-HTTP-Tiny',
#            repository => {
#                type   => 'git',
#                url    => 'git@github.com:abeltje/MooX-Role-HTTP-Tiny.git',
#                web    => 'https://github.com/abeltje/MooX-Role-HTTP-Tiny.git',
#            },
#            x_IRC      => 'irc://irc.perl.org/#amsterdam.pm',
#        },
    },
);
WriteMakefile(%makefile_arguments);