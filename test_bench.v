`timescale 1ns/100ps
`include "cpu.v"

module test_tb;
  reg clk = 1;
  reg [31:0] command;
  CPU cpu(
    clk
  );
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test_tb);
    #1
    clk = ~clk;
    #1
    clk = ~clk;
    #1
    clk = ~clk;
    #1
    clk = ~clk;
    #1
    clk = ~clk;
    #1
    clk = ~clk;
    #1
    clk = ~clk;
    #1
    clk = ~clk;
    #1
    clk = ~clk;
    #1
    clk = ~clk;
    #1
    $finish;
   end
endmodule