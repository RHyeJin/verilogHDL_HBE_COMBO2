module ProjectFinal_SEG(
	input[3:0] BCD,
	input DOT,
	output reg[7:0] SEG_DATA
	);
	
	always @(*)
	begin
		case(BCD)
			4'd0 : SEG_DATA = {7'b1111_110, DOT}; //0
			4'd1 : SEG_DATA = {7'b0110_000, DOT}; //1
			4'd2 : SEG_DATA = {7'b1101_101, DOT}; //2
			4'd3 : SEG_DATA = {7'b1111_001, DOT}; //3
			4'd4 : SEG_DATA = {7'b0110_011, DOT}; //4
			4'd5 : SEG_DATA = {7'b1011_011, DOT}; //5
			4'd6 : SEG_DATA = {7'b1011_111, DOT}; //6
			4'd7 : SEG_DATA = {7'b1110_000, DOT}; //7
			4'd8 : SEG_DATA = {7'b1111_111, DOT}; //8
			4'd9 : SEG_DATA = {7'b1111_011, DOT}; //9
			default : SEG_DATA = {7'b0000_000, DOT}; //NULL
		endcase
	end
	
endmodule
