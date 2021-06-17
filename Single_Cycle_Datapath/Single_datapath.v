`include "decoder.v"
`include "Alu.v"
`include "Data_mem.v"
`include "Reg_file.v"
module Single_datapath(input[31:0] instr,
                       input clk);
reg [3:0] Alu_opr,load_flag;
reg [1:0] store_flag;
reg [4:0] Rd_addr, Rs1_addr,Rs2_addr;
wire[63:0] Alu_output;
wire [63:0] Rs1_data,Rs2_data,input2_data;
reg reg_write_en,mem_write_en,mem_read_en;
wire [63:0] reg_file_input, mem_data_output;

  /*Decode the instruction and fetch the ALU operation, load instruction type, store instruction type, destination register address, Input 1 & 2's register addresses,
  Register file write enable, data memory write enable, data memory read enable*/
  Decoder_64_bit_RISC u2 (instr,Alu_opr,load_flag,store_flag,Rd_addr,Rs1_addr,Rs2_addr,reg_write_en,mem_write_en,mem_read_en);

  //Fetch the data value from register file for input data 1 and input data 2
  Reg_file u3 (reg_write_en,Rs1_addr,Rs2_addr,Rd_addr,reg_file_input,Rs1_data,Rs2_data);

  //Assign the 2nd input to ALU as per the type of instruction
  assign input2_data = (instr[6:0] == 7'b0110011) ? Rs2_data : //R-type instruction's register value
                        (instr[6:0] == 7'b0010011 || instr[6:0] == 7'b0000011 )? {52'b0,instr[31:20]} : //I-type & L-Load type instruction's immediate value
                        (instr[6:0] == 7'b0100011) ? {instr[31:25],instr[11:7]} : //Store instruction's immediate value
                        {instr[31],instr[7],instr[30:25],instr[11:8]};  //Branch instruction's immediate value

  //ALU performs the operation as per the instruction
  ALU_64bit_RISCV u4(Alu_opr,Rs1_data,input2_data,Alu_output);
  
  //Data memory is of 2047 x 8 means 8-bit as RISC V has byte addressable memory.
  data_memory U5(load_flag,store_flag,mem_write_en,mem_read_en,Alu_output,Rs2_data,mem_data_output);

  //This is a mux having two inputs with one select line.It provides the data memory output if instruction is load else provides the alu output to the register file 
  assign reg_file_input = (mem_read_en == 1 && mem_write_en == 0 && reg_write_en== 1)? mem_data_output:Alu_output; 
/*always@ (posedge instr)begin
   $monitor("Wen: %b,Rs1_addr: %h,Rs2_addr: %h,Wd_addr: %h,write_data: %h,Rs1_data: %h,Rs2_data: %h, alu_output: %h", Wen,Rs1_addr,Rs2_addr,Wd_addr,write_data,Rs1_data,Rs2_data,Alu_output);
end*/
endmodule