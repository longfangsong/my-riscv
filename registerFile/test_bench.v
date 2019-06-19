`timescale 1ns/100ps
`include "registerFile.v"

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $finish; \
        end

module test_tb;
  reg         clk = 0;
  reg         input_enable    = 0;
  reg  [4:0]  output_select_1 = 0;
  reg  [4:0]  output_select_2 = 0;
  reg  [4:0]  input_select    = 0;
  wire [31:0] output_value_1     ;
  wire [31:0] output_value_2     ;
  reg  [31:0] input_value     = 0;
  RegisterFile registerFile(
    clk,
    input_enable,   
    output_select_1,
    output_select_2,
    input_select,
    output_value_1,
    output_value_2,
    input_value    
  );
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test_tb);
    clk = #1 ~clk;
    // test case 1
    // try to set x0
    input_select = 0;
    input_value = 'h3f3f3f3f;
    clk = #1 ~clk;
    `assert(output_value_1, 'h00000000);
    input_enable = 1;
    input_select = 1;
    input_value = 'h3f3f3f3f;
    clk = #1 ~clk;
    output_select_1 = 1;
    #0
    `assert(output_value_1, 'h3f3f3f3f);
    clk = #1 ~clk;
    input_value = input_value << 2;
    clk = #1 ~clk;
    input_value = $signed(input_value) >>> 3;
    clk = #1 ~clk;
    $finish;
   end
endmodule