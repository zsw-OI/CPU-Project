`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 19:16:20
// Design Name: 
// Module Name: cpu_top
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


module cpu_top(
    input clk,
    input rst
    //how to output...
);

wire [31:0] pc;
wire [31:0] inst;
wire [31:0] alu_res;
wire [31:0] mem_res;
wire branch, is_zero, jmp; 
reg set_inst = 0;
reg [31:0] inst_data = 0;

IFetch ifetch(
    .clk(clk), .rst(rst), 
    .branch(branch), .is_zero(is_zero), .set_pc(jmp), .set_data(set_inst),
    .offset(alu_res), .inst_data(inst_data), .inst(inst), .pc(pc)
);

wire use_imm, write_flag;
wire [2:0] func3;
wire [6:0] func7;
wire [2:0] mem_op;
wire [31:0] imm, data1, data2;

Decoder decoder(
    .clk(clk), .rst(rst),
    .inst(inst), .alu_res(alu_res), .mem_res(mem_res), .pc(pc),
    .use_imm(use_imm), .func3(func3), .func7(func7),
    .data1(data1), .data2(data2), .imm(imm),
    .write_flag(write_flag), .mem_op(mem_op),
    .branch(branch), .jmp(jmp)
);

ALU alu(
    .clk(clk),//unused
    .func3(func3), .func7(func7),
    .use_imm(use_imm),
    .data1(data1), .data2(data2),
    .imm(imm), .branch(branch),
    .res(alu_res), .is_zero(is_zero)
);

memory data_mem(
    .clk(clk), .rst(rst),
    .mem_w(write_flag), .mem_op(mem_op),
    .addr(alu_res), .data_in(data2),
    .res(mem_res)
);

endmodule
