//file name:	top_fpga.v
//author:		ETree
//date:			2017.10.1
//function:		top file of project
//log:

module top_fpga(
	//global signal                           
	input  clk,
	input  rst_n,

	//CMOS Port
	output cam_scl,
	inout  cam_sda,
	input [7:0] cam_data,
	
	input cam_vsync,	
	input cam_hsync,
	input cam_pclk,
	output cam_xclk,

	output cam_pdown,
	output cam_reset,	
	
	
	//NET
	output e_txen,
	output [1:0] e_tx,

	input e_rxer,
	input e_rxdv,
	input e_rxclk,
	input [1:0] e_rx,
	
	//LED
	output led
	
);

reg [5:0] reset_init = 6'b0 /* synthesis syn_preserve = 1*/;

wire init = reset_init[5];

always @ (posedge clk) 
	if (!init) 
		reset_init <= reset_init + 1'b1;
	else;


wire locked;
wire clk_cmos;
	
alt_pll alt_pll_inst(
	.inclk0(clk),
	.areset(~init),
	.c0(clk_cmos),
	.locked(locked)
	);	
	
wire sys_rstn;
assign sys_rstn = locked;	
	
//---------------CMOS--------------------
wire [7:0] cam_data_out;
wire cam_vsync_out;
wire cam_hsync_out;
wire cam_vsync_neg;

camera_if camera_if_inst
(
	.clk(clk_cmos) ,	// input  clk_sig
	.rst_n(sys_rstn) ,	// input  rst_n_sig
	.cam_scl(cam_scl) ,	// output  cam_scl_sig
	.cam_sda(cam_sda) ,	// inout  cam_sda_sig
	
	.cam_data(cam_data) ,	// input [7:0] cam_data_sig
	
	.cam_vsync(cam_vsync) ,	// input  cam_vsync_sig
	.cam_hsync(cam_hsync) ,	// input  cam_hsync_sig
	.cam_pclk(cam_pclk) ,	// input  cam_pclk_sig
	.cam_xclk(cam_xclk) ,	// output  cam_xclk_sig
	
	.cam_pdown(cam_pdown) ,	// output  cam_pdown_sig
	.cam_reset(cam_reset) ,	// output  cam_reset_sig
	
	.cam_data_out(cam_data_out),
	.cam_vsync_out(cam_vsync_out),
	.cam_hsync_out(cam_hsync_out),
	
	.cam_vsync_neg(cam_vsync_neg),
	
	.line_count(line_count),
	.Config_Done(Config_Done),
	.cam_en(1'b1)	// input  cam_en_sig
);	

defparam camera_if_inst.IMG_H = 640;		
		
//-------------CMOS FIFO-----------------
wire [9 : 0] fifo_data_count;
wire [31:0] fifo_q;
wire fifo_full;
wire fifo_empty;


cmos1_fifo cmos1_fifo_inst (
  .aclr                     (cam_vsync_neg),   // input rst
  .wrclk                    (cam_pclk),                   // input wr_clk
  .data                     (cam_data_out),                   // input [7 : 0] din
  .wrreq                    (cam_hsync_out),                    // input wr_en
  
  .rdclk                    (clk_25m),                         // input rd_clk
  .rdreq                    (read_data_req),                    // input rd_en
  .q                        (fifo_q),                     // output [7 : 0] dout
  .wrfull                   (fifo_full),                     // output full
  .rdempty                  (fifo_empty),                    // output empty
  .rdusedw                  (fifo_data_count),               // output [10 : 0] rd_data_count
  .wrusedw                  ()
);
		
//-----------ETHernet-------------

//parameter define
parameter   BOARD_MAC   = 48'h03_08_35_01_AE_C2 ;   //板卡MAC地址
parameter   BOARD_IP    = 32'hC0_A8_03_02       ;   //板卡IP地址
parameter   BOARD_PORT  = 16'd32768             ;   //板卡端口号
parameter   PC_MAC      = 48'hFF_FF_FF_FF_FF_FF ;   //PC机MAC地址
parameter   PC_IP       = 32'hC0_A8_03_03       ;   //PC机IP地址
parameter   PC_PORT     = 16'd32768             ;   //PC机端口号

//wire define
wire            send_end        ;   //发送完成信号
wire            read_data_req   ;   //读数据请求信号
wire            send_en         ;   //数据开始发送信号
wire   [31:0]   send_data       ;   //发送数据
wire            eth_tx_en       ;   //输出数据有效信号(mii)
wire    [3:0]   eth_tx_data     ;   //输出数据(mii)

//reg   define
reg             clk_25m         ;   //mii时钟
	
//clk_25m:mii时钟
always @(negedge e_rxclk or negedge sys_rstn)
    if(~sys_rstn)
        clk_25m <=  1'b0;
    else
        clk_25m <= ~clk_25m;
		  
//------------- eth_udp_inst -------------
wire send_start = (fifo_data_count>='d320);

assign send_data = {fifo_q[7:0],fifo_q[15:8],fifo_q[23:16],fifo_q[31:24]};





eth_udp
#(
    .BOARD_MAC      (BOARD_MAC      ),  //板卡MAC地址
    .BOARD_IP       (BOARD_IP       ),  //板卡IP地址
    .BOARD_PORT     (BOARD_PORT     ),  //板卡端口号
    .PC_MAC         (PC_MAC         ),  //PC机MAC地址
    .PC_IP          (PC_IP          ),  //PC机IP地址
    .PC_PORT        (PC_PORT        )   //PC机端口号
)
eth_udp_inst
(
    .rst_n          (sys_rstn       ),  //复位信号,低电平有效
    .eth_tx_clk     (clk_25m        ),  //mii时钟,发送
    .send_en        (send_start     ),  //开始发送信号
    //.send_data      (select_conv_data ? send_data_conv : send_data),  //发送数据
	 .send_data      (send_data ),
    .send_data_num  ('d1280         ),  //发送有效数据字节数

    .send_end       (send_end       ),  //单包数据发送完成信号
    .read_data_req  (read_data_req  ),  //读数据请求信号
    .eth_tx_en      (eth_tx_en      ),  //输出数据有效信号(mii)
    .eth_tx_data    (eth_tx_data    )   //输出数据(mii)
);		  
		  
//------------- mii_to_rmii_inst -------------
mii_to_rmii mii_to_rmii_inst
(
    .eth_mii_clk    (clk_25m        ),  //mii时钟
    .eth_rmii_clk   (e_rxclk        ),  //rmii时钟
    .rst_n          (sys_rstn       ),  //复位信号
    .tx_dv          (eth_tx_en      ),  //输出数据有效信号(mii)
    .tx_data        (eth_tx_data    ),  //输出有效数据(mii)

    .eth_tx_dv      (e_txen         ),  //输出数据有效信号(rmii)
    .eth_tx_data    (e_tx           )   //输出数据(rmii)
);


//LED 使能控制

reg  led_r;
reg  [24:0] timer;
		
assign led = led_r;

always @(posedge clk)
	if(~sys_rstn)
		timer <= 0;
	else
		timer <= timer + 1'b1; //计数器加 1

//LED控制
always @(posedge clk)
		 if (timer == 0)
			  led_r <= ~led_r; //LED
		 else;
		 


endmodule


