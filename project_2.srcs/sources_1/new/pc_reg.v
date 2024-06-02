`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 15:57:42
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
    input rst, input cpu_clk, input [31:0] next_pc, input [1:0] sr_ctrl,
    output reg [31:0] pc_out, output reg nop_out
    );
    `include "constants.v"
    always @(posedge cpu_clk or negedge rst) 
    begin
        if (~rst) begin
            pc_out <= 0;
            nop_out <= 0;
        end
        else begin
            case (sr_ctrl)
            SR_NOP: begin
                pc_out <= 0;
                nop_out <= 0;
            end
                
            SR_REMAIN: begin
            //remain unchanged
            end
            default: 
                begin
                    pc_out <= next_pc;
                    nop_out <= 0;
                end
                
            endcase
            
        end
    end
endmodule
