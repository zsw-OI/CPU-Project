`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 23:36:33
// Design Name: 
// Module Name: ID_EX_reg
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


module ID_EX_reg(
    input cpu_clk, rst, nop_in, sr_ctrl,
    [4:0] idx_sw_in, [4:0] dst_in, 
    [31:0] data1_in, [31:0] data2_in, [31:0] sw_data_in, 
    [2:0] func3_in, [6:0] func7_in, [2:0] mem_op_in, [3:0] reg_write_in,
    output reg nop_out, 
    reg[4:0] idx_sw_out ,reg [4:0] dst_out,
    reg [31:0] data1_out, reg [31:0] data2_out, reg [31:0] sw_data_out, 
    reg [2:0] func3_out, reg [6:0] func7_out, reg [2:0] mem_op_out, reg [3:0] reg_write_out
    );
    always @(posedge cpu_clk or negedge rst) 
    begin
        if (~rst) begin
            nop_out <= 0;
            idx_sw_out <= 0;
            dst_out <= 0;
            data1_out <= 0;
            data2_out <= 0;
            sw_data_out <= 0;
            func3_out <= 0;
            func7_out <= 0;
            mem_op_out <=0;
            reg_write_out <= 0;
        end
        else begin
            case (sr_ctrl)
                SR_NOP: begin
                    nop_out <= 1;
                    idx_sw_out <= 0;
                    dst_out <= 0;
                    data1_out <= 0;
                    data2_out <= 0;
                    sw_data_out <= 0;
                    func3_out <= 0;
                    func7_out <= 0;
                    mem_op_out <=0;
                    reg_write_out <= 0;
                end
                SR_REMAIN: begin
                
                end
                default: begin
                    if (nop_in) begin
                        nop_out <= 1;
                        idx_sw_out <= 0;
                        dst_out <= 0;
                        data1_out <= 0;
                        data2_out <= 0;
                        sw_data_out <= 0;
                        func3_out <= 0;
                        func7_out <= 0;
                        mem_op_out <=0;
                        reg_write_out <= 0;
                    end
                    else begin
                        nop_out <= 1;
                        idx_sw_out <= idx_sw_in;
                        dst_out <= dst_in;
                        data1_out <= data1_in;
                        data2_out <= data2_in;
                        sw_data_out <= sw_data_in;
                        func3_out <= func3_in;
                        func7_out <= func7_in;
                        mem_op_out <= mem_op_in;
                        reg_write_out <= reg_write_in;
                    end
                end
            endcase
        end
    end
endmodule
