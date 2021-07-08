`timescale 1ns/1ps

`include "decoder.v"
`include "Alu.v"
`include "Data_mem.v"
`include "Reg_file.v"
`include "instr_mem.v"


//module Single_datapath(input[31:0] instr,input clk);
module pipeline_datapath();


wire clk; // clock signal

wire br_taken,br_en1, br_en2; //br_taken tells whether branch is taken or not. br_en tells that instruction is of branch type
reg br_taken_buff,br_en1_buff, br_en1_buff2, br_en2_buff, br_en2_buff2; //branch taken and enable signals buffers for different pipeline stages
wire [63:0] br_addr; //br_addr is the address where processor has to jump
reg [63:0] br_addr_buff;
reg[63:0] pc,pc4; //program counter
reg [63:0] pc_buff,pc_buff2, pc_buff3, pc_buff4,pc4_buff,pc4_buff2,pc4_buff3, pc4_buff4 ; //program counter buffers 
wire[31:0] instr1,instr2, instr_inputA,instr_inputB;  //instruction's variable
reg [31:0] instr1_buff,instr2_buff ; //insruction1 and instruction 2 buffer
wire exec_bypass1_Rs1, exe_bypass1_Rs2, mem_bypass1_Rs2,  mem_bypass1_Rs1, wrb_bypass1_Rs1,wrb_bypass1_Rs2;
wire exec_bypass2_Rs1, exe_bypass2_Rs2, mem_bypass2_Rs2,  mem_bypass2_Rs1, wrb_bypass2_Rs1,wrb_bypass2_Rs2;
reg exec_bypass1_buff_Rs1, exec_bypass1_buff_Rs2, mem_bypass1_buff_Rs1, mem_bypass1_buff_Rs2, wrb_bypass1_buff_Rs1, wrb_bypass1_buff_Rs2;
reg exec_bypass2_buff_Rs1, exec_bypass2_buff_Rs2, mem_bypass2_buff_Rs1, mem_bypass2_buff_Rs2, wrb_bypass2_buff_Rs1, wrb_bypass2_buff_Rs2;
wire exec_intr_bp1_Rs1,exec_intr_bp1_Rs2,mem_intr_bp1_Rs1,mem_intr_bp1_Rs2,wrb_intr_bp1_Rs1,wrb_intr_bp1_Rs2;
wire exec_intr_bp2_Rs1,exec_intr_bp2_Rs2,mem_intr_bp2_Rs1,mem_intr_bp2_Rs2,wrb_intr_bp2_Rs1,wrb_intr_bp2_Rs2;
reg exec_intr_bp1_buff_Rs1,exec_intr_bp1_buff_Rs2,mem_intr_bp1_buff_Rs1,mem_intr_bp1_buff_Rs2,wrb_intr_bp1_buff_Rs1,wrb_intr_bp1_buff_Rs2;
reg exec_intr_bp2_buff_Rs1,exec_intr_bp2_buff_Rs2,mem_intr_bp2_buff_Rs1,mem_intr_bp2_buff_Rs2,wrb_intr_bp2_buff_Rs1,wrb_intr_bp2_buff_Rs2;


wire stall_A,stall_B, are_instrs_br, are_instrs_ld_sd;

wire signed[63:0] Alu_op1, Alu_op2; //ALU output variable
reg signed[63:0] Alu_op1_buff,Alu_op1_buff2,Alu_op2_buff,Alu_op2_buff2;
wire [63:0] reg_file_input1, mem_data_output,reg_file_input2; //Register file input variable  used in writeback stage & memory data output
reg [63:0] mem_data_output_buff;
wire sign_bit1,sign_bit2; //it determines the sign of input value i.e. positive or negative
reg sign_bit1_buff,sign_bit2_buff; //sign bit buffer
wire signed [63:0] pc_offset;

wire reg_wr_en1, Rs2_en1,reg_wr_en2, Rs2_en2; //register file write enable signal & Rs2_en is used to fetch immediate value from instruction if it is not R & B type
reg reg_wr_en1_buff, reg_wr_en1_buff2, reg_wr_en1_buff3,Rs2_en1_buff, reg_wr_en2_buff, reg_wr_en2_buff2, reg_wr_en2_buff3,Rs2_en2_buff; // register write enable signal's buffer

