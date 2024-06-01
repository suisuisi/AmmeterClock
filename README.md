# AmmeterClock
Using an ammeter and FPGA to create a clock

# 视频介绍（双击图片播放视频）

[![安培★表★“龙”时钟](https://github.com/suisuisi/AmmeterClock/blob/main/Doc/%E5%B0%81%E9%9D%A2.jpg)](https://www.bilibili.com/video/BV1hr421A7SL/?spm_id_from=333.999.0.0&vd_source=94a53952efb76af78a48919ff19ee645)

# 文件说明

- 3Dmodule

除了PCB文件不用打印，其他需要打印。

- Binaries

Ampere_Clock.fs - 是FPGA的源程序，直接下载即可（Gowin IDE下载，无需license）。

uart2time.exe - 时钟校准上位机，需要下载《MATLAB_Runtime_R2023a_Update_6_win64.zip》。

官网免费下载。

- FPGA

FPGA工程源码。

# PCB

- FPGA主控板

>  https://oshwhub.com/openfpga/ampere_clock_copy

- 18650背板

>  https://oshwhub.com/openfpga/18650_power_charge

# 注意

- GoWin下载器可以使用之前发布的JTAG<https://github.com/suisuisi/jtag>，使用FTPROG将EEPROM内容删除即可下载GoWin FPGA。

- 表盘的改造，可以使用3D打印，或者使用“涂改带”将目前表盘上字体涂改掉，然后手写上新的刻度也可。

- 其他未尽事宜，欢迎提ISSUES
