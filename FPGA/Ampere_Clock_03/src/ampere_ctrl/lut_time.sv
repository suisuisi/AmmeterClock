
module lut_time_60(
	input[7:0]             lut_index,   //Look-up table address
	output reg[31:0]       lut_data     //Device address (8bit I2C address), register address, register data
);


always@(*)
begin
	case(lut_index)			  
		10'd  0: lut_data <= 0;
		10'd  1: lut_data <= 368;
		10'd  2: lut_data <= 736;
		10'd  3: lut_data <= 1105;
		10'd  4: lut_data <= 1473;
		10'd  5: lut_data <= 1841;
		10'd  6: lut_data <= 2209;
		10'd  7: lut_data <= 2577;
		10'd  8: lut_data <= 2945;
		10'd  9: lut_data <= 3314;
		10'd 10: lut_data <= 3682;
		10'd 11: lut_data <= 4050;
		10'd 12: lut_data <= 4418;
		10'd 13: lut_data <= 4786;
		10'd 14: lut_data <= 5154;
		10'd 15: lut_data <= 5523;
		10'd 16: lut_data <= 5891;
		10'd 17: lut_data <= 6259;
		10'd 18: lut_data <= 6627;
		10'd 19: lut_data <= 6995;
		10'd 20: lut_data <= 7363;
		10'd 21: lut_data <= 7732;
		10'd 22: lut_data <= 8100;
		10'd 23: lut_data <= 8468;
		10'd 24: lut_data <= 8836;
		10'd 25: lut_data <= 9204;
		10'd 26: lut_data <= 9572;
		10'd 27: lut_data <= 9941;
		10'd 28: lut_data <= 10309;
		10'd 29: lut_data <= 10677;
		10'd 30: lut_data <= 11045;
		10'd 31: lut_data <= 11413;
		10'd 32: lut_data <= 11781;
		10'd 33: lut_data <= 12150;
		10'd 34: lut_data <= 12518;
		10'd 35: lut_data <= 12886;
		10'd 36: lut_data <= 13254;
		10'd 37: lut_data <= 13622;
		10'd 38: lut_data <= 13990;
		10'd 39: lut_data <= 14359;
		10'd 40: lut_data <= 14727;
		10'd 41: lut_data <= 15095;
		10'd 42: lut_data <= 15463;
		10'd 43: lut_data <= 15831;
		10'd 44: lut_data <= 16199;
		10'd 45: lut_data <= 16568;
		10'd 46: lut_data <= 16936;
		10'd 47: lut_data <= 17304;
		10'd 48: lut_data <= 17672;
		10'd 49: lut_data <= 18040;
		10'd 50: lut_data <= 18408;
		10'd 51: lut_data <= 18777;
		10'd 52: lut_data <= 19145;
		10'd 53: lut_data <= 19513;
		10'd 54: lut_data <= 19881;
		10'd 55: lut_data <= 20249;
		10'd 56: lut_data <= 20617;
		10'd 57: lut_data <= 20986;
		10'd 58: lut_data <= 21354;
		10'd 59: lut_data <= 21722;
		10'd 60: lut_data <= 22090;
		10'd 61: lut_data <= 22458;
		10'd 62: lut_data <= 22826;
		10'd 63: lut_data <= 23195;
		10'd 64: lut_data <= 23563;
		10'd 65: lut_data <= 23931;
		10'd 66: lut_data <= 24299;
		10'd 67: lut_data <= 24667;
		10'd 68: lut_data <= 25035;
		10'd 69: lut_data <= 25404;
		10'd 70: lut_data <= 25772;
		10'd 71: lut_data <= 26140;
		10'd 72: lut_data <= 26508;
		10'd 73: lut_data <= 26876;
		10'd 74: lut_data <= 27244;
		10'd 75: lut_data <= 27613;
		10'd 76: lut_data <= 27981;
		10'd 77: lut_data <= 28349;
		10'd 78: lut_data <= 28717;
		10'd 79: lut_data <= 29085;
		10'd 80: lut_data <= 29453;
		10'd 81: lut_data <= 29822;
		10'd 82: lut_data <= 30190;
		10'd 83: lut_data <= 30558;
		10'd 84: lut_data <= 30926;
		10'd 85: lut_data <= 31294;
		10'd 86: lut_data <= 31662;
		10'd 87: lut_data <= 32031;
		10'd 88: lut_data <= 32399;
		10'd 89: lut_data <= 32767;
		default:lut_data <=  32767;
	endcase
end
endmodule 


module lut_time_12(
	input[7:0]             lut_index,   //Look-up table address
	output reg[31:0]       lut_data     //Device address , register address, register data
);

always@(*)
begin
	case(lut_index)			  
		10'd  0: lut_data <= 0     ;
		10'd  1: lut_data <= 1820  ;
		10'd  2: lut_data <= 3641  ;
		10'd  3: lut_data <= 5461  ;
		10'd  4: lut_data <= 7282  ;
		10'd  5: lut_data <= 9102  ;
		10'd  6: lut_data <= 10922 ;
		10'd  7: lut_data <= 12743 ;
		10'd  8: lut_data <= 14563 ;
		10'd  9: lut_data <= 16384 ;
		10'd 10: lut_data <= 18204 ;
		10'd 11: lut_data <= 20024 ;
		10'd 12: lut_data <= 21845 ;
		10'd 13: lut_data <= 23665 ;
		10'd 14: lut_data <= 25485 ;
		10'd 15: lut_data <= 27306 ;
		10'd 16: lut_data <= 29126 ;
		10'd 17: lut_data <= 30947 ;
		10'd 18: lut_data <= 32767 ;
		10'd 19: lut_data <= 0     ;
		10'd 20: lut_data <= 1820  ;
		10'd 21: lut_data <= 3641  ;
		10'd 22: lut_data <= 5461  ;
		10'd 23: lut_data <= 7282  ;
		10'd 24: lut_data <= 9102  ;
		10'd 25: lut_data <= 10922 ;
		10'd 26: lut_data <= 12743 ;
		10'd 27: lut_data <= 14563 ;
		10'd 28: lut_data <= 16384 ;
		10'd 29: lut_data <= 18204 ;
		10'd 30: lut_data <= 20024 ;
		10'd 31: lut_data <= 21845 ;
		10'd 32: lut_data <= 23665 ;
		10'd 33: lut_data <= 25485 ;
		10'd 34: lut_data <= 27306 ;
		10'd 35: lut_data <= 29126 ;
		10'd 36: lut_data <= 30947 ;
		default:lut_data <= 32767  ;
	endcase
end


endmodule 