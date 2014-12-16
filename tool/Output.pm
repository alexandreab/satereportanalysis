package Output;

use strict;
use warnings;

sub new {
  my ($class) = @_;
  my $self = {};
  bless($self,$class);

  $self->{'counter'} = 0;
  
  return $self;
}


sub to_latex {
  my ($self, $table_title, @table) = @_;

  my $tool_name;
  my $columns;

  my $table_label = "tabreport_$self->{counter}";

  my $table_latex;

  my $table_values = "";
  my $table_values_header = "";
  my $table_values_body = "";
  my $table_values_foot = "";

  $table_values_header .= "\\begin{table}[h]\n";
  $table_values_header .= "\t\\centering\n";
  $table_values_header .= "\t\\label{$table_label}\n";

  my $reference = $table[0];
  my @first_line = @$reference;
  $columns = @first_line;
  $table_values_header .= "\t\\begin{tabular}{"."c"x$columns."}\n";
  $table_values_header .= "\t\t\\toprule\n";
  $table_values_header .= "\t\t".join(' & ', @first_line)." \\\\\n";
  $table_values_header .= "\t\t\\midrule\n";
  
  foreach my $line_ref (@table) {
    my @line = @$line_ref;
    my $latex_line = "";
    if($line[0] ne 'Ferramenta/Valor') {
      $latex_line = "\t\t".join(' & ', @line)." \\\\\n";
      $table_values_body .= $latex_line;
    }
  }
  $table_values_foot .= "\t\t\\bottomrule\n";
  $table_values_foot .= "\t\\end{tabular}\n";
  $table_values_foot .= "\t\\caption{$table_title}\n";
  $table_values_foot .= "\\end{table}\n";

  $table_values = $table_values_header.$table_values_body.$table_values_foot;

  return $table_values;

}

sub to_csv {
  my ($self, $table_title, @table) = @_;
  my $table_values = "";

  foreach my $line_ref (@table) {
    my @line = @$line_ref;
    my $latex_line = "";
    $latex_line = join(',', @line)." \n";
    $table_values .= $latex_line;
  }

  return $table_values;
}

1;
