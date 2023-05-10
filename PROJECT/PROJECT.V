module PROJECT(
	input CLK, RSTN, B1, B2, B3, B4, B5, B6, B7, STOP,
	output reg L1_R, L1_G, L2_R, L2_G, L3_R, L3_G,
	output reg[3:0] SEG_COM,
	output reg[7:0] SEG_DATA,
	output LCD_E,
	output reg LCD_RS, LCD_RW,
	output reg[7:0] LCD_DATA,
	output reg PIEZO
	);
	
	reg[2:0] sec = 3'd4;
	reg[6:0] msec = 7'd99;
	reg[6:0] cnt1;
	reg[4:0] state;
	reg[1:0] CNT_PIEZO, CNT_SCAN;
	reg CLK_100Hz;
	reg[2:0] CNT_100Hz;
	reg[8:0] CNT;
	wire[3:0] msec10, msec1;
	wire[7:0] SEG_DATA1, SEG_DATA2, SEG_DATA3;
	
	parameter 	DELAY = 5'd0,
					FUNCTION_SET = 5'd1,
					ENTRY_MODE = 5'd2,
					DISP_ONOFF = 5'd3,
					LINE1_1 = 5'd4,
					LINE2_1 = 5'd5,
					DELAY_T_1 = 5'd6,
					LINE1_1_M = 5'd7,
					LINE2_1_M = 5'd8,
					DELAY_T_1_M = 5'd9,
					LINE1_2 = 5'd10,
					LINE2_2 = 5'd11,
					DELAY_T_2 = 5'd12,
					LINE1_3 = 5'd13,
					LINE2_3 = 5'd14,
					DELAY_T_3 = 5'd15,
					LINE1_3_M = 5'd16,
					LINE2_3_M = 5'd17,
					DELAY_T_3_M = 5'd18;
					
	always @(posedge CLK)
	begin
		if(!RSTN)
		begin
			CNT_PIEZO <= 2'd0;
			PIEZO <= 1'b0;
		end
		else if(STOP == 1 | B7 == 1)
		begin
			CNT_PIEZO <= CNT_PIEZO;
			PIEZO <= PIEZO;
		end
		else if(state == LINE1_1 | state == LINE2_1 | state == DELAY_T_1 | state == LINE1_1_M | state == LINE2_1_M | state == DELAY_T_1_M)
		begin
			CNT_PIEZO <= (CNT_PIEZO >= 2'd3) ? 2'd0 : CNT_PIEZO + 1'b1;
			PIEZO <= (CNT_PIEZO >= 2'd3) ? ~PIEZO : PIEZO;
		end
		else if(state == LINE1_2 | state == LINE2_2 | state == DELAY_T_2)
		begin
			CNT_PIEZO <= (CNT_PIEZO >= 2'd2) ? 2'd0 : CNT_PIEZO + 1'b1;
			PIEZO <= (CNT_PIEZO >= 2'd2) ? ~PIEZO : PIEZO;
		end
		else if(state == LINE1_3 | state == LINE2_3 | state == DELAY_T_3 | state == LINE1_3_M | state == LINE2_3_M | state == DELAY_T_3_M)
		begin
			CNT_PIEZO <= (CNT_PIEZO >= 2'd1) ? 2'd0 : CNT_PIEZO + 1'b1;
			PIEZO <= (CNT_PIEZO >= 2'd1) ? ~PIEZO : PIEZO;
		end
		else
		begin
			CNT_PIEZO <= 2'd0;
			PIEZO <= 1'b0;
		end
	end
	
	always @(posedge CLK)
	begin
		if(!RSTN)
		begin
			CNT_SCAN <= 2'b00;
		end
		else if(B5 == 1)
		begin
			CNT_SCAN <= CNT_SCAN + 1'b1;
			case(CNT_SCAN)
				2'd0 :
				begin
					SEG_COM <= 4'b0111; //select COM1
					SEG_DATA <= 8'b11111100;
				end
				2'd1 :
				begin
					SEG_COM <= 4'b1011; //select COM2
					SEG_DATA <= 8'b11111100;
				end
				2'd2 :
				begin
				SEG_COM <= 4'b1101; //select COM3
				SEG_DATA <= 8'b11111100;
				end
				2'd3 :
				begin
					SEG_COM <= 4'b1110; //select COM4
					SEG_DATA <= 8'b11111100;
				end
			endcase
		end
		else if(STOP == 1)
		begin
			CNT_SCAN <= CNT_SCAN;
			SEG_COM <= SEG_COM;
			SEG_DATA <= SEG_DATA;
		end
		else
		begin
		CNT_SCAN <= CNT_SCAN + 1'b1;
		case(state)
			DELAY_T_1 :
			begin
				case(CNT_SCAN)
					2'd0 :
					begin
						SEG_COM <= 4'b0111; //select COM1
						SEG_DATA <= 8'b11111100;
					end
					2'd1 :
					begin
						SEG_COM <= 4'b1011; //select COM2
						SEG_DATA <= SEG_DATA1;
					end
					2'd2 :
					begin
						SEG_COM <= 4'b1101; //select COM3
						SEG_DATA <= SEG_DATA2;
					end
					2'd3 :
					begin
						SEG_COM <= 4'b1110; //select COM4
						SEG_DATA <= SEG_DATA3;
					end
				endcase
			end
			DELAY_T_1_M :
			begin
				case(CNT_SCAN)
					2'd0 :
					begin
						SEG_COM <= 4'b0111; //select COM1
						SEG_DATA <= 8'b11111100;
					end
					2'd1 :
					begin
						SEG_COM <= 4'b1011; //select COM2
						SEG_DATA <= 8'b11111101;
					end
					2'd2 :
					begin
						SEG_COM <= 4'b1101; //select COM3
						SEG_DATA <= SEG_DATA2;
					end
					2'd3 :
					begin
						SEG_COM <= 4'b1110; //select COM4
						SEG_DATA <= SEG_DATA3;
					end
				endcase
			end
			DELAY_T_2 :
			begin
				case(CNT_SCAN)
					2'd0 :
					begin
						SEG_COM <= 4'b0111; //select COM1
						SEG_DATA <= 8'b11111100;
					end
					2'd1 :
					begin
						SEG_COM <= 4'b1011; //select COM2
						SEG_DATA <= SEG_DATA1;
					end
					2'd2 :
					begin
						SEG_COM <= 4'b1101; //select COM3
						SEG_DATA <= SEG_DATA2;
					end
					2'd3 :
					begin
						SEG_COM <= 4'b1110; //select COM4
						SEG_DATA <= SEG_DATA3;
					end
				endcase
			end
			DELAY_T_3 :
			begin
				case(CNT_SCAN)
					2'd0 :
					begin
						SEG_COM <= 4'b0111; //select COM1
						SEG_DATA <= 8'b11111100;
					end
					2'd1 :
					begin
						SEG_COM <= 4'b1011; //select COM2
						SEG_DATA <= SEG_DATA1;
					end
					2'd2 :
					begin
						SEG_COM <= 4'b1101; //select COM3
						SEG_DATA <= SEG_DATA2;
					end
					2'd3 :
					begin
						SEG_COM <= 4'b1110; //select COM4
						SEG_DATA <= SEG_DATA3;
					end
				endcase
			end
			DELAY_T_3_M :
			begin
				case(CNT_SCAN)
					2'd0 :
					begin
						SEG_COM <= 4'b0111; //select COM1
						SEG_DATA <= 8'b11111100;
					end
					2'd1 :
					begin
						SEG_COM <= 4'b1011; //select COM2
						SEG_DATA <= 8'b11111101;
					end
					2'd2 :
					begin
						SEG_COM <= 4'b1101; //select COM3
						SEG_DATA <= SEG_DATA2;
					end
					2'd3 :
					begin
						SEG_COM <= 4'b1110; //select COM4
						SEG_DATA <= SEG_DATA3;
					end
				endcase
			end
			default :
			begin
				case(CNT_SCAN)
					2'd0 :
					begin
						SEG_COM <= 4'b0111; //select COM1
						SEG_DATA <= 8'b11111100;
					end
					2'd1 :
					begin
						SEG_COM <= 4'b1011; //select COM2
						SEG_DATA <= 8'b11111100;
					end
					2'd2 :
					begin
						SEG_COM <= 4'b1101; //select COM3
						SEG_DATA <= 8'b11111100;
					end
					2'd3 :
					begin
						SEG_COM <= 4'b1110; //select COM4
						SEG_DATA <= 8'b11111100;
					end
				endcase
			end
		endcase
		end
	end
	
	always @(posedge CLK)
	begin
		if(!RSTN)
		begin
			CNT_100Hz <= 0;
			CLK_100Hz <= 0;
		end
		else if(CNT_100Hz >= 3'd4)
		begin
			CNT_100Hz <= 0;
			CLK_100Hz <= ~CLK_100Hz;
		end
		else CNT_100Hz <= CNT_100Hz + 1'b1;
	end
	
	assign LCD_E = CLK_100Hz;
	
	always @(posedge CLK_100Hz)
	begin
		if(!RSTN)
		begin
			cnt1 <= 7'd0;
			sec <= 3'd4;
			msec <= 7'd99;
		end
		else if(STOP == 1)
		begin
			cnt1 <= cnt1;
			sec <= sec;
			msec <= msec;
		end
		else if(state == DELAY_T_1 | state == DELAY_T_1_M | state == DELAY_T_2 | state == DELAY_T_3 | state == DELAY_T_3_M)
		begin
			cnt1 <= (cnt1 == 7'd99) ? 7'd0 : cnt1 + 1'b1;
			sec <= (cnt1 == 7'd99 & msec == 7'd0) ? ((sec == 3'd0) ? 3'd4 : sec - 1'b1) : sec;
			msec <= (msec == 7'd0) ? 7'd99 : msec - 1'b1;
		end
		else
		begin
			cnt1 <= 7'd0;
			sec <= 3'd4;
			msec <= 7'd99;
		end
	end
	
	always @(posedge CLK_100Hz)
	begin
		if(!RSTN) state <= DELAY;
		else if(STOP == 1) state <= state;
		else if(B1 == 1) state <= LINE1_1;
		else if(B2 == 1) state <= LINE1_2;
		else if(B3 == 1) state <= LINE1_3;
		else
		begin
			case(state)
				DELAY				: state <= (CNT >= 69) ? FUNCTION_SET : DELAY;
				FUNCTION_SET	: state <= (CNT >= 29) ? DISP_ONOFF : FUNCTION_SET;
				DISP_ONOFF		: state <= (CNT >= 29) ? ENTRY_MODE : DISP_ONOFF;
				ENTRY_MODE		: state <= (CNT >= 29) ? LINE1_1 : ENTRY_MODE;
				LINE1_1			: state <= (CNT >= 19) ? LINE2_1 : LINE1_1;
				LINE2_1			: state <= (CNT >= 19) ? DELAY_T_1 : LINE2_1;
				DELAY_T_1		: state <= (CNT >= 499) ? LINE1_1_M : DELAY_T_1;
				LINE1_1_M		: state <= (CNT >= 19) ? LINE2_1_M : LINE1_1_M;
				LINE2_1_M		: state <= (CNT >= 19) ? DELAY_T_1_M : LINE2_1_M;
				DELAY_T_1_M		: state <= (CNT >= 99) ? LINE1_2 : DELAY_T_1_M;
				LINE1_2			: state <= (CNT >= 19) ? LINE2_2 : LINE1_2;
				LINE2_2			: state <= (CNT >= 19) ? DELAY_T_2 : LINE2_2;
				DELAY_T_2		: state <= (CNT >= 499) ? LINE1_3 : DELAY_T_2;
				LINE1_3			: state <= (CNT >= 19) ? LINE2_3 : LINE1_3;
				LINE2_3			: state <= (CNT >= 19) ? DELAY_T_3 : LINE2_3;
				DELAY_T_3		: state <= (CNT >= 499) ? LINE1_3_M : DELAY_T_3;
				LINE1_3_M		: state <= (CNT >= 19) ? LINE2_3_M : LINE1_3_M;
				LINE2_3_M		: state <= (CNT >= 19) ? DELAY_T_3_M : LINE2_3_M;
				DELAY_T_3_M		: state <= (CNT >= 99) ? LINE1_1 : DELAY_T_3_M;
				default			: state <= DELAY;
			endcase
		end
	end
	
	always @(posedge CLK_100Hz)
	begin
		if(!RSTN) CNT <= 0;
		else if(STOP == 1) CNT <= CNT;
		else
		begin
			case(state)
				DELAY				: CNT <= (CNT >= 69) ? 0 : CNT + 1'b1;
				FUNCTION_SET	: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				DISP_ONOFF		: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				ENTRY_MODE		: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				LINE1_1			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				LINE2_1			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_1		: CNT <= (CNT >= 499) ? 0 : CNT + 1'b1;
				LINE1_1_M		: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				LINE2_1_M		: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_1_M		: CNT <= (CNT >= 99) ? 0 : CNT + 1'b1;
				LINE1_2			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				LINE2_2			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_2		: CNT <= (CNT >= 499) ? 0 : CNT + 1'b1;
				LINE1_3			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				LINE2_3			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_3		: CNT <= (CNT >= 499) ? 0 : CNT + 1'b1;
				LINE1_3_M		: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				LINE2_3_M		: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_3_M		: CNT <= (CNT >= 99) ? 0 : CNT + 1'b1;
				default			: CNT <= 0;
			endcase
		end
	end
	
	always @(posedge CLK_100Hz)
	begin
		if(!RSTN)
		begin
			LCD_RS <= 1'b1;
			LCD_RW <= 1'b1;
			LCD_DATA <= 8'b0000_0000;
		end
		else if(B4 == 1)
		begin
			LCD_RS <= 1'b1;
			LCD_RW <= 1'b1;
			LCD_DATA <= 8'b0000_0000;
		end
		else if(STOP == 1)
		begin
			LCD_RS <= LCD_RS;
			LCD_RW <= LCD_RW;
			LCD_DATA <= LCD_DATA;
		end
		else
		begin
			case(state)
				FUNCTION_SET :
				begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_DATA <= 8'b0011_1100;
				end
				DISP_ONOFF :
				begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_DATA <= 8'b0000_1100;
				end
				ENTRY_MODE :
				begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_DATA <= 8'b0000_0110;
				end
				LINE1_1 :
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0 :
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_0000; //Address setting : 0x00
						end
						1 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						2 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						3 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						4 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						5 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						6 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						7 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						8 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						9 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						10 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						11 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						12 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0010; //2
						end
						13 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						14 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						15 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						16 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0100; //D
						end
						default :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
					endcase
				end
				LINE2_1	:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0 :
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0000; //Address setting : 0x40
						end
						1 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0011; //3
						end
						2 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						3 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						4 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						5 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0100; //D
						end
						6 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						7 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						8 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						9 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						10 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						11 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0001; //1
						end
						12 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						13 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_1100; //L
						end
						14 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						15 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0110; //F
						end
						16 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0100; //T
						end
						default :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
					endcase
				end
				DELAY_T_1 :
				begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_0010;
				end
				LINE1_1_M :
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0 :
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_0000; //Address setting : 0x00
						end
						1 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						2 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						3 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						4 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						5 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						6 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						7 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						8 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						9 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						10 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						11 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						12 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0010; //2
						end
						13 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						14 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						15 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						16 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0100; //D
						end
						default :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
					endcase
				end
				LINE2_1_M	:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0 :
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0000; //Address setting : 0x40
						end
						1 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0011; //3
						end
						2 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						3 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						4 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						5 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0100; //D
						end
						6 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						7 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						8 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						9 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0001; //1
						end
						10 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						11 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_1111; //O
						end
						12 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						13 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0001; //A
						end
						14 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_1110; //N
						end
						15 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0111; //G
						end
						16 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						default :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
					endcase
				end
				DELAY_T_1_M :
				begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_DATA <= 8'b0000_0010;
				end
				LINE1_2 :
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0 :
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_0000; //Address setting : 0x00
						end
						1 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						2 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						3 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						4 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						5 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						6 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						7 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						8 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						9 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						10 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						11 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0010; //2
						end
						12 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						13 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_1100; //L
						end
						14 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						15 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0110; //F
						end
						16 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0100; //T
						end
						default :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
					endcase
				end
				LINE2_2	:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0 :
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0000; //Address setting : 0x40
						end
						1 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0011; //3
						end
						2 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						3 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						4 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						5 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0100; //D
						end
						6 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						7 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						8 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						9 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						10 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						11 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						12 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0001; //1
						end
						13 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						14 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						15 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						16 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0100; //D
						end
						default :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
					endcase
				end
				DELAY_T_2 :
				begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_0010;
				end
				LINE1_3 :
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0 :
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_0000; //Address setting : 0x00
						end
						1 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						2 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						3 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						4 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						5 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						6 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						7 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						8 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						9 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						10 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0010; //2
						end
						11 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						12 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0111; //G
						end
						13 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						14 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						15 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						16 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_1110; //N
						end
						default :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
					endcase
				end
				LINE2_3	:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0 :
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0000; //Address setting : 0x40
						end
						1 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0011; //3
						end
						2 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						3 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0111; //G
						end
						4 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						5 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						6 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						7 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_1110; //N
						end
						8 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						9 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						10 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						11 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						12 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0001; //1
						end
						13 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						14 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						15 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						16 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0100; //D
						end
						default :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
					endcase
				end
				DELAY_T_3 :
				begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_0010;
				end
				LINE1_3_M :
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0 :
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_0000; //Address setting : 0x00
						end
						1 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						2 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						3 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						4 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						5 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						6 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						7 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						8 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						9 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0010; //2
						end
						10 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						11 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_1111; //O
						end
						12 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						13 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0001; //A
						end
						14 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_1110; //N
						end
						15 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0111; //G
						end
						16 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						default :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
					endcase
				end
				LINE2_3_M	:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0 :
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0000; //Address setting : 0x40
						end
						1 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0011; //3
						end
						2 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						3 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_1111; //O
						end
						4 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						5 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0001; //A
						end
						6 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_1110; //N
						end
						7 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0111; //G
						end
						8 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						9 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						10 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						11 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
						12 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_0001; //1
						end
						13 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110; //.
						end
						14 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0101_0010; //R
						end
						15 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0101; //E
						end
						16 :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0100_0100; //D
						end
						default :
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000; // (SPACE)
						end
					endcase
				end
				DELAY_T_3_M :
				begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_DATA <= 8'b0000_0010;
				end
				default :
				begin
				LCD_RS <= 1'b1;
				LCD_RW <= 1'b1;
				LCD_DATA <= 8'b0000_0000;
				end
			endcase
		end
	end
	
	always @(posedge CLK_100Hz)
	begin
		if(!RSTN)
		begin
			L1_R <= 1'b1;
			L1_G <= 1'b1;
			L2_R <= 1'b1;
			L2_G <= 1'b1;
			L3_R <= 1'b1;
			L3_G <= 1'b1;
		end
		else if(B6 == 1)
		begin
			L1_R <= 1'b0;
			L1_G <= 1'b0;
			L2_R <= 1'b0;
			L2_G <= 1'b0;
			L3_R <= 1'b0;
			L3_G <= 1'b0;
		end
		else if(STOP == 1)
		begin
			L1_R <= L1_R;
			L1_G <= L1_G;
			L2_R <= L2_R;
			L2_G <= L2_G;
			L3_R <= L3_R;
			L3_G <= L3_G;
		end
		else
		begin
		case(state)
				DELAY_T_1 :
				begin
					case(CNT)
						99 :
						begin
							L1_R <= 1'b1;
							L1_G <= 1'b0;
							L2_R <= 1'b0;
							L2_G <= 1'b1;
							L3_R <= 1'b1;
							L3_G <= 1'b0;
						end
						default :
						begin
							L1_R <= L1_R;
							L1_G <= L1_G;
							L2_R <= L2_R;
							L2_G <= L2_G;
							L3_R <= L3_R;
							L3_G <= L3_G;
						end
					endcase
				end
				DELAY_T_2 :
				begin
					case(CNT)
						99 :
						begin
							L1_R <= 1'b1;
							L1_G <= 1'b0;
							L2_R <= 1'b1;
							L2_G <= 1'b0;
							L3_R <= 1'b0;
							L3_G <= 1'b1;
						end
						default :
						begin
							L1_R <= L1_R;
							L1_G <= L1_G;
							L2_R <= L2_R;
							L2_G <= L2_G;
							L3_R <= L3_R;
							L3_G <= L3_G;
						end
					endcase
				end
				DELAY_T_3 :
				begin
					case(CNT)
						99 :
						begin
							L1_R <= 1'b0;
							L1_G <= 1'b1;
							L2_R <= 1'b1;
							L2_G <= 1'b0;
							L3_R <= 1'b1;
							L3_G <= 1'b0;
						end
						default :
						begin
							L1_R <= L1_R;
							L1_G <= L1_G;
							L2_R <= L2_R;
							L2_G <= L2_G;
							L3_R <= L3_R;
							L3_G <= L3_G;
						end
					endcase
				end
				default :
				begin
				L1_R <= L1_R;
				L1_G <= L1_G;
				L2_R <= L2_R;
				L2_G <= L2_G;
				L3_R <= L3_R;
				L3_G <= L3_G;
				end
			endcase
		end
	end
	
	PROJECT_SEP msec_sep(msec, msec10, msec1);
	PROJECT_SEG sec_seg(sec, 1, SEG_DATA1);
	PROJECT_SEG msec10_seg(msec10, 0, SEG_DATA2);
	PROJECT_SEG msec1_seg(msec1, 0, SEG_DATA3);
	
	
endmodule
