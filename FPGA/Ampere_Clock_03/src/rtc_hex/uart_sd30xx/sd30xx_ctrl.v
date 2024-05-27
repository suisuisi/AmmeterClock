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

/*******************************sd30xx_ctrl*********************
--1.sd30xx_ctrl
*********************************************************************/

`timescale 1ns / 1ns//仿真时间间隔/精度

module sd30xx_ctrl(
	input wire clk				,
	input wire rstn				,	
	input wire set_time			,
	input wire [23:0] time_2_set,
	input wire set_date			,
	input wire [31:0] date_2_set,
	input wire read				,
	output reg [23:0] time_read	,
	output reg [31:0] date_read	,
	output reg set_done			,
	output reg read_done		,
	output wire i2c_sclk		,
	inout i2c_sdat				
);




localparam PCF8563_Address_Control_Status_1 = 8'h0f;
localparam PCF8563_Address_Control_Status_2 = 8'h10;
localparam PCF8563_Address_CLKOUT           = 8'h0d;
localparam PCF8563_Address_Timer            = 8'h13;
localparam PCF8563_Address_Timer_VAL        = 8'h14;
localparam PCF8563_Address_Years            = 8'h06;
localparam PCF8563_Address_Months           = 8'h05;
localparam PCF8563_Address_Days             = 8'h04;
localparam PCF8563_Address_WeekDays         = 8'h03;
localparam PCF8563_Address_Hours            = 8'h02;
localparam PCF8563_Address_Minutes          = 8'h01;
localparam PCF8563_Address_Seconds          = 8'h00;
localparam PCF8563_Alarm_Minutes            = 8'h08;
localparam PCF8563_Alarm_Hours              = 8'h09;
localparam PCF8563_Alarm_Days               = 8'h0b;
localparam PCF8563_Alarm_WeekDays           = 8'h0a;

localparam
            IDLE          = 9'b000000001,
            SET_TIME      = 9'b000000010,
            TIME_SET_DONE = 9'b000000100,
            SET_DATE      = 9'b000001000,
            DATE_SET_DONE = 9'b000010000,
            READ          = 9'b000100000,
            READ_DONE     = 9'b001000000,
            INIT_RTC      = 9'b010000000,
            INIT_DONE     = 9'b100000000;

reg wr_req;
reg rd_req;
reg [7:0] addr;
reg [7:0] wr_data;
wire [7:0] rd_data;
wire rw_done;
reg [8:0] state;
reg [3:0] cnt;
reg init_state;
reg [7:0]  PCF8563_Address_Control_Status_1_reg,PCF8563_Address_Control_Status_2_reg;
i2c_control u_i2c_control(
    .clk(clk),
    .rstn(rstn),
    .wr_req(wr_req),
    .rd_req(rd_req),
    .addr({8'd0,addr}),
    .addr_mode(1'b0),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .device_id(8'b0110_0100),
    .rw_done(rw_done),
    .ack(),
    .i2c_sclk(i2c_sclk),
    .i2c_sdat(i2c_sdat)
);

task read_reg;
    input [7:0] reg_addr;
    begin
        rd_req <= 1'b1;
        addr <= reg_addr;
    end
endtask

task write_reg;
    input [7:0] reg_addr;
    input [7:0] reg_data;
    begin
        wr_req <= 1'b1;
        addr <= reg_addr;
        wr_data <= reg_data;
    end
endtask

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        state <= IDLE;
        cnt <= 4'd0;
        set_done <= 1'b0;
        read_done <= 1'b0;
        wr_req <= 1'b0;
        rd_req <= 1'b0;
        init_state <= 1'b0;
    end
    else begin
        case (state)
            IDLE:
                begin
                    set_done <= 1'b0;
                    read_done <= 1'b0;
                    wr_req <= 1'b0;
                    rd_req <= 1'b0;
                    cnt <= 4'd0;
                    if (!init_state) begin
                        state <= INIT_RTC;
                    end
                    else if (set_date) begin
                        state <= SET_DATE;
                    end
                    else if (set_time) begin
                        state <= SET_TIME;
                    end
                    else if (read) begin
                        state <= READ;
                    end
                    else begin
                        state <= IDLE;
                    end
                end

            INIT_RTC:
                begin
                    write_reg(PCF8563_Address_Control_Status_2, 8'hff);
                    state <= INIT_DONE;
                end

            INIT_DONE:
                begin
                    wr_req <= 1'b0;
                    if (rw_done) begin
                        state <= IDLE;
                        init_state <= 1'b1;
                    end
                    else begin
                        state <= INIT_DONE;
                    end
                end
            
            SET_TIME:
                begin
                    state <= TIME_SET_DONE;
                    case (cnt)
						4'd0:	write_reg(PCF8563_Address_Control_Status_2, 8'h84);
						4'd1:	write_reg(PCF8563_Address_Control_Status_1, 8'hff);
                        default:;
                    endcase
                end

            TIME_SET_DONE:
                begin
                    wr_req <= 1'b0;
                    if (rw_done) begin
                        if (cnt < 4'd1) begin
                            cnt <= cnt + 1'b1;
                            state <= SET_TIME;
                        end
                        else begin
                            cnt <= 4'd0;
                            state <= IDLE;
                            set_done <= 1'b1;
                        end
                    end
                    else begin
                        state <= TIME_SET_DONE;
                    end
                end
            
            SET_DATE:
                begin
                    state <= DATE_SET_DONE;
                    case (cnt)
                        4'd0:   write_reg(PCF8563_Address_Seconds, time_2_set[7:0]);
                        4'd1:   write_reg(PCF8563_Address_Minutes, time_2_set[15:8]);
                        4'd2:   write_reg(PCF8563_Address_Hours, {0,time_2_set[22:16]});//12H TYPE
                        4'd3:   write_reg(PCF8563_Address_WeekDays, date_2_set[7:0]);
                        4'd4:   write_reg(PCF8563_Address_Days, date_2_set[15:8]);
                        4'd5:   write_reg(PCF8563_Address_Months, date_2_set[23:16]);
                        4'd6:   write_reg(PCF8563_Address_Years,date_2_set[31:24]);
						4'd7:	write_reg(PCF8563_Address_Control_Status_1, 8'h7b);
						4'd8:	write_reg(PCF8563_Address_Control_Status_2, 8'h00);
                        default:;
                    endcase
                end

            DATE_SET_DONE:
                begin
                    wr_req <= 1'b0;
                    if (rw_done) begin
                        if (cnt < 4'd8) begin
                            cnt <= cnt + 1'b1;
                            state <= SET_DATE;
                        end
                        else begin
                            cnt <= 4'd0;
                            state <= IDLE;
                            set_done <= 1'b1;
                        end
                    end
                    else begin
                        state <= DATE_SET_DONE;
                    end
                end
            
            READ:
                begin
                    state <= READ_DONE;
                    case (cnt) 
                        4'd0:   read_reg(PCF8563_Address_WeekDays);
                        4'd1:   read_reg(PCF8563_Address_Days);
                        4'd2:   read_reg(PCF8563_Address_Months);
                        4'd3:   read_reg(PCF8563_Address_Years);
                        4'd4:   read_reg(PCF8563_Address_Seconds);
                        4'd5:   read_reg(PCF8563_Address_Minutes);
                        4'd6:   read_reg(PCF8563_Address_Hours);
                        4'd7:   read_reg(PCF8563_Address_Control_Status_1);
                        4'd8:   read_reg(PCF8563_Address_Control_Status_2);
                        default:;
                    endcase
                end
            
            READ_DONE:
                begin
                    rd_req <= 1'b0;
                    if (rw_done) begin
                        case (cnt) 
                            4'd0:   date_read[7:0] <= rd_data;
                            4'd1:   date_read[15:8] <= rd_data;
                            4'd2:   date_read[23:16] <= rd_data;
                            4'd3:   date_read[31:24] <= rd_data;
                            4'd4:   time_read[7:0] <= rd_data;
                            4'd5:   time_read[15:8] <= rd_data;
                            4'd6:   time_read[20:16] <= rd_data;
                            4'd7:   PCF8563_Address_Control_Status_1_reg <= rd_data;
                            4'd8:   PCF8563_Address_Control_Status_2_reg <= rd_data;
                            default:;
                        endcase
                        if (cnt <4'd8) begin
                            cnt <= cnt + 1'b1;
                            state <= READ;
                        end
                        else begin
                            read_done <= 1'b1;
                            cnt <= 4'd0;
                            state <= IDLE;
                        end
                    end
                    else begin
                        state <= READ_DONE;
                    end
                end
            default:;
        endcase
    end
end

endmodule