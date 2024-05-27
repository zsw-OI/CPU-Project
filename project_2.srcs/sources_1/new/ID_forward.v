`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 22:53:04
// Design Name: 
// Module Name: ID_forward
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


module ID_forward(
    input [4:0] ID_idx, [31:0] ID_data,
        [4:0] EX_dst, [31:0] EX_alu_result, [2:0] EX_reg_write,
        [4:0] mem_dst, [31:0] mem_alu_result, [31:0] mem_mem_result, [2:0] mem_reg_write, 
        [4:0] WB_dst, [31:0] WB_alu_result, [31:0] WB_mem_result, [2:0] WB_reg_write,
    output reg [31:0] res_data
    );
    always @(*)
    begin
        if (ID_idx != 0) begin
            if (EX_dst == ID_idx && EX_reg_write == REG_ALU_W)
                res_data <= EX_alu_result;
            else if (mem_dst == ID_idx) begin
                res_data <= (mem_reg_write == REG_ALU_W) ? mem_alu_result : mem_mem_result;
            end
            else if (WB_dst == ID_idx) begin
                res_data <= (WB_reg_write == REG_ALU_W) ? WB_alu_result : WB_mem_result;
            end 
            else 
                res_data <= ID_data;
        end
        else 
            res_data <= ID_data;
            
    end
    
endmodule
