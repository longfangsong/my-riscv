module DataCache(
  input  wire        clk,
  input  wire        write_en,
  input  wire [2:0]  width,
  input  wire [31:0] full_address,
  output wire [31:0] out,
  input  wire [31:0] in
);
  wire [5:0] address;
  assign address = full_address[5:0];
  reg [7:0]registers[63:0];
  assign out = (width == 'b000) ? {{24{registers[address][7]}},registers[address]} :
               (width == 'b001) ? {{16{registers[address+1][7]}},registers[address+1],registers[address]} :
               (width == 'b010) ? {registers[address+3],registers[address+2],registers[address+1],registers[address]} :
               (width == 'b100) ? {24'b0, registers[address]} :
               (width == 'b101) ? {16'b0,registers[address+1],registers[address]} :
               {32'hzzzz_zzzz};
  always @(clk) begin
    if (write_en == 1) begin
      registers[address] <= in[7:0];
      if (width == 'b001 || width == 'b010) begin
        registers[address+1] <= in[15:8];
        if (width == 'b010) begin
          registers[address+2] <= in[23:16];
          registers[address+3] <= in[31:24];
        end
      end
    end
  end
endmodule