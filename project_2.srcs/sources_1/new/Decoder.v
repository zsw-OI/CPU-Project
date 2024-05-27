`timescale 1ns / 1ps
`include "constants.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/24 14:56:36
// Design Name: 
// Module Name: Decoder
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


module Decoder(
    input clk, rst,
    input [31:0] inst,
    input [31:0] alu_res,
    input [31:0] mem_res,
    input [31:0] pc,
    output reg use_imm,
    output reg [2:0] func3,
    output reg [6:0] func7,
    output reg [31:0] data1,
    output reg [31:0] data2,
    output reg [31:0] imm,
    output reg write_flag,
    output reg [2:0] mem_op,
    output reg branch,
    output reg jmp
);

reg [31:0] reg_data[31:0];
//write data from ALU/MEM to reg
reg reg_write = 0;
reg wb = 0;
reg [31:0] self_res = 0;

wire [6:0] opcode;
wire [4:0] rg1;
wire [4:0] rg2;
wire [4:0] rd;

assign rd = inst[11:7];
assign rg1 = inst[19:15];
assign rg2 = inst[24:20];
assign opcode = inst[6:0];

always @* begin
    case(opcode)
    //I type
    OP_JARL:begin
        imm = $signed(inst[31:20]);
        use_imm = 1;
        reg_write = REG_PC_W;
        self_res = pc + 4;
        data1 = reg_data[rg1];
        func3 = FUN3_ADD;
        write_flag = 0;
        branch = 0;
        jmp = 1;
    end

    OP_ALU:begin
        imm = $signed(inst[31:20]);
        use_imm = 1;
        reg_write = REG_ALU_W;
        func3 = inst[14:12];
        data1 = reg_data[rg1];
        write_flag = 0;
        branch = 0;
        jmp = 0;
    end

    OP_LOAD:begin
        imm = $signed(inst[31:20]);
        use_imm = 1;
        reg_write = REG_MEM_W;
        write_flag = 0;
        func3 = FUN3_ADD;
        data1 = reg_data[rg1];
        mem_op = inst[14:12];
        branch = 0;
        jmp = 0;
    end

    OP_ENV:begin
        imm = $signed(inst[31:20]);
        use_imm = 1;
        write_flag = 0;
        branch = 0;
        jmp = 0;
        //TODO: set ecall&ebreak flag.
    end

    //U type
    OP_LUI, OP_AUIPC:begin
        imm = $signed({inst[31:12],12'b0});
        use_imm = 1;
        reg_write = REG_ALU_W;
        data1 = (opcode == OP_LUI ? 0 : pc);
        func3 = FUN3_ADD;
        jmp = 0;
        branch = 0;
        write_flag = 0;
    end
    //S type
    7'b0100011:begin
        imm = $signed({inst[31:25],inst[11:7]});
        use_imm = 1;
        reg_write = 0;
        func3 = FUN3_ADD;
        mem_op = inst[14:12];
        data1 = reg_data[rg1];
        data2 = reg_data[rg2];
        write_flag = 1;
        branch = 0;
        jmp = 0;
    end
    //B type
    7'b1100011:begin
        imm = $signed({inst[31], inst[7], inst[30:25], inst[11:8], 1'b0});
        use_imm = 0;
        reg_write = 0;
        self_res = pc + 4;
        data1 = reg_data[rg1];
        data2 = reg_data[rg2];
        func3 = inst[14:12];
        write_flag = 0;
        branch = 1;
        jmp = 0;
    end
    //J type
    7'b1101111:begin
        imm = $signed({inst[31],inst[19:12], inst[20], inst[30:21], 1'b0});
        use_imm = 1;
        reg_write = REG_PC_W;
        self_res = pc + 4;
        data1 = pc;
        func3 = FUN3_ADD;
        write_flag = 0;
        branch = 0;
        jmp = 1;
    end
    //R type
    default:begin
        imm = 32'b0;
        use_imm = 0;
        reg_write = REG_ALU_W;
        func3 = inst[14:12];
        func7 = inst[31:25];
        data1 = reg_data[rg1];
        data2 = reg_data[rg2];
        write_flag = 0;
        branch = 0;
        jmp = 0;
    end
    endcase
end

integer i;
always @(posedge clk, negedge rst) begin
    if(rst) begin
        if(wb)begin
            case(reg_write)
                REG_ALU_W: reg_data[rd] <= alu_res;
                REG_MEM_W: reg_data[rd] <= mem_res;
                REG_PC_W: reg_data[rd] <= self_res;
            endcase
        end
        wb = wb ^ 1;
    end else begin
        for(i = 0; i < 32; i = i + 1)begin
            reg_data[i] <= 0;
        end
        wb <= 0;
    end
end

endmodule
