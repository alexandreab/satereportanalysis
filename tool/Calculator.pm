package Calculator;

use strict;
use warnings;

use ReportExtractor;
use Data::Dumper;

sub new {
  my ($class, $file_path) = @_;
  my $self = {};
  bless($self,$class);
  
  $self->{'report_extractor'} = new ReportExtractor($file_path);

  return $self;
}

sub calculate {
  my ($self) = @_;
  my $tool;
  $tool = $self->{'report_extractor'}->extract_report();

  my @tools = ( "cppcheck", "ldra", "monoidics", "parasoft", "redlizard");

  foreach (@tools) {
    measures($_ , $tool->{$_});
  }

  my @table_values = to_table($tool,'values');
  my @table_metrics = to_table($tool,'metrics');

  print to_latex(@table_values);
  print "\n\n";
  print to_latex(@table_metrics);

}

sub measures {
  my ($tool_name, $data_tool) = @_;
  my $reports = $data_tool->{'values'};
  my $title_line = "\t\t\\textbf{$tool_name} & TP & FP & TN & None\\\\\n";
  my $fp_rate = "NULL"; 
  my $precision = "NULL"; 
  my  $recall = "NULL";
  my  $fscore = "NULL";
  my   $flaws = $reports->{'TP'} +$reports->{'FN'};
  my $discrim = "NULL";

  $fp_rate = $reports->{'FP'}/($reports->{'TP'} +$reports->{'FP'}) if ($reports->{'TP'}+$reports->{'FP'})>0;
  $precision = $reports->{'TP'}/($reports->{'TP'} +$reports->{'FP'}) if ($reports->{'TP'}+$reports->{'FP'})>0;
  $recall =  $reports->{'TP'}/($reports->{'TP'} +$reports->{'FN'}) if ($reports->{'TP'}+$reports->{'FN'})>0;
  $fscore = 2*($precision*$recall)/($precision+$recall) if ($precision ne "NULL" and $recall ne "NULL");
  $discrim = $data_tool->{'metrics'}->{'Discrim'}/$flaws if $flaws>0;

  $data_tool->{'metrics'}->{'FP Rate'}  = point_precision($fp_rate,5);
  $data_tool->{'metrics'}->{'Precision'}  = point_precision($precision,5);
  $data_tool->{'metrics'}->{'Recall'}  = point_precision($recall,5);
  $data_tool->{'metrics'}->{'F-Score'}  = point_precision($fscore,5);
  $data_tool->{'metrics'}->{'Discrim Rate'}  = point_precision($discrim,5);
}

sub to_latex {
  my (@table) = @_;

  my $tool_name;
  my $columns;

  my $table_latex;

  my $table_values = "";
  my $table_values_header = "";
  my $table_values_body = "";
  my $table_values_foot = "";

  $table_values_header .= "\\begin{table}[h]\n";
  $table_values_header .= "\t\\centering\n";
  $table_values_header .= "\t\\label{tabtools}\n";

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
  $table_values_foot .= "\t\\caption{Ferramentas Analisadas no SATE IV utilizadas nesse trabalho}\n";
  $table_values_foot .= "\\end{table}\n";

  $table_values = $table_values_header.$table_values_body.$table_values_foot;

  return $table_values;

}

sub to_csv {
  my (@table) = @_;
  my $table_values = "";

  foreach my $line_ref (@table) {
    my @line = @$line_ref;
    my $latex_line = "";
    $latex_line = join(',', @line)." \n";
    $table_values .= $latex_line;
  }

  return $table_values;
}

sub to_table {
  my ($data,$type) = @_;

  my $tool_name;
  my $columns;

  foreach (keys %$data) {
    $tool_name = $_;
  }

  my @table = ();
  my @line = ();
  my @values = ();

  push @line, "Ferramenta/Valor";

  foreach (keys $data->{$tool_name}->{$type})
  {
    push @line, $_;
    push @values, $_;
  }

  push @table, [@line];

  foreach my $tool_alias (keys %$data) {
    @line = ();
    push @line, $tool_alias;

    foreach my $param(@values) {
      push @line, $data->{$tool_alias}->{$type}->{$param};
    }

    push @table, [@line];
  }

  return @table;
}

sub point_precision {
  my ($value,$prec) = @_;
  if ($value =~ /^[^N].+$/ ) {
    my $pow = 10**$prec;
    $value+=0.5/$pow;
    $value = int($value*$pow);
    return $value/$pow;
  }
  else {
    return $value;
  }
}

1;
