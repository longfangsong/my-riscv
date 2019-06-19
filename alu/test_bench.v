`timescale 1ns/100ps
`include "alu.v"

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end

module test_tb;
  reg  [3:0]  func = 4'b0000;
  reg  [31:0] input_value1 = 32'd10;
  reg  [31:0] input_value2 = 32'd20;
  wire [31:0] output_value;
  ALU alu(
    func,
    input_value1,
    input_value2,
    output_value
  );
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test_tb);
    #1
    func = 'b1000;
    #1
    func = 'b0001;
    #1
    input_value1 = 'hfffffff6;
    input_value2 = 'b0001;
    func = 'b0101;
    #1
    func = 'b1101;
    #1
    #1
    $finish;
   end
endmodule