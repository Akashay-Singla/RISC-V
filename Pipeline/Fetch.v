
module fetch_RISCV(input clk,branch_en,
input signed [63:0] branch_pc,
output reg signed [63:0] PC);
initial begin
    PC=32'b0;
end
//reg[31:0] PC;
always @(posedge clk) begin
  //$display("branch_pc: %h",branch_pc);
    if(branch_en == 1) begin
      PC<=branch_pc;
    end
    else begin
    PC <=  PC + 4;
    end
    
    $display("PC: %d",PC);
end
//always @()
endmodule

module instruction_mem(input[31:0] PC,output reg[31:0] instr);

reg[7:0] byte_instr[65535:0];
initial begin
   //32'h015A04B3  ADD X9, X14 ,X15
   byte_instr[64'h0000000000000004]<=8'hB3;
   byte_instr[64'h0000000000000005]<=8'h04;
   byte_instr[64'h0000000000000006]<=8'h5A;
   byte_instr[64'h0000000000000007]<=8'h01;
/*
   //32'h00148493 ADDi x9, x9, 1 add 1 to the value of x9 register
   byte_instr[64'h0000000000000008]<=8'h93;
   byte_instr[64'h0000000000000009]<=8'h84;
   byte_instr[64'h000000000000000A]<=8'h14;
   byte_instr[64'h000000000000000B]<=8'h00;
    */
   //32'h00148493 ADDi x9, x9, 1 add 1 to the value of x9 register
   byte_instr[64'h0000000000000008]<=8'h93;
   byte_instr[64'h0000000000000009]<=8'h84;
   byte_instr[64'h000000000000000A]<=8'hF4;
   byte_instr[64'h000000000000000B]<=8'hFF;

   //32'h0E953823 SD X9,240(x10) doubleword
   byte_instr[64'h000000000000000C]<=8'h23;
   byte_instr[64'h000000000000000D]<=8'h38;
   byte_instr[64'h000000000000000E]<=8'h95;
   byte_instr[64'h000000000000000F]<=8'hF0;//0E; 

   //32'h0F053283 LD x5,240(x10)  doubleword
   byte_instr[64'h0000000000000010]<=8'h83;
   byte_instr[64'h0000000000000011]<=8'h32;
   byte_instr[64'h0000000000000012]<=8'h05;
   byte_instr[64'h0000000000000013]<=8'hF1;//0F;

  /* 32'h02548167 Beq x5,x9,11(hex and 17 in decimal)
   byte_instr[64'h0000000000000014]<=8'h67;
   byte_instr[64'h0000000000000015]<=8'h81;
   byte_instr[64'h0000000000000016]<=8'h54;
   byte_instr[64'h0000000000000017]<=8'h02; 
*/

  //32'h80548867 Beq x5,x9,-16(-16 in decimal)
   byte_instr[64'h0000000000000014]<=8'hE7;
   byte_instr[64'h0000000000000015]<=8'h88;
   byte_instr[64'h0000000000000016]<=8'h54;
   byte_instr[64'h0000000000000017]<=8'hFE;

   //32'h00148593 ADDi xB, x9, 1 add 1 to the value of x9 register
   byte_instr[64'h0000000000000025]<=8'h93;
   byte_instr[64'h0000000000000026]<=8'h85;
   byte_instr[64'h0000000000000027]<=8'h14;
   byte_instr[64'h0000000000000028]<=8'h00;


end

always @(PC)begin
    $display("PC: %h", PC);
 instr[7:0] <= byte_instr[PC];
 instr[15:8] <= byte_instr[PC+1];
 instr[23:16] <= byte_instr[PC+2];
 instr[31:24] <= byte_instr[PC+3];
// $display("instr[31:0]: %h",instr);
end
endmodule


module clk_input(output reg clk);
initial begin
  $dumpfile("Single_datapath_log.vcd");
  $dumpvars;
  #300;
  $finish;
end
initial begin
    clk=0;
end
always #15 clk= ~clk;

endmodule