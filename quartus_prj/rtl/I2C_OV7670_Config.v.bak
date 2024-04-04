/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from .www.cnblogs.com/
(C) COPYRIGHT 2012 . ALL RIGHTS RESERVED
Filename			:		led_matrix_display.v
Author				:		
Data				:		2012-01-18
Version				:		1.0
Description			:		I2C Configure Data of OV7670.
Modification History	:
Data			By			Version			Change Description
===========================================================================
12/05/11			1.0				Original
--------------------------------------------------------------------------*/

`timescale 1ns/1ns
module	I2C_OV7670_Config
(
	input		[7:0]	LUT_INDEX,
	output	reg	[15:0]	LUT_DATA
);


parameter	Read_DATA	=	0;			//Read data LUT Address
parameter	SET_OV7670	=	2;			//SET_OV LUT Adderss
/////////////////////	Config Data LUT	  //////////////////////////	
always@(*)
begin
	case(LUT_INDEX)
	//Audio Config Data
	//Read Data Index
//	Read_DATA + 0 :		LUT_DATA	=	{8'h0A, 8'h76};	//PID	���̸�λʶ���� ��ֻ��� 
//	Read_DATA + 1 :		LUT_DATA	=	{8'h0B, 8'h73};	//VER	���̵�λʶ���� ��ֻ���
	Read_DATA + 0 :		LUT_DATA	=	{8'h1C, 8'h7F};	//MIDH	����ʶ���ֽ�-�ߣ�ֻ���
	Read_DATA + 1 :		LUT_DATA	=	{8'h1D, 8'hA2};	//MIDL	����ʶ���ֽ�-�ͣ�ֻ���
	//OV7670 : RAW8 25FPS 24M input
    SET_OV7670+'d0 :   LUT_DATA <=  'h1280;
    SET_OV7670+'d1 :   LUT_DATA <=  'h0000; 
    SET_OV7670+'d2 :   LUT_DATA <=  'h0000;     
    SET_OV7670+'d3 :   LUT_DATA <=  'h0000;     
    SET_OV7670+'d4 :   LUT_DATA <=  'h0000;        
    SET_OV7670+'d5 :   LUT_DATA <=  'h0000;     
    SET_OV7670+'d6 :   LUT_DATA <=  'h0000;     
    SET_OV7670+'d7 :   LUT_DATA <=  'h0000;     
    SET_OV7670+'d8 :   LUT_DATA <=  'h1101;     
    SET_OV7670+'d9 :   LUT_DATA <=  'h3a04; 
    SET_OV7670+'d10    :   LUT_DATA <=  'h1201;
    //windows setting
    SET_OV7670+'d11    :   LUT_DATA <=  'h1712;  //Hstart high 8bit
    SET_OV7670+'d12    :   LUT_DATA <=  'h1800;  //Hstop high 8bit
    SET_OV7670+'d13    :   LUT_DATA <=  'h1902;  //Vstart high 8bit
    SET_OV7670+'d14    :   LUT_DATA <=  'h1a7a;  //Vstop high 8bit
    SET_OV7670+'d15    :   LUT_DATA <=  'h32b6;  //HREF
    SET_OV7670+'d16    :   LUT_DATA <=  'h0300;  //VREF         
    SET_OV7670+'d17    :   LUT_DATA <=  'h0c00; 
    SET_OV7670+'d18    :   LUT_DATA <=  'h3e00; 
    SET_OV7670+'d19    :   LUT_DATA <=  'h703a; 
    SET_OV7670+'d20    :   LUT_DATA <=  'h7135;
    SET_OV7670+'d21    :   LUT_DATA <=  'h7211;
    SET_OV7670+'d22    :   LUT_DATA <=  'h73f0;
    SET_OV7670+'d23    :   LUT_DATA <=  'ha202; 
    SET_OV7670+'d24    :   LUT_DATA <=  'h13e0;
    SET_OV7670+'d25    :   LUT_DATA <=  'h0000;
    SET_OV7670+'d26    :   LUT_DATA <=  'h0d40;
    SET_OV7670+'d27    :   LUT_DATA <=  'h1438; 
    SET_OV7670+'d28    :   LUT_DATA <=  'ha507;
    SET_OV7670+'d29    :   LUT_DATA <=  'hab08;
    SET_OV7670+'d30    :   LUT_DATA <=  'h2495;
    SET_OV7670+'d31    :   LUT_DATA <=  'h2533; 
    SET_OV7670+'d32    :   LUT_DATA <=  'h26e3;
    SET_OV7670+'d33    :   LUT_DATA <=  'h9f78;
    SET_OV7670+'d34    :   LUT_DATA <=  'ha068;
    SET_OV7670+'d35    :   LUT_DATA <=  'ha10b;
    SET_OV7670+'d36    :   LUT_DATA <=  'ha6d8;
    SET_OV7670+'d37    :   LUT_DATA <=  'ha7d8;
    SET_OV7670+'d38    :   LUT_DATA <=  'ha8f0;
    SET_OV7670+'d39    :   LUT_DATA <=  'ha990; 
    SET_OV7670+'d40    :   LUT_DATA <=  'haa94;
    SET_OV7670+'d41    :   LUT_DATA <=  'h13e5; 
    SET_OV7670+'d42    :   LUT_DATA <=  'h0e61;
    SET_OV7670+'d43    :   LUT_DATA <=  'h0f4b; 
    SET_OV7670+'d44    :   LUT_DATA <=  'h1602;
    SET_OV7670+'d45    :   LUT_DATA <=  'h2102;
    SET_OV7670+'d46    :   LUT_DATA <=  'h2291;
    SET_OV7670+'d47    :   LUT_DATA <=  'h2907;
    SET_OV7670+'d48    :   LUT_DATA <=  'h3303;
    SET_OV7670+'d49    :   LUT_DATA <=  'h350b;
    SET_OV7670+'d50    :   LUT_DATA <=  'h371c;
    SET_OV7670+'d51    :   LUT_DATA <=  'h3871; 
    SET_OV7670+'d52    :   LUT_DATA <=  'h3c78;
    SET_OV7670+'d53    :   LUT_DATA <=  'h3d08;
    SET_OV7670+'d54    :   LUT_DATA <=  'h413a;
    SET_OV7670+'d55    :   LUT_DATA <=  'h4d40; 
    SET_OV7670+'d56    :   LUT_DATA <=  'h4e20;
    SET_OV7670+'d57    :   LUT_DATA <=  'h6955;
    SET_OV7670+'d58    :   LUT_DATA <=  'h6b4a;
    SET_OV7670+'d59    :   LUT_DATA <=  'h7419;
    SET_OV7670+'d60    :   LUT_DATA <=  'h7661;
    SET_OV7670+'d61    :   LUT_DATA <=  'h8d4f;
    SET_OV7670+'d62    :   LUT_DATA <=  'h8e00;
    SET_OV7670+'d63    :   LUT_DATA <=  'h8f00; 
    SET_OV7670+'d64    :   LUT_DATA <=  'h9000;
    SET_OV7670+'d65    :   LUT_DATA <=  'h9100;
    SET_OV7670+'d66    :   LUT_DATA <=  'h9600;
    SET_OV7670+'d67    :   LUT_DATA <=  'h9a80; 
    SET_OV7670+'d68    :   LUT_DATA <=  'hb08c;
    SET_OV7670+'d69    :   LUT_DATA <=  'hb10c;
    SET_OV7670+'d70    :   LUT_DATA <=  'hb20e;
    SET_OV7670+'d71    :   LUT_DATA <=  'hb382;
    SET_OV7670+'d72    :   LUT_DATA <=  'hb80a; 
    SET_OV7670+'d73    :   LUT_DATA <=  'h4314;
    SET_OV7670+'d74    :   LUT_DATA <=  'h44f0;
    SET_OV7670+'d75    :   LUT_DATA <=  'h4534; 
    SET_OV7670+'d76    :   LUT_DATA <=  'h4658;
    SET_OV7670+'d77    :   LUT_DATA <=  'h4728;
    SET_OV7670+'d78    :   LUT_DATA <=  'h483a;
    SET_OV7670+'d79    :   LUT_DATA <=  'h5988; 
    SET_OV7670+'d80    :   LUT_DATA <=  'h5a88;
    SET_OV7670+'d81    :   LUT_DATA <=  'h5b44;
    SET_OV7670+'d82    :   LUT_DATA <=  'h5c67;
    SET_OV7670+'d83    :   LUT_DATA <=  'h5d49;
    SET_OV7670+'d84    :   LUT_DATA <=  'h5e0e;
    SET_OV7670+'d85    :   LUT_DATA <=  'h6c0a;
    SET_OV7670+'d86    :   LUT_DATA <=  'h6d55;
    SET_OV7670+'d87    :   LUT_DATA <=  'h6e11; 
    SET_OV7670+'d88    :   LUT_DATA <=  'h6f9f;
    SET_OV7670+'d89    :   LUT_DATA <=  'h6a40;
    SET_OV7670+'d90    :   LUT_DATA <=  'h0140;
    SET_OV7670+'d91    :   LUT_DATA <=  'h0240; 
    SET_OV7670+'d92    :   LUT_DATA <=  'h13e7;
    SET_OV7670+'d93    :   LUT_DATA <=  'h3411;
    SET_OV7670+'d94    :   LUT_DATA <=  'h9266;
    SET_OV7670+'d95    :   LUT_DATA <=  'h3b0a;
    SET_OV7670+'d96    :   LUT_DATA <=  'ha488;
    SET_OV7670+'d97    :   LUT_DATA <=  'h9600;
    SET_OV7670+'d98    :   LUT_DATA <=  'h9730;
    SET_OV7670+'d99    :   LUT_DATA <=  'h9820; 
    SET_OV7670+'d100   :   LUT_DATA <=  'h9920;
    SET_OV7670+'d101   :   LUT_DATA <=  'h9a84;
    SET_OV7670+'d102   :   LUT_DATA <=  'h9b29;
    SET_OV7670+'d103   :   LUT_DATA <=  'h9c03; 
    SET_OV7670+'d104   :   LUT_DATA <=  'h9d4c;
    SET_OV7670+'d105   :   LUT_DATA <=  'h9e3f;
    SET_OV7670+'d106   :   LUT_DATA <=  'h7804;
    SET_OV7670+'d107   :   LUT_DATA <=  'h7901;  
    SET_OV7670+'d108   :   LUT_DATA <=  'hc8f0;
    SET_OV7670+'d109   :   LUT_DATA <=  'h790f;
    SET_OV7670+'d110   :   LUT_DATA <=  'hc820;
    SET_OV7670+'d111   :   LUT_DATA <=  'h7910;
    SET_OV7670+'d112   :   LUT_DATA <=  'hc87e;
    SET_OV7670+'d113   :   LUT_DATA <=  'h790b;
    SET_OV7670+'d114   :   LUT_DATA <=  'hc801; 
    SET_OV7670+'d115   :   LUT_DATA <=  'h790c;
    SET_OV7670+'d116   :   LUT_DATA <=  'hc807;
    SET_OV7670+'d117   :   LUT_DATA <=  'h790d;
    SET_OV7670+'d118   :   LUT_DATA <=  'hc820; 
    SET_OV7670+'d119   :   LUT_DATA <=  'h7902;
    SET_OV7670+'d120   :   LUT_DATA <=  'hc8c0;
    SET_OV7670+'d121   :   LUT_DATA <=  'h7903;
    SET_OV7670+'d122   :    LUT_DATA <=  'hc840;
    SET_OV7670+'d123   :   LUT_DATA <=  'h7905;
    SET_OV7670+'d124   :   LUT_DATA <=  'hc830;
    SET_OV7670+'d125   :    LUT_DATA <=  'h7926;
	default		 	 :	LUT_DATA	=	0;
	endcase
end

endmodule
