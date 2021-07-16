
module instruction_mem(input[63:0] PC,PC4,output reg[31:0] instr1 , instr2);

reg[7:0] byte_instr[65535:0];
initial begin
   //32'h015A04B3  ADD X9, X14 ,X15
   byte_instr[64'h0000000000000000]<=8'hB3;
   byte_instr[64'h0000000000000001]<=8'h04;
   byte_instr[64'h0000000000000002]<=8'h5A;
   byte_instr[64'h0000000000000003]<=8'h01;

   //32'h00148493 ADDi x9, x9, 1 add 1 to the value of x9 register
   byte_instr[64'h0000000000000004]<=8'h93;
   byte_instr[64'h0000000000000005]<=8'h84;
   byte_instr[64'h0000000000000006]<=8'h14;
   byte_instr[64'h0000000000000007]<=8'h00;
    /*
   //32'hFFF48493 ADDi x9, x9, -1 add 1 to the value of x9 register
   byte_instr[64'h0000000000000008]<=8'h93;
   byte_instr[64'h0000000000000009]<=8'h84;
   byte_instr[64'h000000000000000A]<=8'hF4;
   byte_instr[64'h000000000000000B]<=8'hFF;
*/
   //32'h0E953823 SD X9,240(x10) doubleword
   byte_instr[64'h0000000000000008]<=8'h23;
   byte_instr[64'h0000000000000009]<=8'h38;
   byte_instr[64'h000000000000000A]<=8'h95;
   byte_instr[64'h000000000000000B]<=8'hF0;//0E; //-240 offset

   //32'h0F053283 LD x5,240(x10)  doubleword
   byte_instr[64'h00000000000000C]<=8'h83;
   byte_instr[64'h00000000000000D]<=8'h32;
   byte_instr[64'h00000000000000E]<=8'h05;
   byte_instr[64'h00000000000000F]<=8'hF1;//0F;  //-240 offset

  /* 32'h02548167 Beq x5,x9,11(hex and 17 in decimal)
   byte_instr[64'h0000000000000014]<=8'h67;
   byte_instr[64'h0000000000000015]<=8'h81;
   byte_instr[64'h0000000000000016]<=8'h54;
   byte_instr[64'h0000000000000017]<=8'h02; 


  //32'h80548867 Beq x5,x9,-16(-16 in decimal)
   byte_instr[64'h0000000000000010]<=8'hE7;
   byte_instr[64'h0000000000000011]<=8'h88;
   byte_instr[64'h0000000000000012]<=8'h54;
   byte_instr[64'h0000000000000013]<=8'hFE;

   //32'h00148593 ADDi xB, x9, 1 add 1 to the value of x9 register
   byte_instr[64'h0000000000000025]<=8'h93;
   byte_instr[64'h0000000000000026]<=8'h85;
   byte_instr[64'h0000000000000027]<=8'h14;
   byte_instr[64'h0000000000000028]<=8'h00;
*/
   //ADD X5,X6,X7
   byte_instr[64'h0000000000000010]<=8'hB3;
   byte_instr[64'h0000000000000011]<=8'h82;
   byte_instr[64'h0000000000000012]<=8'h63;
   byte_instr[64'h0000000000000013]<=8'h00;

   //SUB X7,X4,X3
   byte_instr[64'h0000000000000014]<=8'hB3;
   byte_instr[64'h0000000000000015]<=8'h83;
   byte_instr[64'h0000000000000016]<=8'h41;
   byte_instr[64'h0000000000000017]<=8'h40;

  //AND X2,X5,X7
   byte_instr[64'h0000000000000018]<=8'h33;
   byte_instr[64'h0000000000000019]<=8'hF1;
   byte_instr[64'h000000000000001A]<=8'h53;
   byte_instr[64'h000000000000001B]<=8'h00;

   //OR X30,X29,X28
   byte_instr[64'h000000000000001C]<=8'h33;
   byte_instr[64'h000000000000001D]<=8'h6F;
   byte_instr[64'h000000000000001E]<=8'hDE;
   byte_instr[64'h000000000000001F]<=8'h01;

   //XOR X27,X26,X25
   byte_instr[64'h0000000000000020]<=8'hB3;
   byte_instr[64'h0000000000000021]<=8'hCD;
   byte_instr[64'h0000000000000022]<=8'hAC;
   byte_instr[64'h0000000000000023]<=8'h01;

   //SLL X6,X5,X2
   byte_instr[64'h0000000000000024]<=8'h33;
   byte_instr[64'h0000000000000025]<=8'h13;
   byte_instr[64'h0000000000000026]<=8'h51;
   byte_instr[64'h0000000000000027]<=8'h00;

  //SRL X7,X2,X6
   byte_instr[64'h0000000000000028]<=8'hB3;
   byte_instr[64'h0000000000000029]<=8'h53;
   byte_instr[64'h000000000000002A]<=8'h23;
   byte_instr[64'h000000000000002B]<=8'h00;

   //BEQ x7,x5,offset
   byte_instr[64'h000000000000002C]<=8'h63;
   byte_instr[64'h000000000000002D]<=8'h84;
   byte_instr[64'h000000000000002E]<=8'h72;
   byte_instr[64'h000000000000002F]<=8'h02;

    //ORi X20,x21,20
   byte_instr[64'h0000000000000054]<=8'h13;
   byte_instr[64'h0000000000000055]<=8'hEA;
   byte_instr[64'h0000000000000056]<=8'h4A;
   byte_instr[64'h0000000000000057]<=8'h01;

   //ANDi X19,x21,20
   byte_instr[64'h0000000000000058]<=8'h93;
   byte_instr[64'h0000000000000059]<=8'hF9;
   byte_instr[64'h000000000000005A]<=8'hFA;
   byte_instr[64'h000000000000005B]<=8'h7F;


   //XORi X18,x21,20
   byte_instr[64'h000000000000005C]<=8'h13;
   byte_instr[64'h000000000000005D]<=8'hC9;
   byte_instr[64'h000000000000005E]<=8'h4A;
   byte_instr[64'h000000000000005F]<=8'h01;


  //XORi X18,x21,20
   byte_instr[64'h000000000000005C]<=8'h13;
   byte_instr[64'h000000000000005D]<=8'hC9;
   byte_instr[64'h000000000000005E]<=8'h4A;
   byte_instr[64'h000000000000005F]<=8'h01;



end

always @(PC)begin
 //$display("PC: %h", PC);
 instr1[7:0] <= byte_instr[PC];
 instr1[15:8] <= byte_instr[PC+1];
 instr1[23:16] <= byte_instr[PC+2];
 instr1[31:24] <= byte_instr[PC+3];

 instr2[7:0] <= byte_instr[PC4];
 instr2[15:8] <= byte_instr[PC4+1];
 instr2[23:16] <= byte_instr[PC4+2];
 instr2[31:24] <= byte_instr[PC4+3];
// $display("instr[31:0]: %h",instr);
end
endmodule


module clk_input(output reg clk);
initial begin
  //$dumpfile("datapath_log.vcd");
  //$dumpvars;
  #100;
  $finish;
end
initial begin
    clk=0;
end
always #3 clk= ~clk;

endmodule


/*
module fetch_RISCV(input clk,branch_en,stall,
input signed [63:0] branch_pc,
output reg signed [63:0] PC,PC4);
initial begin
    PC=32'b0;
end
//reg[31:0] PC;
always @(posedge clk) begin
  //$display("branch_pc: %h",branch_pc);
    if(branch_en == 1'b1) begin
      PC<=branch_pc;
      PC4 <= branch_pc + 4; 
    end
    else if(stall == 1'b1) begin
    PC<=PC;
    PC4<=PC4;
    end
    else begin
    PC <=  PC + 4;
    PC4 <= PC4 + 4;
    end
    
    //$display("PC: %d",PC);
end
//always @()
endmodule
*/