wire mem_rd_en2, mem_wr_en2; //memory read enable signal and memory write enable signal
reg mem_rd_en2_buff, mem_rd_en2_buff2,mem_rd_en2_buff3, mem_wr_en2_buff,mem_wr_en2_buff1, mem_wr_en2_buff2, mem_wr_en2_buff3; // memory read enable signal's buffer and memory write enable signal's buffer

wire [3:0] Alu_opr1, final_alu_opr1,Alu_opr2, final_alu_opr2; //ALU operation codes i.e. load byte,halfword or doubleword
reg [3:0] Alu_opr1_buff,Alu_opr1_buff2,Alu_opr2_buff,Alu_opr2_buff2;

wire [2:0] load_opr2; //logic operation codes i.e. load byte,halfword or doubleword
reg [2:0] load_opr2_buff,load_opr2_buff2;
wire [1:0] store_opr2; //Store operation codes i.e. store byte,halfword or doubleword
reg [1:0] store_opr2_buff,store_opr2_buff2;

wire [4:0] Rd_addr1, Rs1_addr1,Rs2_addr1, Rd_addr2, Rs1_addr2,Rs2_addr2; //destination address, input source 1 address and input source 2 address
reg [4:0] Rd_addr1_buff,Rd_addr1_buff2,Rd_addr1_buff3,Rd_addr2_buff,Rd_addr2_buff2,Rd_addr2_buff3;// destination address buffers


wire signed [63:0] Rs1_data1,Rs2_data1,input1_data1,input2_data1,Rs1_data2,Rs2_data2,input1_data2,input2_data2 ,data_store_mem; //Register file source 1 data and register file source 2 data & ALU input 2 data
reg signed [63:0] Rs1_data1_buff,Rs2_data1_buff, Rs1_data2_buff,Rs2_data2_buff ,data_store_mem_buff;
wire signed [11:0] imm_val1, imm_val2; //immmediate value
reg signed [11:0] imm_val1_buff, imm_val2_buff; //immediate value buffer

//intialization of registers
//----------------------------------------------------------------------------------------------
initial begin
  pc<=64'h0000000000000000;
  pc4<=64'h0000000000000004;
end
 //Clock source
  clk_input U1(clk);

                                                      //Fetching stage
//---------------------------------------------------------------------------------------------------------------------
  //fetch_RISCV U2(clk,((br_taken_buff == 1'b0 && br_en_buff2==1'b1)? 1'b1:1'b0),stall,br_addr_buff,pc);

always @(posedge clk) begin
  if(stall_A == 1'b1 || stall_B == 1'b1) begin
    pc <= pc;
    pc4 <= pc4;
  end
  else if(are_instrs_ld_sd == 1'b1 || are_instrs_br == 1'b1)begin
    pc <= pc4_buff;
    pc4<= pc4_buff +4;
  end
  else if(br_taken == 1'b0 && br_en1_buff == 1'b1) begin
      pc<=br_addr;
      pc4 <= br_addr + 4; 
    end
  else begin
    pc<=pc+4;
    pc4<=pc4+4;
  end
end
  instruction_mem U3(pc,pc4,instr1,instr2);
  //IF/ID pipeline register
always @(posedge clk) begin
   pc_buff <= pc;
   pc4_buff <= pc4;
  if(are_instrs_br) begin
     instr1_buff <= instr2_buff;
     instr2_buff <= instr1;
   end 
   else if (are_instrs_ld_sd ) begin
     instr2_buff <= instr2_buff;
     instr1_buff <= instr1;
   end
   else if(br_taken == 1'b0 && br_en1_buff == 1'b1)begin
      instr2_buff<=32'h00000000;
      instr1_buff<=32'h00000000; 
   end
  else begin
      instr1_buff <= instr1;
      instr2_buff <= instr2;
  end
  
   $display ("2nd stage: pc_buff: %h,instr1_buff: %h, instr2_buff: %h", pc_buff,instr1_buff, instr2_buff);
end

assign instr_inputA = ((instr1_buff[6:0] != 7'b0000011 || instr1_buff[6:0] == 7'b0000011)) ? instr1_buff : 
                      ((instr2_buff[6:0] != 7'b0000011 || instr2_buff[6:0] == 7'b0000011)) ? instr2_buff : 32'bz;

