module ALU(
  input  wire [3:0]  func,
  input  wire [31:0] input_value1,
  input  wire [31:0] input_value2,
  output reg  [31:0] output_value
);
  always @(*) begin
    case (func)
      'b0000:  output_value <= $signed(input_value1) + $signed(input_value2);
      'b1000:  output_value <= $signed(input_value1) - $signed(input_value2);
      'b0001:  output_value <= input_value1 << input_value2[4:0];
      'b0010:  output_value <= {{31'b0},$signed(input_value1) < $signed(input_value2)};
      'b0011:  output_value <= {{31'b0},$unsigned(input_value1) < $unsigned(input_value2)};
      'b0100:  output_value <= input_value1 ^ input_value2;
      'b0101:  output_value <= input_value1 >>> input_value2[4:0];
      'b1101:  output_value <= $signed(input_value1) >>> input_value2[4:0];
      'b0110:  output_value <= input_value1 | input_value2;
      'b0111:  output_value <= input_value1 & input_value2;
      default: output_value <= 32'hzzzzzzzz;
    endcase
  end
endmodule // ALU