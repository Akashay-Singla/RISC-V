
module ALU_64bit_A(input[3:0] Alu_opr,
                       input signed [63:0] IP_data1,IP_data2,
                       output signed [63:0] OP_data,
                       output is_br_taken);

//always @(Alu_opr or IP_data1 or IP_data2) begin
  //  $display("Entered into Alu_opr: %h", Alu_opr);
   // $display("IP_data1: %d,  IP_data2: %d",IP_data1,IP_data2);
    assign OP_data = (Alu_opr == 4'b0000)? (IP_data1 + IP_data2): (Alu_opr == 4'b0001) ? (IP_data1 - IP_data2) : (Alu_opr == 4'b0010) ? (IP_data1 << IP_data2) :
              (Alu_opr == 4'b0011)? (IP_data1 ^ IP_data2): (Alu_opr == 4'b0100)? (IP_data1 >> IP_data2): (Alu_opr == 4'b0110)? (IP_data1 | IP_data2):
              (Alu_opr==4'b0111)? (IP_data1 & IP_data2): 64'bz;

       assign is_br_taken = (Alu_opr==4'b0111)? ((IP_data1 == IP_data2)? 1'b0: 1'b1): (Alu_opr == 4'b1000)?
              ((IP_data1 != IP_data2) ? 1'b0: 1'b1):(Alu_opr == 4'b1001)? ((IP_data1 < IP_data2)? 1'b0: 1'b1): (Alu_opr == 4'b1010)?
              ((IP_data1 >= IP_data2)? 1'b0: 1'b1): 1'b1;
   // $display("OP_data: %d", OP_data);
endmodule



module ALU_64bit_B(input[3:0] Alu_opr,
                       input signed [63:0] IP_data1,IP_data2,
                       output signed [63:0] OP_data);

//always @(Alu_opr or IP_data1 or IP_data2) begin
  //  $display("Entered into Alu_opr: %h", Alu_opr);
   // $display("IP_data1: %d,  IP_data2: %d",IP_data1,IP_data2);
    assign OP_data = (Alu_opr == 4'b0000)? (IP_data1 + IP_data2): (Alu_opr == 4'b0001) ? (IP_data1 - IP_data2) : (Alu_opr == 4'b0010) ? (IP_data1 << IP_data2) :
              (Alu_opr == 4'b0011)? (IP_data1 ^ IP_data2): (Alu_opr == 4'b0100)? (IP_data1 >> IP_data2): (Alu_opr == 4'b0110)? (IP_data1 | IP_data2):
              (Alu_opr==4'b0111)? (IP_data1 & IP_data2): 64'bz;
   // $display("OP_data: %d", OP_data);
endmodule