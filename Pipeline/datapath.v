`timescale 1ns/1ps

`include "decoder.v"
`include "Alu.v"
`include "Data_mem.v"
`include "Reg_file.v"
`include "Fetch.v"


//module Single_datapath(input[31:0] instr,input clk);
module Single_datapath();


wire clk; // clock signal

wire br_taken,br_en; //br_taken tells whether branch is taken or not. br_en tells that instruction is of branch type
reg br_taken_buff,br_en_buff, br_en_buff2; //branch taken and enable signals buffers for different pipeline stages
wire [63:0] br_addr; //br_addr is the address where processor has to jump
wire[63:0] pc; //program counter
reg [63:0] pc_buff,pc_buff2; //program counter buffers 
wire[31:0] instr;  //instruction's variable
reg [31:0] instr_buff; //insruction's buffer

wire signed[63:0] Alu_output; //ALU output variable
reg [63:0] Alu_output_buff,Alu_output_buff2;
wire [63:0] reg_file_input, mem_data_output; //Register file input variable  used in writeback stage & memory data output
reg [63:0] mem_data_output_buff;
wire sign_bit; //it determines the sign of input value i.e. positive or negative
reg sign_bit_buff; //sign bit buffer
wire signed [63:0] pc_offset;

wire reg_wr_en, Rs2_en; //register file write enable signal & Rs2_en is used to fetch immediate value from instruction if it is not R & B type
reg reg_wr_en_buff, reg_wr_en_buff2, reg_wr_en_buff3,Rs2_en_buff; // register write enable signal's buffer
wire mem_rd_en, mem_wr_en; //memory read enable signal and memory write enable signal
reg mem_rd_en_buff, mem_rd_en_buff2,mem_rd_en_buff3, mem_wr_en_buff,mem_wr_en_buff1, mem_wr_en_buff2, mem_wr_en_buff3; // memory read enable signal's buffer and memory write enable signal's buffer
wire [3:0] Alu_opr; //ALU operation codes i.e. load byte,halfword or doubleword
wire [2:0] load_opr; //logic operation codes i.e. load byte,halfword or doubleword
reg [3:0] Alu_opr_buff,Alu_opr_buff2;
reg [2:0] load_opr_buff,load_opr_buff2;
wire [1:0] store_opr; //Store operation codes i.e. store byte,halfword or doubleword
reg [1:0] store_opr_buff,store_opr_buff2;
wire [4:0] Rd_addr, Rs1_addr,Rs2_addr; //destination address, input source 1 address and input source 2 address
reg [4:0] Rd_addr_buff,Rd_addr_buff2,Rd_addr_buff3;// destination address buffers
wire signed [63:0] Rs1_data,Rs2_data,input2_data; //Register file source 1 data and register file source 2 data & ALU input 2 data
reg signed [63:0] Rs1_data_buff,Rs2_data_buff,Rs2_data_buff2;
wire signed [11:0] imm_val; //immmediate value
reg signed [11:0] imm_val_buff; //immediate value buffer


 //Clock source
  clk_input U1(clk);

