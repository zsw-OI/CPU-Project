`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 23:36:33
// Design Name: 
// Module Name: mem_WB_reg
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


module mem_WB_reg(
    input cpu_clk, rst, nop_in, sr_ctrl,
    [4:0] dst_in, [31:0] alu_data_in, [31:0] mem_data_in,
    [2:0] reg_write_in,
    output reg [4:0] dst_out, reg [31:0] alu_data_out, reg [31:0] mem_data_out,
    reg [2:0] reg_write_out
    );
    always @(posedge cpu_clk or negedge rst)
        begin
            if (~rst) begin
                dst_out <= 0;
                alu_data_out <= 0;
                mem_data_out <= 0;
                reg_write_out <= 0;
            end
            else begin
                case (sr_ctrl)
                    SR_NOP: begin
                        dst_out <= 0;
                        alu_data_out <= 0;
                        mem_data_out <= 0;
                        reg_write_out <= 0;
                    end
                    SR_REMAIN: begin
                    
                    end
                    default: begin
                        if (nop_in) begin
                            dst_out <= 0;
                            alu_data_out <= 0;
                            mem_data_out <= 0;
                            reg_write_out <= 0;
                        end
                        else begin
                            dst_out <= dst_in;
                            alu_data_out <= alu_data_in;
                            mem_data_out <= mem_data_in;
                            reg_write_out <= reg_write_in;
                        end
                    end
                endcase
            end
        end    
endmodule
