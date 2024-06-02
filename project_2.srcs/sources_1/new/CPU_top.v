`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/25 19:16:20
// Design Name: 
// Module Name: cpu_top
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


module cpu_top(
    input clk_in,
    input rst_in, 
    input local_rst_in, 
    input start_in, 
    input pause_in, 
    input uart_mode_in, 
    input [7:0] idata_in,
    
    input uart_rx,
    output [1:0]led,
    output [3:0]sel1, 
    output [3:0]sel2, 
    output [7:0]seg_ctrl1, 
    output [7:0] seg_ctrl2,
    
    output [7:0] debug_led,
    
    output uart_tx
);

wire cpu_clk, ctr_clk, uart_clk;

cpu_clk clk_gen(
    .clk_in(clk_in),
    .cpu_clk(cpu_clk),
    .ctr_clk(ctr_clk),
    .uart_clk(uart_clk)
);

wire rst, local_rst, start, pause, uart_mode;
wire [31:0] idata;
wire [31:0] odata;
wire [1:0] state_in;

fpga_io _fpga_io(
    .cpu_clk(cpu_clk),
    .rst_in(rst_in),
    .local_rst_in(local_rst_in),
    .start_in(start_in),
    .pause_in(pause_in),
    .uart_mode_in(uart_mode_in),
    .idata_in(idata_in),
    .odata_in(odata),
    .state_in(state_in),
    
    .sel1(sel1),
    .sel2(sel2),
    .seg_ctrl1(seg_ctrl1),
    .seg_ctrl2(seg_ctrl2),
    .rst_out(rst),
    .local_rst_out(local_rst),
    .start_out(start),
    .pause_out(pause),
    .uart_mode_out(uart_mode),
    .reg_idata(idata),
    .led(led)
//    .debug_led(debug_led)
);
//assign debug_led = odata[7:0];
wire uart_clk_o, inst_enable, mem_enable;
wire [31:0] uart_addr;
wire [31:0] uart_data;
wire uart_done;

uart_io _uart_io(
    .rst(~rst),
    .uart_clk_i(uart_clk),
    .uart_rx(uart_rx),
    .uart_mode(uart_mode),
    .uart_clk_o(uart_clk_o),
    .inst_enable(inst_enable),
    .mem_enable(mem_enable),
    .uart_addr(uart_addr),
    .uart_data(uart_data),
    .uart_done(uart_done),
    .uart_tx(uart_tx)
);

wire [1:0] pc_sr_ctrl;
wire [1:0] IF_sr_ctrl;
wire [1:0] ID_sr_ctrl;
wire [1:0] EX_sr_ctrl;
wire [1:0] mem_sr_ctrl;
wire pc_nop;
wire IF_nop;
wire ID_nop;
wire EX_nop;
wire mem_nop;
wire nop_flag; 


wire branch;
wire jmp;
wire [31:0] pc_offset;
wire [31:0] pc_pc_reg;
wire [31:0] next_pc;

wire [31:0] IF_inst_out;

wire [31:0] ID_inst_reg;
wire [31:0] ID_pc_reg;

wire [31:0] ID_imm_out;
wire ID_use_imm_out;
wire [2:0] ID_func3_out;
wire [6:0] ID_func7_out;
wire [4:0] ID_idx1_out;
wire [4:0] ID_idx2_out;
wire [4:0] ID_sw_idx_out;
wire [4:0] ID_dst_idx_out;
wire [31:0] ID_raw_data1;
wire [31:0] ID_raw_data2;
wire [31:0] ID_raw_sw_data;
wire [31:0] ID_data1_out;
wire [31:0] ID_data2_out;
wire [31:0] ID_sw_data_out;
wire [2:0] ID_reg_write_out;
wire ID_mem_write_out;
wire [2:0] ID_mem_op_out;
wire ecall_pause;
wire ecall_exit;
wire branch_flag;
wire jmp_flag;
wire ID_use_alu_out;

wire [4:0] EX_sw_idx_reg;
wire [4:0] EX_dst_idx_reg;
wire [31:0] EX_data1_reg;
wire [31:0] EX_data2_reg;
wire [31:0] EX_sw_data_reg;
wire [2:0] EX_func3_reg;
wire [6:0] EX_func7_reg;
wire [2:0] EX_mem_op_reg;
wire [2:0] EX_reg_write_reg;
wire EX_mem_write_reg;
wire [31:0] EX_imm_reg;
wire EX_use_imm_reg;

wire [31:0] EX_alu_result_out;
wire [31:0] EX_sw_data_out;

wire [4:0] mem_dst_idx_reg;
wire [31:0] mem_alu_result_reg;
wire [31:0] mem_sw_data_reg;
wire [2:0] mem_mem_op_reg;
wire [2:0] mem_reg_write_reg;
wire mem_mem_write_reg;

wire [31:0] mem_mem_data_out;

wire [4:0] WB_dst_idx_reg;
wire [31:0] WB_mem_data_reg;
wire [31:0] WB_alu_result_reg;
wire [2:0] WB_reg_write_reg;
// control plane, todo

wire r_start, r_pause;
wire is_clear;

wire read_pause;

wire [31:0] pause_unit_cnt;
assign debug_led = ID_pc_reg[9:2];
//assign debug_led = EX_alu_result_out[7:0];
//assign debug_led = WB_alu_result_reg[7:0];
//assign debug_led = ID_sw_data_out;
//assign debug_led = EX_sw_data_reg[7:0];
//assign debug_led = pause_unit_cnt[7:0];
pause_unit _pause_unit(
    .rst(rst & (~local_rst)),
    .cpu_clk(cpu_clk),
    .ecall_pause(ecall_pause),
    .board_start(start),
    .board_pause(pause),
    .read_pause(read_pause),
    .start(r_start),
    .pause(r_pause),
    .debug_led(pause_unit_cnt)
);

control_plane _control_plane(
    .ctr_clk(ctr_clk),
    .rst(rst),
    .local_rst(local_rst),
    .start(r_start),
    .pause(r_pause),
    .exit(ecall_exit),
    .nop_flag(nop_flag),
    .branch_flag(branch),
    .ID_nop(ID_nop),
    .EX_nop(EX_nop),
    .mem_nop(mem_nop),
    .pc_ctrl(pc_sr_ctrl),
    .IF_ctrl(IF_sr_ctrl),
    .ID_ctrl(ID_sr_ctrl),
    .EX_ctrl(EX_sr_ctrl),
    .mem_ctrl(mem_sr_ctrl),
    .is_clear(is_clear),
    .state_out(state_in)
);

//module control_plane(
//    input ctr_clk, input rst, input local_rst, input start, input pause, input exit, input nop_flag, input branch_flag, 
//    input ID_nop, input EX_nop, input mem_nop,
//    output reg [1:0] pc_ctrl, output reg [1:0] IF_ctrl, output reg [1:0] ID_ctrl, output reg [1:0] EX_ctrl, output reg [1:0] mem_ctrl,
//    output is_clear
//    );

pc_calculator _pc_cal(
    .pc(pc_pc_reg),
    .branch(branch),
    .jmp(jmp),
    .offset(pc_offset),
    .nxt_pc(next_pc)
);

pc_reg _pc_reg(
    .rst(rst),
    .cpu_clk(cpu_clk),
    .next_pc(next_pc),
    .sr_ctrl(pc_sr_ctrl),
    .pc_out(pc_pc_reg),
    .nop_out(pc_nop)
);



IFetch _IFetch(
    .clk(cpu_clk),
    .pc(pc_pc_reg),
    .uart_clk(uart_clk_o),
    .uart_enable(inst_enable),
    .uart_data(uart_data),
    .uart_addr(uart_addr),
    .uart_done(uart_done),
    .inst(IF_inst_out)
);


IF_ID_reg _IF_ID_reg(
    .rst(rst),
    .cpu_clk(cpu_clk),
    .nop_in(pc_nop),
    .sr_ctrl(IF_sr_ctrl),
    .inst_in(IF_inst_out),
    .pc_in(pc_pc_reg),
    
    .nop_out(IF_nop),
    .inst_out(ID_inst_reg), 
    .pc_out(ID_pc_reg)
);



Decoder _Decoder(
    .clk(cpu_clk),
    .rst(rst & (~local_rst)),
    .inst(ID_inst_reg),
    .dst(WB_dst_idx_reg),
    .alu_res(WB_alu_result_reg),
    .mem_res(WB_mem_data_reg),
    .pc(ID_pc_reg),
    .reg_write_flag(WB_reg_write_reg),
    .ecall_enable(is_clear),
    
    .imm(ID_imm_out),
    .use_imm(ID_use_imm_out),
    .func3(ID_func3_out),
    .func7(ID_func7_out),
    .data1_idx(ID_idx1_out),
    .data2_idx(ID_idx2_out),
    .sw_idx(ID_sw_idx_out),
    .dst_idx(ID_dst_idx_out),
    .data1(ID_raw_data1),
    .data2(ID_raw_data2),
    .sw_data(ID_raw_sw_data),
    .reg_write(ID_reg_write_out),
    .mem_write(ID_mem_write_out),
    .mem_op(ID_mem_op_out),
    .branch(branch_flag),
    .jmp(jmp_flag),
    .ecall_pause(ecall_pause),
    .read_pause(read_pause),
    .exit(ecall_exit),
    .use_alu(ID_use_alu_out)
    
);

ID_forward forward_data1(
    .ID_idx(ID_idx1_out),
    .ID_data(ID_raw_data1),
    .EX_dst(EX_dst_idx_reg),
    .EX_alu_result(EX_alu_result_out),
    .EX_reg_write(EX_reg_write_reg),
    .mem_dst(mem_dst_idx_reg),
    .mem_alu_result(mem_alu_result_reg),
    .mem_mem_result(mem_mem_data_out),
    .mem_reg_write(mem_reg_write_reg),
    .WB_dst(WB_dst_idx_reg),
    .WB_alu_result(WB_alu_result_reg),
    .WB_mem_result(WB_mem_data_reg),
    .WB_reg_write(WB_reg_write_reg),
    .res_data(ID_data1_out)
);
ID_forward forward_data2(
    .ID_idx(ID_idx2_out),
    .ID_data(ID_raw_data2),
    .EX_dst(EX_dst_idx_reg),
    .EX_alu_result(EX_alu_result_out),
    .EX_reg_write(EX_reg_write_reg),
    .mem_dst(mem_dst_idx_reg),
    .mem_alu_result(mem_alu_result_reg),
    .mem_mem_result(mem_mem_data_out),
    .mem_reg_write(mem_reg_write_reg),
    .WB_dst(WB_dst_idx_reg),
    .WB_alu_result(WB_alu_result_reg),
    .WB_mem_result(WB_mem_data_reg),
    .WB_reg_write(WB_reg_write_reg),
    .res_data(ID_data2_out)
);
ID_forward forward_sw_data(
    .ID_idx(ID_sw_idx_out),
    .ID_data(ID_raw_sw_data),
    .EX_dst(EX_dst_idx_reg),
    .EX_alu_result(EX_alu_result_out),
    .EX_reg_write(EX_reg_write_reg),
    .mem_dst(mem_dst_idx_reg),
    .mem_alu_result(mem_alu_result_reg),
    .mem_mem_result(mem_mem_data_out),
    .mem_reg_write(mem_reg_write_reg),
    .WB_dst(WB_dst_idx_reg),
    .WB_alu_result(WB_alu_result_reg),
    .WB_mem_result(WB_mem_data_reg),
    .WB_reg_write(WB_reg_write_reg),
    .res_data(ID_sw_data_out)
);

hazard_checker _hazard_checker(
    .ID_idx1(ID_idx1_out),
    .ID_idx2(ID_idx2_out),
    .alu_op_flag(ID_use_alu_out),
    .EX_dst(EX_dst_idx_reg),
    .EX_reg_write(EX_reg_write_reg),
    .nop_flag(nop_flag)
);

branch_check _branch_check(
    .branch_flag(branch_flag),
    .jmp_flag(jmp_flag),
    .data1(ID_data1_out),
    .data2(ID_data2_out),
    .imm(ID_imm_out),
    .func3(ID_func3_out),
    .branch(branch),
    .jmp(jmp),
    .offset(pc_offset)
);




ID_EX_reg _ID_EX_reg(
    .cpu_clk(cpu_clk),
    .rst(rst),
    .nop_in(IF_nop),
    .sr_ctrl(ID_sr_ctrl),
    .idx_sw_in(ID_sw_idx_out),
    .dst_in(ID_dst_idx_out),
    .data1_in(ID_data1_out),
    .data2_in(ID_data2_out),
    .sw_data_in(ID_sw_data_out),
    .func3_in(ID_func3_out),
    .func7_in(ID_func7_out),
    .mem_op_in(ID_mem_op_out),
    .reg_write_in(ID_reg_write_out),
    .mem_write_in(ID_mem_write_out),
    .imm_in(ID_imm_out),
    .use_imm_in(ID_use_imm_out),
    
    .nop_out(ID_nop),
    .idx_sw_out(EX_sw_idx_reg),
    .dst_out(EX_dst_idx_reg),
    .data1_out(EX_data1_reg),
    .data2_out(EX_data2_reg),
    .sw_data_out(EX_sw_data_reg),
    .func3_out(EX_func3_reg),
    .func7_out(EX_func7_reg),
    .mem_op_out(EX_mem_op_reg),
    .reg_write_out(EX_reg_write_reg),
    .mem_write_out(EX_mem_write_reg),
    .imm_out(EX_imm_reg),
    .use_imm_out(EX_use_imm_reg)
);



ALU _ALU(
    .func3(EX_func3_reg),
    .func7(EX_func7_reg),
    .use_imm(EX_use_imm_reg),
    .data1(EX_data1_reg),
    .data2(EX_data2_reg),
    .imm(EX_imm_reg),
    .res(EX_alu_result_out)
);



EX_forward _EX_forward(
    .EX_idx(EX_sw_idx_reg),
    .EX_data(EX_sw_data_reg),
    .mem_dst(mem_dst_idx_reg),
    .mem_alu_result(mem_alu_result_reg),
    .mem_mem_result(mem_mem_data_out),
    .mem_reg_write(mem_reg_write_reg),
    .WB_dst(WB_dst_idx_reg),
    .WB_alu_result(WB_alu_result_reg),
    .WB_mem_result(WB_mem_data_reg),
    .WB_reg_write(WB_reg_write_reg),
    .res_data(EX_sw_data_out)
);



EX_mem_reg _EX_mem_reg(
    .cpu_clk(cpu_clk),
    .rst(rst),
    .sr_ctrl(EX_sr_ctrl),
    .nop_in(ID_nop),
    .dst_in(EX_dst_idx_reg),
    .alu_result_in(EX_alu_result_out),
    .sw_data_in(EX_sw_data_out),
    .mem_op_in(EX_mem_op_reg),
    .reg_write_in(EX_reg_write_reg),
    .mem_write_in(EX_mem_write_reg),
    
    .nop_out(EX_nop),
    .dst_out(mem_dst_idx_reg),
    .alu_result_out(mem_alu_result_reg),
    .sw_data_out(mem_sw_data_reg),
    .mem_op_out(mem_mem_op_reg),
    .reg_write_out(mem_reg_write_reg),
    .mem_write_out(mem_mem_write_reg)
);



memory _memory(
    .clk(cpu_clk),
    .rst(rst & (~local_rst)),
    .write_flag(mem_mem_write_reg),
    .mem_op(mem_mem_op_reg),
    .addr(mem_alu_result_reg),
    .data_in(mem_sw_data_reg),
    .input_data(idata),
    .uart_clk(uart_clk_o),
    .uart_enable(mem_enable),
    .uart_data(uart_data),
    .uart_addr(uart_addr),
    .uart_done(uart_done),
    .res(mem_mem_data_out),
    .output_data(odata)
);


mem_WB_reg _mem_WB_reg(
    .cpu_clk(cpu_clk),
    .rst(rst),
    .nop_in(EX_nop),
    .sr_ctrl(mem_sr_ctrl),
    .dst_in(mem_dst_idx_reg),
    .alu_data_in(mem_alu_result_reg),
    .mem_data_in(mem_mem_data_out),
    .reg_write_in(mem_reg_write_reg),
    .nop_out(mem_nop),
    .dst_out(WB_dst_idx_reg),
    .alu_data_out(WB_alu_result_reg),
    .mem_data_out(WB_mem_data_reg),
    .reg_write_out(WB_reg_write_reg)
    
);






endmodule
