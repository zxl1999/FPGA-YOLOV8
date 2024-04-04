
module  eth_udp
#(
    parameter   BOARD_MAC   = 48'hFF_FF_FF_FF_FF_FF ,   //板卡MAC地址
    parameter   BOARD_IP    = 32'hFF_FF_FF_FF       ,   //板卡IP地址
    parameter   BOARD_PORT  = 16'd32768             ,   //板卡端口号
    parameter   PC_MAC      = 48'hFF_FF_FF_FF_FF_FF ,   //PC机MAC地址
    parameter   PC_IP       = 32'hFF_FF_FF_FF       ,   //PC机IP地址
    parameter   PC_PORT     = 16'd32768                 //PC机端口号
)
(
    input   wire            rst_n           ,   //复位信号,低电平有效
    input   wire            eth_tx_clk      ,   //mii时钟,发送
    input   wire            send_en         ,   //开始发送信号
    input   wire    [31:0]  send_data       ,   //发送数据
    input   wire    [15:0]  send_data_num   ,   //发送有效数据字节数

    output  wire            send_end        ,   //单包数据发送完成信号
    output  wire            read_data_req   ,   //读数据请求信号
    output  wire            eth_tx_en       ,   //输出数据有效信号(mii)
    output  wire    [3:0]   eth_tx_data         //输出数据(mii)
);

//wire define
wire            crc_en  ;   //CRC校验开始标志信号
wire            crc_clr ;   //CRC数据复位信号
wire    [31:0]  crc_data;   //CRC校验数据
wire    [31:0]  crc_next;   //CRC下次校验完成数据

//------------ ip_send_inst -------------
ip_send
#(
    .BOARD_MAC      (BOARD_MAC      ),  //板卡MAC地址
    .BOARD_IP       (BOARD_IP       ),  //板卡IP地址
    .BOARD_PORT     (BOARD_PORT     ),  //板卡端口号
    .PC_MAC         (PC_MAC         ),  //PC机MAC地址
    .PC_IP          (PC_IP          ),  //PC机IP地址
    .PC_PORT        (PC_PORT        )   //PC机端口号
)
ip_send_inst
(
    .clk            (eth_tx_clk     ),  //时钟信号
    .rst_n          (rst_n          ),  //复位信号,低电平有效
    .send_en        (send_en        ),  //数据发送开始信号
    .send_data      (send_data      ),  //发送数据
    .send_data_num  (send_data_num  ),  //发送数据有效字节数
    .crc_data       (crc_data       ),  //CRC校验数据
    .crc_next       (crc_next[31:28]),  //CRC下次校验完成数据

    .send_end       (send_end       ),  //单包数据发送完成标志信号
    .read_data_req  (read_data_req  ),  //读FIFO使能信号
    .eth_tx_en      (eth_tx_en      ),  //输出数据有效信号
    .eth_tx_data    (eth_tx_data    ),  //输出数据
    .crc_en         (crc_en         ),  //CRC开始校验使能
    .crc_clr        (crc_clr        )   //crc复位信号
);

//------------ crc32_inst -------------
crc32    crc32_inst
(
    .clk            (eth_tx_clk     ),  //时钟信号
    .rst_n          (rst_n          ),  //复位信号,低电平有效
    .data           (eth_tx_data    ),  //待校验数据
    .crc_en         (crc_en         ),  //crc使能,校验开始标志
    .crc_clr        (crc_clr        ),  //crc数据复位信号

    .crc_data       (crc_data       ),  //CRC校验数据
    .crc_next       (crc_next       )   //CRC下次校验完成数据
);

endmodule
