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

module time_ctrl#(
	parameter SYSCLKHZ = 5000_0000, //系统时钟 hz
    //parameter Period=SYSCLKHZ/Freq,
    parameter SD_FREQ = 500,
    parameter MIN_FREQ = 500,
    parameter HOUR_FREQ = 500,
	parameter SD_FULL_SCALE = 100,		//满量程微调
	parameter MIN_FULL_SCALE = 100,		//满量程微调
	parameter HOUR_FULL_SCALE = 100,		//满量程微调
    parameter SD_FULL_PERIOD = 100,        //占空比微调
    parameter MIN_FULL_PERIOD = 100,        //占空比微调
    parameter HOUR_FULL_PERIOD = 100        //占空比微调
)(
    input clk,     //1 MHz
    input [23:0]time_data,
    input Rst_n,
    input En,
    output sd_pwm,
	output min_pwm,
	output hour_pwm
);


second#(
    .Freq 		(SD_FREQ),
	.SYSCLKHZ 	(SYSCLKHZ), //系统时钟 hz
	.FULL_SCALE (SD_FULL_SCALE),	//满量程微调
	.FULL_PERIOD(SD_FULL_PERIOD),
	.Period     (SYSCLKHZ/SD_FREQ)
)u0_second(
    .clk(clk),     //1 MHz
    .time_data(time_data[7:0]),
    .Rst_n(Rst_n),
    .En(En),
    .sd_pwm(sd_pwm)
);

min#(
    .Freq 		(MIN_FREQ),
	.SYSCLKHZ 	(SYSCLKHZ), //系统时钟 hz
	.FULL_SCALE (MIN_FULL_SCALE),	//满量程微调
	.FULL_PERIOD(MIN_FULL_PERIOD)	,
	.Period     (SYSCLKHZ/MIN_FREQ)
)u0_min(
    .clk(clk),     
    .time_data(time_data[15:8]),
    .Rst_n(Rst_n),
    .En(En),
    .min_pwm(min_pwm)
);


hour#(
    .Freq 		(HOUR_FREQ),
	.SYSCLKHZ 	(SYSCLKHZ), //系统时钟 hz
	.FULL_SCALE (HOUR_FULL_SCALE),	//满量程微调
	.FULL_PERIOD(HOUR_FULL_PERIOD),
	.Period     (416667)//(SYSCLKHZ/HOUR_FREQ)
)u0_hour(
    .clk(clk),     
    .time_data(time_data[23:16]),
    .Rst_n(Rst_n),
    .En(En),
    .hour_pwm(hour_pwm)
); 

endmodule    