`timescale 1ns/1ps
`include "PATTERN.v"
`ifdef RTL
`include "CNN.v"
`elsif GATE
`include "CNN_SYN.v"
`elsif POSIM
`include "CHIP.v"
`endif
module TESTBED();

wire clk,rst_n,in_valid_1,in_valid_2,out_valid;
wire number_2,number_4,number_6;
wire [14:0] in_data;


initial begin
  `ifdef RTL
      $fsdbDumpfile("CNN.fsdb");
//	  $fsdbDumpvars();
	  $fsdbDumpvars(0,"+mda");
  `elsif GATE
      $fsdbDumpfile("CNN_SYN.fsdb");
	  $sdf_annotate("CNN_SYN.sdf",I_CNN);      
	  $fsdbDumpvars(0,"+mda");
//	  $fsdbDumpvars();   
  `elsif POSIM
      $fsdbDumpfile("CHIP.fsdb");
	  $sdf_annotate("CHIP.sdf",I_CHIP);      
	  $fsdbDumpvars(0,"+mda");
//	  $fsdbDumpvars();
  `endif
end

`ifdef RTL	
	CNN I_CNN
	(
        .clk(clk),
        .rst_n(rst_n),
        .in_valid_1(in_valid_1),
        .in_valid_2(in_valid_2),
        .number_2(number_2),
        .number_4(number_4),
        .number_6(number_6),
        .in_data(in_data),
        .out_valid(out_valid)
	);
`elsif GATE
	CNN I_CNN
	(
        .clk(clk),
        .rst_n(rst_n),
        .in_valid_1(in_valid_1),
        .in_valid_2(in_valid_2),
        .number_2(number_2),
        .number_4(number_4),
        .number_6(number_6),
        .in_data(in_data),
        .out_valid(out_valid)
    ); 
`elsif POSIM
	CHIP I_CHIP
	(
        .clk(clk),
        .rst_n(rst_n),
        .in_valid_1(in_valid_1),
        .in_valid_2(in_valid_2),
        .number_2(number_2),
        .number_4(number_4),
        .number_6(number_6),
        .in_data(in_data),
        .out_valid(out_valid)
    );
`endif

PATTERN I_PATTERN
(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid_1(in_valid_1),
    .in_valid_2(in_valid_2),
    .number_2(number_2),
    .number_4(number_4),
    .number_6(number_6),
    .in_data(in_data),
    .out_valid(out_valid)
);

endmodule
