use strict;
use warnings;

use Data::Dumper;

use lib 'lib';

use Calculator;
use Output;

my @cwe_ids = ();
my $calc = new Calculator("data/synthetic-c.xml");

my $output = new Output();

my @tools = ("monoidics", "redlizard");
{
  @cwe_ids = (126,127);
  my ($total_files, $values_ref, $metrics_ref) = $calc->compare(\@cwe_ids,\@tools);
  my @values = @$values_ref;
  print "Total de casos de teste: $total_files\n";
  print $output->to_latex("Buffer Overflows relacionados a Leitura de Buffer - Valores",@values);
  print "\n\n";
  print "%----------------------------------------------------------------%\n";
}


{
  @cwe_ids = (124);
  my ($total_files, $values_ref, $metrics_ref) = $calc->compare(\@cwe_ids,\@tools);
  my @values = @$values_ref;
  print "Total de casos de teste: $total_files\n";
  print $output->to_latex("Buffer Overflows relacionados a Escrita de Buffer - Valores",@values);
  print "\n\n";
  print "%----------------------------------------------------------------%\n";
}

 
{
  @cwe_ids = (121);
  my ($total_files, $values_ref, $metrics_ref) = $calc->compare(\@cwe_ids,\@tools);
  my @values = @$values_ref;
  print "Total de casos de teste: $total_files\n";
  print $output->to_latex("Buffer Overflows relacionados a Buffers em Heap - Valores",@values);
  print "\n\n";
  print "%----------------------------------------------------------------%\n";
}

{
  @cwe_ids = (122);
  my ($total_files, $values_ref, $metrics_ref) = $calc->compare(\@cwe_ids,\@tools);
  my @values = @$values_ref;
  print "Total de casos de teste: $total_files\n";
  print $output->to_latex("Buffer Overflows relacionados a Buffers em Stack - Valores",@values);
  print "\n\n";
  print "%----------------------------------------------------------------%\n";
}
