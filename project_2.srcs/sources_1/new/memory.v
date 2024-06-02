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

initial output_data = 0;

wire [31:0] data;
wire [1:0] offset;
reg [31:0] data_w;
wire uart_en;

assign uart_en = uart_enable & (~uart_done);
assign offset = addr[1:0];

wire [31:0] r_addr;
assign r_addr = addr - ADDR_OFFSET;

mem_block2 data_mem(
    .clka(uart_en ? uart_clk : ~clk), 
//    .wea(write_flag), 
    .wea(uart_en | (write_flag & mem_op != MEM_OUT)),
    .addra(uart_en ? uart_addr[13:0] : r_addr[15:2]), 
    .dina(uart_en ? uart_data : data_w), 
    .douta(data)
);

reg [7:0] byte_data;
reg [31:0] byte_in;
reg [15:0] hw_data;
reg [31:0] hw_in;

always @* begin
    res = 0;

    case(offset)
        2'b00: byte_data = data[7:0];
        2'b01: byte_data = data[15:8];
        2'b10: byte_data = data[23:16];
        2'b11: byte_data = data[31:24];
    endcase

    case(offset)
        2'b00: byte_in = {data[31:8], data_in[7:0]};
        2'b01: byte_in = {data[31:16], data_in[15:8], data[7:0]};
        2'b10: byte_in = {data[31:24], data_in[23:16], data[15:0]};
        2'b11: byte_in = {data_in[31:24], data[23:0]};
    endcase

    hw_data = (offset[1] ? data[31:16] : data[15:0]);
    hw_in = (offset[1]? ({data_in[31:16], data[15:0]}): ({data[31:16], data_in[15:0]}));

    case(mem_op)
        MEM_LB: res = $signed(byte_data);
        MEM_LH: res = $signed(hw_data);
        MEM_LW: res = data;
        MEM_LBU:res = byte_data; 
        MEM_LHU:res = hw_data;
        MEM_IN: res = input_data;
        default:res = 0;
    endcase
end

always @(*) begin
//    output_flag = 0;
    data_w = 0;
    case(mem_op)
        MEM_SB: data_w = byte_in;
        MEM_SH: data_w = hw_in;
        MEM_SW: data_w = data_in;
//        MEM_OUT:begin
////            if(write_flag && rst)begin
//              if(write_flag) begin
//                output_data = data_in;
////                output_flag = 1;
//            end
//        end
        default: data_w = 0;
    endcase
//    if (!rst)
//        output_data = 0;
end

always @(negedge clk or negedge rst) begin
    if (~rst)
        output_data <= 0;
    else if (mem_op == MEM_OUT && write_flag)
        output_data <= data_in; 
        
end

endmodule