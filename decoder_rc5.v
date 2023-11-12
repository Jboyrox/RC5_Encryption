`timescale 1ns / 1ps
`default_nettype none

module decoder_rc5(
    
    input wire clk,
    input wire rst,
    input wire [63:0] d_in,
    output reg [63:0] d_out
    );
    
    reg [3:0] i_cnt;
    wire [31:0] ab_xor;
    wire [31:0] a_rot;
    wire [31:0] a;
    reg [31:0] a_reg;
    
    wire [31:0] ba_xor; 
    wire [31:0] b_rot;
    wire [31:0] b;
    reg [31:0] b_reg;
    
    reg [31:0] rom [2:25];
    
    initial begin
        rom[2] = 32'h46F8E8C5;
        rom[3] = 32'h460C6085;
        rom[4] = 32'h70F83B8A;
        rom[5] = 32'h284B8303;
        rom[6] = 32'h513E1454;
        rom[7] = 32'hF621ED22;
        rom[8] = 32'h3125065D;
        rom[9] = 32'h11A83A5D;
        rom[10] = 32'hD427686B;
        rom[11] = 32'h713AD82D;
        rom[12] = 32'h4B792F99;
        rom[13] = 32'h2799A4DD;
        rom[14] = 32'hA7901C49;
        rom[15] = 32'hDEDE871A;
        rom[16] = 32'h36C03196;
        rom[17] = 32'hA7EFC249;
        rom[18] = 32'h61A78BB8;
        rom[19] = 32'h3B0A1D2B;
        rom[20] = 32'h4DBFCA76;
        rom[21] = 32'hAE162167;
        rom[22] = 32'h30D76B0A;
        rom[23] = 32'h43192304;
        rom[24] = 32'hF6CC1431;
        rom[25] = 32'h65046380;
    end 
    reg [2:0] s=3'b000;
    
    assign b = b_reg - rom[{i_cnt,1'b1}];
    
    assign b_rot =(a_reg[4:0] == 5'b00001) ? {b[0], b[31:1]}:
                  (a_reg[4:0] == 5'b00010) ? {b[1:0], b[31:2]}:
                  (a_reg[4:0] == 5'b00011) ? {b[2:0], b[31:3]}:
                  (a_reg[4:0] == 5'b00100) ? {b[3:0], b[31:4]}:
                  (a_reg[4:0] == 5'b00101) ? {b[4:0], b[31:5]}:
                  (a_reg[4:0] == 5'b00110) ? {b[5:0], b[31:6]}:
                  (a_reg[4:0] == 5'b00111) ? {b[6:0], b[31:7]}:
                  (a_reg[4:0] == 5'b01000) ? {b[7:0], b[31:8]}:
                  (a_reg[4:0] == 5'b01001) ? {b[8:0], b[31:9]}:
                  (a_reg[4:0] == 5'b01010) ? {b[9:0], b[31:10]}:
                  (a_reg[4:0] == 5'b01011) ? {b[10:0], b[31:11]}:
                  (a_reg[4:0] == 5'b01100) ? {b[11:0], b[31:12]}:
                  (a_reg[4:0] == 5'b01101) ? {b[12:0], b[31:13]}:
                  (a_reg[4:0] == 5'b01110) ? {b[13:0], b[31:14]}:
                  (a_reg[4:0] == 5'b01111) ? {b[14:0], b[31:15]}:
                  (a_reg[4:0] == 5'b10000) ? {b[15:0], b[31:16]}:
                  (a_reg[4:0] == 5'b10001) ? {b[16:0], b[31:17]}:
                  (a_reg[4:0] == 5'b10010) ? {b[17:0], b[31:18]}:
                  (a_reg[4:0] == 5'b10011) ? {b[18:0], b[31:19]}:
                  (a_reg[4:0] == 5'b10100) ? {b[19:0], b[31:20]}:
                  (a_reg[4:0] == 5'b10101) ? {b[20:0], b[31:21]}:
                  (a_reg[4:0] == 5'b10110) ? {b[21:0], b[31:22]}:
                  (a_reg[4:0] == 5'b10111) ? {b[22:0], b[31:23]}:
                  (a_reg[4:0] == 5'b11000) ? {b[23:0], b[31:24]}:
                  (a_reg[4:0] == 5'b11001) ? {b[24:0], b[31:25]}:
                  (a_reg[4:0] == 5'b11010) ? {b[25:0], b[31:26]}:
                  (a_reg[4:0] == 5'b11011) ? {b[26:0], b[31:27]}:
                  (a_reg[4:0] == 5'b11100) ? {b[27:0], b[31:28]}:
                  (a_reg[4:0] == 5'b11101) ? {b[28:0], b[31:29]}:
                  (a_reg[4:0] == 5'b11110) ? {b[29:0], b[31:30]}:
                  (a_reg[4:0] == 5'b11111) ? {b[30:0], b[31]}: 
                  b;
                  
    assign ba_xor = b_rot ^ a_reg;
    
    assign a = a_reg - rom[{i_cnt, 1'b0}];
    
    assign a_rot = (ba_xor[4:0] == 5'b00001)? {a[0], a[31:1]}:
                   (ba_xor[4:0] == 5'b00010)? {a[1:0], a[31:2]}:
                   (ba_xor[4:0] == 5'b00011)? {a[2:0], a[31:3]}:
                   (ba_xor[4:0] == 5'b00100)? {a[3:0], a[31:4]}:
                   (ba_xor[4:0] == 5'b00101)? {a[4:0], a[31:5]}:
                   (ba_xor[4:0] == 5'b00110)? {a[5:0], a[31:6]}:
                   (ba_xor[4:0] == 5'b00111)? {a[6:0], a[31:7]}:
                   (ba_xor[4:0] == 5'b01000)? {a[7:0], a[31:8]}:
                   (ba_xor[4:0] == 5'b01001)? {a[8:0], a[31:9]}:
                   (ba_xor[4:0] == 5'b01010)? {a[9:0], a[31:10]}:
                   (ba_xor[4:0] == 5'b01011)? {a[10:0], a[31:11]}:
                   (ba_xor[4:0] == 5'b01100)? {a[11:0], a[31:12]}:
                   (ba_xor[4:0] == 5'b01101)? {a[12:0], a[31:13]}:
                   (ba_xor[4:0] == 5'b01110)? {a[13:0], a[31:14]}:
                   (ba_xor[4:0] == 5'b01111)? {a[14:0], a[31:15]}:
                   (ba_xor[4:0] == 5'b10000)? {a[15:0], a[31:16]}:
                   (ba_xor[4:0] == 5'b10001)? {a[16:0], a[31:17]}:
                   (ba_xor[4:0] == 5'b10010)? {a[17:0], a[31:18]}:
                   (ba_xor[4:0] == 5'b10011)? {a[18:0], a[31:19]}:
                   (ba_xor[4:0] == 5'b10100)? {a[19:0], a[31:20]}:
                   (ba_xor[4:0] == 5'b10101)? {a[20:0], a[31:21]}:
                   (ba_xor[4:0] == 5'b10110)? {a[21:0], a[31:22]}:
                   (ba_xor[4:0] == 5'b10111)? {a[22:0], a[31:23]}:
                   (ba_xor[4:0] == 5'b11000)? {a[23:0], a[31:24]}:
                   (ba_xor[4:0] == 5'b11001)? {a[24:0], a[31:25]}:
                   (ba_xor[4:0] == 5'b11010)? {a[25:0], a[31:26]}:
                   (ba_xor[4:0] == 5'b11011)? {a[26:0], a[31:27]}:
                   (ba_xor[4:0] == 5'b11100)? {a[27:0], a[31:28]}:
                   (ba_xor[4:0] == 5'b11101)? {a[28:0], a[31:29]}:
                   (ba_xor[4:0] == 5'b11110)? {a[29:0], a[31:30]}:
                   (ba_xor[4:0] == 5'b11111)? {a[30:0], a[31]}: 
                   a;
    
    assign ab_xor = a_rot ^ ba_xor;
    
    
      
			always @(negedge rst or posedge clk)
			
			
			begin
			if(rst==0)
			begin
			a_reg <= d_in[63:32];
			b_reg <= d_in[31:0];
			i_cnt <= 4'b1100;
			s<=3'b000;
			end
			else
			case(s)
			0 : begin
			a_reg <= d_in[63:32];
			b_reg <= d_in[31:0];
			i_cnt <= 4'b1011;
			s<=3'b001;
			end
			1: begin 
			if(i_cnt==4'b0000)
			begin
			i_cnt=4'b1100;
			d_out<= {a, b};
			s<=3'b011;
			s<=3'b000;
			end
			
			else
			begin
			i_cnt<=i_cnt-4'b1;
			s<=3'b001;
			end
			end
			default : begin
				a_reg <= d_in[63:32];
			b_reg <= d_in[31:0];
			i_cnt <= 4'b1100;
			end
			endcase
			end
			
			endmodule