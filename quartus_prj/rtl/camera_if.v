//file name			: camera_if.v
//data				: 2015.11.22
//author				: ETree
//function			: camera interface 
//log					:

module camera_if #(
	parameter IMG_H = 640
)
(
	//global signal
	input clk,
	input rst_n,
	
	//camera port	
	output cam_scl,
	inout  cam_sda,
	input [7:0] cam_data,
	input cam_vsync,	
	input cam_hsync,
	input cam_pclk,
	output cam_xclk,
	output cam_pdown,
	output cam_reset,
	
	//host port
	output [7:0] cam_data_out,
	output cam_vsync_out,
	output cam_hsync_out,
	output cam_vsync_neg,
	
	output [15:0] line_count,
	output Config_Done,
	input cam_en
);

reg [7:0] cam_data_r0;
reg [7:0] cam_data_r1;
reg [4:0] cam_hsync_r;
reg [4:0] cam_vsync_r;

reg [15:0] v_cnt;
reg [15:0] h_cnt;

reg [3:0] f_cnt;

wire  init_done;
wire	i2c_exc;
wire	i2c_done;
wire	[7:0]	i2c_addr;
wire	[7:0]	i2c_data_w;
wire	[7:0]	i2c_data_r;

wire	scl_wr;
wire	sda_wr;
wire	sda_dir;


always @(posedge cam_pclk)
begin
	cam_data_r0 <= cam_data;
	cam_data_r1 <= (v_cnt==0)?0:(cam_data_r0==0)?8'h1:cam_data_r0;
end

always @(posedge cam_pclk)
begin
	cam_hsync_r <= (f_cnt==4'hf)?{cam_hsync_r[3:0],cam_hsync}:0;
	cam_vsync_r <= {cam_vsync_r[3:0],cam_vsync};
end


always @(posedge cam_pclk)
	if(cam_hsync_r[0])
		h_cnt <= h_cnt + 1'b1;
	else
		h_cnt <= 0;

always @(posedge cam_pclk)
	if(cam_vsync_r[0])
		v_cnt <= 0;
	else if(h_cnt==(IMG_H-1))
		v_cnt <= v_cnt + 1'b1;
	else
		v_cnt <= v_cnt;

assign line_count = v_cnt;		
		
wire cam_hsync_pos = (cam_hsync_r[3:2]==2'b01);
wire cam_vsync_pos = (cam_vsync_r[1:0]==2'b01);
assign cam_vsync_neg = (cam_vsync_r[1:0]==2'b10);

always @(posedge cam_pclk)
	if(cam_vsync_neg)
		if(f_cnt<'hf)
			f_cnt <= f_cnt + 1'b1;
		else
			f_cnt <= f_cnt;

assign cam_data_out = cam_data_r1;
assign cam_vsync_out = cam_vsync_r[1];
assign cam_hsync_out = cam_hsync_r[1];

assign	cam_reset = rst_n;		//cmos work state(5ms delay for sccb config)
assign   cam_pdown = 0;		//cmos power on	
assign	cam_xclk = clk;		//25MHz XCLK

		
//wire		Config_Done;		
	
I2C_AV_Config	u_I2C_AV_Config 
(
	//Global clock
	.iCLK		(clk),		//25MHz
	.iRST_N		(rst_n),	//Global Reset
	
	//I2C Side
	.I2C_SCLK	(cam_scl),		//I2C CLOCK
	.I2C_SDAT	(cam_sda),		//I2C DATA
	
	//CMOS Signal
	.Config_Done(Config_Done),
	.I2C_RDATA	( ),	//CMOS ID
	.LUT_INDEX	( )
);
		

endmodule
