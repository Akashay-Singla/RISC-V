module Reg_file(input clk,Wen1,Wen2, 
input [4:0] Rs1_addr1,Rs2_addr1,Rd_addr1,Rs1_addr2,Rs2_addr2,Rd_addr2,
input signed [63:0] write_data1,write_data2,
output signed [63:0] Rs1_data1,Rs2_data1,Rs1_data2,Rs2_data2);

reg [63:0] register[31:0]; //32 registers of 64-bit (2^5 where 5 is size of address bus of instruction)
integer  i;

//Initilization of Registers with zero value
initial begin
  //$display("Entered into intial memory loop");
  for(i=0;i<32;i++)begin
    if(i==5'b10100) begin   //Giving some value at x14(hex & 20 in decimal) for the testing purpose
      register[i] = 64'h456701023D2;
    end
    else if(i== 5'b10101 )begin //Giving some value at x15(hex & 21 in decimal) for the testing purpose
     register[i]<= 64'h012005C2;
    end
    else if(i== 5'b01010)begin  //Giving some value at xA(hex & 10 in decimal) for the testing purpose
      register[i] <= 64'h0000000000000FFF;
    end
   else if(i== 5'b00110)begin  //Giving default value (8) at x6(hex & 10 in decimal) for the testing purpose
      register[i] = 64'h0000000000000008;
    end
    else if(i== 5'b00111)begin  //Giving default value (4) at x7(hex & 10 in decimal) for the testing purpose
      register[i] <= 64'h0000000000000004;
    end
   else if(i== 5'b00100)begin  //Giving default value (7) at x4(hex & 10 in decimal) for the testing purpose
      register[i] <= 64'h0000000000000007;
    end
     else if(i== 5'b00011)begin  //Giving default value (3) at x3(hex & 10 in decimal) for the testing purpose
      register[i] <= 64'h0000000000000003;
    end
      else if(i== 5'b11101)begin  //Giving default value (4) at x29(hex & 10 in decimal) for the testing purpose
      register[i] <= 64'h0000000000000004;
    end   
     else if(i== 5'b11100)begin  //Giving default value (2) at x28(hex & 10 in decimal) for the testing purpose
      register[i] <= 64'h0000000000000002;
    end  
      else if(i== 5'b11010)begin  //Giving default value (5) at x26(hex & 10 in decimal) for the testing purpose
      register[i] <= 64'h0000000000000005;
    end
      else if(i== 5'b11001)begin  //Giving default value (9) at x25(hex & 10 in decimal) for the testing purpose
      register[i] <= 64'h0000000000000009;
    end
/*
     else if(i== 5'b10101)begin  //Giving default value (6) at x21(hex & 10 in decimal) for the testing purpose
      register[i] = 64'h0000000000000006;
    end */
    else begin
      register[i]=64'd0; //intializing the memory with zero values
    end
  end
end

 assign Rs1_data1 = ((Rs1_addr1 === Rd_addr1) && Wen1 == 1'b1)? write_data1: ((Rs1_addr1 === Rd_addr2) && Wen2 == 1'b1)? write_data2 : register[Rs1_addr1];  //gives register value for input 1 of ALU
 assign Rs2_data1 = ((Rs2_addr1 === Rd_addr1) && Wen1 == 1'b1)? write_data1: ((Rs2_addr1 === Rd_addr2) && Wen2 == 1'b1)? write_data2 : register[Rs2_addr1];  //gives register value for input 2 of ALU
 assign Rs1_data2 = ((Rs1_addr2 === Rd_addr2) && Wen2 == 1'b1)? write_data2: ((Rs1_addr1 === Rd_addr1) && Wen1 == 1'b1)? write_data1 : register[Rs1_addr2];  //gives register value for input 1 of ALU
 assign Rs2_data2 = ((Rs2_addr2 === Rd_addr2) && Wen2 == 1'b1)? write_data2: ((Rs2_addr1 === Rd_addr1) && Wen1 == 1'b1)? write_data1 : register[Rs2_addr2];  //gives register value for input 2 of ALU

/*
assign Rs1_data1 =  register[Rs1_addr1];  //gives register value for input 1 of ALU
 assign Rs2_data1 = register[Rs2_addr1];  //gives register value for input 2 of ALU
 assign Rs1_data2 = register[Rs1_addr2];  //gives register value for input 1 of ALU
 assign Rs2_data2 = register[Rs2_addr2];  //gives register value for input 2 of ALU
*/


//always @(Rs1_data or Rs2_data) begin
 // $display("Rs1_data: %d, Rs2_data: %d", Rs1_data,Rs2_data);
//end
//Checks the Write enable bit then assigns the value to the particular register  
always @(posedge clk)begin
  $display("register[9]: %d, Rs2_addr2: %h, Rd_addr1: %h, Rd_addr2: %h", register[9], Rs2_addr2, Rd_addr1, Rd_addr2);
  if(Wen1)begin
  //$display("Entered into write loop");
  register[Rd_addr1] <= write_data1; 
  //$display("Rd_addr1: %h, reg[Rd_addr1]: %d, write_data1: %d",Rd_addr1,register[Rd_addr1],write_data1); 
end
if(Wen2)begin
  // $display("Entered into write loop");
  register[Rd_addr2] <= write_data2; 
 // $monitor("Rd_addr2: %h, mem[Rd_addr2]: %d",Rd_addr2,register[Rd_addr2]);
end
end

endmodule

/*
module decoder_5_to_32(input [4:0] Rd_addr, output [31:0] out_decoder)

assign out_decoder[0] = ~Rd_addr[4] & ~Rd_addr[3] & ~Rd_addr[2] & ~Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[1] = ~Rd_addr[4] & ~Rd_addr[3] & ~Rd_addr[2] & ~Rd_addr[1] & Rd_addr[0];
assign out_decoder[2] = ~Rd_addr[4] & ~Rd_addr[3] & ~Rd_addr[2] & Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[3] = ~Rd_addr[4] & ~Rd_addr[3] & ~Rd_addr[2] & Rd_addr[1] & Rd_addr[0];
assign out_decoder[4] = ~Rd_addr[4] & ~Rd_addr[3] & Rd_addr[2] & ~Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[5] = ~Rd_addr[4] & ~Rd_addr[3] & Rd_addr[2] & ~Rd_addr[1] & Rd_addr[0];
assign out_decoder[6] = ~Rd_addr[4] & ~Rd_addr[3] & Rd_addr[2] & Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[7] = ~Rd_addr[4] & ~Rd_addr[3] & Rd_addr[2] & Rd_addr[1] & Rd_addr[0];
assign out_decoder[8] = ~Rd_addr[4] & Rd_addr[3] & ~Rd_addr[2] & ~Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[9] = ~Rd_addr[4] & Rd_addr[3] & ~Rd_addr[2] & ~Rd_addr[1] & Rd_addr[0];
assign out_decoder[10] = ~Rd_addr[4] & Rd_addr[3] & ~Rd_addr[2] & Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[11] = ~Rd_addr[4] & Rd_addr[3] & ~Rd_addr[2] & Rd_addr[1] & Rd_addr[0];
assign out_decoder[12] = ~Rd_addr[4] & Rd_addr[3] & Rd_addr[2] & ~Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[13] = ~Rd_addr[4] & Rd_addr[3] & Rd_addr[2] & Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[14] = ~Rd_addr[4] & Rd_addr[3] & Rd_addr[2] & Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[15] = ~Rd_addr[4] & Rd_addr[3] & Rd_addr[2] & Rd_addr[1] & Rd_addr[0];
assign out_decoder[16] =  Rd_addr[4] & ~Rd_addr[3] & ~Rd_addr[2] & ~Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[17] =  Rd_addr[4] & ~Rd_addr[3] & ~Rd_addr[2] & ~Rd_addr[1] & Rd_addr[0];
assign out_decoder[18] =  Rd_addr[4] & ~Rd_addr[3] & ~Rd_addr[2] &  Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[19] =  Rd_addr[4] & ~Rd_addr[3] & ~Rd_addr[2] & Rd_addr[1] & Rd_addr[0];
assign out_decoder[20] = Rd_addr[4] & ~Rd_addr[3] & Rd_addr[2] & ~Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[21] = Rd_addr[4] & ~Rd_addr[3] & Rd_addr[2] & ~Rd_addr[1] & Rd_addr[0];
assign out_decoder[22] = Rd_addr[4] & ~Rd_addr[3] & Rd_addr[2] & Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[23] = Rd_addr[4] & ~Rd_addr[3] & Rd_addr[2] & Rd_addr[1] & Rd_addr[0];
assign out_decoder[24] = Rd_addr[4] & Rd_addr[3] & ~Rd_addr[2] & ~Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[25] = Rd_addr[4] & Rd_addr[3] & ~Rd_addr[2] & ~Rd_addr[1] & Rd_addr[0];
assign out_decoder[26] = Rd_addr[4] & Rd_addr[3] & ~Rd_addr[2] & Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[27] = Rd_addr[4] & Rd_addr[3] & ~Rd_addr[2] & Rd_addr[1] & Rd_addr[0];
assign out_decoder[28] = Rd_addr[4] & Rd_addr[3] & Rd_addr[2] & ~Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[29] = Rd_addr[4] & Rd_addr[3] & Rd_addr[2] & Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[30] = Rd_addr[4] & Rd_addr[3] & Rd_addr[2] & Rd_addr[1] & ~Rd_addr[0];
assign out_decoder[31] = Rd_addr[4] & Rd_addr[3] & Rd_addr[2] & Rd_addr[1] & Rd_addr[0];


endmodule*/