use strict;
use warnings;

use Data::Dumper;

use Calculator;
use Output;

my @cwe_ids = ();
#my $calc = new Calculator("synthetic-c121-122.xml");
my $calc = new Calculator("synthetic-c.xml");

my $output = new Output();

# {
#   @cwe_ids = (126, 127);
#   my (@values, @metrics) = $calc->calculate("Buffer Overflows relacionados a Leitura de Buffer",\@cwe_ids);
#   print $output->to_latex("Buffer Overflows relacionados a Leitura de Buffer", @table_values);
#   print "\n\n";
#   print $output->to_latex("Buffer Overflows relacionados a Leitura de Buffer", @table_metrics);
#   print "%----------------------------------------------------------------%\n";
# }
# 
# {
#   @cwe_ids = (124);
#   my (@values, @metrics) = $calc->calculate("Buffer Overflows relacionados a Escrita de Buffer",\@cwe_ids);
#   print "%----------------------------------------------------------------%\n";
# }

# @cwe_ids = (124, 127);
# $calc->calculate("Buffer Overflows relacionados ao limite inicial do Buffer",\@cwe_ids);
# print "%----------------------------------------------------------------%\n";
# 
# @cwe_ids = (126);
# $calc->calculate("Buffer Overflows relacionados ao limite final do Buffer",\@cwe_ids);
# print "%----------------------------------------------------------------%\n";
 
{
  @cwe_ids = (121);
  my ($values_ref, $metrics_ref) = $calc->calculate(@cwe_ids);
  my @values = @$values_ref;
  my @metrics = @$metrics_ref;
  print $output->to_latex("Buffer Overflows relacionados a Buffers em Heap - Valores",@values);
  print "\n\n";
  print $output->to_latex("Buffer Overflows relacionados a Buffers em Heap - Metricas",@metrics);
  print "%----------------------------------------------------------------%\n";
}

{
  @cwe_ids = (122);
  my ($values_ref, $metrics_ref) = $calc->calculate(@cwe_ids);
  my @values = @$values_ref;
  my @metrics = @$metrics_ref;
  print $output->to_latex("Buffer Overflows relacionados a Buffers em Stack - Valores",@values);
  print "\n\n";
  print $output->to_latex("Buffer Overflows relacionados a Buffers em Stack - Metricas",@metrics);
  print "%----------------------------------------------------------------%\n";
}
