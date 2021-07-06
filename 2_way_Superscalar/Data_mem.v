module data_memory(input[2:0] load_format,
input [1:0] store_format,
input mem_write_en,mem_read_en,
input[63:0] mem_addr, mem_data_input,
output reg [63:0] mem_data_output);
integer i;
reg [7:0] data_mem [4095:0];
//initlization of data memory
initial begin
  for (i=0;i<2047;i++)begin
   data_mem[i] <= 8'b0;
  end
end

always @(mem_write_en or mem_read_en) begin
 // $display("mem_addr: %h, mem_data_input %d",mem_addr, mem_data_input);
//Store instructions
if(mem_write_en == 1 && mem_read_en == 0)begin
 // $display("entered into store function");
  if (store_format == 3'b00) begin //Store byte
  // $display("Entered into halfword loop, data_mem %d",data_mem[mem_addr]);
    data_mem[mem_addr]<= mem_data_input[7:0];
    ;
  end
  else if(store_format == 3'b01) begin //Store halfword
//$display("Entered into halfword loop, data_mem %d",{data_mem[mem_addr],data_mem[mem_addr+1]});
      data_mem[mem_addr] <= mem_data_input[7:0];
      data_mem[mem_addr + 1] <= mem_data_input [15:8];
  end
  else if(store_format == 3'b10) begin //store word
  //  $display("Entered into word loop, data_mem %d",{data_mem[mem_addr],data_mem[mem_addr+1],data_mem[mem_addr+2],data_mem[mem_addr+3]});
      data_mem[mem_addr] <= mem_data_input[7:0];
      data_mem[mem_addr + 1] <= mem_data_input [15:8];
      data_mem[mem_addr + 2] <= mem_data_input [23:16];
      data_mem[mem_addr + 3] <= mem_data_input[31:24];
  end
  else begin //Store doubleword
    
      data_mem[mem_addr] <= mem_data_input[7:0];
      data_mem[mem_addr + 64'd1] <= mem_data_input [15:8];
      data_mem[mem_addr + 64'd2] <= mem_data_input [23:16];
      data_mem[mem_addr + 64'd3] <= mem_data_input [31:24];
      data_mem[mem_addr + 64'd4] <= mem_data_input [39:32];
      data_mem[mem_addr + 64'd5] <= mem_data_input [47:40];
      data_mem[mem_addr + 64'd6] <= mem_data_input [55:48];
      data_mem[mem_addr + 64'd7] <= mem_data_input[63:56];
     //  $display("Entered into doubleword loop, data_mem %d",{data_mem[mem_addr],data_mem[mem_addr+1],data_mem[mem_addr+2],data_mem[mem_addr+3],
                   //   data_mem[mem_addr+4],data_mem[mem_addr+5],data_mem[mem_addr+6],data_mem[mem_addr+7]});
  end
  
end

else if (mem_write_en == 0 && mem_read_en == 1) begin
  if (load_format == 3'b000) begin  //load byte
    mem_data_output[7:0] <= data_mem[mem_addr];
  //  $display("Entered into load byte loop, data_mem %h",data_mem[mem_addr]);  
  end
  else if (load_format == 3'b001) begin //load halfword
      mem_data_output[7:0] <= data_mem[mem_addr];
      mem_data_output [15:8] <= data_mem[mem_addr + 1];
     // $display("Entered into load halfword loop, data_mem %h",{data_mem[mem_addr+1],data_mem[mem_addr]});  
end
else if (load_format == 3'b010) begin //load word
      mem_data_output [7:0] <= data_mem[mem_addr];
      mem_data_output [15:8] <= data_mem[mem_addr + 1];
      mem_data_output [23:16] <= data_mem[mem_addr + 2];
      mem_data_output [31:24] <= data_mem[mem_addr+3]; 
     //  $display("Entered into load word loop, data_mem %h",{data_mem[mem_addr+3],data_mem[mem_addr+2],
                                                   //               data_mem[mem_addr+1],data_mem[mem_addr]});        
end
else if (load_format == 3'b101) begin  //load doubleword

      mem_data_output [7:0] <= data_mem[mem_addr];
      mem_data_output [15:8] <= data_mem[mem_addr + 1];
      mem_data_output [23:16] <= data_mem[mem_addr + 2];
      mem_data_output [31:24] <= data_mem[mem_addr + 3];
      mem_data_output [39:32] <= data_mem[mem_addr + 4];
      mem_data_output [47:40] <= data_mem[mem_addr + 5];
      mem_data_output [55:48] <= data_mem[mem_addr + 6];
      mem_data_output [63:56] <= data_mem[mem_addr + 7]; 
     //  $display("Entered into load doubleword loop, data_mem %h",{data_mem[mem_addr+7],data_mem[mem_addr+6],data_mem[mem_addr+5],
                                                      //            data_mem[mem_addr+4],data_mem[mem_addr+3],data_mem[mem_addr+2],
                                                      //            data_mem[mem_addr+1],data_mem[mem_addr]});
end
end
else if(mem_read_en == 1'b0)begin
  mem_data_output = 64'hzzzzzzzzzzzzzzzz;
end
end
endmodule