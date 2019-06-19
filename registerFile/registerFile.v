module RegisterFile(
  input  wire clk,

  input  wire [4:0]  output_select_1,
  output wire [31:0] output_value_1,

  input  wire [4:0]  output_select_2,
  output wire [31:0] output_value_2,

  input  wire input_enable,
  input  wire [4:0] input_select,
  input  wire [31:0] input_value
);
  // x0 is zero forever
  reg [31:0]registers[31:1];
  assign output_value_1 = output_select_1 == 0 ? 'b0000 : registers[output_select_1];
  assign output_value_2 = output_select_2 == 0 ? 'b0000 : registers[output_select_2];
  always @(negedge clk) begin
    if (input_enable && input_select != 0) begin
      registers[input_select] <= input_value;
    end
  end
endmodule