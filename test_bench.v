`timescale 1ns/100ps
`include "cpu.v"

module test_tb;
  reg clk = 1;
  reg [31:0] command;
  integer i = 0;
  CPU cpu(
    clk
  );
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test_tb);
    for (i = 0; i<20; ++i) begin
      #1 clk = ~clk;
    end
    $finish;
   end
endmodule