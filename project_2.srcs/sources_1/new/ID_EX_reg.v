`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 23:36:33
// Design Name: 
// Module Name: ID_EX_reg
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

//module Decoder(
//    input clk, rst,
//    input [31:0] inst,
//    input [4:0] dst,
//    input [31:0] alu_res,
//    input [31:0] mem_res,
//    input [31:0] pc,
//    input [2:0] reg_write_flag,
//    input ecall_enable,
//    output reg [31:0] imm,
//    output reg use_imm,
//    output reg [2:0] func3,
//    output reg [6:0] func7,
//    output reg [4:0] data1_idx, 
//    output reg [4:0] data2_idx,
//    output reg [4:0] sw_idx,
//    output reg [4:0] dst_idx,
//    output reg [31:0] data1,
//    output reg [31:0] data2,
//    output reg [31:0] sw_data,
//    output reg [2:0] reg_write,
//    output reg mem_write,
//    output reg [2:0] mem_op,
//    output reg branch,
//    output reg jmp,
//    output reg pause,
//    output reg exit = 0
//);

module ID_EX_reg(
    input cpu_clk, input rst, input nop_in, input [1:0] sr_ctrl,
    input [4:0] idx_sw_in, input [4:0] dst_in, 
    input [31:0] data1_in, input [31:0] data2_in, input [31:0] sw_data_in, 
    input [2:0] func3_in, input [6:0] func7_in, input [2:0] mem_op_in, input [2:0] reg_write_in,
    
    input mem_write_in,
    input [31:0] imm_in,
    input use_imm_in,
     
    output reg nop_out, 
    output reg[4:0] idx_sw_out ,output reg [4:0] dst_out,
    output reg [31:0] data1_out, output reg [31:0] data2_out, output reg [31:0] sw_data_out, 
    output reg [2:0] func3_out, output reg [6:0] func7_out, output reg [2:0] mem_op_out, output reg [2:0] reg_write_out,
    
    output reg mem_write_out,
    output reg [31:0] imm_out,
    output reg use_imm_out
    );
    `include "constants.v"
    always @(posedge cpu_clk or negedge rst) 
    begin
        if (~rst) begin
            nop_out <= 1;
            idx_sw_out <= 0;
            dst_out <= 0;
            data1_out <= 0;
            data2_out <= 0;
            sw_data_out <= 0;
            func3_out <= 0;
            func7_out <= 0;
            mem_op_out <=0;
            reg_write_out <= 0;
            
            mem_write_out <= 0;
            imm_out <= 0;
            use_imm_out <= 0;
            
        end
        else begin
            case (sr_ctrl)
                SR_NOP: begin
                    nop_out <= 1;
                    idx_sw_out <= 0;
                    dst_out <= 0;
                    data1_out <= 0;
                    data2_out <= 0;
                    sw_data_out <= 0;
                    func3_out <= 0;
                    func7_out <= 0;
                    mem_op_out <=0;
                    reg_write_out <= 0;
                    
                    mem_write_out <= 0;
                    imm_out <= 0;
                    use_imm_out <= 0;
                end
                SR_REMAIN: begin
                
                end
                default: begin
                    if (nop_in) begin
                        nop_out <= 1;
                        idx_sw_out <= 0;
                        dst_out <= 0;
                        data1_out <= 0;
                        data2_out <= 0;
                        sw_data_out <= 0;
                        func3_out <= 0;
                        func7_out <= 0;
                        mem_op_out <=0;
                        reg_write_out <= 0;
                        
                        mem_write_out <= 0;
                        imm_out <= 0;
                        use_imm_out <= 0;
                    end
                    else begin
                        nop_out <= 0;
                        idx_sw_out <= idx_sw_in;
                        dst_out <= dst_in;
                        data1_out <= data1_in;
                        data2_out <= data2_in;
                        sw_data_out <= sw_data_in;
                        func3_out <= func3_in;
                        func7_out <= func7_in;
                        mem_op_out <= mem_op_in;
                        reg_write_out <= reg_write_in;
                        
                        mem_write_out <= mem_write_in;
                        imm_out <= imm_in;
                        use_imm_out <= use_imm_in;
                    end
                end
            endcase
        end
    end
endmodule
