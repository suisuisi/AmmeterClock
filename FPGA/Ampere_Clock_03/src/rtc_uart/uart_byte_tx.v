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

/*******************************uart_byte_tx*********************
--1.uart_byte_tx底层模块
*********************************************************************/

`timescale 1ns / 1ns//仿真时间间隔/精度

module uart_byte_tx(
	input wire clk				,
	input wire rstn				,
	input wire send_en			,
	input wire [7:0] data		,
	input wire [2:0] baud_set	,
	output reg uart_tx			,
	output reg tx_done			,
	output reg uart_state		
);


parameter START_BIT = 0;
parameter STOP_BIT = 1;

//bps_clk gen;
reg [15:0] bps_dr;
reg [15:0] div_cnt;
reg bps_clk;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        bps_dr <= 16'd5207;
    end
    else begin
        case (baud_set) 
            'd0:        bps_dr <= 16'd5207;                 //9600;
            'd1:        bps_dr <= 16'd2603;                 //19200;
            'd2:        bps_dr <= 16'd1301;                 //38400;
            'd3:        bps_dr <= 16'd867;                  //57600;
            'd4:        bps_dr <= 16'd433;                  //115200;
            default:    bps_dr <= 16'd5207;                 //9600;
        endcase
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        div_cnt <= 16'd0;
    end
    else if (uart_state) begin
        if (div_cnt == bps_dr) begin
            div_cnt <= 16'd0;
        end
        else begin
            div_cnt <= div_cnt + 1'b1;
        end
    end
    else begin
        div_cnt <= 16'd0;
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        bps_clk <= 1'b0;
    end
    else if (div_cnt == 16'd1) begin
        bps_clk <= 1'b1;
    end
    else begin
        bps_clk <= 1'b0;
    end
end

//bps_cnt;
reg [3:0] bps_cnt;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
         bps_cnt <= 4'd0;
    end
    else if (bps_cnt == 4'd11) begin
        bps_cnt <= 4'd0;
    end
    else if (bps_clk) begin
        bps_cnt <= bps_cnt + 1'b1;
    end
    else begin
        bps_cnt <= bps_cnt;
    end
end

//tx_done;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        tx_done <= 1'b0;
    end
    else if (bps_cnt == 4'd11) begin
        tx_done <= 1'b1;
    end
    else begin
        tx_done <= 1'b0;
    end
end

//uart_state;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        uart_state <= 1'b0;
    end
    else if (send_en) begin
        uart_state <= 1'b1;
    end
    else if (bps_cnt == 4'd11) begin
        uart_state <= 1'b0;
    end
    else begin
        uart_state <= uart_state;
    end
end

//data_reg;
reg [7:0] data_reg;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        data_reg <= 8'd0;
    end
    else if (send_en) begin
        data_reg <= data;
    end
    else begin
        data_reg <= data_reg;
    end
end

//uart_tx;
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        uart_tx <= 1'b1;
    end
    else begin
        case (bps_cnt) 
            'd0:        uart_tx <= 1'b1;
            'd1:        uart_tx <= START_BIT;
            'd2:        uart_tx <= data_reg[0];
            'd3:        uart_tx <= data_reg[1];
            'd4:        uart_tx <= data_reg[2];
            'd5:        uart_tx <= data_reg[3];
            'd6:        uart_tx <= data_reg[4];
            'd7:        uart_tx <= data_reg[5];
            'd8:        uart_tx <= data_reg[6];
            'd9:        uart_tx <= data_reg[7];
            'd10:       uart_tx <= STOP_BIT;
            default:    uart_tx <= 1'b1;
    endcase
    end
end

endmodule