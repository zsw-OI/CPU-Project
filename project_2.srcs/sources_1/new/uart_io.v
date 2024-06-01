`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 23:23:57
// Design Name: 
// Module Name: uart_io
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


module uart_io(
    input rst, 
    input uart_clk_i, 
    input uart_rx, 
    input uart_mode,
    output uart_clk_o, 
    output inst_enable, 
    output mem_enable, 
    output [31:0] uart_addr, 
    output [31:0] uart_data, 
    output uart_done, 
    output uart_tx
    );
    wire uart_enable;
    wire [14:0] uart_addr_15;
    assign uart_addr = {18'b0, uart_addr_15[13:0]};
    uart_kernel kernel(
        .uart_clk_i(uart_clk_i),
        .uart_rst(rst),
        .uart_rx(uart_rx),
        
        .uart_clk_o(uart_clk_o),
        .uart_enable(uart_enable),
        .uart_data(uart_data),
        .uart_addr(uart_addr_15),
        .uart_done(uart_done),
        .uart_tx(uart_tx)
    );
    assign inst_enable = uart_mode & (~uart_addr_15[14]);
    assign mem_enable = uart_mode & (uart_addr_15[14]);
    
//    input uart_clk_i, uart_rst, uart_rx,
//        output uart_clk_o, uart_enable, uart_data, uart_addr, uart_done, uart_tx
    
endmodule
