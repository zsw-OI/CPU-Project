`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 22:39:56
// Design Name: 
// Module Name: FPGA_io
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


module fpga_io(
    input cpu_clk, 
    input rst_in, 
    input local_rst_in, 
    input start_in, 
    input pause_in, 
    input enter_in, 
    input uart_mode_in, 
    input [7:0] idata_in,
    input [31:0] odata_in,
    output [3:0]sel1, 
    output [3:0]sel2, 
    output [7:0]seg_ctrl1, 
    output [7:0] seg_ctrl2,
    output rst_out, 
    output local_rst_out, 
    output start_out, 
    output pause_out, 
    output enter_out, 
    output uart_mode_out, 
    output reg [31:0] reg_idata
    );
    wire [31:0] idata_out;
    fpga_input f_input(
        .cpu_clk(cpu_clk),
        .rst_in(rst_in),
        .local_rst_in(local_rst_in),
        .start_in(start_in),
        .pause_in(pause_in),
        .enter_in(enter_in),
        .uart_mode_in(uart_mode_in),
        .data_in(idata_in),
        .rst_out(rst_out),
        .local_rst_out(local_rst_out),
        .start_out(start_out),
        .pause_out(pause_out),
        .enter_out(enter_out),
        .data_out(idata_out),
        .uart_mode_out(uart_mode_out)
         );
     fpga_output f_output(
        .cpu_clk(cpu_clk),
        .odata(odata_in),
        .sel1(sel1),
        .sel2(sel2),
        .seg_ctrl1(seg_ctrl1),
        .seg_ctrl2(seg_ctrl2)
     );
     always @(posedge enter_out or negedge rst_out)
     begin
        if (~rst_out)
            reg_idata <= 0;
        else
            reg_idata <= idata_out;
     end
     
endmodule