assign instr_inputB = (instr1_buff[6:0] == 7'b0000011 || instr1_buff[6:0] == 7'b0000011)  ? instr1_buff : 
                      (instr2_buff[6:0] != {instr2_buff[31],instr2_buff[7],instr2_buff[30:25],instr2_buff[11:8]}) ? instr2_buff : 32'bz;
//instr2_buff[6:0] != {instr2_buff[31],instr2_buff[7],instr2_buff[30:25],instr2_buff[11:8]}
// Decode stage
/*Decode the instruction and fetch the ALU operation, load instruction type, store instruction type, destination register address, Input 1 & 2's register addresses,
  Register file write enable, data memory write enable, data memory read enable*/
  Decoder_A U4A(instr_inputA,Alu_opr1,Rd_addr1,Rs1_addr1,Rs2_addr1,reg_wr_en1,br_en1);
  Decoder_B U4B(instr_inputB,Alu_opr2,load_opr2,store_opr2,Rd_addr1,Rs1_addr2,Rs2_addr2,reg_wr_en2,mem_wr_en2,mem_rd_en2,Rs2_en2);
//Fetch the data value from register file for input data 1 and input data 2
  Reg_file U5(reg_wr_en1_buff3, reg_wr_en2_buff3 ,Rs1_addr1,Rs2_addr1,Rd_addr1_buff3, Rs1_addr2, Rs2_addr2, Rd_addr2_buff3,reg_file_input1, reg_file_input2,Rs1_data1,Rs2_data1, Rs1_data2,Rs2_data2);

