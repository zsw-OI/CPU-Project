`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/24 15:06:23
// Design Name: 
// Module Name: IFetch
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


module IFetch(
    input clk, rst,
    input branch,
    input is_zero,
    input set_pc,
    input set_data,
    input [31:0] offset,
    input [31:0] inst_data,
    output [31:0] inst,
    output reg [31:0] pc = 0
);

reg wb = 0;

//pretend to access memory.
mem_block inst_mem(.clka(clk), .wea(set_data), .addra(pc[13:0]), .dina(inst_data), .douta(inst));

always @(negedge clk, negedge rst) begin
    if(!rst)begin
        pc <= 0;
        wb <= 0;
    end else begin
        if(wb) begin
            pc <= (set_pc ? pc : 0) + ((branch && !is_zero) ? offset : 4);
        end
        wb = wb ^ 1;
    end
end

endmodule
