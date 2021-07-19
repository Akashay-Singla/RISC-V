
module instruction_mem(input[63:0] pc,output reg[31:0] instr);

reg[7:0] byte_instr[65535:0];
initial begin
   //32'h015A04B3  ADD X9, X21 ,X20
   byte_instr[64'h0000000000000000]<=8'hB3;
   byte_instr[64'h0000000000000001]<=8'h04;
   byte_instr[64'h0000000000000002]<=8'h5A;
   byte_instr[64'h0000000000000003]<=8'h01;

   //32'h00148493 ADDi x23, x9, 1 add 1 to the value of x9 register
   byte_instr[64'h0000000000000004]<=8'h93;
   byte_instr[64'h0000000000000005]<=8'h8B;
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


  //SB X2,x19,-10
   byte_instr[64'h0000000000000060]<=8'h23;
   byte_instr[64'h0000000000000061]<=8'h8B;
   byte_instr[64'h0000000000000062]<=8'h99;
   byte_instr[64'h0000000000000063]<=8'hFE;

   //SH X2,x19,-9
   byte_instr[64'h0000000000000064]<=8'hA3;
   byte_instr[64'h0000000000000065]<=8'h9B;
   byte_instr[64'h0000000000000066]<=8'h99;
   byte_instr[64'h0000000000000067]<=8'hFE;

    //SW X2,x19,-8
   byte_instr[64'h0000000000000068]<=8'hA3;
   byte_instr[64'h0000000000000069]<=8'hAC;
   byte_instr[64'h000000000000006A]<=8'h99;
   byte_instr[64'h000000000000006B]<=8'hFE;


   //LB X15,x19,-10
   byte_instr[64'h000000000000006C]<=8'h83;
   byte_instr[64'h000000000000006D]<=8'h87;
   byte_instr[64'h000000000000006E]<=8'h69;
   byte_instr[64'h000000000000006F]<=8'hFF; 

   //LH X14,x19,-9
   byte_instr[64'h0000000000000070]<=8'h03;
   byte_instr[64'h0000000000000071]<=8'h97;
   byte_instr[64'h0000000000000072]<=8'h79;
   byte_instr[64'h0000000000000073]<=8'hFF; 

   //LW X13,x19,-8
   byte_instr[64'h0000000000000074]<=8'h83;
   byte_instr[64'h0000000000000075]<=8'hA6;
   byte_instr[64'h0000000000000076]<=8'h99;
   byte_instr[64'h0000000000000077]<=8'hFF; 
end

always @(pc)begin
 //$display("PC: %h", pc);
 instr[7:0] <= byte_instr[pc];
 instr[15:8] <= byte_instr[pc+3'd1];
 instr[23:16] <= byte_instr[pc+3'd2];
 instr[31:24] <= byte_instr[pc+3'd3];
//$display("instr[31:0]: %h",instr);
end
endmodule


module clk_input(output reg clk);
initial begin
  $dumpfile("Single_datapath_log.vcd");
  $dumpvars;
  #5;
  $finish;
end
initial begin
    clk=1'b0;
end
always #0.1 clk= ~clk;

endmodule