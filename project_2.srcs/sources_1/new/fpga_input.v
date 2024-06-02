`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/30 00:02:39
// Design Name: 
// Module Name: fpga_input
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fpga_input(
    input cpu_clk, 
    input rst_in, 
    input local_rst_in, 
    input start_in, 
    input pause_in, 
    input uart_mode_in, 
    input [7:0] data_in,
    output reg rst_out, 
    output reg local_rst_out, 
    output start_out, 
    output reg pause_out, 
    output reg uart_mode_out, 
    output reg [31:0] data_out
    );
//    assign rst_out = rst_in;
//    assign uart_mode_out = uart_mode_in;
//    assign ;
    parameter period=200000;
    reg [30:0] cnt=0;
    reg start_tmp, start_tmp2;
    initial begin
        cnt = 0;
        start_tmp = 0;
        start_tmp2 = 0;
        rst_out = 0;
        uart_mode_out = 0;
        local_rst_out = 0;
        pause_out = 0;
        data_out = 0;
    end
    assign start_out = start_tmp & (~start_tmp2);
    always @(posedge cpu_clk)
    begin
      
          if(cnt==(period >> 1)-1) 
          begin
              rst_out <= rst_in;
              uart_mode_out <= uart_mode_in;
              local_rst_out <= (local_rst_in | uart_mode_in);
              start_tmp <= start_in;
              pause_out <= pause_in;
              data_out <= {24'b0, data_in};
              cnt<=0;
          end
          else cnt<=cnt+1;
          start_tmp2 <= start_tmp;
           
      
    end

//    always @(posedge cpu_clk)
//    begin
//        rst_out <= rst_in;
//        uart_mode_out <= uart_mode_in;
//        local_rst_out <= (local_rst_in | uart_mode_in);
//        start_out <= start_in;
//        pause_out <= pause_in;
//        enter_out <= enter_in;
//        data_out <= {24'b0, data_in};
//    end
endmodule
