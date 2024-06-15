#!/usr/bin/gnuplot

set terminal pngcairo enhanced font 'Verdana,12'
set output 'throughput_plot.png'

set title "Throughput of TCP Connections Over Time"
set xlabel "Time"
set ylabel "Throughput (Kbps)"

set style data linespoints

plot "throughput_data_1.txt" w lines
