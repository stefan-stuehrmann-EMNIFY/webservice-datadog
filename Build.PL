use 5.006;
use strict;
use warnings;
use Module::Build;

my $class = Module::Build->subclass(
	code =>
	q|
		# Override 'test' to support running extended tests in the xt/
		# directory.
		sub ACTION_test
		{
			my ( $self ) = @_;

			$self->recursive_test_files(1);

			$self->test_files( 't', 'xt' )
				if $ENV{'RELEASE_TESTING'};

			return $self->SUPER::ACTION_test();
		}

		# Force running extended tests when testing the distribution.
		sub ACTION_disttest
		{
			my ( $self ) = @_;

			local $ENV{ RELEASE_TESTING } = 1;

			return $self->SUPER::ACTION_disttest();
		}
	|,
);

my $builder = $class->new(
	module_name          => 'WebService::DataDog',
	license              => 'GPL_3',
	dist_author          => q|Jennifer Pinkham <jpinkham@cpan.org>|,
	dist_version_from    => 'lib/WebService/DataDog.pm',
	build_requires       =>
	{
		'Scalar::Util'         => 0,
		'Storable'             => 0,
		'Test::Exception'      => 0,
		'Test::Most'           => 0,
		'Test::FailWarnings'   => 0,
	},
	requires             =>
	{
		'Carp'                 => 0,
		'Data::Dumper'         => 0,
		'Data::Validate::Type' => "1.1.0",
		'HTTP::Request'        => 0,
		'JSON'                 => 0,
		'LWP::UserAgent'       => 0,
		'Try::Tiny'            => 0,
		'Class::Load'          => 0,
		'perl'                 => 5.006,
	},
	add_to_cleanup       => [ 'WebService-DataDog-*' ],
	create_makefile_pl   => 'traditional',
	recursive_test_files => 1,
	configure_requires   =>
	{
		'Module::Build'  => 0,
	},
	meta_merge           =>
	{
		resources        =>
		{
			repository  => 'https://github.com/jpinkham/webservice-datadog.git',
			homepage    => 'https://metacpan.org/release/WebService-DataDog',
			bugtracker  => 'https://github.com/jpinkham/webservice-datadog/issues',
		},
	},
);

$builder->create_build_script();
