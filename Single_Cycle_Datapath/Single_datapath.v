`timescale 1ns/1ps

`include "decoder.v"
`include "Alu.v"
`include "Data_mem.v"
`include "Reg_file.v"
`include "Instr_mem.v"


//module Single_datapath(input[31:0] instr,input clk);
module Single_datapath();
wire [3:0] Alu_opr;
wire [2:0]load_flag;
wire [1:0] store_flag;
wire [4:0] Rd_addr, Rs1_addr,Rs2_addr;
wire signed[63:0] Alu_output;
wire signed [63:0] Rs1_data,Rs2_data,input2_data;
wire mem_write_en,mem_read_en,branch_en,branch_mux;
wire reg_write_en;

wire signed [63:0] reg_file_input, mem_data_output;
wire clk;
reg[63:0] pc;
wire[31:0] instr;
wire [63:0] branch_addr;
wire signed [63:0] branch_offset;
//assign pc=64'h0000000000000000;
   
initial begin
   pc<= 64'h0000000000000000;
end

    clk_input U1(clk);
    assign branch_offset = (instr[31]== 1'b1)? {52'hFFFFFFFFFFFFF,instr[7],instr[30:25],instr[11:8],1'b0} : {52'h0000000000000,instr[7],instr[30:25],instr[11:8],1'b0};
    assign branch_addr = (branch_mux == 1'b0 && branch_en==1'b1)? (pc+branch_offset): 64'bz;
     always @(posedge clk) begin
     //$display("branch_pc: %h",branch_pc);
       if(branch_en == 1'b1 && branch_mux == 1'b0) begin
          pc<=branch_addr;
        end
        else begin
          pc <=  pc + 3'd4;
         end
    
   // $display("PC: %d",PC);
      end
  //fetch_RISCV U2(clk,branch_en,branch_addr,pc);
  
  instruction_mem U3(pc,instr);
  /*Decode the instruction and fetch the ALU operation, load instruction type, store instruction type, destination register address, Input 1 & 2's register addresses,
  Register file write enable, data memory write enable, data memory read enable*/
  Decoder_64_bit_RISC U4(instr,Alu_opr,load_flag,store_flag,Rd_addr,Rs1_addr,Rs2_addr,reg_write_en,mem_write_en,mem_read_en,branch_en);

  //Fetch the data value from register file for input data 1 and input data 2
  Reg_file U5(reg_write_en,Rs1_addr,Rs2_addr,Rd_addr,reg_file_input,Rs1_data,Rs2_data);

  //Assign the 2nd input to ALU as per the type of instruction
  assign input2_data = (instr[6:0] === 7'b0110011 || instr[6:0]===7'b1100011) ? Rs2_data : //R-type & branch type instruction's register value
            (instr[6:0] === 7'b0010011 || instr[6:0] === 7'b0000011 )? 
            ((instr[31]=== 1'b1)?{52'hFFFFFFFFFFFFF,instr[31:20]}:{52'h0000000000000,instr[31:20]}) : //I-type & L-Load type instruction's immediate value
            (instr[6:0] === 7'b0100011) ? ((instr[31]==1'b1)?{52'hFFFFFFFFFFFFF,instr[31:25],instr[11:7]}:{52'h0000000000000,instr[31:25],instr[11:7]}): //Store instruction's immediate value
                        64'bz;
                        //{instr[31],instr[7],instr[30:25],instr[11:8]};  //Branch instruction's immediate value

  //ALU performs the operation as per the instruction
  ALU_64bit_RISCV U6(Alu_opr,Rs1_data,input2_data,Alu_output,branch_mux);
  
  //Data memory is of 2047 x 8 means 8-bit as RISC V has byte addressable memory.
  data_memory U7(load_flag,store_flag,mem_write_en,mem_read_en,Alu_output,Rs2_data,mem_data_output);

  //This is a mux having two inputs with one select line.It provides the data memory output if instruction is load else provides the alu output to the register file 
  assign reg_file_input = (mem_read_en == 1'b1 && mem_write_en == 1'b0 && reg_write_en== 1'b1)? mem_data_output:Alu_output; 
always @(posedge clk) begin
     $display("-------------------------------------------------------------------------------------------------------------------------------------------------------");
     $display("pc: %h,instr: %h, Alu_opr: %b, load_flag: %b,store_flag: %b ",pc,instr, Alu_opr, load_flag,store_flag );
     $display("Rd_addr: %d,Rs1_addr: %d, Rs2_addr: %d",Rd_addr,Rs1_addr, Rs2_addr);
     $display("reg_write_en: %b, mem_write_en: %b, mem_read_en:%b, branch_en: %b", reg_write_en, mem_write_en, mem_read_en,branch_en);
     $display("Rs1_data: %d, Rs2_data: %d, input2_data: %d", Rs1_data,Rs2_data, input2_data);
     $display("Alu_output: %d, branch_mux: %d, mem_data_output: %b,reg_file_input: %d",Alu_output,branch_mux, mem_data_output,reg_file_input);

  end
/*always@ (posedge instr)begin
   $monitor("Wen: %b,Rs1_addr: %h,Rs2_addr: %h,Wd_addr: %h,write_data: %h,Rs1_data: %h,Rs2_data: %h, alu_output: %h", Wen,Rs1_addr,Rs2_addr,Wd_addr,write_data,Rs1_data,Rs2_data,Alu_output);
end*/
endmodule