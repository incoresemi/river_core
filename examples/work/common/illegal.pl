#!/usr/bin/env perl
use v5.10.0;
use warnings;
srand($ARGV[1]);
my @illegal_instr_list = ();
foreach my $count (0 .. 100) {
    my $d = int(rand(4294967295));
    my $hex = sprintf("0x%X", $d);
    my $illegal = `echo "DASM(0x$hex)" | spike-dasm`;
    if ($illegal =~ /un/ && $illegal !~ /counter/) {
      push @illegal_instr_list, ".word $hex";
      push @illegal_instr_list, "
";
    }
  }
my $filename = $ARGV[0];
open(FH, '>', $filename) or die $!;
print FH @illegal_instr_list;
close(FH);