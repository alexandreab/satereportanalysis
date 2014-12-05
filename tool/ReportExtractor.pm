package ReportExtractor;

use strict;
use warnings;

use XML::Parser;
use XML::SimpleObject;

use Data::Dumper;

sub new {
  my ($class, $file_path) = @_;
  my $self = {};
  bless($self,$class);
  
  $self->{'file_path'} = $file_path;

  return $self;
}

sub extract_report {
  my ($self) = @_;

  my $parser = XML::Parser->new(ErrorContext => 2, Style => "Tree");
  my $xso = XML::SimpleObject->new( $parser->parsefile($self->{'file_path'}) );

  my @tools = ( "cppcheck", "ldra", "monoidics", "parasoft", "redlizard");
  my @cwe_ids = (121, 122, 124, 126, 127);

  my $tool;
  foreach (@tools) {
    $tool->{$_}->{'values'}->{'TP'}=0;
    $tool->{$_}->{'values'}->{'FN'}=0;
    $tool->{$_}->{'values'}->{'TN'}=0;
    $tool->{$_}->{'values'}->{'FP'}=0;
    $tool->{$_}->{'metrics'}->{'Discrim'}=0;
  }

  my $total_files=0;

  foreach my $testcase ($xso->child('synthetic_results')->children('testcase')) {

    my $path_file = $testcase->child('sources')->child('file')->value;
    my $file_name = "NULL";

    if($path_file =~ m/\/(CWE\d{3}[^\/]+)\.c|cpp$/)
    {
      $file_name = $1;
    }

    my $cwe_id = $testcase->attribute('cweid');
    if($cwe_id ~~ @cwe_ids) {
      $total_files++;
      foreach my $result($testcase->child('results')->children('participant')) {
        my $tool_name = $result->attribute('name');
        my $good_code = $result->child('good')->attribute('status');
        my $bad_code = $result->child('bad')->attribute('status');
        my $positive;

        if($bad_code eq 'true-positive') {
          $tool->{$tool_name}->{'values'}->{'TP'}++;
          $positive=1;
        }
        elsif($bad_code eq 'false-negative') {
          $tool->{$tool_name}->{'values'}->{'FN'}++;
        }

        if($good_code eq 'false-positive') {
          $tool->{$tool_name}->{'values'}->{'FP'}++;
        }
        elsif($good_code eq 'true-negative') {
          $tool->{$tool_name}->{'values'}->{'TN'}++;

          if($positive) {
            $tool->{$tool_name}->{'metrics'}->{'Discrim'}++;
          }
        }
      }
    }
  }

  print "Total de arquivos analisados: $total_files\n";
  return $tool;
}

1;
