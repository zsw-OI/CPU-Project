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
    input rst, input cpu_clk,
    input ecall_pause, input board_start, input board_pause, input read_pause,
//    output reg start, output reg pause
    output start, output pause, output [31:0] debug_led
    );
    reg b_start = 0, b_pause = 0;
    initial begin
        b_start = 0;
        b_pause = 0;
    end
    reg [31:0] cnt = 0;
    assign debug_led = cnt;
    always @(negedge rst or negedge cpu_clk) begin
        if (~rst) begin
            b_start <= 0;
            b_pause <= 0;
        end
        else 
        if (board_pause) begin
            b_start <= 0;
            b_pause <= 1;
        end
        else if (board_start) begin
            b_start <= 1;
            b_pause <= 0;
//            cnt <= cnt + 1;
        end
        else if (read_pause) begin
            b_start <= 0;
            b_pause <= 1;
        end
    end
    assign start = (~ecall_pause) & b_start;
    assign pause = (ecall_pause) | b_pause;      
//    always @(*) begin
//        if (~rst) begin
//            start <= 0;
//            pause <= 0;
//        end
//        else 
//        if (board_pause || ecall_pause) begin
//            start <= 0;
//            pause <= 1;
//        end
//        else if (board_start) begin
//            start <= 1;
//            pause <= 0;
//        end
//        else if (read_pause) begin
//            start <= 0;
//            pause <= 1;
//        end
//        else begin
//            start <= 1;
//            pause <= 0;
//        end
//    end
    
endmodule
