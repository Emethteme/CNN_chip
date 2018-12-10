module CHIP(
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

input clk; 
input rst_n;
input in_valid_1;
input in_valid_2;
input [14:0]in_data;

output out_valid;
output number_2;
output number_4;
output number_6;

/**/

wire C_clk;
wire BUF_CLK;

wire C_rst_n;

wire C_in_valid_1;
wire C_in_valid_2;
wire [14:0] C_in_data;

wire C_out_valid;
wire C_number_2;
wire C_number_4;
wire C_number_6;

/**/

CNN CNN ( .clk(BUF_CLK),
	      .rst_n(C_rst_n),
	      .in_valid_1(C_in_valid_1),
	      .in_valid_2(C_in_valid_2),
	      .in_data(C_in_data),
	      .out_valid(C_out_valid),
	      .number_2(C_number_2),
	      .number_4(C_number_4),
	      .number_6(C_number_6));

/**/

CLKBUFX20 buf0 (.Y(BUF_CLK), .A(C_clk));

P8C I_CLK     (.Y(C_clk),        .PU(1'b1),.PD(1'b0),.P(clk),        .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b1),.CEN(1'b0),.A(1'b0));
P8C I_RESET   (.Y(C_rst_n),      .PU(1'b1),.PD(1'b0),.P(rst_n),      .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));

P4C I_VALID_1 (.Y(C_in_valid_1), .PU(1'b1),.PD(1'b0),.P(in_valid_1), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_VALID_2 (.Y(C_in_valid_2), .PU(1'b1),.PD(1'b0),.P(in_valid_2), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));

P4C I_IN_0    (.Y(C_in_data[0]), .PU(1'b1),.PD(1'b0),.P(in_data[0]), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_1    (.Y(C_in_data[1]), .PU(1'b1),.PD(1'b0),.P(in_data[1]), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_2    (.Y(C_in_data[2]), .PU(1'b1),.PD(1'b0),.P(in_data[2]), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_3    (.Y(C_in_data[3]), .PU(1'b1),.PD(1'b0),.P(in_data[3]), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_4    (.Y(C_in_data[4]), .PU(1'b1),.PD(1'b0),.P(in_data[4]), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_5    (.Y(C_in_data[5]), .PU(1'b1),.PD(1'b0),.P(in_data[5]), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_6    (.Y(C_in_data[6]), .PU(1'b1),.PD(1'b0),.P(in_data[6]), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_7    (.Y(C_in_data[7]), .PU(1'b1),.PD(1'b0),.P(in_data[7]), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_8    (.Y(C_in_data[8]), .PU(1'b1),.PD(1'b0),.P(in_data[8]), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_9    (.Y(C_in_data[9]), .PU(1'b1),.PD(1'b0),.P(in_data[9]), .ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_10   (.Y(C_in_data[10]),.PU(1'b1),.PD(1'b0),.P(in_data[10]),.ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_11   (.Y(C_in_data[11]),.PU(1'b1),.PD(1'b0),.P(in_data[11]),.ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_12   (.Y(C_in_data[12]),.PU(1'b1),.PD(1'b0),.P(in_data[12]),.ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_13   (.Y(C_in_data[13]),.PU(1'b1),.PD(1'b0),.P(in_data[13]),.ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));
P4C I_IN_14   (.Y(C_in_data[14]),.PU(1'b1),.PD(1'b0),.P(in_data[14]),.ODEN(1'b0),.OCEN(1'b0),.CSEN(1'b0),.CEN(1'b1),.A(1'b0));

P8C O_VALID   (.PU(1'b1),.PD(1'b0),.P(out_valid),.ODEN(1'b1),.OCEN(1'b1),.CSEN(1'b0),.CEN(1'b1),.A(C_out_valid));

P8C O_NUM_2   (.PU(1'b1),.PD(1'b0),.P(number_2), .ODEN(1'b1),.OCEN(1'b1),.CSEN(1'b0),.CEN(1'b1),.A(C_number_2));
P8C O_NUM_4   (.PU(1'b1),.PD(1'b0),.P(number_4), .ODEN(1'b1),.OCEN(1'b1),.CSEN(1'b0),.CEN(1'b1),.A(C_number_4));
P8C O_NUM_6   (.PU(1'b1),.PD(1'b0),.P(number_6), .ODEN(1'b1),.OCEN(1'b1),.CSEN(1'b0),.CEN(1'b1),.A(C_number_6));

PVDDR VDDP0 ();
PVSSR GNDP0 ();
PVDDR VDDP1 ();
PVSSR GNDP1 ();
PVDDR VDDP2 ();
PVSSR GNDP2 ();
PVDDR VDDP3 ();
PVSSR GNDP3 ();

PVDDC VDDC0 ();
PVSSC GNDC0 ();
PVDDC VDDC1 ();
PVSSC GNDC1 ();
PVDDC VDDC2 ();
PVSSC GNDC2 ();
PVDDC VDDC3 ();
PVSSC GNDC3 ();

endmodule