module Decoder_64_bit_RISC(
input [31:0] input_inst,
output reg [3:0] Alu_opr,load_flag,
output reg [1:0] store_flag,
output reg [4:0] Rd_addr, Rs1_addr,Rs2_addr,
output reg reg_write_en,mem_write_en,mem_read_en,branch_en);


//This function finds the sub instruction of R-type
function [3:0]Alu_opr_R;
input [2:0] func3;
input [0:6] func7;
    
case ({func3,func7})
10'b0000000000: Alu_opr_R = 0000; //ADD instruction
10'b0000100000: Alu_opr_R = 0001; //SUB instruction
10'b0010000000: Alu_opr_R = 0010;//Sll instruction 
10'b1000000000: Alu_opr_R = 0011;//xor instruction
10'b1010000000: Alu_opr_R = 0100;//srl instruction
10'b1010100000: Alu_opr_R = 0101;//sra instruction
10'b1100000000: Alu_opr_R = 0110;//OR instruction
10'b1110000000: Alu_opr_R = 0111;//AND instruction
10'b0100000000: Alu_opr_R = 1000;//SLT instruction
default: Alu_opr_R = 1111; //NOP
endcase
endfunction


function [2:0]Alu_opr_I;
input [2:0] func3;
    
case (func3)
3'b000: Alu_opr_I = 0000; //addi instruction
3'b001: Alu_opr_I = 0010; //Slli instruction
3'b100: Alu_opr_I = 0011;//xori instruction
3'b101: Alu_opr_I = 0100;//srli instruction
//1010 Alu_opr_R = 0101;//srai instruction
3'b110: Alu_opr_I = 0110;//ORi instruction
3'b111: Alu_opr_I = 0111;//AND instruction
default: Alu_opr_I = 1111; //NOP
endcase
endfunction



function [2:0]Alu_opr_B;
input [2:0] func3;
    
case (func3)
3'b000: Alu_opr_B = 0111; //beq instruction
3'b001: Alu_opr_B = 1000; //Bne instruction
3'b100: Alu_opr_B = 1001;//blt instruction
3'b101: Alu_opr_B = 1010;//bge instruction
//1010 Alu_opr_R = 0101;//srai instruction
3'b110: Alu_opr_B = 0110;//bltu instruction
3'b111: Alu_opr_B = 0111;//bgeu instruction
default: Alu_opr_B = 1111; //NOP
endcase
endfunction

function [1:0]store_format;
input [2:0] func3;
    
case (func3)
3'b000: store_format = 00; //Store byte instruction
3'b001: store_format = 01; //Store halfword instruction
3'b010: store_format = 10;//Store word instruction
3'b011: store_format = 11;//Store doubleword
default: store_format = 2'bz; //NOP
endcase
endfunction

function [2:0]load_format;
input [2:0] func3;
case (func3)
3'b000: load_format = 000; //Load byte instruction
3'b001: load_format = 001; //Load halfword instruction
3'b010: load_format = 010;//Load word instruction
3'b100: load_format = 011;// Load unsigned byte
3'b101: load_format = 100; //load unsigned halfword
3'b011: load_format = 101;//Load doubleword instruction
default: load_format = 111; //NOP
endcase
endfunction

//always @(posedge clk)begin
always @(input_inst) begin
  $display("input_inst: %h",input_inst );
/*inst_format = inst_type();
$display("inst_format: %h", inst_format);
$display("input_inst[6:0] = %h",input_inst[6:0] );*/
case (input_inst[6:0])
//R-Register instructions
7'b0110011: begin
  Rs1_addr = input_inst[19:15];
  Rs2_addr = input_inst[24:20];
  Rd_addr =  input_inst[11:7];
  reg_write_en=1'b1;
  mem_write_en=1'b0;
  mem_read_en=1'b0;
  branch_en = 1'b0;
  Alu_opr = Alu_opr_R(input_inst[14:12],input_inst[31:25]);
end
//I-immediate instructions
7'b0010011: begin 
  $display("Entered into immediate loop");
  Rs1_addr = input_inst[19:15];
  Rs2_addr = 5'bz;
  Rd_addr =  input_inst[11:7];
  reg_write_en=1'b1;
  mem_write_en=1'b0;
  mem_read_en=1'b0;
  branch_en = 1'b0;
  Alu_opr = Alu_opr_I(input_inst[14:12]);
end
//Load-instruction
7'b0000011: begin
  Rs1_addr = input_inst[19:15];
  Rs2_addr = 5'bz;
  Rd_addr =  input_inst[11:7];
  reg_write_en=1'b1;
  mem_write_en=1'b0;
  mem_read_en=1'b1;
  branch_en = 1'b0;
  load_flag = load_format(input_inst[14:12]);
  Alu_opr = 0000;
end
//Store Instruction
7'b0100011: begin
  //immed[4:0]= input_inst[11:7];
  //immed[11:5]= input_inst[31:25];
  Rs1_addr = input_inst[19:15];
  Rs2_addr = input_inst[24:20];
  Rd_addr = 5'bz;
  Alu_opr = 0000;
  store_flag=store_format(input_inst[14:12]);
  reg_write_en=1'b0;
  mem_write_en=1'b1;
  mem_read_en=1'b0;
  branch_en = 1'b0;
end
//Branch Instruction
7'b1100111: begin
  //immed[11] = input_inst[31];
  //immed[10] = input_inst[7];
  //immed[3:0] = input_inst[11:8];
  //immed[9:4] = input_inst[30:25];
  $display("Entered into branch loop");
  Rs1_addr = input_inst[19:15];
  Rs2_addr = input_inst[24:20];
  Alu_opr = Alu_opr_B(input_inst[14:12]);
  reg_write_en=1'b0;
  mem_write_en=1'b0;
  mem_read_en=1'b0;
  branch_en = 1'b1;
end
default: begin
 Rs1_addr= 5'bz;
 Rs2_addr = 5'bz;
 Rd_addr = 5'bz;
 //immed = 12'bz;
 Alu_opr = 4'bz;
  reg_write_en=1'b0;
  mem_write_en=1'b0;
  mem_read_en=1'b0;
  branch_en=1'b0;
end
endcase
$display("Alu_opr: %b, Rd_addr: %b , Rs1_addr: %b, Rs2_addr: %b, reg_write_en: %b",Alu_opr, Rd_addr,Rs1_addr,Rs2_addr,reg_write_en);
end
endmodule

