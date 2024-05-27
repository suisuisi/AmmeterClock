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

/*******************************rtc_uart_hex*********************
--1.TOP
*********************************************************************/

`timescale 1ns / 1ns//仿真时间间隔/精度

module rtc_uart_hex#(
    parameter SD_FREQ = 100_000,
    parameter MIN_FREQ = 200,
    parameter HOUR_FREQ = 120,
	parameter SYSCLKHZ =  50_000_000, //系统时钟 hz
   // parameter Period=SYSCLKHZ/Freq,
	parameter SD_FULL_SCALE = 100,		//满量程微调
	parameter MIN_FULL_SCALE = 200,		//满量程微调
	parameter HOUR_FULL_SCALE = 120,		//满量程微调
    parameter SD_FULL_PERIOD = 100,        //占空比微调
    parameter MIN_FULL_PERIOD = 200,        //占空比微调
    parameter HOUR_FULL_PERIOD = 120        //占空比微调
)
(
//	input       rtc_clk,      // 32728
    input       clk,        //50MHz

	output		sd_pwm,
	output 		min_pwm,
	output 		hour_pwm,

    input  [3:0]key,
    output [6:0]led,

	input wire 	uart_rx,
	output wire uart_tx,

	output wire i2c_sclk,
	inout 		i2c_sdat
);

//wire   sysclk;
//wire   clk;
wire 	rstn;
wire [3:0]	key_in;
wire locked;
reg [11:0] rst_cnt = 0;//上电后延迟复


//**********上电延迟复位***************************/

always@(posedge clk) begin
    if(!rst_cnt[8]) 
        rst_cnt <= rst_cnt + 1'b1;
end

assign rstn = rst_cnt[8];

//wire sh_cp;
//wire st_cp;
//wire ds;


wire [23:0] time_data; //time_data[23:16]-h, time_data[15:8]-min, time_data[7:0]}-second
wire [31:0] date_data;
//wire [31:0] disp_data;
//wire disp_data_sel = 1;
wire read_done;

//assign disp_data = disp_data_sel ? {time_data[23:16], 4'hf, time_data[15:8], 4'hf, time_data[7:0]} : {8'h20, date_data[31:8]};


uart_sd30xx_ctrl u_uart_sd30xx_ctrl(
    .clk(clk),
    .rstn(rstn),
    .uart_rx(uart_rx),
    .time_read(time_data),
    .date_read(date_data),
    .read_done(read_done),
    .i2c_sclk(i2c_sclk),
    .i2c_sdat(i2c_sdat)
);
//**********按键消抖***************************/
key #
(
   .CLK_FREQ (50000000)
)u_key0(
    .clk_i(clk),
    .key_i(key[0]),
    .key_cap(key_in[0])
);
key #
(
    .CLK_FREQ (50000000)
)u_key1(
    .clk_i(clk),
    .key_i(key[1]),
    .key_cap(key_in[1])
);
key #
(
    .CLK_FREQ (50000000)
)u_key2(
    .clk_i(clk),
    .key_i(key[2]),
    .key_cap(key_in[2])
);
key #
(
    .CLK_FREQ (50000000)
)u_key3(
    .clk_i(clk),
    .key_i(key[3]),
    .key_cap(key_in[3])
);

led 
#(
    .TIME_SET (32'd9_999_999)                        //分频时钟计数，初始时钟过快，人眼观察会导致LED常亮
)u_led                                                         //设置分频系数，降低流水灯的变化速度
(                                                        //该参数可以由上层调用时修改
    .CLK_i(clk),                                        //时钟输入
    .RSTn_i(rstn),                                      //全局复位
    .key_i(key_in),                               //按键输入
    .time_sec_data_i(time_data[7:0]),                             //second数据输入
    .time_min_data_i(time_data[15:8]),
    .LED_o(led)                                  //LED灯输出
);

/*
hex_top u_hex_top(
    .clk(clk),
    .rstn(rstn),
    .disp_data(disp_data),
    .sh_cp(sh_cp),
    .st_cp(st_cp),
    .ds(ds)
);

key_filter u_key_filter(
    .clk(clk),
    .rstn(rstn),
    .key_in(key_in),
    .key_flag(),
    .key_state(disp_data_sel)
);
*/
time_send_uart u_time_send_uart(
    .clk(clk),
    .rstn(rstn),
    .date_time_en(read_done),
    .time_data(time_data),
    .date_data(date_data),
    .uart_tx(uart_tx)
);


time_ctrl#(
    .SD_FREQ (SD_FREQ),
    .MIN_FREQ (MIN_FREQ),
    .HOUR_FREQ (HOUR_FREQ),
	.SYSCLKHZ 	(SYSCLKHZ), //系统时钟 hz
    //.Period     (Period),
	.SD_FULL_SCALE (SD_FULL_SCALE),		//满量程微调
	.MIN_FULL_SCALE (MIN_FULL_SCALE),		//满量程微调
	.HOUR_FULL_SCALE (HOUR_FULL_SCALE),		//满量程微调
    .SD_FULL_PERIOD (SD_FULL_PERIOD),        //占空比微调
    .MIN_FULL_PERIOD (MIN_FULL_PERIOD),        //占空比微调
    .HOUR_FULL_PERIOD (HOUR_FULL_PERIOD)        //占空比微调
)u_time_ctrl(
    .clk(clk),     //1 MHz
    .time_data(time_data),
    .Rst_n(rstn),
    .En(1'b1),
    .sd_pwm(sd_pwm),
	.min_pwm(min_pwm),
	.hour_pwm(hour_pwm)
);

endmodule