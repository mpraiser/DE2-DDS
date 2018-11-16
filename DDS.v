`define len_N 30
`define fc 28'd50_000_000 //50MHz

module DDS(
	//just for debug
	input CLK_fc,
	input CLK_27M,
	input [17:0] f,
	input phase_select,
	input RST,
	output [7:0] LCD_DATA,
	output LCD_RW,LCD_EN,LCD_RS,LCD_ON,LCD_BLON,
	output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,
	output [9:0] VGA_R,
	output	VGA_CLK,   				//	VGA Clock
	output	VGA_HS,					//	VGA H_SYNC
	output	VGA_VS,					//	VGA V_SYNC
	output	VGA_BLANK,				//	VGA BLANK
	output	VGA_SYNC				//	VGA SYNC
	);
	
	wire [`len_N-1:0] M;
	wire [9:0] DAC_data;
	wire sRST;
	wire VGA_CTRL_CLK;
	
	reg phase;
	reg [`len_N-1:0] counter;
	reg [`len_N-1:0] phase_counter;
	
	//assign VGA_CLK=CLK_fc;
	assign	LCD_ON		=	1'b1;
	assign	LCD_BLON	=	1'b1;
	assign VGA_BLANK = 1;
	assign VGA_CLK = CLK_fc;
	
	f2M dds_f2M(.f(f), .M(M));
	singleRST dds_sRST(.CLK(CLK_fc),.RST(RST),.sRST(sRST));
	LCD dds_LCD(
		.iCLK(CLK_fc),
		.iRST_N(RST),
		.LCD_DATA(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN),
		.LCD_RS(LCD_RS)
		);
	f_display dds_f_display(
		.f(f),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
		);
	DDS_ROM dds_sin_table(
		.address(phase_counter[`len_N-1:`len_N-13]), //13 according to 10b_sin_13b_x
		.data(),
		.inclock(CLK_fc),
		.q(VGA_R)
		);
	
	/*reg [9:0] test;
	assign VGA_R=test;
	always @ (posedge VGA_CLK)
	begin
		test<=test+1;
	end*/
	
	//VGA_Audio_PLL dds_PLL(	.areset(),.inclk0(CLK_27M),.c0(),.c1(VGA_CTRL_CLK),.c2(VGA_CLK));
	/*VGA_Controller		u1	(	//	Host Side
							.iCursor_RGB_EN(4'h7),
							.oAddress(mVGA_ADDR),
							.iRed(DAC_data),
							.iGreen(),
							.iBlue(),
							//	VGA Side
							.oVGA_R(VGA_R),
							.oVGA_G(),
							.oVGA_B(),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC),
							.oVGA_BLANK(VGA_BLANK),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(~RST));*/
	/*VGA_DAC dds_dac(
		
		);*/
	/*initial 
	begin

		counter = 0;
	end*/
	
	always@(posedge CLK_fc)
	begin
		if(!RST)
			counter <= 0;
		else
		begin
			counter <= counter+M;
			if(phase)
				phase_counter <= counter + 268435456; //magic number, 2**(N-2);
			else
				phase_counter <= counter;
			
		end
	end
	
	always@(posedge phase_select)//push button to chang phase
		phase = ~phase;
endmodule

module f2M(input [17:0] f, output reg [`len_N-1:0] M);
	initial
		M=(43*10000)>>1; //default set
	always@(f) //calculater M according to selected f
		M=(43*f)>>1;
		//M=(43*f)>>3;//2**28/50e6=5.37,5.37*8=42.9. it's a magic number
		//improvement1:do not use '**'&'/'
		//improvement2:shift to simulate float calculation
endmodule

/*module VGA_DAC(
	input [9:0] DAC_data,
	input CLK,
	output [9:0] oVGA_R,
	output	reg	oVGA_H_SYNC,
	output	reg	oVGA_V_SYNC,
	output	oVGA_SYNC,
	output	oVGA_BLANK,
	output	oVGA_CLOCK,
	);
	
	assign	oVGA_BLANK	=	oVGA_H_SYNC & oVGA_V_SYNC;
	assign	oVGA_SYNC	=	1'b0;
	assign	oVGA_CLOCK	=	iCLK;
endmodule*/


