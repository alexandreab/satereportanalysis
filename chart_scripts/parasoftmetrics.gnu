set term post eps

set style fill solid 0.8 border -1


WIDTH = 0.4
set boxwidth WIDTH
set yrange[0:1.13]
set xrange[0.25:4.75]
set grid ytics lc rgb "#bbbbbb" lw 1 lt 0
set ytics 0.1

set xtics ("Precision" 1, "Recall" 2, "Discrim Rate" 3, "F-Score" 4) font ",24"
set key samplen 6 spacing 1.5 font ",24"
set title font ",24"

colA = 8
colB = 9

	set output 'ParasoftMetrics_read-write.eps'
	set title 'Parasoft Read and Write Access'
	colAlabel = "Leitura"
	colBlabel = "Escrita"
	filename = 'tool_metrics_read-write.dat'
	plot filename using ($12-WIDTH/2):colA ti colAlabel linecolor rgb "blue" with boxes,\
		 filename using ($12-WIDTH/2):(column(colA)+0.07):colA ti "" with labels rotate by 45,\
		 filename using ($12+WIDTH/2):colB ti colBlabel linecolor rgb "red" with boxes,\
		 filename using ($12+WIDTH/2):(column(colB)+0.07):colB ti "" with labels rotate by 45

	set output 'ParasoftMetrics_under-over.eps'
	set title 'Parasoft Under and Over Bound Access'
	colAlabel = "Under"
	colBlabel = "Over"
	filename = 'tool_metrics_under-over.dat'
	plot filename using ($12-WIDTH/2):colA ti colAlabel linecolor rgb "#008B8B" with boxes,\
		 filename using ($12-WIDTH/2):(column(colA)+0.07):colA ti "" with labels rotate by 45,\
		 filename using ($12+WIDTH/2):colB ti colBlabel linecolor rgb "#B22222" with boxes,\
		 filename using ($12+WIDTH/2):(column(colB)+0.07):colB ti "" with labels rotate by 45

	set output 'ParasoftMetrics_heap-stack.eps'
	set title 'Parasoft Heap and Stack Allocation'
	colAlabel = "Heap"
	colBlabel = "Stack"
	filename = 'tool_metrics_heap-stack.dat'
	plot filename using ($12-WIDTH/2):colA ti colAlabel linecolor rgb "#006400" with boxes,\
		 filename using ($12-WIDTH/2):(column(colA)+0.07):colA ti "" with labels rotate by 45,\
		 filename using ($12+WIDTH/2):colB ti colBlabel linecolor rgb "#800000" with boxes,\
		 filename using ($12+WIDTH/2):(column(colB)+0.07):colB ti "" with labels rotate by 45
