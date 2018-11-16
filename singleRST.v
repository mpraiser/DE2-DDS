module singleRST(input CLK,input RST,output reg sRST);
	reg flag;
	always@(posedge CLK)
	begin
		if(RST && flag==0)
		begin
			flag<=1;
			sRST<=1'b1;
		end
		else
		begin
			sRST<=1'b0;
			if(!RST)
				flag<=0;
		end
	end

endmodule