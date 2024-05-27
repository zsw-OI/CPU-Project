`timescale 1ns / 1ps
`include "constants.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/24 14:47:31
// Design Name: 
// Module Name: ALU
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


module ALU(
    input clk,
    input [2:0] func3,
    input [6:0] func7,
    input use_imm,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] imm,
    input branch,
    output reg [31:0] res,
    output reg is_zero
);

wire [31:0] op1;
reg [31:0] op2;
reg [3:0] alu_op;
reg sp_op = 0;
assign op1 = data1;

always @* begin

    if(branch) begin
        case(func3)
            FUN3_BEQ: alu_op = ALU_EQ;
            FUN3_BNE: alu_op = ALU_NEQ;
            FUN3_BLT: alu_op = ALU_LT;
            FUN3_BGE: alu_op = ALU_GE;
            FUN3_BLTU: alu_op = ALU_ULT;
            FUN3_BGEU: alu_op = ALU_UGE;
        endcase
    end else begin
        if(!use_imm)begin
            sp_op = (func7 == FUN7_SP);
            op2 = data2;
        end else if(func3 == FUN3_SLL || func3 == FUN3_SRL)begin
            sp_op = (imm[11:5] == FUN7_SP);
            op2 = imm[4:0];
        end else begin
            op2 = imm;
            sp_op = 0;
        end
        alu_op = {sp_op, func3};
    end

    case(alu_op)
        ALU_ADD: res = op1 + op2;
        ALU_SUB: res = op1 - op2;
        ALU_AND: res = op1 & op2;
        ALU_OR : res = op1 | op2;
        ALU_XOR: res = op1 ^ op2;
        ALU_SLL: res = op1 << op2;
        ALU_SRL: res = op1 >> op2;
        ALU_SRA: res = $signed(op1) >>> $signed(op2);
        ALU_LT:  res = ($signed(op1) < $signed(op2));
        ALU_ULT: res = (op1 < op2);
        ALU_EQ: res = (op1 == op2);
        ALU_NEQ: res = (op1 != op2);
        ALU_GE:  res = ($signed(op1) >= $signed(op2));
        ALU_UGE: res = (op1 >= op2);

    endcase

    is_zero = (res == 0);
end

endmodule
