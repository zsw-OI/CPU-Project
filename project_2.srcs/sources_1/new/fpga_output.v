`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/30 00:05:45
// Design Name: 
// Module Name: fpga_output
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


module fpga_output(
    input cpu_clk, 
    input [31:0] odata,
    output reg [3:0]sel1, 
    output reg [3:0]sel2, 
    output reg [7:0]seg_ctrl1, 
    output reg [7:0] seg_ctrl2
    );
    wire integer num[7:0];
    assign num[0] = odata[3:0];
    assign num[1] = odata[7:4];
    assign num[2] = odata[11:8];
    assign num[3] = odata[15:12];
    assign num[4] = odata[19:16];
    assign num[5] = odata[23:20];
    assign num[6] = odata[27:24];
    assign num[7] = odata[31:28];
    
    reg tclk=1'b0;
    reg [25:0] ct;
    parameter period=50000;
    always @(posedge cpu_clk)
    begin
        
        if(ct>=(period/2)-1)
        begin
            ct<=0;
            tclk<=~tclk;
        end
        else 
        begin
            ct<=ct+1;
        end
    end
    reg [2:0]cnt=0;
    integer i;
    always@(posedge tclk)
        begin
            if(cnt==3)
                cnt<=0;
            else cnt<=cnt+1;
            for(i=0;i<=3;i=i+1)
                if(cnt==i)
                begin
                    sel1[i]<=1'b1;
                    sel2[i]<=1'b1;
                end
                else
                begin
                    sel1[i]<=1'b0;
                    sel2[i]<=1'b0;
                end
           case(num[cnt])
                0: seg_ctrl1 <= 8'b00111111;  // Display '0'
                1: seg_ctrl1 <= 8'b00000110;  // Display '1' 
                2: seg_ctrl1 <= 8'b01011011;  // Display '2'
                3: seg_ctrl1 <= 8'b01001111;  // Display '3'
                4: seg_ctrl1 <= 8'b01100110;  // Display '4'
                5: seg_ctrl1 <= 8'b01101101;  // Display '5'
                
                
                6: seg_ctrl1 <= 8'b01111101;  // Display '6'
                7: seg_ctrl1 <= 8'b00000111;  // Display '7'
                8: seg_ctrl1 <= 8'b01111111;  // Display '8'
                9: seg_ctrl1 <= 8'b01101111;  // Display '9'
                10: seg_ctrl1 <= 8'b11111111; 
                11: seg_ctrl1 <= 8'b11111111; 
                12: seg_ctrl1 <= 8'b11111111; 
                13: seg_ctrl1 <= 8'b11111111; 
                14: seg_ctrl1 <= 8'b11111111; 
                15: seg_ctrl1 <= 8'b11111111; 
                default: seg_ctrl1 <= 8'b00000000;  // Display nothing
          
           endcase
           case(num[cnt+4])
               0: seg_ctrl2 <= 8'b00111111;  // Display '0'
               1: seg_ctrl2 <= 8'b00000110;  // Display '1' 
               2: seg_ctrl2 <= 8'b01011011;  // Display '2'
               3: seg_ctrl2 <= 8'b01001111;  // Display '3'
               4: seg_ctrl2 <= 8'b01100110;  // Display '4'
               5: seg_ctrl2 <= 8'b01101101;  // Display '5'
               6: seg_ctrl2 <= 8'b01111101;  // Display '6'
               7: seg_ctrl2 <= 8'b00000111;  // Display '7'
               8: seg_ctrl2 <= 8'b01111111;  // Display '8'
               9: seg_ctrl2 <= 8'b01101111;  // Display '9'
               10: seg_ctrl1 <= 8'b11111111; 
               11: seg_ctrl1 <= 8'b11111111; 
               12: seg_ctrl1 <= 8'b11111111; 
               13: seg_ctrl1 <= 8'b11111111; 
               14: seg_ctrl1 <= 8'b11111111; 
               15: seg_ctrl1 <= 8'b11111111; 
               default: seg_ctrl2 <= 8'b00000000;  // Display nothing
           endcase
            
        end

endmodule
