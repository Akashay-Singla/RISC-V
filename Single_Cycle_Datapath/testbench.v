`timescale 1ns/1ps

module testbench();
reg[31:0] instr;
reg clk;
Single_datapath u1(instr,clk);
initial begin
  $dumpfile("Single_datapath_log.vcd");
  $dumpvars;
  #130;
  $finish;
end
initial begin
    clk=0;
    //#5;
    instr = 32'h015A04B3;//ADD X9, X14 ,X15
    #30;
    instr = 32'h00148593;//ADDi xB, x9, 1 add 1 to the value of x9 register
    #30;
    instr = 32'h0E953823;// SD X9,240(x10) doubleword
    #30;
    instr = 32'h0F053283;//LD x5,240(x10)  doubleword
    #30;

 //   $finish;
end
always #5 clk =~clk;
endmodule