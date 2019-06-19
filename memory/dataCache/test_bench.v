`timescale 1ns/100ps
`include "dataCache.v"

module test_tb;
  reg         clk     = 0;
  reg         mode    = 1;
  reg  [2:0]  width   = 'b000;
  reg  [5:0]  select  = 'b000_000;
  wire [31:0] out;
  reg  [31:0] in      = 'h0000_0000;
  DataCache dataCache(
    clk,
    mode,
    width,
    select,
    out,
    in
  );
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test_tb);
    #1
    mode = 0;
    width = 'b010;
    select = 'b000_000;
    in = 'h0a0a_0a0a;
    clk = ~clk;
    #1
    mode = 1;
    width = 'b101;
    select = 'b000_000;
    clk = ~clk;
    #1
    mode = 1;
    width = 'b100;
    select = 'b000_000;
    clk = ~clk;
    #1
    mode = 1;
    width = 'b010;
    select = 'b000_000;
    clk = ~clk;
    #1
    mode = 0;
    width = 'b001;
    select = 'b000_000;
    in = 'h0000_0b0b;
    clk = ~clk;
    #1
    mode = 1;
    width = 'b101;
    select = 'b000_000;
    clk = ~clk;
    #1
    mode = 1;
    width = 'b100;
    select = 'b000_000;
    clk = ~clk;
    #1
    mode = 1;
    width = 'b010;
    select = 'b000_000;
    clk = ~clk;
    #1
    $finish;
   end
endmodule