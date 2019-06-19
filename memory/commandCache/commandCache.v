module CommandCache(
  input  wire [31:0] address,
  output reg  [31:0] content
);
  always @(address) begin
  case(address)
    'h0:  content <= 'b0000_0000_0101_00000_000_00010_0010011; // mov x2, 5
    'h4:  content <= 'b0000_0000_0111_00000_000_00001_0010011; // mov x1, 7
    'h8:  content <= 'b0000000_00010_00001_000_00011_0110011;  // add x3, x2, x1
    'hc:  content <= 'b0000000_00011_00011_000_00011_0110011;  // add x3, x3, x3
    'h10: content <= 'b0000_0000_0000_00000_000_00000_0010011; // nop
  endcase
  end
endmodule