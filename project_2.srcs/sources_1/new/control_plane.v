`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 22:42:00
// Design Name: 
// Module Name: control_plane
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


module control_plane(
    input cpu_clk, rst, pause, resume, nop_flag, branch_flag, 
    output reg [1:0] pc_ctrl, reg [1:0] IF_ctrl, reg [1:0] ID_ctrl, reg [1:0] EX_ctrl, reg [1:0] mem_ctrl, reg [1:0] WB_ctrl
    );
    reg halt;
    always @(negedge cpu_clk or negedge rst) begin
        if (~rst) begin
            halt <= 0;
            pc_ctrl <= SR_NORMAL;
            IF_ctrl <= SR_NORMAL;
            ID_ctrl <= SR_NORMAL;
            EX_ctrl <= SR_NORMAL;
            mem_ctrl <= SR_NORMAL;
            WB_ctrl <= SR_NORMAL;
        end
        else begin
            if (pause)
                halt <= 1;
            else if (resume)
                halt <= 0;
            
            if (halt) begin
                pc_ctrl <= SR_REMAIN;
                IF_ctrl <= SR_REMAIN;
                ID_ctrl <= SR_REMAIN;
                EX_ctrl <= SR_REMAIN;
                mem_ctrl <= SR_REMAIN;
                WB_ctrl <=  SR_REMAIN;
            end
            else if (nop_flag) begin 
                pc_ctrl <= SR_REMAIN;
                IF_ctrl <= SR_REMAIN;
                ID_ctrl <= SR_NOP;
                EX_ctrl <= SR_NORMAL;
                mem_ctrl <= SR_NORMAL;
                WB_ctrl <= SR_NORMAL;
            end
            else if (branch_flag) begin
                pc_ctrl <= SR_REMAIN;
                IF_ctrl <= SR_NOP;
                ID_ctrl <= SR_NORMAL;
                EX_ctrl <= SR_NORMAL;
                mem_ctrl <= SR_NORMAL;
                WB_ctrl <= SR_NORMAL;
            end
            else begin
                pc_ctrl <= SR_NORMAL;
                IF_ctrl <= SR_NORMAL;
                ID_ctrl <= SR_NORMAL;
                EX_ctrl <= SR_NORMAL;
                mem_ctrl <= SR_NORMAL;
                WB_ctrl <= SR_NORMAL;
            end
        end
    end
endmodule
