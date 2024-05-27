/*******************************OpenFPGA*******************************
*All rights reserved.
*Revision: 1.0
*Signal description
*1) _i input
*2) _o output
*3) _n activ low
*4) _dg debug signal 
*5) _r delay or register
*6) _s state mechine
*********************************************************************/

/*******************************second*********************
--1.TOP
*********************************************************************/

`timescale 1ns / 1ns//仿真时间间隔/精度

module min#(
    parameter Freq = 500,
	parameter SYSCLKHZ = 5000_0000, //系统时钟 hz
	parameter FULL_SCALE = 100,		//满量程微调
	parameter FULL_PERIOD = 100,
    parameter Period=SYSCLKHZ/Freq
)(
    input clk,     //1 MHz
    input [7:0]time_data,
    input Rst_n,
    input En,
    output min_pwm
);

reg [31:0] Duty_Num;


lut_time_60 second_lut_time(
	.lut_index(time_data),   //Look-up table address
	.lut_data(Duty_Num)     //Device address , register address, register data
);



pwm_modulator #(
  .PWM_PERIOD_DIV( 19 ),              // 100MHz/2^16= ~1.526 KHz
  .MOD_WIDTH( 15 )                    // from 0 to 255
) pwm1 (
  .clk( clk ),
  .nrst( Rst_n ),

  .mod_setpoint( Duty_Num  ),
  .pwm_out(min_pwm  ),

  .start_strobe( ),
  .busy(  )
);


endmodule    