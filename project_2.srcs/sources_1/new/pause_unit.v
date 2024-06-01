`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/27 14:16:18
// Design Name: 
// Module Name: pause_unit
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


module pause_unit(
    input rst,
    ecall_pause, board_start, board_pause, read_pause,
    output reg start, reg pause
    );
    initial begin
        start = 0;
        pause = 0;
    end
    always @(*) begin
        if (~rst) begin
            start <= 0;
            pause <= 0;
        end
        else 
        if (board_pause || ecall_pause) begin
            start <= 0;
            pause <= 1;
        end
        else if (board_start) begin
            start <= 1;
            pause <= 0;
        end
        else if (read_pause) begin
            start <= 0;
            pause <= 1;
        end
        else begin
            start <= 1;
            pause <= 0;
        end
    end
    
endmodule
