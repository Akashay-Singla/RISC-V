/*module ALU_64bit_RISCV(input[3:0] Alu_opr,
                       input [63:0] IP_data1,IP_data2,
                       output reg [63:0] OP_data);

always @(*) begin
    $display("Entered into Alu_opr: %h", Alu_opr);
    $display("IP_data1: %h,  IP_data2: %h",IP_data1,IP_data2);
    case (Alu_opr)
    4'b0000: OP_data = IP_data1 + IP_data2;
    4'b0001: OP_data = IP_data1 - IP_data2;
    4'b0010: OP_data = IP_data1 << IP_data2;
    4'b0011: OP_data = IP_data1 ^ IP_data2;
    4'b0100: OP_data = IP_data1 >> IP_data2;
    4'b0101: OP_data = IP_data1 || IP_data2;
    4'b0110: OP_data = IP_data1 && IP_data2;
    4'b0111: begin
            if(IP_data1 == IP_data2)begin
              OP_data = 64'b0;
              $display("both data are equal");
            end
            else begin
                $display("both data are not equal");
              OP_data = 64'b1;
            end
            end
    4'b1000: begin
            if(IP_data1 != IP_data2)begin
              OP_data = 64'b0;
            end
            else begin
              OP_data = 64'b1;
            end
            end

    4'b1001: begin
            if(IP_data1 < IP_data2)begin
              OP_data = 64'b0;
            end
            else begin
              OP_data = 64'b1;
            end
            end

    4'b1010: begin
            if(IP_data1 >= IP_data2)begin
              OP_data = 64'b0;
            end
            else begin
              OP_data = 64'b1;
            end
            end
    default: OP_data = 64'bz;
    endcase
    $display("OP_data: %h", OP_data);
end
endmodule
*/

module ALU_64bit_RISCV(input[3:0] Alu_opr,
                       input [63:0] IP_data1,IP_data2,
                       output reg [63:0] OP_data);

always @(Alu_opr or IP_data2) begin
    $display("Entered into Alu_opr: %h", Alu_opr);
    $display("IP_data1: %h,  IP_data2: %h",IP_data1,IP_data2);
    OP_data = (Alu_opr == 4'b0000)? (IP_data1 + IP_data2): (Alu_opr == 4'b0001) ? (IP_data1 - IP_data2) : (Alu_opr == 4'b0010) ? (IP_data1 << IP_data2) :
              (Alu_opr == 4'b0011)? (IP_data1 ^ IP_data2): (Alu_opr == 4'b0100)? (IP_data1 >> IP_data2): (Alu_opr == 4'b0101)? (IP_data1 || IP_data2):
              (Alu_opr==4'b0110)? (IP_data1 && IP_data2): (Alu_opr==4'b0111)? ((IP_data1 == IP_data2)? 64'b0: 64'b1): (Alu_opr == 4'b1000)?
              ((IP_data1 != IP_data2) ? 64'b0: 64'b1):(Alu_opr == 4'b1001)? ((IP_data1 < IP_data2)? 64'b0: 64'b1): (Alu_opr == 4'b1010)?
              ((IP_data1 >= IP_data2)? 64'b0: 64'b1): 64'bz;
    $display("OP_data: %h", OP_data);
end
endmodule