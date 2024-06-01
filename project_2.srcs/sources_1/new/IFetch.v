`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/24 15:06:23
// Design Name: 
// Module Name: IFetch
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


module IFetch(
    input clk,
    input [31:0] pc,
//    input write_flag,
    input uart_clk,
    input uart_enable,
    input [31:0] uart_data,
    input [31:0]uart_addr,
    input uart_done,
//    input [31:0] inst_data,
    output [31:0] inst
);
wire uart_en;
assign uart_en = uart_enable & (~uart_done);
mem_block inst_mem(
    .clka(uart_en ? (~uart_clk) : ~clk), 
//    .wea(uart_enable && write_flag), 
    .wea(uart_en), 
    .addra(uart_en ? uart_addr[13:0] : pc[15:2]), 
    .dina(uart_data), 
    .douta(inst)
);

endmodule
