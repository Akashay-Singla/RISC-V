module data_memory(input clk,
  input[2:0] load_format,
input [1:0] store_format,
input mem_write_en,mem_read_en,
input[63:0] mem_addr, mem_data_input,
output [63:0] mem_data_output);
integer i;
reg [7:0] data_mem [4095:0];
//initlization of data memory
initial begin
  for (i=0;i<2047;i++)begin
   data_mem[i] <= 8'b0;
  end
end

always @(posedge clk) begin
 // $display("mem_addr: %h, mem_data_input %d",mem_addr, mem_data_input);
//Store instructions
if(mem_write_en == 1'b1 && mem_read_en == 1'b0)begin
 // $display("entered into store function");
 case (store_format)
 2'b00:  begin //Store byte
   $display("Entered into byte loop");
    data_mem[mem_addr]<= mem_data_input[7:0];
  end
  2'b01: begin //Store halfword
    $display("Entered into halfword loop");
      data_mem[mem_addr] <= mem_data_input[7:0];
      data_mem[mem_addr + 64'd1] <= mem_data_input [15:8];
  end
  2'b10: begin //store word
    $display("Entered into word loop");
      data_mem[mem_addr] <= mem_data_input[7:0];
      data_mem[mem_addr + 64'd1] <= mem_data_input [15:8];
      data_mem[mem_addr + 64'd2] <= mem_data_input [23:16];
      data_mem[mem_addr + 64'd3] <= mem_data_input[31:24];
  end
  2'b11: begin //Store doubleword
    
      data_mem[mem_addr] <= mem_data_input[7:0];
      data_mem[mem_addr + 64'd1] <= mem_data_input [15:8];
      data_mem[mem_addr + 64'd2] <= mem_data_input [23:16];
      data_mem[mem_addr + 64'd3] <= mem_data_input [31:24];
      data_mem[mem_addr + 64'd4] <= mem_data_input [39:32];
      data_mem[mem_addr + 64'd5] <= mem_data_input [47:40];
      data_mem[mem_addr + 64'd6] <= mem_data_input [55:48];
      data_mem[mem_addr + 64'd7] <= mem_data_input[63:56];
     $display("Entered into doubleword loop");
  end
 endcase
end
end


assign mem_data_output[7:0]    = (mem_write_en == 1'b0 && mem_read_en == 1'b1) ? data_mem[mem_addr] : 8'bzzzzzzzz;
assign mem_data_output[15:8]   = (mem_write_en == 1'b0 && mem_read_en == 1'b1) ? ((load_format == 3'b001 || load_format == 3'b010 || load_format == 3'b101) ? data_mem[mem_addr + 64'd1] : 8'h00) : 8'hzz;
assign mem_data_output [23:16] = (mem_write_en == 1'b0 && mem_read_en == 1'b1) ? ((load_format == 3'b010|| load_format == 3'b101) ? data_mem[mem_addr + 64'd2] : 8'h00) : 8'hzz;
assign mem_data_output [31:24] = (mem_write_en == 1'b0 && mem_read_en == 1'b1) ? ((load_format == 3'b010 || load_format == 3'b101) ? data_mem[mem_addr + 64'd3] : 8'h00) : 8'hzz;
assign mem_data_output [39:32] = (mem_write_en == 1'b0 && mem_read_en == 1'b1) ? ((load_format == 3'b101) ? data_mem[mem_addr + 64'd4] :8'h00) : 8'hzz;
assign mem_data_output [47:40] = (mem_write_en == 1'b0 && mem_read_en == 1'b1) ? ((load_format == 3'b101) ? data_mem[mem_addr + 64'd5]: 8'h00) : 8'hzz;
assign mem_data_output [55:48] = (mem_write_en == 1'b0 && mem_read_en == 1'b1) ? ((load_format == 3'b101) ? data_mem[mem_addr + 64'd6]: 8'h00) : 8'hzz;
assign mem_data_output [63:56] = (mem_write_en == 1'b0 && mem_read_en == 1'b1) ? ((load_format == 3'b101) ? data_mem[mem_addr + 64'd7]: 8'h00) : 8'hzz; 
endmodule
