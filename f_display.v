module f_display(input [17:0] f, output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
	reg [3:0] BCD0,BCD1,BCD2,BCD3,BCD4,BCD5,BCD6,BCD7;
	integer i=17;
	
	always@(f)
	begin
		BCD0=4'd0;
		BCD1=4'd0;
		BCD2=4'd0;
		BCD3=4'd0;
		BCD4=4'd0;
		BCD5=4'd0;
		BCD6=4'd0;
		BCD7=4'd0;
		for(i=17;i>=0;i=i-1)
		begin
			if(BCD0 >= 5) BCD0 = BCD0 + 3;
			if(BCD1 >= 5) BCD1 = BCD1 + 3;
			if(BCD2 >= 5) BCD2 = BCD2 + 3;
			if(BCD3 >= 5) BCD3 = BCD3 + 3;
			if(BCD4 >= 5) BCD4 = BCD4 + 3;
			if(BCD5 >= 5) BCD5 = BCD5 + 3;
			if(BCD6 >= 5) BCD6 = BCD6 + 3;
			if(BCD7 >= 5) BCD7 = BCD7 + 3;
			BCD7=BCD7<<1;
			BCD7[0]=BCD6[3];
			BCD6=BCD6<<1;
			BCD6[0]=BCD5[3];
			BCD5=BCD5<<1;
			BCD5[0]=BCD4[3];
			BCD4=BCD4<<1;
			BCD4[0]=BCD3[3];
			BCD3=BCD3<<1;
			BCD3[0]=BCD2[3];
			BCD2=BCD2<<1;
			BCD2[0]=BCD1[3];
			BCD1=BCD1<<1;
			BCD1[0]=BCD0[3];
			BCD0=BCD0<<1;
			BCD0[0]=f[i];
		end
	end
	SEG7_LUT S0(HEX0,BCD0);
	SEG7_LUT S1(HEX1,BCD1);
	SEG7_LUT S2(HEX2,BCD2);
	SEG7_LUT S3(HEX3,BCD3);
	SEG7_LUT S4(HEX4,BCD4);
	SEG7_LUT S5(HEX5,BCD5);
	SEG7_LUT S6(HEX6,BCD6);
	SEG7_LUT S7(HEX7,BCD7);
endmodule