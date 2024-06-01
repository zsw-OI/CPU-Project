`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 22:49:33
// Design Name: 
// Module Name: cpu_clk
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


module cpu_clk(
    input clk_in, 
    output reg cpu_clk, 
    output reg ctr_clk,
    output uart_clk
    );
    wire clk_out;
    raw_clk clk_gen(.clk_in1(clk_in), .clk_out1(clk_out), .clk_out2(uart_clk));
    reg [3:0] ctr_cnt = 0;
    reg [3:0] cpu_cnt = 0;
    initial begin
        cpu_cnt = 0;
        cpu_clk = 1;
        ctr_clk = 1;
        ctr_cnt = 0;
    end
    always @(posedge clk_out)
    begin
        
        if (cpu_cnt == 1) begin
            cpu_cnt <= 0;
            cpu_clk <= ~cpu_clk;
        end
        else 
            cpu_cnt <= cpu_cnt + 1;
        
        if (ctr_clk) begin
            if (ctr_cnt == 2) begin
                ctr_clk <= ~ctr_clk;
                ctr_cnt <= 0;
            end
            else 
                ctr_cnt <= ctr_cnt + 1;
                
        end
        else begin
            ctr_clk <= ~ctr_clk;
            ctr_cnt <= 0;
        end
        
            
    end

endmodule
