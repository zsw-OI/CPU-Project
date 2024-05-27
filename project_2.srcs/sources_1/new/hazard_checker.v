`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 22:43:10
// Design Name: 
// Module Name: hazard_checker
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


module hazard_checker(
    input [4:0] ID_idx1, [4:0] ID_idx2, alu_op_flag,
          [4:0] EX_dst, [2:0] EX_reg_write,
    output nop_flag
    );
    assign nop_flag = (EX_dst != 0) && alu_op_flag && 
                    (ID_idx1 == EX_dst || ID_idx2 == EX_dst) &&
                    (EX_reg_write == REG_MEM_W);
    
endmodule
