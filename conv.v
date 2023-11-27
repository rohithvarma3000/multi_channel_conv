module conv #(
parameter DataWidth=16,
parameter InputRate=1,
parameter D=2,
parameter K=3
)(
input        i_clk,
input [(InputRate*DataWidth)*9-1:0] i_pixel_data,
input        i_pixel_data_valid,
input kernel_reset,
input [(InputRate*DataWidth)*9-1:0]kernel_vals,
output reg [DataWidth-1:0] o_convolved_data,
output reg   o_convolved_data_valid
    );


reg [DataWidth-1:0] kernel [InputRate-1:0][8:0];
wire [DataWidth-1:0] multData[InputRate-1:0][8:0];
wire [DataWidth-1:0] sumData[InputRate-1:0][9:0];
wire [DataWidth-1:0] sumDataPartial[InputRate:0];
reg [DataWidth-1:0] sumDataFinal = 0;
wire [DataWidth-1:0] storeFinal;
reg multDataValid;
reg sumDataValid;
reg convolved_data_valid = 0;
reg[3:0] counter=0;
reg[3:0] i;
reg[3:0] j;

always @(posedge kernel_reset) begin
    for(i=0;i<K*K;i=i+1) begin
        for(j=0;j<InputRate;j=j+1) begin
            kernel[j][i] = kernel_vals[(DataWidth)*(i+j*K*K)+:DataWidth];
        end
    end
end
   
genvar k,l;

generate
for(l=0;l<InputRate;l=l+1) begin
    assign sumData[l][0] = 0;
    for(k=0;k<K*K;k=k+1) begin
            reg[3:0] g = k/K;
            floatMult FM (i_pixel_data[(DataWidth)*(k%K+(g*InputRate*K)+l*K)+:DataWidth],kernel[l][k],multData[l][k]);
            floatAdd FA (multData[l][k],sumData[l][k],sumData[l][k+1]);
        end
    end

    assign sumDataPartial[0] = 0;
    for(l=0;l<InputRate;l=l+1) begin
        floatAdd FA (sumData[l][9],sumDataPartial[l],sumDataPartial[l+1]);
    end
endgenerate

floatAdd PartialSum (sumDataPartial[InputRate],sumDataFinal,storeFinal);
   
always @(posedge i_clk)
begin
    if(i_pixel_data_valid) begin
        if(counter == 0) begin
            convolved_data_valid = 0;
            sumDataFinal = 0;
        end
    end
    o_convolved_data_valid = convolved_data_valid;
    o_convolved_data = sumDataFinal;
   

end

always @(negedge i_clk) begin
    if(i_pixel_data_valid) begin
    sumDataFinal = storeFinal;
    counter = counter+1;
   
    if(counter == (D/InputRate)) begin
            counter = 0;
            if(sumDataFinal) convolved_data_valid = 1;            
    end    
    end
   
    o_convolved_data_valid = convolved_data_valid;
    o_convolved_data = sumDataFinal;
   
 end
   
endmodule
