module led 
#(
    parameter TIME_SET = 32'd99_999_999                        //分频时钟计数，初始时钟过快，人眼观察会导致LED常亮
)                                                         //设置分频系数，降低流水灯的变化速度
(                                                        //该参数可以由上层调用时修改
    input CLK_i,                                        //时钟输入
    input RSTn_i,                                      //全局复位
    input [3:0] key_i,                               //按键输入
    input [7:0] time_sec_data_i,                      //second数据输入
    input [7:0] time_min_data_i,                      //minute数据输入
    output reg[6:0] LED_o                                  //LED灯输出
);

reg [1:0] LED_o_d;
reg [7:0] time_sec_data_d,time_smin_data_d;
reg data_sec_changed,data_min_changed;
reg [1:0] led_start;
reg [4:0]LED_o_r;   
reg [31:0]tcnt;
reg [3:0] key_d;
wire flag_down;

always @ (posedge CLK_i) begin
    if (!RSTn_i) begin
        time_sec_data_d <= 8'h00; // 在复位时将之前的数据清零
        data_sec_changed <= 1'b0;
    end else begin
        if (time_sec_data_i != time_sec_data_d) begin
            data_sec_changed <= 1'b1; // 当数据变化时，输出变化标志
        end else begin
            data_sec_changed <= 1'b0; // 否则，输出变化标志为0
        end
        time_sec_data_d <= time_sec_data_i; // 更新之前的数据
    end
end

always @ (posedge CLK_i) begin
    if (!RSTn_i) begin
        time_smin_data_d <= 8'h00; // 在复位时将之前的数据清零
        data_min_changed <= 1'b0;
    end else begin
        if (time_min_data_i != time_smin_data_d) begin
            data_min_changed <= 1'b1; // 当数据变化时，输出变化标志
        end else begin
            data_min_changed <= 1'b0; // 否则，输出变化标志为0
        end
        time_smin_data_d <= time_min_data_i; // 更新之前的数据
    end
end

always @ (posedge CLK_i)
    if(!RSTn_i)begin
        LED_o_d[0] <= 1'b1;
    end
    else if (data_sec_changed == 1'b1) begin
        LED_o_d[0] <= ~LED_o_d[0];
    end 

always @ (posedge CLK_i)
    if(!RSTn_i)begin
        LED_o_d[1] <= 1'b1;
    end
    else if (data_min_changed == 1'b1) begin
        LED_o_d[1] <= ~LED_o_d[1];
    end 

assign {LED_o[4],LED_o[1]} = LED_o_d;


always @ (posedge CLK_i)
    if(!RSTn_i)begin
        led_start <= 1'b0;
    end
    else if ((key_i[0] == 1'b1) | (key_i[1] == 1'b1) | (key_i[2] == 1'b1) | (key_i[3] == 1'b1) ) begin 
        led_start <= ~led_start;//1'b1;
    end else begin
        led_start <= led_start;
    end

always@(posedge CLK_i)
    if(!RSTn_i)
        tcnt <= 0;
    else if(tcnt == TIME_SET) //500us
        tcnt <= 0;
    else
        tcnt <= tcnt + 1'd1;
        
    always@(posedge CLK_i)
    if(!RSTn_i)
        LED_o_r <= 5'b0_0001;
    else if(tcnt == TIME_SET)
        LED_o_r <= {LED_o_r[3:0],LED_o_r[4]};    //位拼接
    else
        LED_o_r <= LED_o_r;

assign {LED_o[6],LED_o[5],LED_o[3],LED_o[2],LED_o[0]}= led_start ? LED_o_r : 5'b1_1111;                              //将寄存器内信号翻转输出

endmodule