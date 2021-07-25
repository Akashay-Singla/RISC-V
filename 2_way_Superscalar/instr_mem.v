
module instruction_mem(input[63:0] PC,PC4,output [31:0] instr1 , instr2);

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
//Akashay Singla
   //32'h0E953823 SD X9,240(x10) doubleword
   byte_instr[64'h0000000000000008]<=8'h23;
   byte_instr[64'h0000000000000009]<=8'h38;
   byte_instr[64'h000000000000000A]<=8'h95;
   byte_instr[64'h000000000000000B]<=8'hF0;//0E; //-240 offset

   //32'h0F053283 LD x5,240(x10)  doubleword
   byte_instr[64'h00000000000000C]<=8'h03;
   byte_instr[64'h00000000000000D]<=8'h34;
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
   //ADD X8,X6,X7
   byte_instr[64'h0000000000000010]<=8'h33;
   byte_instr[64'h0000000000000011]<=8'h04;
   byte_instr[64'h0000000000000012]<=8'h73;
   byte_instr[64'h0000000000000013]<=8'h00;

   //SUB X7,X4,X3
   byte_instr[64'h0000000000000014]<=8'hB3;
   byte_instr[64'h0000000000000015]<=8'h83;
   byte_instr[64'h0000000000000016]<=8'h41;
   byte_instr[64'h0000000000000017]<=8'h40;

  //AND X2,X8,X7
   byte_instr[64'h0000000000000018]<=8'h33;
   byte_instr[64'h0000000000000019]<=8'hF1;
   byte_instr[64'h000000000000001A]<=8'h83;
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

   //SLL X6,X8,X2
   byte_instr[64'h0000000000000024]<=8'h33;
   byte_instr[64'h0000000000000025]<=8'h13;
   byte_instr[64'h0000000000000026]<=8'h24;
   byte_instr[64'h0000000000000027]<=8'h00;

  //SRL X7,X2,X6
   byte_instr[64'h0000000000000028]<=8'hB3;
   byte_instr[64'h0000000000000029]<=8'h53;
   byte_instr[64'h000000000000002A]<=8'h23;
   byte_instr[64'h000000000000002B]<=8'h00;

   //BEQ x7,x8,offset
   byte_instr[64'h000000000000002C]<=8'h63;
   byte_instr[64'h000000000000002D]<=8'h04;
   byte_instr[64'h000000000000002E]<=8'h74;
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

   
byte_instr[64'h7b]<= 8'h40;
byte_instr[64'h7a]<= 8'h00;
byte_instr[64'h79]<= 8'h01;
byte_instr[64'h78]<= 8'h13;

byte_instr[64'h7f]<= 8'h00;
byte_instr[64'h7e]<= 8'h21;
byte_instr[64'h7d]<= 8'h01;
byte_instr[64'h7c]<= 8'hB3;

byte_instr[64'h83]<= 8'h00;
byte_instr[64'h82]<= 8'h21;
byte_instr[64'h81]<= 8'hE2;
byte_instr[64'h80]<= 8'h33;

byte_instr[64'h87]<= 8'h4D;
byte_instr[64'h86]<= 8'h20;
byte_instr[64'h85]<= 8'h02;
byte_instr[64'h84]<= 8'h93;

byte_instr[64'h8b]<= 8'h01;
byte_instr[64'h8a]<= 8'h02;
byte_instr[64'h89]<= 8'h93;
byte_instr[64'h88]<= 8'h13;

byte_instr[64'h8f]<= 8'h3E;
byte_instr[64'h8e]<= 8'h73;
byte_instr[64'h8d]<= 8'h03;
byte_instr[64'h8c]<= 8'h93;

byte_instr[64'h93]<= 8'h40;
byte_instr[64'h92]<= 8'h23;
byte_instr[64'h91]<= 8'h84;
byte_instr[64'h90]<= 8'h33;

byte_instr[64'h97]<= 8'h00;
byte_instr[64'h96]<= 8'h32;
byte_instr[64'h95]<= 8'h44;
byte_instr[64'h94]<= 8'hB3;

byte_instr[64'h9b]<= 8'h0F;
byte_instr[64'h9a]<= 8'hF1;
byte_instr[64'h99]<= 8'h45;
byte_instr[64'h98]<= 8'h13;

byte_instr[64'h9f]<= 8'h00;
byte_instr[64'h9e]<= 8'h53;
byte_instr[64'h9d]<= 8'h55;
byte_instr[64'h9c]<= 8'h93;

byte_instr[64'ha3]<= 8'h00;
byte_instr[64'ha2]<= 8'h75;
byte_instr[64'ha1]<= 8'hF6;
byte_instr[64'ha0]<= 8'hB3;

byte_instr[64'ha7]<= 8'h06;
byte_instr[64'ha6]<= 8'h42;
byte_instr[64'ha5]<= 8'hF7;
byte_instr[64'ha4]<= 8'h13;

byte_instr[64'hab]<= 8'h40;
byte_instr[64'haa]<= 8'hA0;
byte_instr[64'ha9]<= 8'h07;
byte_instr[64'ha8]<= 8'hB3;

byte_instr[64'haf]<= 8'h00;
byte_instr[64'hae]<= 8'hA0;
byte_instr[64'had]<= 8'h05;
byte_instr[64'hac]<= 8'h13;

byte_instr[64'hb3]<= 8'h0F;
byte_instr[64'hb2]<= 8'hF0;
byte_instr[64'hb1]<= 8'h02;
byte_instr[64'hb0]<= 8'h93;

byte_instr[64'hb7]<= 8'h00;
byte_instr[64'hb6]<= 8'h52;
byte_instr[64'hb5]<= 8'h83;
byte_instr[64'hb4]<= 8'h33;

byte_instr[64'hbb]<= 8'h00;
byte_instr[64'hba]<= 8'h63;
byte_instr[64'hb9]<= 8'h03;
byte_instr[64'hb8]<= 8'hB3;

byte_instr[64'hbf]<= 8'h7D;
byte_instr[64'hbe]<= 8'h03;
byte_instr[64'hbd]<= 8'h84;
byte_instr[64'hbc]<= 8'h13;

byte_instr[64'hc3]<= 8'h00;
byte_instr[64'hc2]<= 8'h50;
byte_instr[64'hc1]<= 8'hA0;
byte_instr[64'hc0]<= 8'h23;

byte_instr[64'hc7]<= 8'h00;
byte_instr[64'hc6]<= 8'h60;
byte_instr[64'hc5]<= 8'hA2;
byte_instr[64'hc4]<= 8'h23;

byte_instr[64'hcb]<= 8'h00;
byte_instr[64'hca]<= 8'h70;
byte_instr[64'hc9]<= 8'hA4;
byte_instr[64'hc8]<= 8'h23;

byte_instr[64'hcf]<= 8'h00;
byte_instr[64'hce]<= 8'h80;
byte_instr[64'hcd]<= 8'hA6;
byte_instr[64'hcc]<= 8'h23;

byte_instr[64'hd3]<= 8'h00;
byte_instr[64'hd2]<= 8'h00;
byte_instr[64'hd1]<= 8'hA4;
byte_instr[64'hd0]<= 8'h83;

byte_instr[64'hd7]<= 8'h00;
byte_instr[64'hd6]<= 8'h40;
byte_instr[64'hd5]<= 8'hA5;
byte_instr[64'hd4]<= 8'h03;

byte_instr[64'hdb]<= 8'h00;
byte_instr[64'hda]<= 8'h80;
byte_instr[64'hd9]<= 8'hA5;
byte_instr[64'hd8]<= 8'h83;

byte_instr[64'hdf]<= 8'h00;
byte_instr[64'hde]<= 8'hC0;
byte_instr[64'hdd]<= 8'hA6;
byte_instr[64'hdc]<= 8'h03;

byte_instr[64'he3]<= 8'h00;
byte_instr[64'he2]<= 8'h40;
byte_instr[64'he1]<= 8'h80;
byte_instr[64'he0]<= 8'h93;

byte_instr[64'he7]<= 8'h00;
byte_instr[64'he6]<= 8'h50;
byte_instr[64'he5]<= 8'hA0;
byte_instr[64'he4]<= 8'h23;

byte_instr[64'heb]<= 8'h00;
byte_instr[64'hea]<= 8'h60;
byte_instr[64'he9]<= 8'hA2;
byte_instr[64'he8]<= 8'h23;

byte_instr[64'hef]<= 8'h00;
byte_instr[64'hee]<= 8'h70;
byte_instr[64'hed]<= 8'hA4;
byte_instr[64'hec]<= 8'h23;

byte_instr[64'hf3]<= 8'h00;
byte_instr[64'hf2]<= 8'h80;
byte_instr[64'hf1]<= 8'hA6;
byte_instr[64'hf0]<= 8'h23;

byte_instr[64'hf7]<= 8'hFF;
byte_instr[64'hf6]<= 8'hC0;
byte_instr[64'hf5]<= 8'hA6;
byte_instr[64'hf4]<= 8'h83;

byte_instr[64'hfb]<= 8'h00;
byte_instr[64'hfa]<= 8'h00;
byte_instr[64'hf9]<= 8'hA7;
byte_instr[64'hf8]<= 8'h03;

byte_instr[64'hff]<= 8'h00;
byte_instr[64'hfe]<= 8'h40;
byte_instr[64'hfd]<= 8'hA7;
byte_instr[64'hfc]<= 8'h83;

byte_instr[64'h103]<= 8'h00;
byte_instr[64'h102]<= 8'h80;
byte_instr[64'h101]<= 8'hA8;
byte_instr[64'h100]<= 8'h03;

byte_instr[64'h107]<= 8'h00;
byte_instr[64'h106]<= 8'h90;
byte_instr[64'h105]<= 8'h08;
byte_instr[64'h104]<= 8'hB3;

byte_instr[64'h10b]<= 8'h00;
byte_instr[64'h10a]<= 8'hA8;
byte_instr[64'h109]<= 8'h88;
byte_instr[64'h108]<= 8'hB3;

byte_instr[64'h10f]<= 8'h00;
byte_instr[64'h10e]<= 8'hB8;
byte_instr[64'h10d]<= 8'h88;
byte_instr[64'h10c]<= 8'hB3;

byte_instr[64'h113]<= 8'h00;
byte_instr[64'h112]<= 8'hC8;
byte_instr[64'h111]<= 8'h88;
byte_instr[64'h110]<= 8'hB3;

byte_instr[64'h117]<= 8'h00;
byte_instr[64'h116]<= 8'hD8;
byte_instr[64'h115]<= 8'h88;
byte_instr[64'h114]<= 8'hB3;

byte_instr[64'h11b]<= 8'h00;
byte_instr[64'h11a]<= 8'hE8;
byte_instr[64'h119]<= 8'h88;
byte_instr[64'h118]<= 8'hB3;

byte_instr[64'h11f]<= 8'h00;
byte_instr[64'h11e]<= 8'hF8;
byte_instr[64'h11d]<= 8'h88;
byte_instr[64'h11c]<= 8'hB3;

byte_instr[64'h123]<= 8'h01;
byte_instr[64'h122]<= 8'h08;
byte_instr[64'h121]<= 8'h88;
byte_instr[64'h120]<= 8'hB3;

end

  //$display("PC: %h,PC4: %h", PC,PC4);
 //$display("PC: %h", PC);
 assign instr1[7:0] = byte_instr[PC];
 assign instr1[15:8] = byte_instr[PC+1];
 assign instr1[23:16] = byte_instr[PC+2];
 assign instr1[31:24] = byte_instr[PC+3];

 assign instr2[7:0] = byte_instr[PC4];
 assign instr2[15:8] = byte_instr[PC4+1];
 assign instr2[23:16] = byte_instr[PC4+2];
 assign instr2[31:24] = byte_instr[PC4+3];
// $display("instr[31:0]: %h",instr);

endmodule


module clk_input(output reg clk);
initial begin
  //$dumpfile("datapath_log.vcd");
  //$dumpvars;
  #11;
  $finish;
end
initial begin
    clk=0;
end
always #0.1 clk= ~clk;

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
