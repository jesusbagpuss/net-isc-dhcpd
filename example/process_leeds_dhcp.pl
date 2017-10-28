#!/usr/bin/env perl
use strict;
use warnings;
#use if -d 'lib', lib => 'lib'; # include libraries from ./lib

#use if -d '/root/perl5/github/net-isc-dhcpd/lib', lib => qw( /root/perl5/github/net-isc-dhcpd/lib lib );

use Net::ISC::DHCPd::Config;
use Data::Dumper;
use Getopt::Long;
 
my $verbose = 0;
my $help = 0;
my $dump_depth = 0;
my @output;

Getopt::Long::Configure( 'permute' ); 

GetOptions(
	'help|?'     => \$help,
	'verbose+'   => \$verbose,
	'dump_depth' => \$dump_depth,
	'output:s'    => \@output,
);

$Data::Dumper::Maxdepth = $dump_depth;


my $dhcpfile = shift @ARGV;
my $new_dhcpfile = shift @ARGV;


my $config = Net::ISC::DHCPd::Config->new( file => $dhcpfile );
$config->parse( 'recursive' );
#includerator( $config );

my $new_config;
$new_config = Net::ISC::DHCPd::Config->new( file => $new_dhcpfile ) if defined $new_dhcpfile;
 
$new_config->parse( 'recursive' ) if defined $new_config;

foreach my $field( @output ){
	print "Data for $field (existing config)\n";
	foreach( $config->find_all_children( $field ) ){
		print Dumper( $_ );
	}

	if( defined $new_config ){
		print "Data for $field (new config)\n";
		foreach( $config->find_all_children( $field ) ){
			print Dumper( $_ );
		}
	}
}

#foreach( $config->find_all_children( "include" ) ){
#  $_->generate_with_include(1);
#}


#foreach( $config->find_all_children( "option" ) ){
#  print $_->generate,"\n\n";
#}



#for my $include ($config->includes) {
#	$include->parse;
#}

sub includerator
{
	my( $i ) = @_;

	for my $include ( $i->find_all_children( 'include' ) ){
		print "INCLUDING File: ", $include->{file}->{file},"\n";
		$include->parse;
		includerator( $include );
	}

}
