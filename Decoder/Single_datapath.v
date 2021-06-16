`include "decoder.v"
`include "Alu.v"
module Single_datapath(input[31:0] instr,
input clk);
reg [3:0] Alu_opr;
reg [4:0] Rd_addr, Rs1_addr,Rs2_addr;
wire[63:0] Alu_output;
wire[4:0] Wd_addr;
//wire Wen;
wire [63:0] Rs1_data,Rs2_data,input2_data,Rs3_data,Rs4_data;
reg Wen;
//assign Wen =1;
//assign Wd_addr = ;

//always @(posedge clk)begin
  Decoder_64_bit_RISC u2 (instr,Alu_opr,Rd_addr,Rs1_addr,Rs2_addr,Wen);
  Reg_file u3 (Wen,Rs1_addr,Rs2_addr,Rd_addr,Alu_output,Rs1_data,Rs2_data);
  assign input2_data = (instr[6:0] == 7'b0110011) ? Rs2_data : {52'b0,instr[31:20]};
  ALU_64bit_RISCV u4(Alu_opr,Rs1_data,input2_data,Alu_output);
  //Reg_file u3 (clk,1,5'bz,5'bz,Rd_addr,Alu_output,Rs3_data,Rs4_data);
/*always@ (posedge instr)begin
   $monitor("Wen: %b,Rs1_addr: %h,Rs2_addr: %h,Wd_addr: %h,write_data: %h,Rs1_data: %h,Rs2_data: %h, alu_output: %h", Wen,Rs1_addr,Rs2_addr,Wd_addr,write_data,Rs1_data,Rs2_data,Alu_output);
end*/
endmodule