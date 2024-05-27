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
--1.//This is a sample program of the PWM driver.
*********************************************************************/
/*
`timescale 1ns / 1ns//仿真时间间隔/精度


module Driver_PWM#
(
	parameter SYSCLKHZ = 1000_0000, //系统时钟 hz
	parameter Freq		= 100,
	parameter FULL_SCALE = 100,		//满量程微调
	parameter FULL_PERIOD = 167,		//占空比微调
    parameter Period=SYSCLKHZ/Freq
)(
    input clk,
    //input [31:0]Freq,
    input [7:0]Duty,
    input Rst_n,
    input En,
    output reg PWM
);
    //reg [31:0]Period=0;     //PWM period
    reg [27:0]Period_Cnt=0; //PWM cycle count
    reg [31:0]Duty_Num=0;   //Number of duty cycles
    

    //Calculated cycle
    always @ (*)
        begin        
            if(Duty<FULL_SCALE)
                Duty_Num=Duty*561798;
//Period;///FULL_PERIOD;
            else
                Duty_Num=Period;
        end
    
    //Cycle frequency division
    always@(posedge clk or negedge Rst_n)
        begin
            if(!Rst_n)
                Period_Cnt<=0;
            else
                begin
                    if(Period_Cnt<Period-1)
                        Period_Cnt<=Period_Cnt+1;
                    else
                        Period_Cnt<=0;
                end
        end
    
    //Generate PWM
    always @ (posedge clk or negedge Rst_n)
        begin
            if(!Rst_n)
                PWM<=0;
            else
                begin
                    //If enabled, duty cycle adjustment
                    if(En)
                        begin
                            if(Period_Cnt<Duty_Num)
                                PWM<=1;
                            else
                                PWM<=0;
                        end
                    else
                        PWM<=0;
                end
        end  



endmodule
*/
`timescale 1ns / 1ps
module pwm
#(
	parameter N = 32 //pwm bit width 
)
(
    input         clk,
    input         Rst_n,
	input [7:0]	  PWM_in,
/*     input[N - 1:0]period,
    input[N - 1:0]Duty, */
    output        PWM 
    );
 
/* reg[N - 1:0] period_r;
reg[N - 1:0] duty_r;
reg[N - 1:0] period_cnt;
reg pwm_r;
assign PWM = pwm_r;
/* Data buffer for period and duty  
always@(posedge clk or posedge Rst_n)
begin
    if(Rst_n==0)
    begin
        period_r <= { N {1'b0} };
        duty_r <= { N {1'b0} };
    end
    else
    begin
        period_r <= period;
        duty_r   <= Duty;
    end
end
/* period counter, add with period value every clock edge  
always@(posedge clk or posedge Rst_n)
begin
    if(Rst_n==0)
        period_cnt <= { N {1'b0} };
    else
        period_cnt <= period_cnt + period_r;
end

always@(posedge clk or posedge Rst_n)
begin
    if(Rst_n==0)
    begin
        pwm_r <= 1'b0;
    end
    else
    begin
        if(period_cnt >= duty_r)   /* When period counter exceed duty value, pwm output 1 
            pwm_r <= 1'b1;
        else
            pwm_r <= 1'b0;
    end
end */

reg [8:0] pwm_accumulator;
always@(posedge clk)
	pwm_accumulator <= pwm_accumulator[7:0] + PWM_in;
	
assign PWM = pwm_accumulator[8];
endmodule