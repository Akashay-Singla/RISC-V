`timescale 1ns/1ps

module testbench();
reg[31:0] instr;
reg clk;
Single_datapath u1(instr,clk);
initial begin
  $dumpfile("Single_datapath_log.vcd");
  $dumpvars;
  #60;
  $finish;
end
initial begin
    clk=0;
    #5;
    instr = 32'h015A04B3;//00000001010110100000010010110011;
    #30;
    instr = 32'h00148593;//00000001010110100000010010110011;
    #30;
  //  instr = 32'h009A04B3;//00000001010110100000010010110011;

 //   $finish;
end
always #5 clk =~clk;
endmodule