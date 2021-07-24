
module instruction_mem(input[63:0] pc,output reg[31:0] instr);

reg[7:0] byte_instr[65535:0];
initial begin
byte_instr[64'h3]<= 8'h01;
byte_instr[64'h2]<= 8'h5A;
byte_instr[64'h1]<= 8'h04;
byte_instr[64'h0]<= 8'hB3;

byte_instr[64'h7]<= 8'h00;
byte_instr[64'h6]<= 8'h14;
byte_instr[64'h5]<= 8'h84;
byte_instr[64'h4]<= 8'h93;

byte_instr[64'hb]<= 8'hF0;
byte_instr[64'ha]<= 8'h95;
byte_instr[64'h9]<= 8'h38;
byte_instr[64'h8]<= 8'h23;

byte_instr[64'hf]<= 8'hF1;
byte_instr[64'he]<= 8'h05;
byte_instr[64'hd]<= 8'h32;
byte_instr[64'hc]<= 8'h83;

byte_instr[64'h13]<= 8'h00;
byte_instr[64'h12]<= 8'h73;
byte_instr[64'h11]<= 8'h02;
byte_instr[64'h10]<= 8'hB3;

byte_instr[64'h17]<= 8'h40;
byte_instr[64'h16]<= 8'h41;
byte_instr[64'h15]<= 8'h83;
byte_instr[64'h14]<= 8'hB3;

byte_instr[64'h1b]<= 8'h00;
byte_instr[64'h1a]<= 8'h53;
byte_instr[64'h19]<= 8'hF1;
byte_instr[64'h18]<= 8'h33;

byte_instr[64'h1f]<= 8'h01;
byte_instr[64'h1e]<= 8'hCE;
byte_instr[64'h1d]<= 8'hEF;
byte_instr[64'h1c]<= 8'h33;

byte_instr[64'h23]<= 8'h01;
byte_instr[64'h22]<= 8'h9D;
byte_instr[64'h21]<= 8'h4D;
byte_instr[64'h20]<= 8'hB3;

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

byte_instr[64'h33]<= 8'h00;
byte_instr[64'h32]<= 8'h10;
byte_instr[64'h31]<= 8'h80;
byte_instr[64'h30]<= 8'h93;

byte_instr[64'h37]<= 8'h00;
byte_instr[64'h36]<= 8'h10;
byte_instr[64'h35]<= 8'h80;
byte_instr[64'h34]<= 8'h93;

byte_instr[64'h3b]<= 8'h00;
byte_instr[64'h3a]<= 8'h10;
byte_instr[64'h39]<= 8'h80;
byte_instr[64'h38]<= 8'h93;

byte_instr[64'h3f]<= 8'h00;
byte_instr[64'h3e]<= 8'h10;
byte_instr[64'h3d]<= 8'h80;
byte_instr[64'h3c]<= 8'h93;

byte_instr[64'h43]<= 8'h00;
byte_instr[64'h42]<= 8'h10;
byte_instr[64'h41]<= 8'h80;
byte_instr[64'h40]<= 8'h93;

byte_instr[64'h47]<= 8'h00;
byte_instr[64'h46]<= 8'h10;
byte_instr[64'h45]<= 8'h80;
byte_instr[64'h44]<= 8'h93;

byte_instr[64'h4b]<= 8'h00;
byte_instr[64'h4a]<= 8'h10;
byte_instr[64'h49]<= 8'h80;
byte_instr[64'h48]<= 8'h93;

byte_instr[64'h4f]<= 8'h00;
byte_instr[64'h4e]<= 8'h10;
byte_instr[64'h4d]<= 8'h80;
byte_instr[64'h4c]<= 8'h93;

byte_instr[64'h53]<= 8'h00;
byte_instr[64'h52]<= 8'h10;
byte_instr[64'h51]<= 8'h80;
byte_instr[64'h50]<= 8'h93;

byte_instr[64'h57]<= 8'h01;
byte_instr[64'h56]<= 8'h4A;
byte_instr[64'h55]<= 8'hEA;
byte_instr[64'h54]<= 8'h13;

   byte_instr[64'h0000000000000058]<=8'h93;
   byte_instr[64'h0000000000000059]<=8'hF9;
   byte_instr[64'h000000000000005A]<=8'hFA;
   byte_instr[64'h000000000000005B]<=8'h7F;

byte_instr[64'h5f]<= 8'h01;
byte_instr[64'h5e]<= 8'h4A;
byte_instr[64'h5d]<= 8'hC9;
byte_instr[64'h5c]<= 8'h13;
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

byte_instr[64'h107]<= 8'h01;
byte_instr[64'h106]<= 8'h14;
byte_instr[64'h105]<= 8'h88;
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
  #10;
  $finish;
end
initial begin
    clk=1'b0;
end
always #0.1 clk= ~clk;

endmodule