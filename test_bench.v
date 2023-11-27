module tb();
 
  reg clk, rst, i_rd_data, i_data_valid;
  reg[31:0] data;
  wire[15:0] o_data;
  wire o_valid;
  reg kernel_reset = 0;
  reg[287:0] kernel_vals;
 
  conv_top l0 (clk, rst, data, i_data_valid, kernel_reset, kernel_vals,  o_data, o_valid);
 
  initial begin
    clk=0;
    rst = 0;
    i_rd_data = 0;
    i_data_valid = 0;
  end
 
  initial begin
 
    kernel_vals[15:0] = 16'b0011110000000000;
    kernel_vals[31:16] = 16'b0011110000000000;
    kernel_vals[47:32] = 16'b0011110000000000;
    kernel_vals[63:48] = 16'b0011110000000000;
    kernel_vals[79:64] = 16'b0011110000000000;
    kernel_vals[95:80] = 16'b0011110000000000;
    kernel_vals[111:96] = 16'b0011110000000000;
    kernel_vals[127:112] = 16'b0011110000000000;
    kernel_vals[143:128] = 16'b0011110000000000;
    kernel_vals[159:144] = 16'b0100000000000000;
    kernel_vals[175:160] = 16'b0100000000000000;
    kernel_vals[191:176] = 16'b0100000000000000;
    kernel_vals[207:192] = 16'b0100000000000000;
    kernel_vals[223:208] = 16'b0100000000000000;
    kernel_vals[239:224] = 16'b0100000000000000;
    kernel_vals[255:240] = 16'b0100000000000000;
    kernel_vals[271:256] = 16'b0100000000000000;
    kernel_vals[287:272] = 16'b0100000000000000;
 
 
   
    data[15:0] = 16'b0011110000000000;
    data[31:16] = 16'b0100000000000000;
    #2 i_data_valid = 1;
    kernel_reset = 1;
    #6
    data[15:0] = 16'b0011110000000000;
    #10 data[15:0] = 16'b0011110000000000;
//    #10 data[15:0] = 4;
   
//    #10 data[15:0] = 5;
//    #10 data[15:0] = 6;
//    #10 data[15:0] = 7;
//    #10 data[15:0] = 8;
//    #10 data[15:0] = 9;
//    #10 data[15:0] = 10;
//    #10 data[15:0] = 11;
//    #10 data[15:0] = 12;
//    #10 data[15:0] = 13;
//    #10 data[15:0] = 14;
//    #10 data[15:0] = 15;
//    #10 data[15:0] = 16;
   
//    i_rd_data=1;
   
   
  end
 
    always begin
    #5 clk = ~clk;
  end
 
 
endmodule
