use strict;
use warnings;

use Data::Dumper;

use Calculator;
use Output;

my @cwe_ids = ();
#my $calc = new Calculator("synthetic-c121-122.xml");
my $calc = new Calculator("synthetic-c.xml");

my $output = new Output();

 
{
  @cwe_ids = (121);
  my ($values_ref, $metrics_ref) = $calc->calculate(@cwe_ids);
  my @values = @$values_ref;
  my @metrics = @$metrics_ref;
  print $output->to_csv("Buffer Overflows relacionados a Buffers em Heap - Valores",@values);
  print "\n\n";
  print $output->to_csv("Buffer Overflows relacionados a Buffers em Heap - Metricas",@metrics);
  print "\n\n";
  print "\n\n";
}

{
  @cwe_ids = (122);
  my ($values_ref, $metrics_ref) = $calc->calculate(@cwe_ids);
  my @values = @$values_ref;
  my @metrics = @$metrics_ref;
  print $output->to_csv("Buffer Overflows relacionados a Buffers em Stack - Valores",@values);
  print "\n\n";
  print $output->to_csv("Buffer Overflows relacionados a Buffers em Stack - Metricas",@metrics);
  print "\n";
}
