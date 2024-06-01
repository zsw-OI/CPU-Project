`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/24 22:17:55
// Design Name: 
// Module Name: memory
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


module memory(
    input clk, rst,
    input write_flag,
    input [2:0] mem_op,
    input [31:0] addr,
    input [31:0] data_in,
    input [31:0] input_data,
    input uart_clk,
    input uart_enable,
    input [31:0] uart_data,
    input [31:0]uart_addr,
    input uart_done,
    output reg [31:0] res,
//    output reg output_flag,
    output reg [31:0] output_data
);
`include "constants.v"

wire [31:0] data;
reg [31:0] data_w;
wire uart_en;
assign uart_en = uart_enable & (~uart_done);

mem_block2 data_mem(
    .clka(uart_en ? ~uart_clk : ~clk), 
//    .wea(write_flag), 
    .wea(uart_en | write_flag),
    .addra(uart_en ? uart_addr[13:0] : addr[15:2]), 
    .dina(uart_en ? uart_data : data_w), 
    .douta(data)
);

always @* begin
    res = 0;
    case(mem_op)
        MEM_LB: res = $signed(data[7:0]);
        MEM_LH: res = $signed(data[15:0]);
        MEM_LW: res = data;
        MEM_LBU:res = data[7:0]; 
        MEM_LHU:res = data[15:0];
        MEM_IN: res = input_data;
        default:res = 0;
    endcase
end

always @(*) begin
//    output_flag = 0;
    data_w = 0;
    case(mem_op)
        MEM_SB: data_w = {data[31:8], data_in[7:0]};
        MEM_SH: data_w = {data[31:16], data_in[15:0]};
        MEM_SW: data_w = data_in;
        MEM_OUT:begin
            if(write_flag)begin
                output_data = data_in;
//                output_flag = 1;
            end
        end
        default: data_w = 0;
    endcase
end

endmodule