//Fetching stage


  fetch_RISCV U2(clk,(br_taken_buff == 1'b0 && br_en_buff2==1),br_addr,pc);
  instruction_mem U3(pc,instr);
  //IF/ID pipeline register
always @(posedge clk) begin
   pc_buff <= pc;
   instr_buff <= instr;
   $display ("pc_buff: %h,instr_buff: %h", pc_buff,instr_buff);
end


// Decode stage
/*Decode the instruction and fetch the ALU operation, load instruction type, store instruction type, destination register address, Input 1 & 2's register addresses,
  Register file write enable, data memory write enable, data memory read enable*/
  Decoder_64_bit_RISC U4(instr_buff,Alu_opr,load_opr,store_opr,Rd_addr,Rs1_addr,Rs2_addr,reg_wr_en,mem_wr_en,mem_rd_en,br_en,Rs2_en);
//Fetch the data value from register file for input data 1 and input data 2
  Reg_file U5(reg_wr_en,Rs1_addr,Rs2_addr,Rd_addr_buff3,reg_file_input,Rs1_data,Rs2_data);

//fetching of immediate value
 assign imm_val = (instr_buff[6:0] == 7'b0010011 || instr_buff[6:0] == 7'b0000011 )? instr_buff[31:20]: //I-type & L-Load type instruction's immediate value
                                              (instr_buff[6:0] == 7'b0100011) ?{instr_buff[31:25],instr_buff[11:7]}: //Store instruction's immediate value
                        (instr_buff[6:0] == 7'b1100111)? {instr_buff[31],instr_buff[7],instr_buff[30:25],instr_buff[11:8]}: //Branch instruction's immediate value
                        12'bz;
 assign sign_bit = instr_buff[31];
  always @(posedge clk) begin
     Alu_opr_buff <= Alu_opr;
     load_opr_buff <= load_opr;
     store_opr_buff <= store_opr;
     Rs1_data_buff <= Rs1_data;
     Rs2_data_buff <= Rs2_data;
     Rd_addr_buff <= Rd_addr;
     mem_wr_en_buff <= mem_wr_en;
     mem_rd_en_buff <= mem_rd_en;
     br_en_buff <= br_en;
     imm_val_buff <= imm_val;
     Rs2_en_buff <= Rs2_en;
     sign_bit_buff <= sign_bit;
     pc_buff2 <= pc_buff;
     reg_wr_en_buff <= reg_wr_en; 
     $display("Alu_opr_buff: %h,Rs1_data_buff: %d,Rs2_data_buff: %d,imm_val_buff: %d", Alu_opr_buff, Rs1_data_buff, Rs2_data_buff, imm_val_buff);
  end

  //Assign the 2nd input to ALU as per the type of instruction
  assign input2_data = (Rs2_en_buff == 1'b1) ? Rs2_data_buff : //R-type & branch instruction's register value
                        ((sign_bit_buff == 1'b1)?{52'hFFFFFFFFFFFFF,imm_val_buff}
                              :{52'h0000000000000,imm_val_buff});//determine +ve and -ve number of I-type & L-Load type instruction's immediate value
  assign pc_offset = (sign_bit_buff == 1'b1)? {51'hFFFFFFFFFFFFF,imm_val_buff,1'b0} : {51'h0000000000000,imm_val_buff,1'b0};

  assign br_addr = pc_buff2 + pc_offset;
  //ALU performs the operation as per the instruction
  ALU_64bit_RISCV U6(Alu_opr_buff,Rs1_data_buff,input2_data,Alu_output,br_taken);
   
 always @(posedge clk) begin
   Alu_output_buff <= Alu_output;
   load_opr_buff2 <= load_opr_buff;
   store_opr_buff2 <= store_opr_buff;
   mem_rd_en_buff2 <= mem_rd_en_buff;
   mem_wr_en_buff2 <= mem_wr_en_buff;
   Rs2_data_buff2 <= Rs2_data_buff;
   br_en_buff2 <= br_en_buff;
   br_taken_buff <= br_taken;
   reg_wr_en_buff2 <= reg_wr_en_buff;
   Rd_addr_buff2 <= Rd_addr_buff;

   $display ("Alu_output_buff: %d, Rd_addr_buff2: %h", Alu_output_buff,Rd_addr_buff2);
 end
  
  //Data memory is of 2047 x 8 means 8-bit as RISC V has byte addressable memory.
  data_memory U7(load_opr_buff2,store_opr_buff2,mem_wr_en_buff2,mem_rd_en_buff2,Alu_output_buff,Rs2_data_buff2,mem_data_output);
always @(posedge clk) begin
   mem_data_output_buff <= mem_data_output;
   Alu_output_buff2 <= Alu_output_buff;
   mem_rd_en_buff3 <= mem_rd_en_buff2;
   mem_wr_en_buff3 <= mem_wr_en_buff2;
   reg_wr_en_buff3 <= reg_wr_en_buff2;
   Rd_addr_buff3 <= Rd_addr_buff2;
   $display("mem_data_output: %h,Alu_output_buff2: %d ,Rd_addr_buff3: %h", mem_data_output,Alu_output_buff2, Rd_addr_buff3);
end
  //This is a mux having two inputs with one select line.It provides the data memory output if instruction is load else provides the alu output to the register file 
  assign reg_file_input = (mem_rd_en_buff3 == 1'b1 && mem_wr_en_buff3 == 1'b0 && reg_wr_en_buff3 == 1'b1 ) ? mem_data_output_buff:Alu_output_buff2; 
/*always@ (posedge instr)begin
   $monitor("Wen: %b,Rs1_addr: %h,Rs2_addr: %h,Wd_addr: %h,write_data: %h,Rs1_data: %h,Rs2_data: %h, alu_output: %h", Wen,Rs1_addr,Rs2_addr,Wd_addr,write_data,Rs1_data,Rs2_data,Alu_output);
end*/
endmodule