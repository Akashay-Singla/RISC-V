module ALU_64bit_RISCV(input[3:0] Alu_opr,
                       input [63:0] IP_data1,IP_data2,
                       output reg [63:0] OP_data);

always @(Alu_opr or IP_data1 or IP_data2) begin
    $display("Entered into Alu_opr: %h", Alu_opr);
    
    case (Alu_opr)
    4'b0000: OP_data = IP_data1 + IP_data2;
    4'b0001: OP_data = IP_data1 - IP_data2;
    4'b0010: OP_data = IP_data1 << IP_data2;
    4'b0011: OP_data = IP_data1 ^ IP_data2;
    4'b0100: OP_data = IP_data1 >> IP_data2;
    4'b0101: OP_data = IP_data1 || IP_data2;
    4'b0110: OP_data = IP_data1 && IP_data2;
    default: OP_data = 64'b0;
    endcase
    $display("OP_data: %h", OP_data);
end
endmodule
