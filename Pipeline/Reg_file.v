module Reg_file(input Wen, 
input [4:0] Rs1_addr,Rs2_addr, Rd_addr,
input [63:0] write_data,
output [63:0] Rs1_data,Rs2_data);

reg signed[63:0] register[31:0]; //32 registers of 64-bit (2^5 where 5 is size of address bus of instruction)
integer  i;

//Initilization of Registers with zero value
initial begin
  //$display("Entered into intial memory loop");
  for(i=0;i<32;i++)begin
    if(i==5'b10100) begin   //Giving some value at x14(hex & 20 in decimal) for the testing purpose
      register[i] = 64'h456701023D2;
    end
    else if(i== 5'b10101 )begin //Giving some value at x15(hex & 21 in decimal) for the testing purpose
     register[i]= 64'h012005C2;
    end
    else if(i== 5'b01010)begin  //Giving some value at xA(hex & 10 in decimal) for the testing purpose
      register[i] = 64'h0000000000000FFF;
    end
    else begin
      register[i]=64'd0; //intializing the memory with zero values
    end
  end
end

 assign Rs1_data = register[Rs1_addr];  //gives register value for input 1 of ALU
 assign Rs2_data = register[Rs2_addr];  //gives register value for input 2 of ALU
always @(Rs1_data or Rs2_data) begin
 // $display("Rs1_data: %d, Rs2_data: %d", Rs1_data,Rs2_data);
end
//Checks the Write enable bit then assigns the value to the particular register  
always @(posedge Wen or write_data )begin
  if(Wen)begin
  // $display("Entered into write loop");
  register[Rd_addr] = write_data;
//  $monitor("Rd_addr: %h, mem[Rd_addr]: %h",Rd_addr,register[Rd_addr]);
end
end
endmodule
