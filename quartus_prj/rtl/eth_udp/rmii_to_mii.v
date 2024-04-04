
module  rmii_to_mii
(
    input               eth_rmii_clk,   //rmii时钟
    input               eth_mii_clk ,   //mii时钟
    input               rst_n       ,   //复位信号
    input               rx_dv       ,   //输入数据有效信号(rmii)
    input       [1:0]   rx_data     ,   //输入数据(rmii)

    output reg          eth_rx_dv   ,   //输入数据有效信号(mii)
    output reg [3:0]    eth_rx_data     //输入数据(mii)
);

reg             rx_dv_reg       ;   //输入数据有效信号寄存(rmii)
reg     [1:0]   rx_data_reg     ;   //输入数据寄存(rmii)
reg             rx_dv_reg1      ;   //rx_dv_reg寄存
reg             rx_dv_reg2      ;   //rx_dv_reg1寄存
reg             rx_dv_ture      ;   //真实的输入数据有效信号
reg             rx_dv_ture_reg  ;   //真实的输入数据有效信号打拍
reg     [1:0]   rx_data_reg1    ;   //rx_data_reg寄存
reg     [1:0]   rx_data_ture    ;   //有效的输入数据
reg             data_sw_en      ;   //数据拼接使能
reg     [3:0]   data            ;   //拼接后的数据


//rx_dv:输入数据有效信号寄存(rmii)
always @(posedge eth_rmii_clk or negedge rst_n)
    if(~rst_n)
        rx_dv_reg   <=  1'b0;
    else
        rx_dv_reg   <=  rx_dv;

//rx_data_reg:输入数据寄存(rmii)
always @(posedge eth_rmii_clk or negedge rst_n)
    if(~rst_n)
        rx_data_reg <=  2'b0;
    else
        rx_data_reg <=  rx_data;

//rx_dv_reg1:rx_dv_reg寄存
always @(negedge eth_rmii_clk or negedge rst_n)
    if(~rst_n)
        rx_dv_reg1  <=  1'b0;
    else    if(rx_dv_reg == 1'b1)
        if(rx_data_reg == 2'b1)
            rx_dv_reg1  <=  1'b1;
        else
            rx_dv_reg1  <=  rx_dv_reg1;
    else
        rx_dv_reg1  <=  1'b0;

//rx_dv_reg2:rx_dv_reg1寄存
always @(negedge eth_rmii_clk or negedge rst_n)
    if(~rst_n)
        rx_dv_reg2  <=  1'b0;
    else
        rx_dv_reg2  <=  rx_dv_reg;

//rx_dv_ture:真实的输入数据有效信号
always @(negedge eth_rmii_clk or negedge rst_n)
    if(~rst_n)
        rx_dv_ture  <=  1'b0;
    else    if((rx_dv_reg1) && (rx_dv_reg2))
        rx_dv_ture  <=  1'b1;
    else
        rx_dv_ture  <=  1'b0;

//rx_data_reg1:rx_data_reg寄存
always @(negedge eth_rmii_clk or negedge rst_n)
    if(~rst_n)
        rx_data_reg1    <=  2'b0;
    else
        rx_data_reg1    <=  rx_data_reg;

//rx_data_ture:有效的输入数据
always @(negedge eth_rmii_clk or negedge rst_n)
    if(~rst_n)
        rx_data_ture    <=  2'b0;
    else
        rx_data_ture    <=  rx_data_reg1;

//data_sw_en:数据拼接使能
always @(negedge eth_rmii_clk or negedge rst_n)
    if(~rst_n)
        data_sw_en  <=  1'b0;
    else    if(rx_dv_ture == 1'b1)
        data_sw_en  <=  ~data_sw_en;
    else
        data_sw_en  <=  1'b0;

//data:拼接后的数据
always @(posedge eth_rmii_clk or negedge rst_n)
    if(~rst_n)
        data    <=  4'b0;
    else    if((rx_dv_ture == 1'b1) && (data_sw_en == 1'b0))
        data    <=  {rx_data_reg1,rx_data_ture};
    else
        data    <=  data;

//rx_dv_ture_reg:真实的输入数据有效信号打一拍
always @(posedge eth_rmii_clk or negedge rst_n)
    if(~rst_n)
        rx_dv_ture_reg  <=  1'b0;
    else
        rx_dv_ture_reg  <=  rx_dv_ture;


//eth_rx_dv:输入数据有效信号(mii)
always @(negedge eth_mii_clk or negedge rst_n)
    if(~rst_n)
        eth_rx_dv   <=  1'b0;
    else
        eth_rx_dv   <=  rx_dv_ture_reg;

//eth_rx_data:输入数据(mii)
always @(negedge eth_mii_clk or negedge rst_n)
    if(~rst_n)
        eth_rx_data <=  4'b0;
    else
        eth_rx_data <=  data;

endmodule
