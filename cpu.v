`include "./alu/alu.v"
`include "./registerFile/registerFile.v"
`include "./memory/commandCache/commandCache.v"
`include "./memory/dataCache/dataCache.v"
`include "./commands.v"

module CPU(
  input wire        clk
);
  reg  [31:0] program_counter = 32'h0;
  reg  [31:0] next_program_counter = 32'h0;
  wire [31:0] instruction;
  CommandCache commandCache(
    program_counter,
    instruction
  );

  wire        memory_write_enable;
  wire [2:0]  memory_io_width;
  wire [31:0] memory_io_address;
  wire [31:0] memory_out;
  wire [31:0] memory_in;

  DataCache dataCache(
    clk,
    memory_write_enable,
    memory_io_width,
    memory_io_address,
    memory_out,
    memory_in
  );

  wire [4:0]  register_1_select;
  wire [31:0] register_1_value;

  wire [4:0]  register_2_select;
  wire [31:0] register_2_value;

  wire        register_save_enable;
  wire [4:0]  register_save_select;
  wire [31:0] register_save_value;
  RegisterFile registers(
    clk,

    register_1_select,
    register_1_value,

    register_2_select,
    register_2_value,

    register_save_enable,
    register_save_select,
    register_save_value
  );
  wire [3:0]  alu_func;
  wire [31:0] alu_input_1;
  wire [31:0] alu_input_2;
  wire [31:0] alu_output;
  ALU alu(
    alu_func,
    alu_input_1, //
    alu_input_2, //
    alu_output   //
  );
  assign register_1_select = instruction[19:15];
  assign register_2_select = instruction[24:20];
  assign register_save_select = instruction[11:7];
  
  assign alu_func = (instruction[6:0] == `CALC_I || instruction[6:0] == `CALC_R) ? {instruction[30],instruction[14:12]} : 4'b0000;
  assign alu_input_1 = (instruction[6:0] == `LUI   ) ? {instruction[31:12], 12'b0} :
                       (instruction[6:0] == `AUIPC ) ? ({instruction[31:12], 12'b0} + program_counter) :
                       (instruction[6:0] == `JAL || instruction[6:0] == `JALR) 
                                                    ? 'd4 :
                       (instruction[6:0] == `BRANCH || instruction[6:0] == `LOAD || instruction[6:0] == `STORE) 
                                                    ? 'b0 :
                       (instruction[6:0] == `CALC_I || instruction[6:0] == `CALC_R) ? register_1_value : 'bz;

  assign alu_input_2 = (instruction[6:0] == `LUI || instruction[6:0] == `BRANCH) ? 'b0 :
                       (instruction[6:0] == `AUIPC || instruction[6:0] == `JAL || instruction[6:0] == `JALR) ? program_counter :
                       (instruction[6:0] == `LOAD)   ? memory_out :
                       (instruction[6:0] == `STORE || instruction[6:0] == `CALC_R)  ? register_2_value :
                       (instruction[6:0] == `CALC_I) ? {{20{instruction[31]}},instruction[31:20]} : 'bz;

  assign register_save_value = alu_output;
  assign memory_in = alu_output;
  assign memory_io_address = register_1_value + ((instruction[6:0] == `STORE) ? {instruction[31:25],instruction[11:7]} : {instruction[31:20]});
  assign memory_io_width = instruction[14:12];
  assign memory_write_enable = (instruction[6:0] == `STORE);
  assign register_save_enable = (instruction[6:0] != `BRANCH && instruction[6:0] != `STORE);
  always @(posedge clk) begin
    program_counter <= next_program_counter;
  end
  always @(negedge clk) begin
    case (instruction[6:0])
      `JAL   : next_program_counter <= $signed(program_counter) + $signed({12'b0, instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0}); 
      `JALR  : next_program_counter <= ($signed(program_counter) + $signed(register_1_value) + $signed({{20{instruction[31]}},instruction[31:20]})) & 32'hffff_fffe; 
      `BRANCH: begin
        case(instruction[14:12])
          `BEQ : next_program_counter <= $signed(program_counter) + $signed((register_1_value == register_2_value) ? {instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0} : 32'h4);
          `BNE : next_program_counter <= $signed(program_counter) + $signed((register_1_value != register_2_value) ? {instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0} : 32'h4);
          `BLT : next_program_counter <= $signed(program_counter) + $signed(($signed(register_1_value) <  $signed(register_2_value)) ? {instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0} : 32'h4);
          `BGE : next_program_counter <= $signed(program_counter) + $signed(($signed(register_1_value) >= $signed(register_2_value)) ? {instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0} : 32'h4);
          `BLTU: next_program_counter <= $signed(program_counter) + $signed(($unsigned(register_1_value) <  $signed(register_2_value)) ? {instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0} : 32'h4);
          `BGEU: next_program_counter <= $signed(program_counter) + $signed(($unsigned(register_1_value) >= $signed(register_2_value)) ? {instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0} : 32'h4);
          default: next_program_counter <= next_program_counter + 32'h4;
        endcase
      end
      default: next_program_counter <= next_program_counter + 32'h4;
    endcase
  end
endmodule