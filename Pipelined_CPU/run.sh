#!/bin/bash

objectfile=$1
testbench_file=$(ls ./*_tb.v 2>/dev/null)
verilog_files=$(ls *.v 2>/dev/null | grep -v "_tb.v")
iverilog_command="iverilog -o ./$objectfile $testbench_file $verilog_files"

echo "Testbench file: $testbench_file"
echo "Source files: $verilog_files"
echo "Compilation command: $iverilog_command"

vvp -n ./$objectfile -lxt2
isGtkWaveRunning=$(ps -ef | grep gtkwave | grep -v "grep" | wc -l)
if [ $isGtkWaveRunning -eq 0 ]; then
    gtkwave wave.vcd 
else
    echo "gtkwave is running"
fi