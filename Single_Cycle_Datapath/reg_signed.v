module reg_signed(input clk);

reg signed [63:0] var_a;
reg signed [63:0] var_b;
reg [63:0] var_z;
initial begin
  var_a = -64'd34359738368;//FFFFFFFFFFFFFFF0; //8000000000000010;  //7
  var_b = 64'h0000000000000014;  //59
end

always @(posedge clk) begin
$display("var_a: %h, var_b: %d",var_a,var_b);
 var_z = var_a + var_b;
 $display("var_z in h: %h, var_z in d: %d",var_z,var_z);  
end
endmodule

module clock(output reg clk);
 reg_signed U1(clk); 
 always#10 clk= ~clk;
 initial begin
   clk=0;
   #20;
   $finish;
 end
endmodule