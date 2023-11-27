module linebuffer #(parameter D=1,
                    parameter Row = 4,
                    parameter pointer = 5,
                    parameter Pwr = 1,
                    parameter Prd = 1,
                    parameter DataWidth = 16)(
input i_clk,
input i_rst,
input [Pwr*DataWidth-1:0] i_data,
input i_data_valid,
output reg [3*Prd*DataWidth-1:0] o_data,
output reg o_row_end,
input i_rd_data
    );
   
reg [DataWidth-1:0] line [Row-1:0][D-1:0];
reg [pointer-1:0] wr_pointer_channel = 0, wr_pointer_row = 0;
reg [pointer-1:0] rd_pointer_channel = 0, rd_pointer_row = 0;
integer i,j;

always@(posedge i_clk)
begin
  if(i_data_valid) begin
    for(i=0; i<Pwr;i=i+1)
    begin
      line[wr_pointer_row][wr_pointer_channel+i] =  i_data[i*DataWidth+:DataWidth];
    end
  end
       
end

always@(posedge i_clk)
begin
    if(i_rst) begin
      wr_pointer_row='d0;
      wr_pointer_channel='d0;
      o_row_end=1'b0;
      end
    else if(i_data_valid) begin
        wr_pointer_channel=wr_pointer_channel+Pwr;
        if(wr_pointer_channel>D-1) begin
            wr_pointer_channel='d0;
            if(wr_pointer_row==Row-1) begin
                wr_pointer_row='d0;
                o_row_end=1'b1;
            end
            else begin
                wr_pointer_row=wr_pointer_row+1;
            end
        end
    end
end

always @(negedge i_clk) begin
  o_row_end = 1'b0;
end


always@(posedge i_clk, i_rd_data)
begin
    if(i_rst) begin
      rd_pointer_channel='d0;
    end
    else if(i_rd_data)
    begin
        for(j=0;j<Prd;j=j+1)
        begin
            o_data[j*3*DataWidth+:DataWidth] = line[rd_pointer_row][rd_pointer_channel+j];
            o_data[(j*3+1)*DataWidth+:DataWidth] = line[rd_pointer_row+1][rd_pointer_channel+j];
            o_data[(j*3+2)*DataWidth+:DataWidth] = line[rd_pointer_row+2][rd_pointer_channel+j];
        end
        rd_pointer_channel=rd_pointer_channel+Prd;
        if(rd_pointer_channel>D-1) begin
            rd_pointer_channel='d0;
            if(rd_pointer_row==Row-3) begin
                rd_pointer_row='d0;
                o_row_end = 1'b1;
            end
            else begin
                rd_pointer_row=rd_pointer_row+1;
            end
        end
    end  
end
endmodule
