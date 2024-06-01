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
    input ctr_clk, input rst, input local_rst, input start, input pause, input exit, input nop_flag, input branch_flag, 
    input ID_nop, input EX_nop, input mem_nop,
    output reg [1:0] pc_ctrl, output reg [1:0] IF_ctrl, output reg [1:0] ID_ctrl, output reg [1:0] EX_ctrl, output reg [1:0] mem_ctrl,
    output is_clear
    );
    `include "constants.v"
    reg [1:0] state = 2'b00;
    parameter ST_REST = 2'b00;
    parameter ST_RUN = 2'b01;
    parameter ST_PAUSE = 2'b10;
    parameter ST_EXIT = 2'b11;
     
    assign is_clear = ID_nop && EX_nop && mem_nop; 
     
    always @(negedge ctr_clk or negedge rst) begin
        if (~rst) begin
            state <= ST_REST;
            pc_ctrl <= SR_NOP;
            IF_ctrl <= SR_NOP;
            ID_ctrl <= SR_NOP;
            EX_ctrl <= SR_NOP;
            mem_ctrl <= SR_NOP;
        end
        else begin
            if (local_rst) begin
                state <= ST_REST;
                pc_ctrl <= SR_NOP;
                IF_ctrl <= SR_NOP;
                ID_ctrl <= SR_NOP;
                EX_ctrl <= SR_NOP;
                mem_ctrl <= SR_NOP;
            end
            else if (pause) begin
                if (state == ST_RUN) begin
                    state <= ST_PAUSE;
                    pc_ctrl <= SR_REMAIN;
                    IF_ctrl <= SR_REMAIN;
                    ID_ctrl <= SR_NOP;
                    EX_ctrl <= SR_NORMAL;
                    mem_ctrl <= SR_NORMAL;
                end
            end
            else if (exit) begin
                if (state == ST_RUN) begin
                    state <= ST_EXIT;
                    pc_ctrl <= SR_NOP;
                    IF_ctrl <= SR_NOP;
                    ID_ctrl <= SR_NOP;
                    EX_ctrl <= SR_NORMAL;
                    mem_ctrl <= SR_NORMAL;
                end
            end
            else if (start) begin
                if (state == ST_PAUSE || state == ST_REST) begin
                    state <= ST_RUN;
                    if (nop_flag) begin 
                        pc_ctrl <= SR_REMAIN;
                        IF_ctrl <= SR_REMAIN;
                        ID_ctrl <= SR_NOP;
                        EX_ctrl <= SR_NORMAL;
                        mem_ctrl <= SR_NORMAL;
                    end
                    else if (branch_flag) begin
                        pc_ctrl <= SR_NORMAL;
                        IF_ctrl <= SR_NOP;
                        ID_ctrl <= SR_NORMAL;
                        EX_ctrl <= SR_NORMAL;
                        mem_ctrl <= SR_NORMAL;
                    end
                    else begin
                        pc_ctrl <= SR_NORMAL;
                        IF_ctrl <= SR_NORMAL;
                        ID_ctrl <= SR_NORMAL;
                        EX_ctrl <= SR_NORMAL;
                        mem_ctrl <= SR_NORMAL;
                    end                    
                end
            end
            else if (state == ST_PAUSE) begin
                pc_ctrl <= SR_REMAIN;
                IF_ctrl <= SR_REMAIN;
                ID_ctrl <= SR_REMAIN;
                EX_ctrl <= SR_REMAIN;
                mem_ctrl <= SR_REMAIN;
            end
            else 
            if (state == ST_RUN) begin
                if (nop_flag) begin 
                    pc_ctrl <= SR_REMAIN;
                    IF_ctrl <= SR_REMAIN;
                    ID_ctrl <= SR_NOP;
                    EX_ctrl <= SR_NORMAL;
                    mem_ctrl <= SR_NORMAL;
                end
                else if (branch_flag) begin
                    pc_ctrl <= SR_NORMAL;
                    IF_ctrl <= SR_NOP;
                    ID_ctrl <= SR_NORMAL;
                    EX_ctrl <= SR_NORMAL;
                    mem_ctrl <= SR_NORMAL;
                end
                else begin
                    pc_ctrl <= SR_NORMAL;
                    IF_ctrl <= SR_NORMAL;
                    ID_ctrl <= SR_NORMAL;
                    EX_ctrl <= SR_NORMAL;
                    mem_ctrl <= SR_NORMAL;
                end
            end
            else if (state == ST_EXIT) begin
                pc_ctrl <= SR_NOP;
                IF_ctrl <= SR_NOP;
                ID_ctrl <= SR_NOP;
                EX_ctrl <= SR_NORMAL;
                mem_ctrl <= SR_NORMAL;
            end
            else if (state == ST_REST) begin
                pc_ctrl <= SR_NOP;
                IF_ctrl <= SR_NOP;
                ID_ctrl <= SR_NOP;
                EX_ctrl <= SR_NOP;
                mem_ctrl <= SR_NOP;
            end
        end
    end
endmodule
