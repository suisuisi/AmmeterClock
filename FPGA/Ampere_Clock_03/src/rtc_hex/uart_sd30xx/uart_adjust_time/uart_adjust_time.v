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

/*******************************uart_sd30xx_ctrl*********************
--1.串口接收数据顶层
*********************************************************************/

`timescale 1ns / 1ns//仿真时间间隔/精度

module uart_adjust_time(
	input 	wire clk				,
	input 	wire rstn				,
	input 	wire uart_rx			,
	input 	wire set_done			,
	output 	wire set_time			,
	output 	wire set_date			,
	output 	wire [23:0] time_2_set	,
	output 	wire [31:0] date_2_set	
);



wire [7:0] uart_rx_data;
wire uart_data_valid;


uart_byte_rx u_uart_byte_rx(
    .clk(clk),
    .rstn(rstn),
    .uart_rx(uart_rx),
    .baud_set(3'd0),
    .data_byte(uart_rx_data),
    .rx_done(uart_data_valid)
);

/*
ila_disp_data ila_rx_bytes (
	.clk(clk), // input wire clk


	.probe0({set_done,set_time,uart_data_valid,uart_rx_data}), // input wire [31:0] probe0
	.probe1(time_2_set) // input wire [31:0] probe0
);
*/

adjust_time u_adjust_time(
    .clk(clk),
    .rstn(rstn),
    .uart_rx_data(uart_rx_data),
    .uart_data_valid(uart_data_valid),
    .set_done(set_done),
    .set_time(set_time),
    .set_date(set_date),
    .time_2_set(time_2_set),
    .date_2_set(date_2_set)
);

endmodule