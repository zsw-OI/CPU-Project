`timescale 1ns / 1ps

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
    input [4:0] dst,
    input [31:0] alu_res,
    input [31:0] mem_res,
    input [31:0] pc,
    input [2:0] reg_write_flag,
    input ecall_enable,
    output reg [31:0] imm,
    output reg use_imm,
    output reg use_alu,
    output reg [2:0] func3,
    output reg [6:0] func7,
    output reg [4:0] data1_idx, 
    output reg [4:0] data2_idx,
    output reg [4:0] sw_idx,
    output reg [4:0] dst_idx,
    output reg [31:0] data1,
    output reg [31:0] data2,
    output reg [31:0] sw_data,
    output reg [2:0] reg_write,
    output reg mem_write,
    output reg [2:0] mem_op,
    output reg branch,
    output reg jmp,
    output reg ecall_pause,
    output reg read_pause,
    output reg exit
);
`include "constants.v"

reg [31:0] reg_data[31:0];

wire [6:0] opcode;
wire [4:0] rg1;
wire [4:0] rg2;
wire [4:0] rd;

assign rd = inst[11:7];
assign rg1 = inst[19:15];
assign rg2 = inst[24:20];
assign opcode = inst[6:0];

always @* begin

    imm = 0;
    use_imm = 0;
    use_alu = 0;
    func3 = inst[14:12];
    func7 = inst[31:25];
    data1_idx = 0;
    data2_idx = 0;
    sw_idx = 0;
    data1 = 0;
    data2 = 0;
    sw_data = 0;
    dst_idx = 0;
    reg_write = 0;
    mem_write = 0;
    mem_op = MEM_NOP;
    branch = 0;
    jmp = 0;
    exit = 0;
    ecall_pause = 0;
    read_pause = 0;
    case(opcode)

    
    //I type
    OP_JARL:begin
        //calc data1 + imm in branch_checker
        //calc set2 in ALU (hence use_imm = 0)
        imm = $signed(inst[31:20]);
        reg_write = REG_ALU_W;

        data1 = reg_data[rg1];
        data1_idx = rg1;
        data2 = pc + 4;
        dst_idx = rd;

        func3 = FUN3_SET2;
        use_alu = 1;
        jmp = 1;
    end

    OP_ALU:begin
        imm = $signed(inst[31:20]);
        use_imm = 1;
        reg_write = REG_ALU_W;
        data1 = reg_data[rg1];
        data1_idx = rg1;
        dst_idx = rd;
        use_alu = 1;
    end

    OP_LOAD:begin
        imm = $signed(inst[31:20]);
        use_imm = 1;
        use_alu = 1;
        reg_write = REG_MEM_W;

        func3 = FUN3_ADD;
        func7 = 0;
        data1 = reg_data[rg1];
        data1_idx = rg1;
        dst_idx = rd;
        mem_op = inst[14:12];
    end

    OP_ENV:begin
        imm = $signed(inst[31:20]);
        
        if(imm == 0)begin
            if(!ecall_enable)begin
                ecall_pause = 1;
            end else begin
                case(reg_data[REG_A7])
                    10: begin
                        exit = 1;
                        ecall_pause = 0;
                    end
                    5:begin
                        mem_op = MEM_IN;
                        dst_idx = REG_A0;
                        read_pause = 1;
                        ecall_pause = 0;
                        reg_write = REG_MEM_W;
                    end 
                    1:begin
                        mem_op = MEM_OUT;
                        sw_idx = REG_A0;
                        sw_data = reg_data[REG_A0];
                        mem_write = 1;
                        ecall_pause = 0;
                    end
                endcase
            end
        end
    end

    //U type
    OP_LUI, OP_AUIPC:begin
        imm = $signed({inst[31:12],12'b0});
        use_imm = 1;
        reg_write = REG_ALU_W;

        data1 = (opcode == OP_LUI ? 0 : pc);
        dst_idx = rd;

        func3 = FUN3_ADD;
        func7 = 0;
    end
    //S type
    7'b0100011:begin
        imm = $signed({inst[31:25],inst[11:7]});
        use_imm = 1;
        use_alu = 1;

        func3 = FUN3_ADD;
        func7 = 0;
        mem_op = inst[14:12];
        data1 = reg_data[rg1];
        data1_idx = rg1;
        sw_data = reg_data[rg2];
        sw_idx = rg2;
        mem_write = 1;
    end
    //B type
    7'b1100011:begin
        imm = $signed({inst[31], inst[7], inst[30:25], inst[11:8], 1'b0});
        data1 = reg_data[rg1];
        data1_idx = rg1;
        data2 = reg_data[rg2];
        data2_idx = rg2;
        branch = 1;
        use_alu = 1;
    end
    //J type
    7'b1101111:begin
        imm = $signed({inst[31],inst[19:12], inst[20], inst[30:21], 1'b0});
        use_imm = 0;
        reg_write = REG_ALU_W;
        data1 = pc;
        data2 = pc + 4;
        dst_idx = rd;
        func3 = FUN3_SET2;
        jmp = 1;
    end
    //R type
    7'b0110011:begin
        reg_write = REG_ALU_W;
        data1 = reg_data[rg1];
        data1_idx = rg1;
        data2 = reg_data[rg2];
        data2_idx = rg2;
        dst_idx = rd;
        use_alu = 1;
    end
    
    default:begin
        if (pc != 0)
            exit = 1;
    end
    endcase
end

integer i;
always @(negedge clk, negedge rst) begin
    if(!rst) begin
        for(i = 0; i < 32; i = i + 1)begin
            reg_data[i] <= 0;
        end
    end else begin

        case(reg_write_flag)
            REG_ALU_W: reg_data[dst] <= alu_res;
            REG_MEM_W: reg_data[dst] <= mem_res;
            default:begin
                //nop
            end
        endcase
    end
end

endmodule
