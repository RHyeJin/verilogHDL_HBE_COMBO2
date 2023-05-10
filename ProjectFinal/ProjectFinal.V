module ProjectFinal(
	input clk, rst, LCD_Stop, SEG_Stop, LED_Stop, PIEZO_Stop, STOP,
	input [2:0] Man_Button,
	output reg Light1_Red, Light1_Green, Light2_Red, Light2_Green, Light3_Red, Light3_Green,
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
	reg clk_100Hz;
	reg[2:0] CNT_100Hz;
	reg[8:0] CNT;
	wire[3:0] msec10, msec1;
	wire[7:0] SEG_DATA1, SEG_DATA2, SEG_DATA3;
	
	parameter 	DELAY = 5'd0,
					FUNCTION_SET = 5'd1,
					ENTRY_MODE = 5'd2,
					DISP_ONOFF = 5'd3,
					Line1_case0 = 5'd4,
					Line2_case0 = 5'd5,
					DELAY_T_case0 = 5'd6,
					Line1_case1 = 5'd7,
					Line2_case1 = 5'd8,
					DELAY_T_case1 = 5'd9,
					Line1_case2 = 5'd10,
					Line2_case2 = 5'd11,
					DELAY_T_case2 = 5'd12,
					Line1_case3 = 5'd13,
					Line2_case3 = 5'd14,
					DELAY_T_case3 = 5'd15,
					Line1_case4 = 5'd16,
					Line2_case4 = 5'd17,
					DELAY_T_case4 = 5'd18,
					Line1_case5 = 5'd19,
					Line2_case5 = 5'd20,
					DELAY_T_case5 = 5'd21;
					
	always @(posedge clk)
	begin
		if(!rst)
		begin
			CNT_PIEZO <= 2'd0;
			PIEZO <= 1'b0;
		end
		else if(STOP == 1 | PIEZO_Stop == 1)
		begin
			CNT_PIEZO <= CNT_PIEZO;
			PIEZO <= PIEZO;
		end
		else if(state == Line1_case0 | state == Line2_case0 | state == DELAY_T_case0 | state == Line1_case1 | state == Line2_case1 | state == DELAY_T_case1)
		begin
			CNT_PIEZO <= (CNT_PIEZO >= 2'd3) ? 2'd0 : CNT_PIEZO + 1'b1;
			PIEZO <= (CNT_PIEZO >= 2'd3) ? ~PIEZO : PIEZO;
		end
		else if(state == Line1_case2 | state == Line2_case2 | state == DELAY_T_case2 | state == Line1_case3 | state == Line2_case3 | state == DELAY_T_case3)
		begin
			CNT_PIEZO <= (CNT_PIEZO >= 2'd2) ? 2'd0 : CNT_PIEZO + 1'b1;
			PIEZO <= (CNT_PIEZO >= 2'd2) ? ~PIEZO : PIEZO;
		end
		else if(state == Line1_case4 | state == Line2_case4 | state == DELAY_T_case4 | state == Line1_case5 | state == Line2_case5 | state == DELAY_T_case5)
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
	
	always @(posedge clk)
	begin
		if(!rst)
		begin
			CNT_SCAN <= 2'b00;
		end
		else if(SEG_Stop == 1)
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
			DELAY_T_case0 :
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
			DELAY_T_case1 :
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
			DELAY_T_case2 :
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
			DELAY_T_case3 :
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
			DELAY_T_case4 :
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
			DELAY_T_case5 :
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
	
	always @(posedge clk)
	begin
		if(!rst)
		begin
			CNT_100Hz <= 0;
			clk_100Hz <= 0;
		end
		else if(CNT_100Hz >= 3'd4)
		begin
			CNT_100Hz <= 0;
			clk_100Hz <= ~clk_100Hz;
		end
		else CNT_100Hz <= CNT_100Hz + 1'b1;
	end
	
	assign LCD_E = clk_100Hz;
	
	always @(posedge clk_100Hz)
	begin
		if(!rst)
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
		else if(state == DELAY_T_case0 | state == DELAY_T_case1 | state == DELAY_T_case2 | state == DELAY_T_case3 | state == DELAY_T_case4 | state == DELAY_T_case5)
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
	
	always @(posedge clk_100Hz)
	begin
		if(!rst) state <= DELAY;
		else if(STOP == 1) state <= state;
		else if(Man_Button[0] == 1) state <= Line1_case0;
		else if(Man_Button[1] == 1) state <= Line1_case2;
		else if(Man_Button[2] == 1) state <= Line1_case4;
		else
		begin
			case(state)
				DELAY				: state <= (CNT >= 69) ? FUNCTION_SET : DELAY;
				FUNCTION_SET	: state <= (CNT >= 29) ? DISP_ONOFF : FUNCTION_SET;
				DISP_ONOFF		: state <= (CNT >= 29) ? ENTRY_MODE : DISP_ONOFF;
				ENTRY_MODE		: state <= (CNT >= 29) ? Line1_case0 : ENTRY_MODE;
				Line1_case0			: state <= (CNT >= 19) ? Line2_case0 : Line1_case0;
				Line2_case0			: state <= (CNT >= 19) ? DELAY_T_case0 : Line2_case0;
				DELAY_T_case0		: state <= (CNT >= 499) ? Line1_case1 : DELAY_T_case0;
				Line1_case1		: state <= (CNT >= 19) ? Line2_case1 : Line1_case1;
				Line2_case1		: state <= (CNT >= 19) ? DELAY_T_case1 : Line2_case1;
				DELAY_T_case1		: state <= (CNT >= 99) ? Line1_case2 : DELAY_T_case1;
				Line1_case2			: state <= (CNT >= 19) ? Line2_case2 : Line1_case2;
				Line2_case2			: state <= (CNT >= 19) ? DELAY_T_case2 : Line2_case2;
				DELAY_T_case2		: state <= (CNT >= 499) ? Line1_case3 : DELAY_T_case2;
				Line1_case3			: state <= (CNT >= 19) ? Line2_case3 : Line1_case3;
				Line2_case3			: state <= (CNT >= 19) ? DELAY_T_case3 : Line2_case3;
				DELAY_T_case3		: state <= (CNT >= 99) ? Line1_case4 : DELAY_T_case3;
				Line1_case4		: state <= (CNT >= 19) ? Line2_case4 : Line1_case4;
				Line2_case4		: state <= (CNT >= 19) ? DELAY_T_case4 : Line2_case4;
				DELAY_T_case4		: state <= (CNT >= 499) ? Line1_case5 : DELAY_T_case4;
				Line1_case5		: state <= (CNT >= 19) ? Line2_case5 : Line1_case5;
				Line2_case5		: state <= (CNT >= 19) ? DELAY_T_case5 : Line2_case5;
				DELAY_T_case5		: state <= (CNT >= 99) ? Line1_case0 : DELAY_T_case5;
				default			: state <= DELAY;
			endcase
		end
	end
	
	always @(posedge clk_100Hz)
	begin
		if(!rst) CNT <= 0;
		else if(STOP == 1) CNT <= CNT;
		else
		begin
			case(state)
				DELAY				: CNT <= (CNT >= 69) ? 0 : CNT + 1'b1;
				FUNCTION_SET	: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				DISP_ONOFF		: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				ENTRY_MODE		: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				Line1_case0			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				Line2_case0			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_case0		: CNT <= (CNT >= 499) ? 0 : CNT + 1'b1;
				Line1_case1		: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				Line2_case1		: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_case1		: CNT <= (CNT >= 99) ? 0 : CNT + 1'b1;
				Line1_case2			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				Line2_case2			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_case2		: CNT <= (CNT >= 499) ? 0 : CNT + 1'b1;
				Line1_case3			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				Line2_case3			: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_case3		: CNT <= (CNT >= 99) ? 0 : CNT + 1'b1;
				Line1_case4		: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				Line2_case4		: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_case4		: CNT <= (CNT >= 499) ? 0 : CNT + 1'b1;
				Line1_case5		: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				Line2_case5		: CNT <= (CNT >= 19) ? 0 : CNT + 1'b1;
				DELAY_T_case5		: CNT <= (CNT >= 99) ? 0 : CNT + 1'b1;
				default			: CNT <= 0;
			endcase
		end
	end
	
	always @(posedge clk_100Hz)
	begin
		if(!rst)
		begin
			LCD_RS <= 1'b1;
			LCD_RW <= 1'b1;
			LCD_DATA <= 8'b0000_0000;
		end
		else if(LCD_Stop == 1)
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
				Line1_case0 :
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
				Line2_case0	:
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
				DELAY_T_case0 :
				begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_0010;
				end
				Line1_case1 :
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
				Line2_case1	:
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
				DELAY_T_case1 :
				begin
				LCD_RS <= 1'b0;
				LCD_RW <= 1'b0;
				LCD_DATA <= 8'b0000_0010;
				end
				Line1_case2 :
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
				Line2_case2	:
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
				DELAY_T_case2 :
				begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_0010;
				end
				Line1_case3 :
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
				Line2_case3	:
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
				DELAY_T_case3 :
				begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_0010;
				end
				Line1_case4 :
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
				Line2_case4	:
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
				DELAY_T_case4 :
				begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_0010;
				end
				Line1_case5 :
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
				Line2_case5	:
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
				DELAY_T_case5 :
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
	
	always @(posedge clk_100Hz)
	begin
		if(!rst)
		begin
			Light1_Red <= 1'b1;
			Light1_Green <= 1'b1;
			Light2_Red <= 1'b1;
			Light2_Green <= 1'b1;
			Light3_Red <= 1'b1;
			Light3_Green <= 1'b1;
		end
		else if(LED_Stop == 1)
		begin
			Light1_Red <= 1'b0;
			Light1_Green <= 1'b0;
			Light2_Red <= 1'b0;
			Light2_Green <= 1'b0;
			Light3_Red <= 1'b0;
			Light3_Green <= 1'b0;
		end
		else if(STOP == 1)
		begin
			Light1_Red <= Light1_Red;
			Light1_Green <= Light1_Green;
			Light2_Red <= Light2_Red;
			Light2_Green <= Light2_Green;
			Light3_Red <= Light3_Red;
			Light3_Green <= Light3_Green;
		end
		else
		begin
		case(state)
				DELAY_T_case0 :
				begin
					case(CNT)
						99 :
						begin
							Light1_Red <= 1'b1;
							Light1_Green <= 1'b0;
							Light2_Red <= 1'b0;
							Light2_Green <= 1'b1;
							Light3_Red <= 1'b1;
							Light3_Green <= 1'b0;
						end
						default :
						begin
							Light1_Red <= Light1_Red;
							Light1_Green <= Light1_Green;
							Light2_Red <= Light2_Red;
							Light2_Green <= Light2_Green;
							Light3_Red <= Light3_Red;
							Light3_Green <= Light3_Green;
						end
					endcase
				end
				DELAY_T_case2 :
				begin
					case(CNT)
						99 :
						begin
							Light1_Red <= 1'b1;
							Light1_Green <= 1'b0;
							Light2_Red <= 1'b1;
							Light2_Green <= 1'b0;
							Light3_Red <= 1'b0;
							Light3_Green <= 1'b1;
						end
						default :
						begin
							Light1_Red <= Light1_Red;
							Light1_Green <= Light1_Green;
							Light2_Red <= Light2_Red;
							Light2_Green <= Light2_Green;
							Light3_Red <= Light3_Red;
							Light3_Green <= Light3_Green;
						end
					endcase
				end
				DELAY_T_case4 :
				begin
					case(CNT)
						99 :
						begin
							Light1_Red <= 1'b0;
							Light1_Green <= 1'b1;
							Light2_Red <= 1'b1;
							Light2_Green <= 1'b0;
							Light3_Red <= 1'b1;
							Light3_Green <= 1'b0;
						end
						default :
						begin
							Light1_Red <= Light1_Red;
							Light1_Green <= Light1_Green;
							Light2_Red <= Light2_Red;
							Light2_Green <= Light2_Green;
							Light3_Red <= Light3_Red;
							Light3_Green <= Light3_Green;
						end
					endcase
				end
				default :
				begin
				Light1_Red <= Light1_Red;
				Light1_Green <= Light1_Green;
				Light2_Red <= Light2_Red;
				Light2_Green <= Light2_Green;
				Light3_Red <= Light3_Red;
				Light3_Green <= Light3_Green;
				end
			endcase
		end
	end
	
	ProjectFinal_SEP msec_sep(msec, msec10, msec1);
	ProjectFinal_SEG sec_seg(sec, 1, SEG_DATA1);
	ProjectFinal_SEG msec10_seg(msec10, 0, SEG_DATA2);
	ProjectFinal_SEG msec1_seg(msec1, 0, SEG_DATA3);
	
	
endmodule
