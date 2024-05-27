`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 22:38:44
// Design Name: 
// Module Name: UART_input
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


module uart_kernel(
    input uart_clk_i, uart_rst, uart_rx,
    output uart_clk_o, uart_enable, uart_data, uart_addr, uart_done, uart_tx
    );
    uart_bmpg_0 kernal(
        .upg_clk_i(uart_clk_i),
        .upg_rst_i(uart_rst),
        .upg_rx_i(uart_rx),
        
        .upg_clk_o  (uart_clk_o),
        .upg_wen_o  (uart_enable),
        .upg_dat_o  (uart_data),
        .upg_adr_o  (uart_addr),
        .upg_done_o (uart_done),
        .upg_tx_o   (uart_tx)
    );
endmodule
