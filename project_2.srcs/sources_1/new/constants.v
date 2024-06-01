//`ifndef CONSTANTS
//`define CONSTANTS

parameter ALU_ADD = 4'b0000;
parameter ALU_SUB = 4'b1000;
parameter ALU_SLL = 4'b0001;
parameter ALU_LT  = 4'b0010;
parameter ALU_ULT = 4'b0011;
parameter ALU_XOR = 4'b0100;
parameter ALU_SRL = 4'b0101;
parameter ALU_SRA = 4'b1101;
parameter ALU_OR  = 4'b0110;
parameter ALU_AND = 4'b0111;
parameter ALU_SET2= 4'b1001;
parameter ALU_NOP = 4'b1100;

parameter FUN3_ADD = 3'b000;
parameter FUN3_SLL = 3'b001;
parameter FUN3_SLT = 3'b010;
parameter FUN3_ULT = 3'b011;
parameter FUN3_XOR = 3'b100;
parameter FUN3_SRL = 3'b101;
parameter FUN3_OR =  3'b110;
parameter FUN3_AND = 3'b111;

parameter FUN3_BEQ = 3'b000;
parameter FUN3_BNE = 3'b001;
parameter FUN3_BLT = 3'b100;
parameter FUN3_BGE = 3'b101;
parameter FUN3_BLTU = 3'b110;
parameter FUN3_BGEU = 3'b111;
parameter FUN3_SET2 = 3'b011;

parameter FUN7_SP = 7'b0100000; //0x20

parameter REG_ALU_W = 3'b100;
parameter REG_MEM_W = 3'b010;
parameter REG_PC_W =  3'b001; //unused

parameter OP_NOP = 7'b0000000;

parameter OP_R_type = 7'b0110011;

parameter OP_LUI = 7'b0110111;
parameter OP_AUIPC = 7'b0010111;

parameter OP_ALU = 7'b0010011;
parameter OP_LOAD = 7'b0000011;
parameter OP_JARL = 7'b1100111;
parameter OP_ENV =  7'b1110011;

parameter MEM_LB = 3'b000;
parameter MEM_LH = 3'b001;
parameter MEM_LW = 3'b010;
parameter MEM_LBU = 3'b100;
parameter MEM_LHU = 3'b101;
parameter MEM_IN = 3'b111;

parameter MEM_SB = 3'b000;
parameter MEM_SH = 3'b001;
parameter MEM_SW = 3'b010;
parameter MEM_OUT= 3'b100;

parameter MEM_NOP = 3'b111;

parameter SR_NORMAL = 2'b00;
parameter SR_REMAIN = 2'b01;
parameter SR_NOP = 2'b10;

parameter REG_A7 = 17;
parameter REG_A0 = 10;

parameter ADDR_OFFSET = 4'hfc10;

//`endif
