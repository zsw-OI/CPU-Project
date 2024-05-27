`timescale 1ns / 1ps
`include "constants.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/24 22:17:55
// Design Name: 
// Module Name: memory
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


module memory(
    input clk, rst,
    input mem_w,
    input [2:0] mem_op,
    input [31:0] addr,
    input [31:0] data_in,
    output reg [31:0] res
);

wire [31:0] data;
reg [31:0] data_w;
reg write_flag;
reg wb = 0;

mem_block data_mem(.clka(~clk), .wea(write_flag), .addra(addr[13:0]), .dina(data_w), .douta(data));

always @* begin
    case(mem_op)
        MEM_LB: res = $signed(data[7:0]);
        MEM_LH: res = $signed(data[15:0]);
        MEM_LW: res = data;
        MEM_LBU:res = data[7:0]; 
        MEM_LHU:res = data[15:0];
    endcase
end

always @(posedge clk, negedge rst) begin
    if(rst)begin
        if(!wb)begin
            write_flag <= 0;
        end
        if(wb && mem_w)begin
            write_flag <= 1;
            case(mem_op)
                MEM_SB: data_w <= {data_w[31:8], data_in[7:0]};
                MEM_SH: data_w <= {data_w[31:16], data_in[15:0]};
                MEM_SW: data_w <= data_in;
            endcase
        end
        wb <= wb ^ 1;
    end else begin
        wb <= 0;
        write_flag <= 0;
    end
end

endmodule
