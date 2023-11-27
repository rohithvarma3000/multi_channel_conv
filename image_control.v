module imageControl#(
    parameter DataWidth = 16,
    parameter Row = 4,
    parameter D = 2,
    parameter Pwr = 2,
    parameter Prd = 1
)(
input                    i_clk,
input                    i_rst,
input [DataWidth*Pwr-1:0]  i_pixel_data,
input                    i_pixel_data_valid,
output reg [(DataWidth*Prd)*9-1:0]        o_pixel_data,
output                   o_pixel_data_valid
);

reg [1:0] currentWrLineBuffer = 2'b00;
reg [3:0] lineBuffDataValid;
wire [3:0] lineBuffRowEnd;
reg [3:0] lineBuffRdData;
reg [1:0] currentRdLineBuffer = 2'b00;
wire [(DataWidth*Prd)*3-1:0] lb0data;
wire [(DataWidth*Prd)*3-1:0] lb1data;
wire [(DataWidth*Prd)*3-1:0] lb2data;
wire [(DataWidth*Prd)*3-1:0] lb3data;
reg read_ready = 0;
wire rd_line_buffer;
reg [11:0] totalPixelCounter;
reg rdState = 1'b0;
reg o_valid_store = 0;
reg[2:0] switchRDBuffer = 0;


localparam IDLE = 'b0,
           RD_BUFFER = 'b1;

assign o_pixel_data_valid = o_valid_store;
assign rd_line_buffer = rdState;


always @(posedge rdState) begin
    o_valid_store = rdState;
end

always @(lineBuffRowEnd, i_rst)
begin
    if(i_rst) begin
        currentWrLineBuffer = 0;
        read_ready = 0;
    end
    else
    begin
        if(lineBuffRowEnd[currentWrLineBuffer]) begin
            currentWrLineBuffer = currentWrLineBuffer+1;
            if(read_ready) begin
                rdState <= 1'b1;
            end

            if(currentWrLineBuffer == 2'b11) begin
                read_ready = 1'b1;
                rdState <= 1'b1;
            end
        end
    end
end

always @(*)
begin
    lineBuffDataValid = 4'h0;
    lineBuffDataValid[currentWrLineBuffer] = i_pixel_data_valid;
end

always @(lineBuffRowEnd, i_rst)
begin
    if(i_rst)
        currentRdLineBuffer = 0;
    else
    begin
        if(read_ready && lineBuffRowEnd[currentRdLineBuffer]) begin
            switchRDBuffer = 1;
            rdState <= IDLE;
        end
    end
end

always @(negedge i_clk) begin
    if(switchRDBuffer==1) begin
        switchRDBuffer = 2;
    end
end

always @(posedge i_clk) begin
    if(switchRDBuffer==2) begin
        currentRdLineBuffer = currentRdLineBuffer+1;
        o_valid_store = 0;
        switchRDBuffer = 0;
linebuffer#(.DataWidth(DataWidth), .Row(Row), .D(D), .Pwr(Pwr),.Prd(Prd)) lB0(
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_data(i_pixel_data),
    .i_data_valid(lineBuffDataValid[0]),
    .o_data(lb0data),
    .i_rd_data(lineBuffRdData[0]),
    .o_row_end(lineBuffRowEnd[0])
 );
 
 linebuffer#(.DataWidth(DataWidth), .Row(Row),.D(D), .Pwr(Pwr),.Prd(Prd)) lB1(
     .i_clk(i_clk),
     .i_rst(i_rst),
     .i_data(i_pixel_data),
     .i_data_valid(lineBuffDataValid[1]),
     .o_data(lb1data),
     .i_rd_data(lineBuffRdData[1]),
     .o_row_end(lineBuffRowEnd[1])
  );
 
  linebuffer#(.DataWidth(DataWidth), .Row(Row),.D(D), .Pwr(Pwr), .Prd(Prd)) lB2(
      .i_clk(i_clk),
      .i_rst(i_rst),
      .i_data(i_pixel_data),
      .i_data_valid(lineBuffDataValid[2]),
      .o_data(lb2data),
      .i_rd_data(lineBuffRdData[2]),
      .o_row_end(lineBuffRowEnd[2])
   );
   
   linebuffer#(.DataWidth(DataWidth), .Row(Row),.D(D), .Pwr(Pwr), .Prd(Prd)) lB3(
       .i_clk(i_clk),
       .i_rst(i_rst),
       .i_data(i_pixel_data),
       .i_data_valid(lineBuffDataValid[3]),
       .o_data(lb3data),
       .i_rd_data(lineBuffRdData[3]),
       .o_row_end(lineBuffRowEnd[3])
    );    
   
endmodule
