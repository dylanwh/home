#!/usr/bin/perl
use strict;
use warnings;
use XML::LibXML;
use Palm::Address;
use Getopt::Long;
use YAML::Syck;

my $infile  = "$ENV{HOME}/pim/contacts.xml";
my $outfile = "AddressDB.pdb";

Getopt::Long::Configure('gnu_getopt');
GetOptions('infile|i=s', \$infile, 'outfile|o=s', \$outfile);

my $total  = 0;
my $parser = new XML::LibXML;
my $doc    = $parser->parse_file($infile);
my $pdb    = new Palm::Address;

$pdb->addCategory('personal');
$pdb->addCategory('internet');

$pdb->{appinfo}{fieldLabels}{custom1} = 'Nick';

foreach my $contact ($doc->findnodes("//contact")) {
	my $nick = $contact->getAttribute('id');
	my $rec = $pdb->new_Record;
	my ($first, $last) = name_split(scalar $contact->findvalue("./name"));
	$rec->{fields}{firstName}   = $first;
	$rec->{fields}{name}        = $last;
	$rec->{fields}{city}        = $contact->findvalue('./city');
	$rec->{fields}{state}       = $contact->findvalue('./state');
	$rec->{fields}{country}     = $contact->findvalue('./country');
	$rec->{fields}{zipCode}     = $contact->findvalue('./zip');
	$rec->{fields}{address}     = $contact->findvalue('./address');
	$rec->{fields}{custom1}     = $nick;


	my @phone;
	foreach my $phone ($contact->findnodes("./phone")) {
		my $label = $phone->getAttribute('label');
		my %phone = (
			rank  => 5,
			value => $phone->to_literal,
		);
		if (not $label) {
			$phone{rank}  = 1;
			$phone{label} = find_label('Main');
		} elsif ($label eq 'work') {
			$phone{label} = find_label('Work');
		} elsif ($label eq 'mobile') {
			$phone{label} = find_label('Mobile');
		} elsif ($label eq 'alt' or $label eq 'other') {
			$phone{label} = find_label('Other');
		}
		push @phone, \%phone;
	}

	my @email;
	foreach my $email ($contact->findnodes("./email")) {
		my $label = $email->getAttribute('label');
		my %email = (
			rank  => 5,
			label => find_label('E-mail'),
			value => $email->to_literal,
		);
		if (not $label) {
			$email{rank} = 1;
		}
		push @email, \%email;
	}

	@phone = sort { $b->{rank} <=> $a->{rank} } @phone;
	@email = sort { $b->{rank} <=> $a->{rank} } @email;


	if (@phone) {
		print "$nick: Display Main phone\n";
		$rec->{phoneLabel}{display} = find_label('Main');
		$rec->{category} = find_category($pdb, 'personal');
	} elsif (@email) {
		print "$nick: Display email\n";
		$rec->{phoneLabel}{display} = find_label('E-mail');
		$rec->{category} = find_category($pdb, 'internet');
	}

	if (@phone + @email > 5) {
		pop @phone while @phone > 4;
	}

	my @all = (@phone, @email);

	foreach my $n (1 .. 5) {
		$rec->{phoneLabel}{"phone$n"} = $all[$n - 1]{label};
		$rec->{fields}{"phone$n"} = $all[$n - 1]{value};
	}

	$pdb->append_Record($rec);
	$total++;
}

$pdb->Write($outfile);

print "Wrote $total contacts.\n";

sub name_split {
	local $_ = shift;
	if (/^(\S+) ?(.*)$/) {
		return ($1, $2);
	} else {
		die "Bad: $_\n";
	}
}

sub find_category {
	my ($pdb, $key) = @_;
	find(sub { $_->{name} eq $key }, @{ $pdb->{appinfo}{categories} });
}

sub find_label {
	my ($key) = @_;
	find(sub { $_ eq $key }, @Palm::Address::phoneLabels);
}

sub find (&@) {
	my ($f, @l) = @_;
	my $idx = 0;
	foreach (@l) {
		if ($f->($_, $idx)) {
			return $idx;
		}
		$idx++;
	}
	return undef;
}