//fetching of immediate value
 assign imm_val1 = (instr1_buff[6:0] == 7'b0010011)? instr1_buff[31:20]: //I-type instruction's immediate value
                  (instr1_buff[6:0] == 7'b1100111)? {instr1_buff[31],instr1_buff[7],instr1_buff[30:25],instr1_buff[11:8]}: //Branch instruction's immediate value
                        12'bz;
 assign imm_val2 = (instr2_buff[6:0] == 7'b0010011 || instr2_buff[6:0] == 7'b0000011 )? instr2_buff[31:20]: //I-type & L-Load type instruction's immediate value
                   (instr2_buff[6:0] == 7'b0100011) ?{instr2_buff[31:25],instr2_buff[11:7]}: //Store instruction's immediate value
                   12'bz;
 assign sign_bit1 = instr1_buff[31];
 assign sign_bit2 = instr2_buff[31];
 assign exec_bypass1_Rs1 = ((Rs1_addr1 === Rd_addr1_buff) &&
                    (((Rs1_addr1 === Rd_addr2_buff)&&(pc_buff2 > pc4_buff2))||(Rs1_addr1 != Rd_addr2_buff))) ? 1'b1: 1'b0;
 assign exec_bypass1_Rs2 = ((Rs2_addr1 === Rd_addr1_buff) &&
                        (((Rs2_addr1 === Rd_addr2_buff)&&(pc_buff2 > pc4_buff2))||(Rs2_addr1 != Rd_addr2_buff)))  ? 1'b1: 1'b0;
 assign mem_bypass1_Rs1 = ((Rs1_addr1 === Rd_addr1_buff2) && (exec_bypass1_Rs1 == 1'b0) && (exec_intr_bp1_Rs1 == 1'b0) &&
                    (((Rs1_addr1 === Rd_addr2_buff2)&&(pc_buff3 > pc4_buff3))||(Rs1_addr1 != Rd_addr2_buff2)))? 1'b1: 1'b0;
 assign mem_bypass1_Rs2 = ((Rs2_addr1 === Rd_addr1_buff2) && (exe_bypass1_Rs2 == 1'b0) &&  (exec_intr_bp1_Rs2 == 1'b0) &&
                          (((Rs2_addr1 === Rd_addr2_buff2)&&(pc_buff3 > pc4_buff3))||(Rs2_addr1 != Rd_addr2_buff2)))? 1'b1: 1'b0;
 assign wrb_bypass1_Rs1 = ((Rs1_addr1 === Rd_addr1_buff3) && (exec_bypass1_Rs1 == 1'b0)&&(mem_bypass1_Rs1==1'b0)&& (exec_intr_bp1_Rs1 == 1'b0) && 
                           (((Rs2_addr1 === Rd_addr2_buff3)&&(pc_buff4 > pc4_buff4))||(Rs2_addr1 != Rd_addr2_buff3)))? 1'b1 : 1'b0;
 assign wrb_bypass1_Rs2 = ((Rs2_addr1 === Rd_addr1_buff3 && reg_wr_en1_buff3 == 1'b1) && (exec_bypass1_Rs2 == 1'b0)&&(mem_bypass1_Rs2==1'b0)&& (exec_intr_bp1_Rs2 == 1'b0) && 
                 (((Rs2_addr1 === Rd_addr2_buff3)&&(pc_buff4 > pc4_buff4))||(Rs2_addr1 != Rd_addr2_buff3)))  ? 1'b1 : 1'b0;


 assign exec_bypass2_Rs1 = ((Rs1_addr2 === Rd_addr2_buff) && (mem_wr_en2_buff === 1'b0) && (mem_rd_en2_buff === 1'b0) &&
                          (((Rs1_addr2 === Rd_addr1_buff)&&(pc_buff2 < pc4_buff2))||(Rs1_addr2 != Rd_addr1_buff)))  ? 1'b1: 1'b0;
 assign exec_bypass2_Rs2 = ((Rs2_addr2 === Rd_addr2_buff) && (mem_wr_en2_buff === 1'b0) && (mem_rd_en2_buff === 1'b0) && 
                            (((Rs2_addr2 === Rd_addr1_buff)&&(pc_buff2 < pc4_buff2))||(Rs2_addr2 != Rd_addr1_buff))) ? 1'b1: 1'b0;
 assign mem_bypass2_Rs1 =  ((Rs1_addr2 === Rd_addr2_buff2) && (mem_wr_en2_buff2 === 1'b0) && (exec_bypass2_Rs1 == 1'b0) && (exec_intr_bp2_Rs1 == 1'b0) &&
                        (((Rs1_addr2 === Rd_addr1_buff2)&&(pc_buff3 < pc4_buff3))||(Rs1_addr2 != Rd_addr1_buff2))) ? 1'b1 : 1'b0;
 assign mem_bypass2_Rs2 =  ((Rs2_addr2 === Rd_addr2_buff2) && (mem_wr_en2_buff2 === 1'b0) && (exec_bypass2_Rs2 == 1'b0) && (exec_intr_bp2_Rs2 == 1'b0) &&
                      (((Rs1_addr2 === Rd_addr1_buff2)&&(pc_buff3 < pc4_buff3))||(Rs1_addr2 != Rd_addr1_buff2))) ? 1'b1 : 1'b0;
 assign wrb_bypass2_Rs1 = ((Rs1_addr2 === Rd_addr2_buff3) && (reg_wr_en2_buff3 == 1'b1)&& (exec_bypass2_Rs1 == 1'b0)&&(mem_bypass2_Rs1==1'b0)&& (exec_intr_bp2_Rs1 == 1'b0) && 
                           (((Rs2_addr2 === Rd_addr1_buff3)&&(pc_buff4 < pc4_buff4))||(Rs2_addr2 != Rd_addr1_buff3)) )? 1'b1 : 1'b0;
 assign wrb_bypass2_Rs2 = ((Rs2_addr2 === Rd_addr2_buff3 && (reg_wr_en2_buff3 == 1'b1) && (exec_bypass2_Rs2 == 1'b0)&&(mem_bypass2_Rs2 ==1'b0)&& (exec_intr_bp2_Rs2 == 1'b0) &&
                           (((Rs2_addr2 === Rd_addr1_buff3)&&(pc_buff4 < pc4_buff4))||(Rs2_addr2 != Rd_addr1_buff3)))? 1'b1 : 1'b0;



 assign exec_intr_bp2_Rs1 = ((Rs1_addr2 === Rd_addr1_buff)&& (exec_bypass2_Rs1 == 1'b0)) ? 1'b1 : 1'b0;
 assign exec_intr_bp2_Rs2 = ((Rs2_addr2 === Rd_addr1_buff)&& (exec_bypass2_Rs1 == 1'b0)) ? 1'b1 : 1'b0;
 assign mem_intr_bp2_Rs1 = ((Rs1_addr2 === Rd_addr1_buff2)&&(exec_intr_bp2_Rs1 == 1'b0) && (exec_bypass2_Rs1 == 1'b0)&&
                           (mem_bypass1_Rs2 == 1'b0)) ? 1'b1: 1'b0;
 assign mem_intr_bp2_Rs2 =((Rs2_addr2 === Rd_addr1_buff2)&& (exec_intr_bp2_Rs2 == 1'b0) && (exec_bypass2_Rs2 == 1'b0)&&
                           (mem_bypass2_Rs2 == 1'b0)) ? 1'b1: 1'b0;
 assign wrb_intr_bp2_Rs1 = (Rs1_addr2 === Rd_addr1_buff3) && (exec_intr_bp2_Rs1 == 1'b0)
                            && (exec_bypass1_Rs1 == 1'b0)&& (mem_bypass1_Rs1 == 1'b0) && (wrb_bypass1_Rs1 == 1'b0) ? 1'b1: 1'b0;
 assign wrb_intr_bp2_Rs2 = ((Rs2_addr2 === Rd_addr1_buff3) &&(exec_intr_bp1_Rs2 == 1'b0)
                            && (exec_bypass2_Rs2 == 1'b0)&& (mem_bypass2_Rs2 == 1'b0) && (wrb_bypass2_Rs2 == 1'b0)) ? 1'b1: 1'b0;


 assign exec_intr_bp1_Rs1 =((Rs1_addr1 === Rd_addr2_buff) && (mem_wr_en2_buff === 1'b0) && (mem_rd_en2_buff === 1'b0) &&
                              (exec_bypass1_Rs1 == 1'b0)) ? 1'b1 : 1'b0;
 assign exec_intr_bp1_Rs2 =((Rs2_addr1 === Rd_addr2_buff) && (mem_wr_en2_buff === 1'b0) && (mem_rd_en2_buff === 1'b0) &&
                            (exec_bypass1_Rs2 == 1'b0)) ? 1'b1 : 1'b0;
 assign mem_intr_bp1_Rs1 = ((Rs1_addr1 === Rd_addr2_buff2) && (mem_wr_en2_buff2 === 1'b0) && (exec_intr_bp1_Rs1 == 1'b0) && (exec_bypass1_Rs1 == 1'b0)&&
                           (mem_bypass1_Rs1 == 1'b0)) ? 1'b1: 1'b0;
 assign mem_intr_bp1_Rs2 = ((Rs2_addr1 === Rd_addr2_buff2) && (mem_wr_en2_buff === 1'b0) && (exec_intr_bp1_Rs2 == 1'b0)
                            && (exec_bypass1_Rs2 == 1'b0)&& (mem_bypass1_Rs2 == 1'b0))? 1'b1: 1'b0;
 assign wrb_intr_bp1_Rs1 = ((Rs1_addr1 === Rd_addr2_buff3) && (reg_wr_en2_buff3 == 1'b1) && (exec_intr_bp1_Rs1 == 1'b0)
                            && (exec_bypass1_Rs1 == 1'b0)&& (mem_bypass1_Rs1 == 1'b0) && (wrb_bypass1_Rs1 == 1'b0) )? 1'b1: 1'b0;
 assign wrb_intr_bp1_Rs2 = ((Rs2_addr1 === Rd_addr2_buff3) && (reg_wr_en2_buff3 == 1'b1) && (exec_intr_bp1_Rs2 == 1'b0) && 
                          (exec_bypass1_Rs2 == 1'b0) && (mem_bypass1_Rs2 == 1'b0) && (wrb_bypass1_Rs2 == 1'b0))? 1'b1: 1'b0;


 assign are_instrs_ld_sd = ((instr1_buff ==  7'b0000011 && instr2_buff == 7'b0000011) || (instr1_buff == 7'b0100011 && instr2_buff == 7'b0100011 ))? 1'b1: 1'b0; //if both instructions are either load or store instructions
 assign are_instrs_br = ((instr1_buff ==  7'b0100011) && (instr2_buff == 7'b0100011))?  1'b1 : 1'b0; //if both instructions are branch instructiom 
 assign stall_B = (((Rs1_addr2 == Rd_addr2_buff || Rs2_addr2 == Rd_addr2_buff) && (mem_rd_en2_buff == 1'b1))|| (Rs1_addr2 == Rd_addr1 || Rs2_addr2 == Rd_addr1))? 1'b1 : 1'b0;         
 assign stall_A = ((Rs1_addr1 == Rd_addr2 || Rs2_addr1 == Rd_addr2)||
                    (((Rs2_addr1 == Rd_addr2_buff)||(Rs1_addr1 == Rd_addr2_buff))&&(mem_rd_en2_buff == 1'b1)))? 1'b1:1'b0;
  always @(posedge clk) begin
  pc_buff2 <= pc_buff;
  pc4_buff2 <= pc4_buff;
  
  if(stall_A == 1'b1) begin
    Alu_opr1_buff <= 4'hf;//Alu_opr of 1st ALU;
  end
  else if (stall_B == 1'b1) begin
    Alu_opr2_buff <= 4'hf;  // Alu_opr of 2nd ALU
  end
  else begin
     Alu_opr1_buff <= Alu_opr1;
     Alu_opr2_buff <= Alu_opr2;
  end
      //(stall == 1'b1) ? 4'bz: Alu_opr;
     load_opr2_buff <= load_opr2;
     store_opr2_buff <= store_opr2;

     Rs1_data1_buff <= Rs1_data1;
     Rs2_data1_buff <= Rs2_data1;
     imm_val1_buff <= imm_val1;
     Rd_addr1_buff <= Rd_addr1;
     br_en1_buff <= br_en1;
     sign_bit1_buff <= sign_bit1;
     reg_wr_en1_buff <= reg_wr_en1;

     Rs1_data2_buff <= Rs1_data2;
     Rs2_data2_buff <= Rs2_data2;
     imm_val2_buff <= imm_val2;
     Rd_addr2_buff <= Rd_addr2;
     mem_wr_en2_buff <= mem_wr_en2;
     mem_rd_en2_buff <= mem_rd_en2;
     Rs2_en2_buff <= Rs2_en2;
     sign_bit2_buff <= sign_bit2;
     reg_wr_en2_buff <= reg_wr_en2;


     exec_bypass1_buff_Rs1 <= exec_bypass1_Rs1;
     exec_bypass1_buff_Rs2 <= exec_bypass1_Rs2;
     mem_bypass1_buff_Rs1 <= mem_bypass1_Rs1;
     mem_bypass1_buff_Rs2 <= mem_bypass1_Rs2;
     wrb_bypass1_buff_Rs1 <= wrb_bypass1_Rs1;
     wrb_bypass1_buff_Rs2 <= wrb_bypass1_Rs2;

     exec_bypass2_buff_Rs1 <= exec_bypass2_Rs1;
     exec_bypass2_buff_Rs2 <= exec_bypass2_Rs2;
     mem_bypass2_buff_Rs1 <= mem_bypass2_Rs1;
     mem_bypass2_buff_Rs2 <= mem_bypass2_Rs2;
     wrb_bypass2_buff_Rs1 <= wrb_bypass2_Rs1;
     wrb_bypass2_buff_Rs2 <= wrb_bypass2_Rs2;
     
     exec_intr_bp1_buff_Rs1 <= exec_intr_bp1_Rs1;
     exec_intr_bp1_buff_Rs2 <= exec_intr_bp1_Rs2;
     mem_intr_bp1_buff_Rs1 <= mem_intr_bp1_Rs1;
     mem_intr_bp1_buff_Rs2 <= mem_intr_bp1_Rs2;
     wrb_intr_bp1_buff_Rs1 <= wrb_intr_bp1_Rs1;
     wrb_intr_bp1_buff_Rs2 <= wrb_intr_bp1_Rs2;

     exec_intr_bp2_buff_Rs1 <= exec_intr_bp2_Rs1;
     exec_intr_bp2_buff_Rs2 <= exec_intr_bp2_Rs2;
     mem_intr_bp2_buff_Rs1 <= mem_intr_bp2_Rs1;
     mem_intr_bp2_buff_Rs2 <= mem_intr_bp2_Rs2;
     wrb_intr_bp2_buff_Rs1 <= wrb_intr_bp2_Rs1;
     wrb_intr_bp2_buff_Rs2 <= wrb_intr_bp2_Rs2;

     $display("3rd stage:\n stall: %b,Rs2_en_buff: %b,Alu_opr_buff: %h,Rs1_data_buff: %d,Rs2_data_buff: %d,imm_val_buff: %d,Rd_addr_buff: ",stall, Rs2_en_buff,
                Alu_opr_buff, Rs1_data_buff, Rs2_data_buff, imm_val_buff, Rd_addr_buff);
                $display("Rs1_addr: %h, Rs2_addr: %h, pc_buff2: %h",Rs1_addr, Rs2_addr, pc_buff2 );
  end

  //Assign the 2nd input to ALU as per the type of instruction
  assign input1_data1 = (exec_bypass1_buff_Rs1 == 1'b1) ? Alu_op1_buff: (mem_bypass1_buff_Rs1 == 1'b1) ? Alu_op1_buff2: (wrb_bypass1_buff_Rs1 == 1'b1)? reg_file_input1 :
                         (exec_intr_bp1_Rs1 == 1'b1)? Alu_op2_buff: (mem_intr_bp1_Rs1 == 1'b1)? mem_data_output_buff : (wrb_intr_bp1_Rs1 == 1'b1) ? reg_file_input2 : Rs1_data1_buff;
  assign input2_data1 = (exec_bypass1_buff_Rs2 == 1'b1) ? Alu_op2_buff: (mem_bypass1_buff_Rs2 == 1'b1) ? mem_data_output_buff: (wrb_bypass1_buff_Rs2 == 1'b1) ? reg_file_input1:
                       (exec_intr_bp1_Rs2 == 1'b1)? Alu_op2_buff: (mem_intr_bp1_Rs2 == 1'b1)? mem_data_output_buff : (wrb_intr_bp1_Rs2 == 1'b1) ? reg_file_input2 :Rs2_data1_buff;              //R-type & branch instruction's register value

  assign input1_data2 = (exec_bypass2_buff_Rs1 == 1'b1) ? Alu_op2_buff:(mem_bypass2_buff_Rs1 == 1'b1) ? mem_data_output_buff:(wrb_bypass2_buff_Rs2 == 1'b1)? reg_file_input2:
                        (exec_intr_bp2_Rs1 == 1'b1)? Alu_op1_buff: (mem_intr_bp2_Rs1 == 1'b1)? Alu_op2_buff2 : (wrb_intr_bp2_Rs1 == 1'b1)? reg_file_input1 : Rs1_data2_buff;

  assign input2_data2 = (Rs2_en2_buff == 1'b1) ? ((exec_bypass2_buff_Rs2 == 1'b1) ? Alu_op2_buff:(mem_bypass2_buff_Rs2 == 1'b1) ? mem_data_output_buff:
                       (wrb_bypass1_buff_Rs2 == 1'b1) ? reg_file_input2: (exec_intr_bp2_Rs2 == 1'b1)? Alu_op1_buff: (mem_intr_bp2_Rs2 == 1'b1)? Alu_op2_buff2 : 
                       (wrb_intr_bp2_Rs2 == 1'b1): reg_file_input1  :Rs2_data2_buff) : //R-type & branch instruction's register value
                ((sign_bit2_buff == 1'b1)?{52'hFFFFFFFFFFFFF,imm_val2_buff}:{52'h0000000000000,imm_val2_buff});//determine +ve and -ve number of I-type & L-Load type instruction's immediate value 
  

  assign pc_offset = (sign_bit1_buff == 1'b1)? {48'hFFFFFFFFFFFF,3'b111,imm_val1_buff,1'b0} : {48'h000000000000,3'b000,imm_val1_buff,1'b0};
  assign br_addr = pc_buff2 + pc_offset;
  assign data_store_mem = (exec_bypass2_buff_Rs2 == 1'b1 && Rs2_en2_buff == 1'b0) ? Alu_op2_buff : (mem_bypass2_buff_Rs2 && Rs2_en2_buff == 1'b0) ? mem_data_output_buff : 
                          (wrb_bypass2_buff_Rs2 == 1'b1 && Rs2_en2_buff == 1'b0)? reg_file_input2: (exec_intr_bp2_Rs2 == 1'b1)? Alu_op1_buff : (mem_intr_bp2_Rs2 == 1'b1)? Alu_op1_buff2:
                           (wrb_intr_bp2_Rs2 == 1'b1) ? reg_file_input1 : Rs2_data2_buff;
  //ALU performs the operation as per the instruction
  ALU_64bit_A U6A(Alu_opr1_buff,input1_data1,input2_data1,Alu_op1,br_taken);
  ALU_64bit_B U6B(Alu_opr2_buff,input1_data2,input2_data2,Alu_op2);

 always @(posedge clk) begin
  pc4_buff3 = pc4_buff2;
  pc_buff3 = pc_buff2;

   Alu_op1_buff <= Alu_op1;
   reg_wr_en1_buff2 <= reg_wr_en1_buff;
   Rd_addr1_buff2 <= Rd_addr1_buff;

   Alu_op2_buff <= Alu_op2;
   load_opr2_buff2 <= load_opr2_buff;
   store_opr2_buff2 <= store_opr2_buff;
   mem_rd_en2_buff2 <= mem_rd_en2_buff;
   mem_wr_en2_buff2 <= mem_wr_en2_buff;
   Rd_addr2_buff2 <= Rd_addr2_buff;
   data_store_mem_buff <= data_store_mem;
   reg_wr_en2_buff2 <= reg_wr_en2_buff;
  

$display ("4th Stage: \n mem_rd_en: %b,mem_wr_en: %b, br_en_buff2: %b, br_taken_buff: %b,Alu_output_buff: %d,data_store_mem_buff: %d,Rd_addr_buff2: %h", 
                         mem_rd_en_buff2, mem_wr_en_buff2,br_en_buff2, br_taken_buff,Alu_output_buff,data_store_mem_buff, Rd_addr_buff2);
$display ("input1_data: %d, input2_data: %d, pc_offset: %d, br_addr_buff: %h",input1_data,input2_data, pc_offset, br_addr_buff);
 end
  
  //Data memory is of 2047 x 8 means 8-bit as RISC V has byte addressable memory.
  data_memory U7(load_opr2_buff2,store_opr2_buff2,mem_wr_en2_buff2,mem_rd_en2_buff2,Alu_op2_buff,data_store_mem_buff,mem_data_output);
always @(posedge clk) begin

   pc4_buff4 = pc4_buff3;
   pc_buff4 = pc_buff3;
   Alu_op1_buff2 <= Alu_op1_buff;
   reg_wr_en1_buff3 <= reg_wr_en1_buff2;
   Rd_addr1_buff3 <= Rd_addr1_buff2;

   mem_data_output_buff <= mem_data_output;
   Alu_op2_buff2 <= Alu_op2_buff;
   mem_rd_en2_buff3 <= mem_rd_en2_buff2;
   mem_wr_en2_buff3 <= mem_wr_en2_buff2;
   reg_wr_en2_buff3 <= reg_wr_en2_buff2;
   Rd_addr2_buff3 <= Rd_addr2_buff2;
   $display("5th stage: \n mem_wr_en_buff3: %b,reg_wr_en_buff3: %b, mem_data_output_buff: %d,Alu_output_buff2: %d ,Rd_addr_buff3: %h",mem_wr_en_buff3, reg_wr_en_buff3 , mem_data_output_buff,Alu_output_buff2, Rd_addr_buff3);
   $display("------------------------------------------------------------------------------------------------------------------------------");
end
  //This is a mux having two inputs with one select line.It provides the data memory output if instruction is load else provides the alu output to the register file 
  assign reg_file_input2 = (mem_rd_en2_buff3 == 1'b1 && mem_wr_en2_buff3 == 1'b0 && reg_wr_en2_buff3 == 1'b1 ) ? mem_data_output_buff:Alu_op2_buff2;
  assign reg_file_input1 = Alu_op2_buff2; 
/*always@ (posedge instr)begin
   $monitor("Wen: %b,Rs1_addr: %h,Rs2_addr: %h,Wd_addr: %h,write_data: %h,Rs1_data: %h,Rs2_data: %h, alu_output: %h", Wen,Rs1_addr,Rs2_addr,Wd_addr,write_data,Rs1_data,Rs2_data,Alu_output);
end*/
endmodule