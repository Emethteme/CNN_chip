//synopsys translate_off 
`include "/misc/RAID2/COURSE/iclab/iclab39/FP/04_MEM/RA1SH.v"
//synopsys translate_on

/****************************************************************************************************/
// pixel
// >100  =>  1

// weight
// 取[13:8]
// 四捨五入
// type 1

// 正確率：8
/****************************************************************************************************/

module CNN(
    clk,
    rst_n,

    in_valid_1,
    in_valid_2,
    in_data,

    out_valid,
    number_2,
    number_4,
    number_6
);
//////////////////////////////////////////////////
///// INPUT AND OUTPUT DECLARATION ///////////////      
//////////////////////////////////////////////////              
input clk; 
input rst_n;
input in_valid_1;
input in_valid_2;
input [14:0]in_data;

output reg out_valid;
output reg number_2;
output reg number_4;
output reg number_6;
//////////////////////////////////////////////////
///// REGISTER ///////////////////////////////////
//////////////////////////////////////////////////
reg [0:0] pixel [63:0];


reg signed [5:0] filter_1 [8:0];
reg signed [5:0] filter_2 [8:0];
reg signed [5:0] filter_3 [8:0];

reg signed [5:0] filter_1_bias;
reg signed [5:0] filter_2_bias;
reg signed [5:0] filter_3_bias;


reg signed [5:0] weight_1 [80:0];

reg signed [5:0] weight_1_bias_1;
reg signed [5:0] weight_1_bias_2;
reg signed [5:0] weight_1_bias_3;


reg signed [5:0] weight_2 [8:0];

reg signed [5:0] weight_2_bias_1;
reg signed [5:0] weight_2_bias_2;
reg signed [5:0] weight_2_bias_3;

/************************************************/

reg signed [14:0] conv_1 [35:0];
reg signed [14:0] conv_2 [35:0];
reg signed [14:0] conv_3 [35:0];

reg signed [4:0] pool [26:0];

reg signed [9:0] affine_1 [2:0];

reg signed [15:0] affine_2 [2:0];

/************************************************/

reg [9:0] cs, ns;

reg [6:0] counter;

reg [6:0] cursor;
//////////////////////////////////////////////////
///// PARAMETER //////////////////////////////////
//////////////////////////////////////////////////
parameter ST_IDLE			= 'd0,

          ST_INPUT_WEIGHT	= 'd1,
          ST_INPUT_PIXEL	= 'd2,

          ST_CONVOLUTION	= 'd3,
          ST_RELU_1			= 'd4,
          ST_POOLING		= 'd5,

          ST_QK				= 'd6,

          ST_AFFINE_1		= 'd7,
          ST_RELU_2			= 'd8,
          ST_AFFINE_2		= 'd9,

          ST_OUTPUT			= 'd10;

integer i;
//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

reg CEN;
reg WEN;
reg [6:0] A;
reg [3:0] D;
reg OEN;
wire [3:0] Q;

RA1SH R1 ( .Q(Q), .CLK(clk), .CEN(CEN), .WEN(WEN), .A(A), .D(D), .OEN(OEN) );

/************************************************/
/***** input filter *****************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0 ; i <= 8 ; i = i + 1) begin
			filter_1[i] <= 'd0;
			filter_2[i] <= 'd0;
			filter_3[i] <= 'd0;
		end
		filter_1_bias <= 'd0;
		filter_2_bias <= 'd0;
		filter_3_bias <= 'd0;
	end

	else if (ns == ST_INPUT_WEIGHT && counter >= 'd1 && counter <= 'd9) begin
		if (in_data[7] == 'd1) filter_1[8] <= in_data[13:8] + 'd1;
		else                   filter_1[8] <= in_data[13:8];
		
		for (i = 7 ; i >= 0 ; i = i - 1) begin 
			filter_1[i] <= filter_1[i+1];
		end
	end

	else if (ns == ST_INPUT_WEIGHT && counter >= 'd10 && counter <= 'd18) begin
		if (in_data[7] == 'd1) filter_2[8] <= in_data[13:8] + 'd1;
		else                   filter_2[8] <= in_data[13:8];
		
		for (i = 7 ; i >= 0 ; i = i - 1) begin 
			filter_2[i] <= filter_2[i+1];
		end
	end

	else if (ns == ST_INPUT_WEIGHT && counter >= 'd19 && counter <= 'd27) begin
		if (in_data[7] == 'd1) filter_3[8] <= in_data[13:8] + 'd1;
		else                   filter_3[8] <= in_data[13:8];
		
		for (i = 7 ; i >= 0 ; i = i - 1) begin 
			filter_3[i] <= filter_3[i+1];
		end
	end

	else if (ns == ST_INPUT_WEIGHT && counter >= 'd28 && counter <= 'd30) begin
		if (in_data[7] == 'd1) filter_3_bias <= in_data[13:8] + 'd1;
		else                   filter_3_bias <= in_data[13:8];
		filter_2_bias <= filter_3_bias;
		filter_1_bias <= filter_2_bias;
	end

	else begin
		for (i = 0 ; i <= 8 ; i = i + 1) begin
			filter_1[i] <= filter_1[i];
			filter_2[i] <= filter_2[i];
			filter_3[i] <= filter_3[i];
		end
		filter_1_bias <= filter_1_bias;
		filter_2_bias <= filter_2_bias;
		filter_3_bias <= filter_3_bias;
	end
end
/************************************************/
/***** input weight 1 ***************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0 ; i <= 80 ; i = i + 1) begin
			weight_1[i] <= 'd0;
		end
		weight_1_bias_1 <= 'd0;
		weight_1_bias_2 <= 'd0;
		weight_1_bias_3 <= 'd0;
	end

	else if (ns == ST_INPUT_WEIGHT && counter >= 'd31 && counter <= 'd111) begin
		if (in_data[7] == 'd1) weight_1[80] <= in_data[13:8] + 'd1;
		else                   weight_1[80] <= in_data[13:8];

		for (i = 79 ; i >= 0 ; i = i - 1) begin
			weight_1[i] <= weight_1[i+1];
		end
	end

	else if (ns == ST_INPUT_WEIGHT && counter >= 'd112 && counter <= 'd114) begin
		if (in_data[7] == 'd1) weight_1_bias_3 <= in_data[13:8] + 'd1;
		else                   weight_1_bias_3 <= in_data[13:8];

		weight_1_bias_2 <= weight_1_bias_3;
		weight_1_bias_1 <= weight_1_bias_2;
	end

	else begin
		for (i = 0 ; i <= 80 ; i = i + 1) begin
			weight_1[i] <= weight_1[i];
		end
		weight_1_bias_1 <= weight_1_bias_1;
		weight_1_bias_2 <= weight_1_bias_2;
		weight_1_bias_3 <= weight_1_bias_3;
	end
end
/************************************************/
/***** input weight 2 ***************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0 ; i <= 8 ; i = i + 1) begin
			weight_2[i] <= 'd0;
		end
		weight_2_bias_1 <= 'd0;
		weight_2_bias_2 <= 'd0;
		weight_2_bias_3 <= 'd0;
	end

	else if (ns == ST_INPUT_WEIGHT && counter >= 'd115 && counter <= 'd123) begin
		if (in_data[7] == 'd1) weight_2[8] <= in_data[13:8] + 'd1;
		else                   weight_2[8] <= in_data[13:8];
		
		for (i = 7 ; i >= 0 ; i = i - 1) begin
			weight_2[i] <= weight_2[i+1];
		end
	end

	else if (ns == ST_INPUT_WEIGHT && counter >= 'd124 && counter <= 'd126) begin
		if (in_data[7] == 'd1) weight_2_bias_3 <= in_data[13:8] + 'd1;
		else                   weight_2_bias_3 <= in_data[13:8];
		
		weight_2_bias_2 <= weight_2_bias_3;
		weight_2_bias_1 <= weight_2_bias_2;
	end

	else begin
		for (i = 0 ; i <= 8 ; i = i + 1) begin
			weight_2[i] <= weight_2[i];
		end
		weight_2_bias_1 <= weight_2_bias_1;
		weight_2_bias_2 <= weight_2_bias_2;
		weight_2_bias_3 <= weight_2_bias_3;
	end
end
/************************************************/
/***** input pixel ******************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0 ; i <= 63 ; i = i + 1) begin
			pixel[i] <= 'd0;
		end
	end

	else if (ns == ST_INPUT_PIXEL) begin
		if (in_data > 'd100) pixel[63] <= 'd1;
		else				 pixel[63] <= 'd0;

		for (i = 62 ; i >= 0 ; i = i - 1) begin
			pixel[i] <= pixel[i+1];
		end
	end

	else begin
		for (i = 0 ; i <= 63 ; i = i + 1) begin
			pixel[i] <= pixel[i];
		end
	end
end
/************************************************/
/***** convolution & relu 1 *********************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			conv_1[i] <= 'd0;
		end
	end

	else if (ns == ST_INPUT_PIXEL) begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			conv_1[i] <= filter_1_bias;
		end
	end

	else if (ns == ST_CONVOLUTION) begin
		if (pixel[cursor]        == 'd1) conv_1[0]  <= conv_1[0]  + filter_1[counter];
		else                             conv_1[0]  <= conv_1[0];
		if (pixel[cursor + 'd1]  == 'd1) conv_1[1]  <= conv_1[1]  + filter_1[counter];
		else                             conv_1[1]  <= conv_1[1];
		if (pixel[cursor + 'd2]  == 'd1) conv_1[2]  <= conv_1[2]  + filter_1[counter];
		else                             conv_1[2]  <= conv_1[2];
		if (pixel[cursor + 'd3]  == 'd1) conv_1[3]  <= conv_1[3]  + filter_1[counter];
		else                             conv_1[3]  <= conv_1[3];
		if (pixel[cursor + 'd4]  == 'd1) conv_1[4]  <= conv_1[4]  + filter_1[counter];
		else                             conv_1[4]  <= conv_1[4];
		if (pixel[cursor + 'd5]  == 'd1) conv_1[5]  <= conv_1[5]  + filter_1[counter];
		else                             conv_1[5]  <= conv_1[5];

		if (pixel[cursor + 'd8]  == 'd1) conv_1[6]  <= conv_1[6]  + filter_1[counter];
		else                             conv_1[6]  <= conv_1[6];
		if (pixel[cursor + 'd9]  == 'd1) conv_1[7]  <= conv_1[7]  + filter_1[counter];
		else                             conv_1[7]  <= conv_1[7];
		if (pixel[cursor + 'd10] == 'd1) conv_1[8]  <= conv_1[8]  + filter_1[counter];
		else                             conv_1[8]  <= conv_1[8];
		if (pixel[cursor + 'd11] == 'd1) conv_1[9]  <= conv_1[9]  + filter_1[counter];
		else                             conv_1[9]  <= conv_1[9];
		if (pixel[cursor + 'd12] == 'd1) conv_1[10] <= conv_1[10] + filter_1[counter];
		else                             conv_1[10] <= conv_1[10];
		if (pixel[cursor + 'd13] == 'd1) conv_1[11] <= conv_1[11] + filter_1[counter];
		else                             conv_1[11] <= conv_1[11];

		if (pixel[cursor + 'd16] == 'd1) conv_1[12] <= conv_1[12] + filter_1[counter];
		else                             conv_1[12] <= conv_1[12];
		if (pixel[cursor + 'd17] == 'd1) conv_1[13] <= conv_1[13] + filter_1[counter];
		else                             conv_1[13] <= conv_1[13];
		if (pixel[cursor + 'd18] == 'd1) conv_1[14] <= conv_1[14] + filter_1[counter];
		else                             conv_1[14] <= conv_1[14];
		if (pixel[cursor + 'd19] == 'd1) conv_1[15] <= conv_1[15] + filter_1[counter];
		else                             conv_1[15] <= conv_1[15];
		if (pixel[cursor + 'd20] == 'd1) conv_1[16] <= conv_1[16] + filter_1[counter];
		else                             conv_1[16] <= conv_1[16];
		if (pixel[cursor + 'd21] == 'd1) conv_1[17] <= conv_1[17] + filter_1[counter];
		else                             conv_1[17] <= conv_1[17];

		if (pixel[cursor + 'd24] == 'd1) conv_1[18] <= conv_1[18] + filter_1[counter];
		else                             conv_1[18] <= conv_1[18];
		if (pixel[cursor + 'd25] == 'd1) conv_1[19] <= conv_1[19] + filter_1[counter];
		else                             conv_1[19] <= conv_1[19];
		if (pixel[cursor + 'd26] == 'd1) conv_1[20] <= conv_1[20] + filter_1[counter];
		else                             conv_1[20] <= conv_1[20];
		if (pixel[cursor + 'd27] == 'd1) conv_1[21] <= conv_1[21] + filter_1[counter];
		else                             conv_1[21] <= conv_1[21];
		if (pixel[cursor + 'd28] == 'd1) conv_1[22] <= conv_1[22] + filter_1[counter];
		else                             conv_1[22] <= conv_1[22];
		if (pixel[cursor + 'd29] == 'd1) conv_1[23] <= conv_1[23] + filter_1[counter];
		else                             conv_1[23] <= conv_1[23];

		if (pixel[cursor + 'd32] == 'd1) conv_1[24] <= conv_1[24] + filter_1[counter];
		else                             conv_1[24] <= conv_1[24];
		if (pixel[cursor + 'd33] == 'd1) conv_1[25] <= conv_1[25] + filter_1[counter];
		else                             conv_1[25] <= conv_1[25];
		if (pixel[cursor + 'd34] == 'd1) conv_1[26] <= conv_1[26] + filter_1[counter];
		else                             conv_1[26] <= conv_1[26];
		if (pixel[cursor + 'd35] == 'd1) conv_1[27] <= conv_1[27] + filter_1[counter];
		else                             conv_1[27] <= conv_1[27];
		if (pixel[cursor + 'd36] == 'd1) conv_1[28] <= conv_1[28] + filter_1[counter];
		else                             conv_1[28] <= conv_1[28];
		if (pixel[cursor + 'd37] == 'd1) conv_1[29] <= conv_1[29] + filter_1[counter];
		else                             conv_1[29] <= conv_1[29];

		if (pixel[cursor + 'd40] == 'd1) conv_1[30] <= conv_1[30] + filter_1[counter];
		else                             conv_1[30] <= conv_1[30];
		if (pixel[cursor + 'd41] == 'd1) conv_1[31] <= conv_1[31] + filter_1[counter];
		else                             conv_1[31] <= conv_1[31];
		if (pixel[cursor + 'd42] == 'd1) conv_1[32] <= conv_1[32] + filter_1[counter];
		else                             conv_1[32] <= conv_1[32];
		if (pixel[cursor + 'd43] == 'd1) conv_1[33] <= conv_1[33] + filter_1[counter];
		else                             conv_1[33] <= conv_1[33];
		if (pixel[cursor + 'd44] == 'd1) conv_1[34] <= conv_1[34] + filter_1[counter];
		else                             conv_1[34] <= conv_1[34];
		if (pixel[cursor + 'd45] == 'd1) conv_1[35] <= conv_1[35] + filter_1[counter];
		else                             conv_1[35] <= conv_1[35];
	end

	else if (ns == ST_RELU_1) begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			if (conv_1[i][14] == 'd1) conv_1[i] <= 'd0;
			else                      conv_1[i] <= conv_1[i];
		end
	end

	else begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			conv_1[i] <= conv_1[i];
		end
	end
end

always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			conv_2[i] <= 'd0;
		end
	end

	else if (ns == ST_INPUT_PIXEL) begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			conv_2[i] <= filter_2_bias;
		end
	end

	else if (ns == ST_CONVOLUTION) begin
		if (pixel[cursor]        == 'd1) conv_2[0]  <= conv_2[0]  + filter_2[counter];
		else                             conv_2[0]  <= conv_2[0];
		if (pixel[cursor + 'd1]  == 'd1) conv_2[1]  <= conv_2[1]  + filter_2[counter];
		else                             conv_2[1]  <= conv_2[1];
		if (pixel[cursor + 'd2]  == 'd1) conv_2[2]  <= conv_2[2]  + filter_2[counter];
		else                             conv_2[2]  <= conv_2[2];
		if (pixel[cursor + 'd3]  == 'd1) conv_2[3]  <= conv_2[3]  + filter_2[counter];
		else                             conv_2[3]  <= conv_2[3];
		if (pixel[cursor + 'd4]  == 'd1) conv_2[4]  <= conv_2[4]  + filter_2[counter];
		else                             conv_2[4]  <= conv_2[4];
		if (pixel[cursor + 'd5]  == 'd1) conv_2[5]  <= conv_2[5]  + filter_2[counter];
		else                             conv_2[5]  <= conv_2[5];

		if (pixel[cursor + 'd8]  == 'd1) conv_2[6]  <= conv_2[6]  + filter_2[counter];
		else                             conv_2[6]  <= conv_2[6];
		if (pixel[cursor + 'd9]  == 'd1) conv_2[7]  <= conv_2[7]  + filter_2[counter];
		else                             conv_2[7]  <= conv_2[7];
		if (pixel[cursor + 'd10] == 'd1) conv_2[8]  <= conv_2[8]  + filter_2[counter];
		else                             conv_2[8]  <= conv_2[8];
		if (pixel[cursor + 'd11] == 'd1) conv_2[9]  <= conv_2[9]  + filter_2[counter];
		else                             conv_2[9]  <= conv_2[9];
		if (pixel[cursor + 'd12] == 'd1) conv_2[10] <= conv_2[10] + filter_2[counter];
		else                             conv_2[10] <= conv_2[10];
		if (pixel[cursor + 'd13] == 'd1) conv_2[11] <= conv_2[11] + filter_2[counter];
		else                             conv_2[11] <= conv_2[11];

		if (pixel[cursor + 'd16] == 'd1) conv_2[12] <= conv_2[12] + filter_2[counter];
		else                             conv_2[12] <= conv_2[12];
		if (pixel[cursor + 'd17] == 'd1) conv_2[13] <= conv_2[13] + filter_2[counter];
		else                             conv_2[13] <= conv_2[13];
		if (pixel[cursor + 'd18] == 'd1) conv_2[14] <= conv_2[14] + filter_2[counter];
		else                             conv_2[14] <= conv_2[14];
		if (pixel[cursor + 'd19] == 'd1) conv_2[15] <= conv_2[15] + filter_2[counter];
		else                             conv_2[15] <= conv_2[15];
		if (pixel[cursor + 'd20] == 'd1) conv_2[16] <= conv_2[16] + filter_2[counter];
		else                             conv_2[16] <= conv_2[16];
		if (pixel[cursor + 'd21] == 'd1) conv_2[17] <= conv_2[17] + filter_2[counter];
		else                             conv_2[17] <= conv_2[17];

		if (pixel[cursor + 'd24] == 'd1) conv_2[18] <= conv_2[18] + filter_2[counter];
		else                             conv_2[18] <= conv_2[18];
		if (pixel[cursor + 'd25] == 'd1) conv_2[19] <= conv_2[19] + filter_2[counter];
		else                             conv_2[19] <= conv_2[19];
		if (pixel[cursor + 'd26] == 'd1) conv_2[20] <= conv_2[20] + filter_2[counter];
		else                             conv_2[20] <= conv_2[20];
		if (pixel[cursor + 'd27] == 'd1) conv_2[21] <= conv_2[21] + filter_2[counter];
		else                             conv_2[21] <= conv_2[21];
		if (pixel[cursor + 'd28] == 'd1) conv_2[22] <= conv_2[22] + filter_2[counter];
		else                             conv_2[22] <= conv_2[22];
		if (pixel[cursor + 'd29] == 'd1) conv_2[23] <= conv_2[23] + filter_2[counter];
		else                             conv_2[23] <= conv_2[23];

		if (pixel[cursor + 'd32] == 'd1) conv_2[24] <= conv_2[24] + filter_2[counter];
		else                             conv_2[24] <= conv_2[24];
		if (pixel[cursor + 'd33] == 'd1) conv_2[25] <= conv_2[25] + filter_2[counter];
		else                             conv_2[25] <= conv_2[25];
		if (pixel[cursor + 'd34] == 'd1) conv_2[26] <= conv_2[26] + filter_2[counter];
		else                             conv_2[26] <= conv_2[26];
		if (pixel[cursor + 'd35] == 'd1) conv_2[27] <= conv_2[27] + filter_2[counter];
		else                             conv_2[27] <= conv_2[27];
		if (pixel[cursor + 'd36] == 'd1) conv_2[28] <= conv_2[28] + filter_2[counter];
		else                             conv_2[28] <= conv_2[28];
		if (pixel[cursor + 'd37] == 'd1) conv_2[29] <= conv_2[29] + filter_2[counter];
		else                             conv_2[29] <= conv_2[29];

		if (pixel[cursor + 'd40] == 'd1) conv_2[30] <= conv_2[30] + filter_2[counter];
		else                             conv_2[30] <= conv_2[30];
		if (pixel[cursor + 'd41] == 'd1) conv_2[31] <= conv_2[31] + filter_2[counter];
		else                             conv_2[31] <= conv_2[31];
		if (pixel[cursor + 'd42] == 'd1) conv_2[32] <= conv_2[32] + filter_2[counter];
		else                             conv_2[32] <= conv_2[32];
		if (pixel[cursor + 'd43] == 'd1) conv_2[33] <= conv_2[33] + filter_2[counter];
		else                             conv_2[33] <= conv_2[33];
		if (pixel[cursor + 'd44] == 'd1) conv_2[34] <= conv_2[34] + filter_2[counter];
		else                             conv_2[34] <= conv_2[34];
		if (pixel[cursor + 'd45] == 'd1) conv_2[35] <= conv_2[35] + filter_2[counter];
		else                             conv_2[35] <= conv_2[35];
	end

	else if (ns == ST_RELU_1) begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			if (conv_2[i][14] == 'd1) conv_2[i] <= 'd0;
			else                      conv_2[i] <= conv_2[i];
		end
	end

	else begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			conv_2[i] <= conv_2[i];
		end
	end
end

always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			conv_3[i] <= 'd0;
		end
	end

	else if (ns == ST_INPUT_PIXEL) begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			conv_3[i] <= filter_3_bias;
		end
	end

	else if (ns == ST_CONVOLUTION) begin
		if (pixel[cursor]        == 'd1) conv_3[0]  <= conv_3[0]  + filter_3[counter];
		else                             conv_3[0]  <= conv_3[0];
		if (pixel[cursor + 'd1]  == 'd1) conv_3[1]  <= conv_3[1]  + filter_3[counter];
		else                             conv_3[1]  <= conv_3[1];
		if (pixel[cursor + 'd2]  == 'd1) conv_3[2]  <= conv_3[2]  + filter_3[counter];
		else                             conv_3[2]  <= conv_3[2];
		if (pixel[cursor + 'd3]  == 'd1) conv_3[3]  <= conv_3[3]  + filter_3[counter];
		else                             conv_3[3]  <= conv_3[3];
		if (pixel[cursor + 'd4]  == 'd1) conv_3[4]  <= conv_3[4]  + filter_3[counter];
		else                             conv_3[4]  <= conv_3[4];
		if (pixel[cursor + 'd5]  == 'd1) conv_3[5]  <= conv_3[5]  + filter_3[counter];
		else                             conv_3[5]  <= conv_3[5];

		if (pixel[cursor + 'd8]  == 'd1) conv_3[6]  <= conv_3[6]  + filter_3[counter];
		else                             conv_3[6]  <= conv_3[6];
		if (pixel[cursor + 'd9]  == 'd1) conv_3[7]  <= conv_3[7]  + filter_3[counter];
		else                             conv_3[7]  <= conv_3[7];
		if (pixel[cursor + 'd10] == 'd1) conv_3[8]  <= conv_3[8]  + filter_3[counter];
		else                             conv_3[8]  <= conv_3[8];
		if (pixel[cursor + 'd11] == 'd1) conv_3[9]  <= conv_3[9]  + filter_3[counter];
		else                             conv_3[9]  <= conv_3[9];
		if (pixel[cursor + 'd12] == 'd1) conv_3[10] <= conv_3[10] + filter_3[counter];
		else                             conv_3[10] <= conv_3[10];
		if (pixel[cursor + 'd13] == 'd1) conv_3[11] <= conv_3[11] + filter_3[counter];
		else                             conv_3[11] <= conv_3[11];

		if (pixel[cursor + 'd16] == 'd1) conv_3[12] <= conv_3[12] + filter_3[counter];
		else                             conv_3[12] <= conv_3[12];
		if (pixel[cursor + 'd17] == 'd1) conv_3[13] <= conv_3[13] + filter_3[counter];
		else                             conv_3[13] <= conv_3[13];
		if (pixel[cursor + 'd18] == 'd1) conv_3[14] <= conv_3[14] + filter_3[counter];
		else                             conv_3[14] <= conv_3[14];
		if (pixel[cursor + 'd19] == 'd1) conv_3[15] <= conv_3[15] + filter_3[counter];
		else                             conv_3[15] <= conv_3[15];
		if (pixel[cursor + 'd20] == 'd1) conv_3[16] <= conv_3[16] + filter_3[counter];
		else                             conv_3[16] <= conv_3[16];
		if (pixel[cursor + 'd21] == 'd1) conv_3[17] <= conv_3[17] + filter_3[counter];
		else                             conv_3[17] <= conv_3[17];

		if (pixel[cursor + 'd24] == 'd1) conv_3[18] <= conv_3[18] + filter_3[counter];
		else                             conv_3[18] <= conv_3[18];
		if (pixel[cursor + 'd25] == 'd1) conv_3[19] <= conv_3[19] + filter_3[counter];
		else                             conv_3[19] <= conv_3[19];
		if (pixel[cursor + 'd26] == 'd1) conv_3[20] <= conv_3[20] + filter_3[counter];
		else                             conv_3[20] <= conv_3[20];
		if (pixel[cursor + 'd27] == 'd1) conv_3[21] <= conv_3[21] + filter_3[counter];
		else                             conv_3[21] <= conv_3[21];
		if (pixel[cursor + 'd28] == 'd1) conv_3[22] <= conv_3[22] + filter_3[counter];
		else                             conv_3[22] <= conv_3[22];
		if (pixel[cursor + 'd29] == 'd1) conv_3[23] <= conv_3[23] + filter_3[counter];
		else                             conv_3[23] <= conv_3[23];

		if (pixel[cursor + 'd32] == 'd1) conv_3[24] <= conv_3[24] + filter_3[counter];
		else                             conv_3[24] <= conv_3[24];
		if (pixel[cursor + 'd33] == 'd1) conv_3[25] <= conv_3[25] + filter_3[counter];
		else                             conv_3[25] <= conv_3[25];
		if (pixel[cursor + 'd34] == 'd1) conv_3[26] <= conv_3[26] + filter_3[counter];
		else                             conv_3[26] <= conv_3[26];
		if (pixel[cursor + 'd35] == 'd1) conv_3[27] <= conv_3[27] + filter_3[counter];
		else                             conv_3[27] <= conv_3[27];
		if (pixel[cursor + 'd36] == 'd1) conv_3[28] <= conv_3[28] + filter_3[counter];
		else                             conv_3[28] <= conv_3[28];
		if (pixel[cursor + 'd37] == 'd1) conv_3[29] <= conv_3[29] + filter_3[counter];
		else                             conv_3[29] <= conv_3[29];

		if (pixel[cursor + 'd40] == 'd1) conv_3[30] <= conv_3[30] + filter_3[counter];
		else                             conv_3[30] <= conv_3[30];
		if (pixel[cursor + 'd41] == 'd1) conv_3[31] <= conv_3[31] + filter_3[counter];
		else                             conv_3[31] <= conv_3[31];
		if (pixel[cursor + 'd42] == 'd1) conv_3[32] <= conv_3[32] + filter_3[counter];
		else                             conv_3[32] <= conv_3[32];
		if (pixel[cursor + 'd43] == 'd1) conv_3[33] <= conv_3[33] + filter_3[counter];
		else                             conv_3[33] <= conv_3[33];
		if (pixel[cursor + 'd44] == 'd1) conv_3[34] <= conv_3[34] + filter_3[counter];
		else                             conv_3[34] <= conv_3[34];
		if (pixel[cursor + 'd45] == 'd1) conv_3[35] <= conv_3[35] + filter_3[counter];
		else                             conv_3[35] <= conv_3[35];
	end

	else if (ns == ST_RELU_1) begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			if (conv_3[i][14] == 'd1) conv_3[i] <= 'd0;
			else                      conv_3[i] <= conv_3[i];
		end
	end

	else begin
		for (i = 0 ; i <= 35 ; i = i + 1) begin
			conv_3[i] <= conv_3[i];
		end
	end
end
/************************************************/
/***** pooling **********************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0 ; i <= 26 ; i = i + 1) begin
			pool[i] <= 'd0;
		end
	end

	else if (ns == ST_POOLING && counter == 'd1) begin
		pool[0]  <= conv_1[cursor];
		pool[1]  <= conv_1[cursor + 'd2];
		pool[2]  <= conv_1[cursor + 'd4];
		pool[3]  <= conv_1[cursor + 'd12];
		pool[4]  <= conv_1[cursor + 'd14];
		pool[5]  <= conv_1[cursor + 'd16];
		pool[6]  <= conv_1[cursor + 'd24];
		pool[7]  <= conv_1[cursor + 'd26];
		pool[8]  <= conv_1[cursor + 'd28];

		pool[9]  <= conv_2[cursor];
		pool[10] <= conv_2[cursor + 'd2];
		pool[11] <= conv_2[cursor + 'd4];
		pool[12] <= conv_2[cursor + 'd12];
		pool[13] <= conv_2[cursor + 'd14];
		pool[14] <= conv_2[cursor + 'd16];
		pool[15] <= conv_2[cursor + 'd24];
		pool[16] <= conv_2[cursor + 'd26];
		pool[17] <= conv_2[cursor + 'd28];

		pool[18] <= conv_3[cursor];
		pool[19] <= conv_3[cursor + 'd2];
		pool[20] <= conv_3[cursor + 'd4];
		pool[21] <= conv_3[cursor + 'd12];
		pool[22] <= conv_3[cursor + 'd14];
		pool[23] <= conv_3[cursor + 'd16];
		pool[24] <= conv_3[cursor + 'd24];
		pool[25] <= conv_3[cursor + 'd26];
		pool[26] <= conv_3[cursor + 'd28];
	end

	else if (ns == ST_POOLING) begin
		if (conv_1[cursor]        > pool[0])  begin pool[0]  <= conv_1[cursor];        end else begin pool[0]  <= pool[0];  end                                
		if (conv_1[cursor + 'd2]  > pool[1])  begin pool[1]  <= conv_1[cursor + 'd2];  end else begin pool[1]  <= pool[1];  end
		if (conv_1[cursor + 'd4]  > pool[2])  begin pool[2]  <= conv_1[cursor + 'd4];  end else begin pool[2]  <= pool[2];  end
		if (conv_1[cursor + 'd12] > pool[3])  begin pool[3]  <= conv_1[cursor + 'd12]; end else begin pool[3]  <= pool[3];  end
		if (conv_1[cursor + 'd14] > pool[4])  begin pool[4]  <= conv_1[cursor + 'd14]; end else begin pool[4]  <= pool[4];  end
		if (conv_1[cursor + 'd16] > pool[5])  begin pool[5]  <= conv_1[cursor + 'd16]; end else begin pool[5]  <= pool[5];  end
		if (conv_1[cursor + 'd24] > pool[6])  begin pool[6]  <= conv_1[cursor + 'd24]; end else begin pool[6]  <= pool[6];  end
		if (conv_1[cursor + 'd26] > pool[7])  begin pool[7]  <= conv_1[cursor + 'd26]; end else begin pool[7]  <= pool[7];  end
		if (conv_1[cursor + 'd28] > pool[8])  begin pool[8]  <= conv_1[cursor + 'd28]; end else begin pool[8]  <= pool[8];  end

		if (conv_2[cursor]        > pool[9])  begin pool[9]  <= conv_2[cursor];        end else begin pool[9]  <= pool[9];  end                                
		if (conv_2[cursor + 'd2]  > pool[10]) begin pool[10] <= conv_2[cursor + 'd2];  end else begin pool[10] <= pool[10]; end
		if (conv_2[cursor + 'd4]  > pool[11]) begin pool[11] <= conv_2[cursor + 'd4];  end else begin pool[11] <= pool[11]; end
		if (conv_2[cursor + 'd12] > pool[12]) begin pool[12] <= conv_2[cursor + 'd12]; end else begin pool[12] <= pool[12]; end
		if (conv_2[cursor + 'd14] > pool[13]) begin pool[13] <= conv_2[cursor + 'd14]; end else begin pool[13] <= pool[13]; end
		if (conv_2[cursor + 'd16] > pool[14]) begin pool[14] <= conv_2[cursor + 'd16]; end else begin pool[14] <= pool[14]; end
		if (conv_2[cursor + 'd24] > pool[15]) begin pool[15] <= conv_2[cursor + 'd24]; end else begin pool[15] <= pool[15]; end
		if (conv_2[cursor + 'd26] > pool[16]) begin pool[16] <= conv_2[cursor + 'd26]; end else begin pool[16] <= pool[16]; end
		if (conv_2[cursor + 'd28] > pool[17]) begin pool[17] <= conv_2[cursor + 'd28]; end else begin pool[17] <= pool[17]; end

		if (conv_3[cursor]        > pool[18]) begin pool[18] <= conv_3[cursor];        end else begin pool[18] <= pool[18]; end                                
		if (conv_3[cursor + 'd2]  > pool[19]) begin pool[19] <= conv_3[cursor + 'd2];  end else begin pool[19] <= pool[19]; end
		if (conv_3[cursor + 'd4]  > pool[20]) begin pool[20] <= conv_3[cursor + 'd4];  end else begin pool[20] <= pool[20]; end
		if (conv_3[cursor + 'd12] > pool[21]) begin pool[21] <= conv_3[cursor + 'd12]; end else begin pool[21] <= pool[21]; end
		if (conv_3[cursor + 'd14] > pool[22]) begin pool[22] <= conv_3[cursor + 'd14]; end else begin pool[22] <= pool[22]; end
		if (conv_3[cursor + 'd16] > pool[23]) begin pool[23] <= conv_3[cursor + 'd16]; end else begin pool[23] <= pool[23]; end
		if (conv_3[cursor + 'd24] > pool[24]) begin pool[24] <= conv_3[cursor + 'd24]; end else begin pool[24] <= pool[24]; end
		if (conv_3[cursor + 'd26] > pool[25]) begin pool[25] <= conv_3[cursor + 'd26]; end else begin pool[25] <= pool[25]; end
		if (conv_3[cursor + 'd28] > pool[26]) begin pool[26] <= conv_3[cursor + 'd28]; end else begin pool[26] <= pool[26]; end
	end

	else begin
		for (i = 0 ; i <= 26 ; i = i + 1) begin
			pool[i] <= pool[i];
		end
	end
end
/************************************************/
/***** affine 1 *********************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		affine_1[0] <= 'd0;
		affine_1[1] <= 'd0;
		affine_1[2] <= 'd0;
	end

	else if (ns == ST_RELU_1) begin
		affine_1[0] <= weight_1_bias_1;
		affine_1[1] <= weight_1_bias_2;
		affine_1[2] <= weight_1_bias_3;
	end

	else if (ns == ST_AFFINE_1) begin
		affine_1[0] <= affine_1[0] + pool[counter] * weight_1[cursor];
		affine_1[1] <= affine_1[1] + pool[counter] * weight_1[cursor + 'd1];
		affine_1[2] <= affine_1[2] + pool[counter] * weight_1[cursor + 'd2];
	end

	else if (ns == ST_RELU_2) begin
		if (affine_1[0][9] == 'd1) affine_1[0] <= 'd0;
		else                       affine_1[0] <= affine_1[0];
		if (affine_1[1][9] == 'd1) affine_1[1] <= 'd0;
		else                       affine_1[1] <= affine_1[1];
		if (affine_1[2][9] == 'd1) affine_1[2] <= 'd0;
		else                       affine_1[2] <= affine_1[2];
	end

	else begin
		affine_1[0] <= affine_1[0];
		affine_1[1] <= affine_1[1];
		affine_1[2] <= affine_1[2];
	end
end
/************************************************/
/***** affine 2 *********************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		affine_2[0] <= 'd0;
		affine_2[1] <= 'd0;
		affine_2[2] <= 'd0;
	end

	else if (ns == ST_RELU_2) begin
		affine_2[0] <= weight_2_bias_1;
		affine_2[1] <= weight_2_bias_2;
		affine_2[2] <= weight_2_bias_3;
	end

	else if (ns == ST_AFFINE_2) begin
		affine_2[0] <= affine_2[0] + affine_1[counter] * weight_2[cursor];
		affine_2[1] <= affine_2[1] + affine_1[counter] * weight_2[cursor + 'd1];
		affine_2[2] <= affine_2[2] + affine_1[counter] * weight_2[cursor + 'd2];
	end

	else begin
		affine_2[0] <= affine_2[0];
		affine_2[1] <= affine_2[1];
		affine_2[2] <= affine_2[2];
	end
end







/************************************************/
/***** out_valid ********************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if      (!rst_n)          out_valid <= 'd0;
	else if (ns == ST_OUTPUT) out_valid <= 'd1;
	else                      out_valid <= 'd0;
end
/************************************************/
/***** out_valid ********************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		number_2 <= 'd0;
		number_4 <= 'd0;
		number_6 <= 'd0;
	end

	else if (ns == ST_OUTPUT) begin
		if      (affine_2[0] >= affine_2[1] && affine_2[0] >= affine_2[2]) number_2 <= 'd1;
		else if (affine_2[1] >= affine_2[0] && affine_2[1] >= affine_2[2]) number_4 <= 'd1;
		else                                                               number_6 <= 'd1;
	end

	else begin
		number_2 <= 'd0;
		number_4 <= 'd0;
		number_6 <= 'd0;
	end
end
/************************************************/
/***** counter **********************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n)						counter <= 'd1;
	else if (ns == ST_INPUT_WEIGHT) counter <= counter + 'd1;
	else if (ns == ST_INPUT_PIXEL)  counter <= 'd0;
	else if (ns == ST_CONVOLUTION)  counter <= counter + 'd1;
	else if (ns == ST_POOLING)      counter <= counter + 'd1;
	else if (ns == ST_QK)           counter <= 'd0;
	else if (ns == ST_AFFINE_1)     counter <= counter + 'd1;
	else if (ns == ST_RELU_2)       counter <= 'd0;
	else if (ns == ST_AFFINE_2)     counter <= counter + 'd1;
	else							counter <= 'd1;
end
/************************************************/
/***** cursor ***********************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n)					 cursor <= 'd0;
	else if (ns == ST_CONVOLUTION) begin
		if      (cursor == 'd2)  cursor <= 'd8;
		else if (cursor == 'd10) cursor <= 'd16;
		else                     cursor <= cursor + 'd1;
	end
	else if (ns == ST_POOLING) begin
		if      (cursor == 'd1)  cursor <= 'd6;
		else                     cursor <= cursor + 'd1;
	end
	else if (ns == ST_QK)        cursor <= 'd0;
	else if (ns == ST_AFFINE_1)  cursor <= cursor + 'd3;
	else if (ns == ST_RELU_2)    cursor <= 'd0;
	else if (ns == ST_AFFINE_2)  cursor <= cursor + 'd3;
	else						 cursor <= 'd0;
end
/************************************************/
/***** switch state *****************************/
/************************************************/
always@ (posedge clk or negedge rst_n) begin
	if (!rst_n) cs <= ST_IDLE;
	else		cs <= ns;
end
/************************************************/
/***** FSM **************************************/
/************************************************/
always@ (*) begin
	case (cs)
		ST_IDLE: begin
			if      (in_valid_1 == 'd1) ns = ST_INPUT_WEIGHT;
			else if (in_valid_2 == 'd1) ns = ST_INPUT_PIXEL;
			else						ns = ST_IDLE;
		end

		ST_INPUT_WEIGHT: begin
			if (counter == 'd127) ns = ST_IDLE;
			else				  ns = ST_INPUT_WEIGHT;
		end

		ST_INPUT_PIXEL: begin
			if (in_valid_2 == 'd0) ns = ST_CONVOLUTION;
			else				   ns = ST_INPUT_PIXEL;
		end

		ST_CONVOLUTION: begin
			if (counter == 'd9) ns = ST_RELU_1;
			else                ns = ST_CONVOLUTION;
		end

		ST_RELU_1: begin
			ns = ST_POOLING;
		end

		ST_POOLING: begin
			if (counter == 'd5) ns = ST_QK;
			else                ns = ST_POOLING;
		end

		ST_QK: begin
			ns = ST_AFFINE_1;
		end

		ST_AFFINE_1: begin
			if (counter == 'd27) ns = ST_RELU_2;
			else                 ns = ST_AFFINE_1;
		end

		ST_RELU_2: begin
			ns = ST_AFFINE_2;
		end

		ST_AFFINE_2: begin
			if (counter == 'd3) ns = ST_OUTPUT;
			else                ns = ST_AFFINE_2;
		end

		ST_OUTPUT: begin
			ns = ST_IDLE;
		end

		default: begin
			ns = ST_IDLE;
		end
	endcase
end
endmodule
