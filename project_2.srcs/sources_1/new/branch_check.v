`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 00:57:46
// Design Name: 
// Module Name: branch_check
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


module branch_check(
    input branch_flag,
    input jmp_flag,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] imm,
    input [2:0] func3,
    output reg branch,
    output jmp,
    output reg [31:0] offset
);
    `include "constants.v"

assign jmp = jmp_flag;

always @* begin
    branch = 0;
    if(branch_flag)begin
        case(func3)
        FUN3_BEQ:  branch = (data1 == data2);
        FUN3_BNE:  branch = (data1 != data2);
        FUN3_BLT:  branch = ($signed(data1) < $signed(data2));
        FUN3_BGE:  branch = ($signed(data1) >= $signed(data2));
        FUN3_BLTU: branch = (data1 < data2);
        FUN3_BGEU: branch = (data1 >= data2);
        default: branch = 0;
        endcase
        offset = imm;
    end else if(jmp_flag)begin
        branch = 1;
        offset = data1 + imm;
    end
end

endmodule
