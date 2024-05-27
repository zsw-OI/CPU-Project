`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 23:36:33
// Design Name: 
// Module Name: IF_ID_reg
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


module IF_ID_reg(
    input rst, cpu_clk, nop_in, sr_ctrl,
    [31:0]inst_in, [31:0] pc_in, 
    output reg nop_out,
    reg [31:0] inst_out, reg [31:0] pc_out
    );
    always @(posedge cpu_clk or negedge rst) 
        begin
            if (~rst) begin
                inst_out <= 0;
                nop_out <= 0;
                pc_out <= 0;
            end
            else begin
                case (sr_ctrl)
                SR_NOP: begin
                    inst_out <= 0;
                    nop_out <= 1;
                    pc_out <= 0;
                end
                    
                SR_REMAIN: begin
                //remain unchanged
                end
                default: begin
                    if (nop_in) begin
                        inst_out <= 0;
                        nop_out <= 1;
                        pc_out <= 0;
                    end
                    else begin
                        inst_out <= inst_in;
                        nop_out <= 0;
                        pc_out <= pc_in;
                    end
                    
                end
                endcase
                
            end
        end
    
endmodule
