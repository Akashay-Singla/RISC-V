module Decoder_64_bit_RISC(
input [31:0] input_inst,
output reg [3:0] Alu_opr,
output reg [4:0] Rd_addr, Rs1_addr,Rs2_addr,
output reg Wen);


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

//always @(posedge clk)begin
always @(input_inst) begin
/*inst_format = inst_type();
$display("inst_format: %h", inst_format);
$display("input_inst[6:0] = %h",input_inst[6:0] );*/
case (input_inst[6:0])
//R-Register instructions
7'b0110011: begin
  Rs1_addr = input_inst[19:15];
  Rs2_addr = input_inst[24:20];
  Rd_addr =  input_inst[11:7];
  Wen=1;
  Alu_opr = Alu_opr_R(input_inst[14:12],input_inst[31:25]);
end
//I-immediate instructions
7'b0010011: begin 
  $display("Entered into immediate loop");
  Rs1_addr = input_inst[19:15];
  Rs2_addr = 5'bz;
  Rd_addr =  input_inst[11:7];
  Wen=1;
  Alu_opr = Alu_opr_I(input_inst[14:12]);
end
//Load-instruction
7'b0000011: begin
  Rs1_addr = input_inst[19:15];
  Rs2_addr = 5'bz;
  Rd_addr =  input_inst[11:7];
  Wen=0;
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
  Wen=0;
end
//Branch Instruction
7'b1100111: begin
  //immed[11] = input_inst[31];
  //immed[10] = input_inst[7];
  //immed[3:0] = input_inst[11:8];
  //immed[9:4] = input_inst[30:25];
  Rs1_addr = input_inst[19:15];
  Rs2_addr = input_inst[24:20];
  Alu_opr = 1001;// Compare ""==""
  Wen=0;
end
default: begin
 Rs1_addr= 5'bz;
 Rs2_addr = 5'bz;
 Rd_addr = 5'bz;
 //immed = 12'bz;
 Alu_opr = 4'bz;
 Wen=0;
end
endcase
$display("Alu_opr: %b, Rd_addr: %b , Rs1_addr: %b, Rs2_addr: %b, Wen: %b",Alu_opr, Rd_addr,Rs1_addr,Rs2_addr,Wen);
end
endmodule

module Reg_file(input Wen, 
input [4:0] Rs1_addr,Rs2_addr, Rd_addr,
input [63:0] write_data,
output [63:0] Rs1_data,Rs2_data);
reg[63:0] mem[31:0]; 
integer  i;
initial begin
  $display("Entered into intial memory loop");
  for(i=0;i<32;i++)begin
    if(i==5'b10100) begin
      mem[i] = 64'h456701023D2;
    end
    else if(i== 5'b10101 )begin
     mem[i]= 64'h012005C2;
    end
    else begin
      mem[i]=64'd0;
    end
  end
end

 assign Rs1_data = mem[Rs1_addr];
 assign Rs2_data = mem[Rs2_addr];
always @(Rs1_data or Rs2_data) begin
  $display("Rs1_data: %h, Rs2_data: %h", Rs1_data,Rs2_data);
end
always @(posedge Wen or write_data )begin
  //if(Wen)begin
   $display("Entered into write loop");
  mem[Rd_addr] = write_data;
  $monitor("Rd_addr: %h, mem[Rd_addr]: %h",Rd_addr,mem[Rd_addr]);
//end
end
endmodule
