use strict;
use warnings;

use Calculator;

my @cwe_ids = ();
my $calc = new Calculator("synthetic-c.xml");

@cwe_ids = (126, 127);
$calc->calculate("Buffer Overflows relacionados a Leitura de Buffer",\@cwe_ids);
print "%----------------------------------------------------------------%\n";

@cwe_ids = (124);
$calc->calculate("Buffer Overflows relacionados a Escrita de Buffer",\@cwe_ids);
print "%----------------------------------------------------------------%\n";

@cwe_ids = (124, 127);
$calc->calculate("Buffer Overflows relacionados ao limite inicial do Buffer",\@cwe_ids);
print "%----------------------------------------------------------------%\n";

@cwe_ids = (126);
$calc->calculate("Buffer Overflows relacionados ao limite final do Buffer",\@cwe_ids);
print "%----------------------------------------------------------------%\n";

@cwe_ids = (121);
$calc->calculate("Buffer Overflows relacionados a Buffers em Heap",\@cwe_ids);
print "%----------------------------------------------------------------%\n";

@cwe_ids = (122);
$calc->calculate("Buffer Overflows relacionados a Buffers em Stack",\@cwe_ids);
print "%----------------------------------------------------------------%\n";
