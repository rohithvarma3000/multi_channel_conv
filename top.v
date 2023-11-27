module conv_top#(
    parameter DataWidth = 16,
    parameter Row = 4,
    parameter D = 2,
    parameter Pwr = 2,
    parameter Prd = 2
)(
input                    i_clk,
input                    i_rst,
input [DataWidth*Pwr-1:0]  i_pixel_data,
input                    i_pixel_data_valid,
input kernel_reset,
input [(Prd*DataWidth)*9-1:0]kernel_vals,
output[DataWidth-1:0] o_conv_data,
output o_conv_valid
    );
    wire o_valid;
    wire[(DataWidth*Prd)*9-1:0] o_data;
   
    imageControl#(.DataWidth(DataWidth), .Row(Row),.D(D), .Pwr(Pwr), .Prd(Prd)) l0 (.i_clk(i_clk),
        .i_rst(i_rst),
        .i_pixel_data(i_pixel_data),
        .i_pixel_data_valid(i_pixel_data_valid),
        .o_pixel_data(o_data),
        .o_pixel_data_valid(o_valid));
       
    conv#(.DataWidth(DataWidth), .InputRate(Prd), .D(D)) c0 (i_clk, o_data, o_valid, kernel_reset, kernel_vals, o_conv_data, o_conv_valid);
   
endmodule
