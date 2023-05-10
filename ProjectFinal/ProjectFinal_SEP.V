module ProjectFinal_SEP(
	input[6:0] NUM,
	output reg[3:0] SEP10, SEP1
	);

	always @(NUM)
	begin
		if(NUM < 10)
		begin
			SEP10 = 4'd0;
			SEP1 = NUM;
		end
		else if(NUM < 20)
		begin
			SEP10 = 4'd1;
			SEP1 = NUM - 10;
		end
		else if(NUM < 30)
		begin
			SEP10 = 4'd2;
			SEP1 = NUM - 20;
		end
		else if(NUM < 40)
		begin
			SEP10 = 4'd3;
			SEP1 = NUM - 30;
		end
		else if(NUM < 50)
		begin
			SEP10 = 4'd4;
			SEP1 = NUM - 40;
		end
		else if(NUM < 60)
		begin
			SEP10 = 4'd5;
			SEP1 = NUM - 50;
		end
		else if(NUM < 70)
		begin
			SEP10 = 4'd6;
			SEP1 = NUM - 60;
		end
		else if(NUM < 80)
		begin
			SEP10 = 4'd7;
			SEP1 = NUM - 70;
		end
		else if(NUM < 90)
		begin
			SEP10 = 4'd8;
			SEP1 = NUM - 80;
		end
		else if(NUM < 100)
		begin
			SEP10 = 4'd9;
			SEP1 = NUM - 90;
		end
		else
		begin
			SEP10 = 4'd0;
			SEP1 = 4'd0;
		end
	end
	
endmodule
