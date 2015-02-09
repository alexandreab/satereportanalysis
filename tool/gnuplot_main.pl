use strict;
use warnings;

use Data::Dumper;

use Calculator;
use Output;

my @cwe_ids = ();
my $calc = new Calculator("synthetic-c.xml");

my $output = new Output();

# {
#   @cwe_ids = (126,127);
#   my ($total_files, $values_ref, $metrics_ref) = $calc->calculate(@cwe_ids);
#   my @values = @$values_ref;
#   my @metrics = @$metrics_ref;
#   print $output->to_gnuplot("Buffer Overflows relacionados a Leitura de Buffer - Valores",@values);
#   print "\n\n";
#   print $output->to_gnuplot("Buffer Overflows relacionados a Leitura de Buffer - Metricas",@metrics);
#   print "%----------------------------------------------------------------%\n";
# }
# 
# {
#   @cwe_ids = (124);
#   my ($total_files, $values_ref, $metrics_ref) = $calc->calculate(@cwe_ids);
#   my @values = @$values_ref;
#   my @metrics = @$metrics_ref;
#   print $output->to_gnuplot("Buffer Overflows relacionados a Escrita de Buffer - Valores",@values);
#   print "\n\n";
#   print $output->to_gnuplot("Buffer Overflows relacionados a Escrita de Buffer - Metricas",@metrics);
#   print "%----------------------------------------------------------------%\n";
# }
# 
# {
#   @cwe_ids = (124,127);
#   my ($total_files, $values_ref, $metrics_ref) = $calc->calculate(@cwe_ids);
#   my @values = @$values_ref;
#   my @metrics = @$metrics_ref;
#   print $output->to_gnuplot("Buffer Overflows relacionados ao Limite Inicial do Buffer - Valores",@values);
#   print "\n\n";
#   print $output->to_gnuplot("Buffer Overflows relacionados ao Limite Inicial do Buffer - Metricas",@metrics);
#   print "%----------------------------------------------------------------%\n";
# }
# 
# {
#   @cwe_ids = (126);
#   my ($total_files, $values_ref, $metrics_ref) = $calc->calculate(@cwe_ids);
#   my @values = @$values_ref;
#   my @metrics = @$metrics_ref;
#   print $output->to_gnuplot("Buffer Overflows relacionados ao Limite Final do Buffer - Valores",@values);
#   print "\n\n";
#   print $output->to_gnuplot("Buffer Overflows relacionados ao Limite Final do Buffer - Metricas",@metrics);
#   print "%----------------------------------------------------------------%\n";
# }

 
{
  @cwe_ids = (121);
  my ($total_files, $values_ref, $metrics_ref) = $calc->calculate(@cwe_ids);
  my @values = @$values_ref;
  my @metrics = @$metrics_ref;

  open (FILE, ">> heap_values.dat") || die "problem opening heap_values.dat\n";
  print FILE "# Total de arquivos: $total_files #\n";
  print FILE $output->to_gnuplot("Buffer Overflows relacionados a Buffers em Heap - Valores",@values);
  close(FILE);

  open (FILE, ">> heap_metrics.dat") || die "problem opening heap_metrics.dat\n";
  print FILE "# Total de arquivos: $total_files #\n";
  print FILE $output->to_gnuplot("Buffer Overflows relacionados a Buffers em Heap - Metricas",@metrics);
  close(FILE);
}

{
  @cwe_ids = (122);
  my ($total_files, $values_ref, $metrics_ref) = $calc->calculate(@cwe_ids);
  my @values = @$values_ref;
  my @metrics = @$metrics_ref;
  print "# Total de arquivos: $total_files #\n";
  print "\n\n";
  print "#----------------------------------------------------------------#\n";

  open (FILE, ">> stack_values.dat") || die "problem opening stack_values.dat\n";
  print FILE "# Total de arquivos: $total_files #\n";
  print FILE $output->to_gnuplot("Buffer Overflows relacionados a Buffers em Stack - Valores",@values);
  close(FILE);

  open (FILE, ">> stack_metrics.dat") || die "problem opening stack_metrics.dat\n";
  print FILE "# Total de arquivos: $total_files #\n";
  print FILE $output->to_gnuplot("Buffer Overflows relacionados a Buffers em Stack - Metricas",@metrics);
  close(FILE);
}
