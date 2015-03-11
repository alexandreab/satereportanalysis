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
  my ($self, $ref_cwe_ids, $ref_tools) = @_;

  my @cwe_ids = @{$ref_cwe_ids};
  my @tools = @{$ref_tools};
  my $parser = XML::Parser->new(ErrorContext => 2, Style => "Tree");
  my $xso = XML::SimpleObject->new( $parser->parsefile($self->{'file_path'}) );

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

  return ($total_files,$tool);
}

sub extract_pair_report {
  my ($self, $ref_cwe_ids, $ref_tools) = @_;

  my @cwe_ids = @{$ref_cwe_ids};
  my @tools = @{$ref_tools};
  my $parser = XML::Parser->new(ErrorContext => 2, Style => "Tree");
  my $xso = XML::SimpleObject->new( $parser->parsefile($self->{'file_path'}) );

  my $tools_intersection = "$tools[0]-$tools[1]";

  my @tools_to_compare = @tools;

  push @tools, $tools_intersection;
  push @tools, "only_$tools[0]";
  push @tools, "only_$tools[1]";

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

      my $tool_tree;
      for my $tool_name(@tools_to_compare) {
        $tool_tree->{$tool_name}->{'TP'} = 0;
        $tool_tree->{$tool_name}->{'FN'} = 0;
        $tool_tree->{$tool_name}->{'FP'} = 0;
        $tool_tree->{$tool_name}->{'TN'} = 0;
        $tool_tree->{$tool_name}->{'D'} = 0;
      }

      $total_files++;
      foreach my $result($testcase->child('results')->children('participant')) {
        my $tool_name = $result->attribute('name');
        if(grep($tool_name, @tools)) {
          my $good_code = $result->child('good')->attribute('status');
          my $bad_code = $result->child('bad')->attribute('status');
          my $positive;

          if($bad_code eq 'true-positive') {
            $tool_tree->{$tool_name}->{'TP'} = 1;
            $positive=1;
          }
          elsif($bad_code eq 'false-negative') {
            $tool_tree->{$tool_name}->{'FN'} = 1;
          }

          if($good_code eq 'false-positive') {
            $tool_tree->{$tool_name}->{'FP'} = 1;
          }
          elsif($good_code eq 'true-negative') {
            $tool_tree->{$tool_name}->{'TN'} = 1;
            if($positive) {
              $tool_tree->{$tool_name}->{'D'} = 1;
            }
          }
        }
      }

      # Feeding first tool report
      $tool->{$tools[0]}->{'values'}->{'TP'} += $tool_tree->{$tools[0]}->{'TP'};
      $tool->{$tools[0]}->{'values'}->{'FN'} += $tool_tree->{$tools[0]}->{'FN'};
      $tool->{$tools[0]}->{'values'}->{'FP'} += $tool_tree->{$tools[0]}->{'FP'};
      $tool->{$tools[0]}->{'values'}->{'TN'} += $tool_tree->{$tools[0]}->{'TN'};

      # Feeding second tool report
      $tool->{$tools[1]}->{'values'}->{'TP'} += $tool_tree->{$tools[1]}->{'TP'};
      $tool->{$tools[1]}->{'values'}->{'FN'} += $tool_tree->{$tools[1]}->{'FN'};
      $tool->{$tools[1]}->{'values'}->{'FP'} += $tool_tree->{$tools[1]}->{'FP'};
      $tool->{$tools[1]}->{'values'}->{'TN'} += $tool_tree->{$tools[1]}->{'TN'};

      # Feeding True positives
      if($tool_tree->{$tools[0]}->{'TP'} == $tool_tree->{$tools[1]}->{'TP'}) {
        $tool->{$tools[2]}->{'values'}->{'TP'} += $tool_tree->{$tools[0]}->{'TP'};
      }
      else {
        $tool->{$tools[3]}->{'values'}->{'TP'} += $tool_tree->{$tools[0]}->{'TP'};
        $tool->{$tools[4]}->{'values'}->{'TP'} += $tool_tree->{$tools[1]}->{'TP'};
      }

      # Feeding False negatives
      if($tool_tree->{$tools[0]}->{'FN'} == $tool_tree->{$tools[1]}->{'FN'}) {
        $tool->{$tools[2]}->{'values'}->{'FN'} += $tool_tree->{$tools[0]}->{'FN'};
      }
      else {
        $tool->{$tools[3]}->{'values'}->{'FN'} += $tool_tree->{$tools[0]}->{'FN'};
        $tool->{$tools[4]}->{'values'}->{'FN'} += $tool_tree->{$tools[1]}->{'FN'};
      }

      # Feeding False positives
      if($tool_tree->{$tools[0]}->{'FP'} == $tool_tree->{$tools[1]}->{'FP'}) {
        $tool->{$tools[2]}->{'values'}->{'FP'} += $tool_tree->{$tools[0]}->{'FP'};
      }
      else {
        $tool->{$tools[3]}->{'values'}->{'FP'} += $tool_tree->{$tools[0]}->{'FP'};
        $tool->{$tools[4]}->{'values'}->{'FP'} += $tool_tree->{$tools[1]}->{'FP'};
      }

      # Feeding True negatives
      if($tool_tree->{$tools[0]}->{'TN'} == $tool_tree->{$tools[1]}->{'TN'}) {
        $tool->{$tools[2]}->{'values'}->{'TN'} += $tool_tree->{$tools[0]}->{'TN'};
      }
      else {
        $tool->{$tools[3]}->{'values'}->{'TN'} += $tool_tree->{$tools[0]}->{'TN'};
        $tool->{$tools[4]}->{'values'}->{'TN'} += $tool_tree->{$tools[1]}->{'TN'};
      }

    }
  }

  return ($total_files,$tool);
}

1;
