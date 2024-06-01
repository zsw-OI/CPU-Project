`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 23:36:33
// Design Name: 
// Module Name: EX_mem_reg
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


module EX_mem_reg(
    input cpu_clk, input rst, input [1:0] sr_ctrl, input nop_in, 
    input [4:0] dst_in, 
    input [31:0] alu_result_in, input [31:0] sw_data_in, 
    input [2:0] mem_op_in, input [2:0] reg_write_in,
    input mem_write_in,
    output reg nop_out, 
    output reg [4:0] dst_out,
    output reg [31:0] alu_result_out, output reg [31:0] sw_data_out,
    output reg [2:0] mem_op_out, output reg [2:0] reg_write_out,
    output reg mem_write_out
    );
    `include "constants.v"
    always @(posedge cpu_clk or negedge rst)
    begin
        if (~rst) begin
            nop_out <= 1;
            alu_result_out <= 0; 
            dst_out <= 0;
            sw_data_out <= 0;
            mem_op_out <=0;
            reg_write_out <= 0;
            mem_write_out <= 0;
        end
        else begin
            case (sr_ctrl)
                SR_NOP: begin
                    nop_out <= 1;
                    alu_result_out <= 0; 
                    dst_out <= 0;
                    sw_data_out <= 0;
                    mem_op_out <=0;
                    reg_write_out <= 0;
                    mem_write_out <= 0;
                end
                SR_REMAIN: begin
                
                end
                default: begin
                    if (nop_in) begin
                        nop_out <= 1;
                        alu_result_out <= 0; 
                        dst_out <= 0;
                        sw_data_out <= 0;
                        mem_op_out <=0;
                        reg_write_out <= 0;
                        mem_write_out <= 0;
                    end
                    else begin
                        nop_out <= 0;
                        alu_result_out <= alu_result_in;
                        dst_out <= dst_in;
                        sw_data_out <= sw_data_in;
                        mem_op_out <= mem_op_in;
                        reg_write_out <= reg_write_in;
                        mem_write_out <= mem_write_in;
                    end
                end
            endcase
        end
    end
    
endmodule
