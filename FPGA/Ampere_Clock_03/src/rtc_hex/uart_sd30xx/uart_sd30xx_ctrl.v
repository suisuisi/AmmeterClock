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
--1.串口和I2C读取顶层
*********************************************************************/

`timescale 1ns / 1ns//仿真时间间隔/精度

module uart_sd30xx_ctrl(
	input 	wire clk				,	
	input 	wire rstn				,
	input 	wire uart_rx			,
	output 	wire [23:0] time_read	,
	output 	wire [31:0] date_read	,
	output 	wire read_done			,
	output 	wire i2c_sclk			,
	inout 		 i2c_sdat					
);


//time adjust module;
wire set_done;
wire set_time;
wire set_date;
wire [23:0] time_2_set;
wire [31:0] date_2_set;

uart_adjust_time u_uart_adjust_time(
    .clk(clk),
    .rstn(rstn),
    .uart_rx(uart_rx),
    .set_done(set_done),
    .set_time(set_time),
    .set_date(set_date),
    .time_2_set(time_2_set),
    .date_2_set(date_2_set)
);

//read time counter;
reg [23:0] read_cnt;
wire read;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        read_cnt <= 1'b0;
    end
    else if (read_cnt == 24'd14_999_999) begin
        read_cnt <= 1'b0;
    end
    else begin
        read_cnt <= read_cnt + 1'b1;
    end
end

assign read = (read_cnt == 24'd14_999_999);

//inst pcf8563_ctrl;
sd30xx_ctrl u_sd30xx_ctrl(
    .clk(clk),
    .rstn(rstn),
    .set_time(set_time),
    .time_2_set(time_2_set),
    .set_date(set_date),
    .date_2_set(date_2_set),
    .read(read),
    .time_read(time_read),
    .date_read(date_read),
    .set_done(set_done),
    .read_done(read_done),
    .i2c_sclk(i2c_sclk),
    .i2c_sdat(i2c_sdat)
);

endmodule