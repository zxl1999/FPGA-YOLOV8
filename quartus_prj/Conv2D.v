module Conv2D(
  input clk,
  input rst_n,
  input signed [31:0] input_data [2:0][2:0],  // 3x3 input patch
  output reg signed [31:0] output_data
);

  // 定义卷积核权重
  reg signed [31:0] kernel [2:0][2:0] = {{1, 2, 1}, {2, 4, 2}, {1, 2, 1}};

  // 定义卷积结果寄存器
  reg signed [63:0] conv_result;

  // 时钟上升沿处理
  always @(posedge clk or posedge rst_n) begin
    if (!rst_n) begin
      // 复位操作
      conv_result <= 0;
    end else begin
      // 执行卷积操作
      conv_result <= (input_data[0][0]*kernel[0][0] + input_data[1][0]*kernel[1][0] + input_data[2][0]*kernel[2][0] +
                      input_data[0][1]*kernel[0][1] + input_data[1][1]*kernel[1][1] + input_data[2][1]*kernel[2][1] +
                      input_data[0][2]*kernel[0][2] + input_data[1][2]*kernel[1][2] + input_data[2][2]*kernel[2][2]);
    end
  end

  // 将结果输出到output_data，并应用ReLU激活函数
  always @* begin
    if (conv_result > 32'h0) begin
      output_data = conv_result[31:0];
    end else begin
      output_data = 32'h0;
    end
  end

endmodule
