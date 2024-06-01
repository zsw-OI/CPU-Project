`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 16:10:04
// Design Name: 
// Module Name: pc_calculator
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


module pc_calculator( // todo: combinatorical logic, connect to pc_reg
    input [31:0] pc,
    input branch,
    input jmp,
    input [31:0] offset,
    output [31:0] nxt_pc
);

assign nxt_pc = jmp ? offset : (branch ? pc - 4 + offset: pc + 4);

endmodule
