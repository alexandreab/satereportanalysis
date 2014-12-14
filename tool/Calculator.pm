package Calculator;

use strict;
use warnings;

use ReportExtractor;
use Output;
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
  my @cwe_ids = (121, 122, 124, 126, 127);

  my $tool;
  $tool = $self->{'report_extractor'}->extract_report(@cwe_ids);

  my @tools = ( "cppcheck", "ldra", "monoidics", "parasoft", "redlizard");

  foreach (@tools) {
    measures($_ , $tool->{$_});
  }

  my @table_values = to_table($tool,'values');
  my @table_metrics = to_table($tool,'metrics');


  my $output = new Output();

  print $output->to_latex(@table_values);
  print "\n\n";
  print $output->to_latex(@table_metrics);

}

sub measures {
  my ($tool_name, $data_tool) = @_;
  my $reports = $data_tool->{'values'};
  my $tp = $reports->{'TP'};
  my $fp = $reports->{'FP'};
  my $tn = $reports->{'TN'};
  my $fn = $reports->{'FN'};

  my $fp_rate = "NULL"; 
  my $precision = "NULL"; 
  my  $recall = "NULL";
  my  $fscore = "NULL";
  my $discrim_rate = "NULL";
  my   $flaws = $reports->{'TP'} +$reports->{'FN'};

  $fp_rate = $fp/($tp + $fp) if ($tp + $fp)>0;
  $precision = $tp/($tp + $fp) if ($tp + $fp)>0;
  $recall =  $tp/($tp +$fn) if ($tp +$fn)>0;
  $fscore = 2*($precision*$recall)/($precision+$recall) if ($precision ne "NULL" and $recall ne "NULL");
  $discrim_rate = $data_tool->{'metrics'}->{'Discrim'}/$flaws if $flaws>0;

  $data_tool->{'metrics'}->{'FP Rate'}  = point_precision($fp_rate,5);
  $data_tool->{'metrics'}->{'Precision'}  = point_precision($precision,5);
  $data_tool->{'metrics'}->{'Recall'}  = point_precision($recall,5);
  $data_tool->{'metrics'}->{'F-Score'}  = point_precision($fscore,5);
  $data_tool->{'metrics'}->{'Discrim Rate'}  = point_precision($discrim_rate,5);
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

  #TODO sort order of elements
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
