
module  crc32
(
    input   wire            clk         ,   //时钟信号
    input   wire            rst_n       ,   //复位信号,低电平有效
    input   wire    [3:0]   data        ,   //待校验数据
    input   wire            crc_en      ,   //crc使能,校验开始标志
    input   wire            crc_clr     ,   //crc数据复位信号

    output  reg     [31:0]  crc_data    ,   //CRC校验数据
    output  reg     [31:0]  crc_next        //CRC下次校验完成数据
);

// wire     define
wire    [3:0]   data_sw;    //待校验数据高低位互换

//data_sw:待校验数据高低位互换
assign  data_sw = {data[0],data[1],data[2],data[3]};

//crc_next:CRC下次校验完成数据
//CRC32的生成多项式为：G(x)= x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11
//+ x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
always@(*)
begin
    crc_next    <=  32'b0;
    if(crc_en == 1'b1)
        begin
            crc_next[0] <=  (data_sw[0] ^ crc_data[28]);
            crc_next[1] <=  (data_sw[1] ^ data_sw[0] ^ crc_data[28]
                            ^ crc_data[29]);
            crc_next[2] <=  (data_sw[2] ^ data_sw[1] ^ data_sw[0]
                            ^ crc_data[28] ^ crc_data[29] ^ crc_data[30]);
            crc_next[3] <=  (data_sw[3] ^ data_sw[2] ^ data_sw[1]
                            ^ crc_data[29] ^ crc_data[30] ^ crc_data[31]);
            crc_next[4] <=  (data_sw[3] ^ data_sw[2] ^ data_sw[0] ^ crc_data[28]
                            ^ crc_data[30] ^ crc_data[31]) ^ crc_data[0];
            crc_next[5] <=  (data_sw[3] ^ data_sw[1] ^ data_sw[0] ^ crc_data[28]
                            ^ crc_data[29] ^ crc_data[31]) ^ crc_data[1];
            crc_next[6] <=  (data_sw[2] ^ data_sw[1] ^ crc_data[29]
                            ^ crc_data[30]) ^ crc_data[ 2];
            crc_next[7] <=  (data_sw[3] ^ data_sw[2] ^ data_sw[0] ^ crc_data[28]
                            ^ crc_data[30] ^ crc_data[31]) ^ crc_data[3];
            crc_next[8] <=  (data_sw[3] ^ data_sw[1] ^ data_sw[0] ^ crc_data[28]
                            ^ crc_data[29] ^ crc_data[31]) ^ crc_data[4];
            crc_next[9] <=  (data_sw[2] ^ data_sw[1] ^ crc_data[29]
                            ^ crc_data[30]) ^ crc_data[5];
            crc_next[10]<=  (data_sw[3] ^ data_sw[2] ^ data_sw[0] ^ crc_data[28]
                            ^ crc_data[30] ^ crc_data[31]) ^ crc_data[6];
            crc_next[11]<=  (data_sw[3] ^ data_sw[1] ^ data_sw[0] ^ crc_data[28]
                            ^ crc_data[29] ^ crc_data[31]) ^ crc_data[7];
            crc_next[12]<=  (data_sw[2] ^ data_sw[1] ^ data_sw[0] ^ crc_data[28]
                            ^ crc_data[29] ^ crc_data[30]) ^ crc_data[8];
            crc_next[13]<=  (data_sw[3] ^ data_sw[2] ^ data_sw[1] ^ crc_data[29]
                                ^ crc_data[30] ^ crc_data[31]) ^ crc_data[9];
            crc_next[14]<=  (data_sw[3] ^ data_sw[2] ^ crc_data[30]
                            ^ crc_data[31]) ^ crc_data[10];
            crc_next[15]<=  (data_sw[3] ^ crc_data[31]) ^ crc_data[11];
            crc_next[16]<=  (data_sw[0] ^ crc_data[28]) ^ crc_data[12];
            crc_next[17]<=  (data_sw[1] ^ crc_data[29]) ^ crc_data[13];
            crc_next[18]<=  (data_sw[2] ^ crc_data[30]) ^ crc_data[14];
            crc_next[19]<=  (data_sw[3] ^ crc_data[31]) ^ crc_data[15];
            crc_next[20]<=  crc_data[16];
            crc_next[21]<=  crc_data[17];
            crc_next[22]<=  (data_sw[0] ^ crc_data[28]) ^ crc_data[18];
            crc_next[23]<=  (data_sw[1] ^ data_sw[0] ^ crc_data[29]
                            ^ crc_data[28]) ^ crc_data[19];
            crc_next[24]<=  (data_sw[2] ^ data_sw[1] ^ crc_data[30]
                            ^ crc_data[29]) ^ crc_data[20];
            crc_next[25]<=  (data_sw[3] ^ data_sw[2] ^ crc_data[31]
                            ^ crc_data[30]) ^ crc_data[21];
            crc_next[26]<=  (data_sw[3] ^ data_sw[0] ^ crc_data[31]
                            ^ crc_data[28]) ^ crc_data[22];
            crc_next[27]<=  (data_sw[1] ^ crc_data[29]) ^ crc_data[23];
            crc_next[28]<=  (data_sw[2] ^ crc_data[30]) ^ crc_data[24];
            crc_next[29]<=  (data_sw[3] ^ crc_data[31]) ^ crc_data[25];
            crc_next[30]<=  crc_data[26];
            crc_next[31]<=  crc_data[27];
        end
end

//crc_data:CRC校验数据
always @(posedge clk or negedge rst_n)
    if(~rst_n)
        crc_data <=  32'hff_ff_ff_ff;
    else if(crc_clr == 1'b1)
        crc_data <= 32'hff_ff_ff_ff;
    else if(crc_en == 1'b1)
        crc_data <=  crc_next;

endmodule
