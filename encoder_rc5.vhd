----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2023 03:14:27 PM
-- Design Name: 
-- Module Name: simple - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity encoder_rc5 is
 Port (
  rst : IN STD_LOGIC;
  clk : IN STD_LOGIC;
  d_in : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
  di_vid: IN    STD_LOGIC;
  d_out : OUT  STD_LOGIC_VECTOR(63 DOWNTO 0);
  do_ready : IN STD_LOGIC
  );
end encoder_rc5;

architecture Behavioral of encoder_rc5 is
SIGNAL i_cnt : STD_LOGIC_VECTOR(3 DOWNTO 0); -- round counter
SIGNAL ab_xor : STD_LOGIC_VECTOR(31 DOWNTO 0); SIGNAL a_rot : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL a : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL a_pre : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL a_reg : STD_LOGIC_VECTOR(31 DOWNTO 0); -- register A
SIGNAL ba_xor: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL b_rot : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL b : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL b_pre : STD_LOGIC_VECTOR(31 DOWNTO 0); 
SIGNAL b_reg : STD_LOGIC_VECTOR(31 DOWNTO 0); -- register B
-- define a type for round keys
TYPE rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
--instantiate round key rom with 26 round keys
CONSTANT skey : rom:=rom'(X"FFFFFFFF", X"FFFFFFFF", X"46F8E8C5",
X"460C6085", X"70F83B8A", X"284B8303", X"513E1454", X"F621ED22",
X"3125065D", X"11A83A5D", X"D427686B", X"713AD82D", X"4B792F99",
X"2799A4DD", X"A7901C49", X"DEDE871A", X"36C03196", X"A7EFC249",
X"61A78BB8", X"3B0A1D2B", X"4DBFCA76", X"AE162167", X"30D76B0A",
X"43192304", X"F6CC1431", X"65046380");
-- Simple state machine
TYPE StateType IS (S1 , 
S2, -- In this state the simple pre round operation is performed
S3);
SIGNAL state: StateType;

begin
-- a operation
ab_xor <= a_reg XOR b_reg;
WITH b_reg(4 DOWNTO 0) SELECT
a_rot<=ab_xor(30 DOWNTO 0) & ab_xor(31) WHEN "00001",
ab_xor(29 DOWNTO 0) & ab_xor(31 DOWNTO 30) WHEN "00010", 
ab_xor(28 DOWNTO 0) & ab_xor(31 DOWNTO 29) WHEN "00011",
ab_xor(27 DOWNTO 0) & ab_xor(31 DOWNTO 28) WHEN "00100",
ab_xor(26 DOWNTO 0) & ab_xor(31 DOWNTO 27) WHEN "00101",
ab_xor(25 DOWNTO 0) & ab_xor(31 DOWNTO 26) WHEN "00110", 
ab_xor(24 DOWNTO 0) & ab_xor(31 DOWNTO 25) WHEN "00111", 
ab_xor(23 DOWNTO 0) & ab_xor(31 DOWNTO 24) WHEN "01000", 
ab_xor(22 DOWNTO 0) & ab_xor(31 DOWNTO 23) WHEN "01001", 
ab_xor(21 DOWNTO 0) & ab_xor(31 DOWNTO 22) WHEN "01010",
ab_xor(20 DOWNTO 0) & ab_xor(31 DOWNTO 21) WHEN "01011", 
ab_xor(19 DOWNTO 0) & ab_xor(31 DOWNTO 20) WHEN "01100", 
ab_xor(18 DOWNTO 0) & ab_xor(31 DOWNTO 19) WHEN "01101", 
ab_xor(17 DOWNTO 0) & ab_xor(31 DOWNTO 18) WHEN "01110",
ab_xor(16 DOWNTO 0) & ab_xor(31 DOWNTO 17) WHEN "01111",
ab_xor(15 DOWNTO 0) & ab_xor(31 DOWNTO 16) WHEN "10000", 
ab_xor(14 DOWNTO 0) & ab_xor(31 DOWNTO 15) WHEN "10001", 
ab_xor(13 DOWNTO 0) & ab_xor(31 DOWNTO 14) WHEN "10010", 
ab_xor(12 DOWNTO 0) & ab_xor(31 DOWNTO 13) WHEN "10011", 
ab_xor(11 DOWNTO 0) & ab_xor(31 DOWNTO 12) WHEN "10100", 
ab_xor(10 DOWNTO 0) & ab_xor(31 DOWNTO 11) WHEN "10101", 
ab_xor(9 DOWNTO 0) & ab_xor(31 DOWNTO 10) WHEN "10110",
ab_xor(8 DOWNTO 0) & ab_xor(31 DOWNTO 9) WHEN "10111", 
ab_xor(7 DOWNTO 0) & ab_xor(31 DOWNTO 8) WHEN "11000", 
ab_xor(6 DOWNTO 0) & ab_xor(31 DOWNTO 7) WHEN "11001", 
ab_xor(5 DOWNTO 0) & ab_xor(31 DOWNTO 6) WHEN "11010", 
ab_xor(4 DOWNTO 0) & ab_xor(31 DOWNTO 5) WHEN "11011", 
ab_xor(3 DOWNTO 0) & ab_xor(31 DOWNTO 4) WHEN "11100", 
ab_xor(2 DOWNTO 0) & ab_xor(31 DOWNTO 3) WHEN "11101",
ab_xor(1 DOWNTO 0) & ab_xor(31 DOWNTO 2) WHEN "11110", 
ab_xor(0) & ab_xor(31 DOWNTO 1) WHEN "11111",
ab_xor WHEN OTHERS;

a<=a_rot + skey(CONV_INTEGER(i_cnt & '0')); -- S[2*i]

-- b operation 
ba_xor <= b_reg XOR a;
WITH a(4 DOWNTO 0) SELECT
b_rot<=ba_xor(30 DOWNTO 0) & ba_xor(31) WHEN "00001",
ba_xor(29 DOWNTO 0) & ba_xor(31 DOWNTO 30) WHEN "00010", 
ba_xor(28 DOWNTO 0) & ba_xor(31 DOWNTO 29) WHEN "00011",
ba_xor(27 DOWNTO 0) & ba_xor(31 DOWNTO 28) WHEN "00100",
ba_xor(26 DOWNTO 0) & ba_xor(31 DOWNTO 27) WHEN "00101",
ba_xor(25 DOWNTO 0) & ba_xor(31 DOWNTO 26) WHEN "00110", 
ba_xor(24 DOWNTO 0) & ba_xor(31 DOWNTO 25) WHEN "00111", 
ba_xor(23 DOWNTO 0) & ba_xor(31 DOWNTO 24) WHEN "01000", 
ba_xor(22 DOWNTO 0) & ba_xor(31 DOWNTO 23) WHEN "01001", 
ba_xor(21 DOWNTO 0) & ba_xor(31 DOWNTO 22) WHEN "01010",
ba_xor(20 DOWNTO 0) & ba_xor(31 DOWNTO 21) WHEN "01011", 
ba_xor(19 DOWNTO 0) & ba_xor(31 DOWNTO 20) WHEN "01100", 
ba_xor(18 DOWNTO 0) & ba_xor(31 DOWNTO 19) WHEN "01101", 
ba_xor(17 DOWNTO 0) & ba_xor(31 DOWNTO 18) WHEN "01110",
ba_xor(16 DOWNTO 0) & ba_xor(31 DOWNTO 17) WHEN "01111",
ba_xor(15 DOWNTO 0) & ba_xor(31 DOWNTO 16) WHEN "10000", 
ba_xor(14 DOWNTO 0) & ba_xor(31 DOWNTO 15) WHEN "10001", 
ba_xor(13 DOWNTO 0) & ba_xor(31 DOWNTO 14) WHEN "10010", 
ba_xor(12 DOWNTO 0) & ba_xor(31 DOWNTO 13) WHEN "10011", 
ba_xor(11 DOWNTO 0) & ba_xor(31 DOWNTO 12) WHEN "10100", 
ba_xor(10 DOWNTO 0) & ba_xor(31 DOWNTO 11) WHEN "10101", 
ba_xor(9 DOWNTO 0) & ba_xor(31 DOWNTO 10) WHEN "10110",
ba_xor(8 DOWNTO 0) & ba_xor(31 DOWNTO 9) WHEN "10111", 
ba_xor(7 DOWNTO 0) & ba_xor(31 DOWNTO 8) WHEN "11000", 
ba_xor(6 DOWNTO 0) & ba_xor(31 DOWNTO 7) WHEN "11001", 
ba_xor(5 DOWNTO 0) & ba_xor(31 DOWNTO 6) WHEN "11010", 
ba_xor(4 DOWNTO 0) & ba_xor(31 DOWNTO 5) WHEN "11011", 
ba_xor(3 DOWNTO 0) & ba_xor(31 DOWNTO 4) WHEN "11100", 
ba_xor(2 DOWNTO 0) & ba_xor(31 DOWNTO 3) WHEN "11101",
ba_xor(1 DOWNTO 0) & ba_xor(31 DOWNTO 2) WHEN "11110", 
ba_xor(0) & ba_xor(31 DOWNTO 1) WHEN "11111",
ba_xor WHEN OTHERS;
b<=b_rot + skey(CONV_INTEGER(i_cnt & '1')); -- S[2*i+1]
PROCESS(rst, clk) 
BEGIN
if(rst='0') then
state <= S1;
a_reg<=d_in(63 downto 32);
b_reg<=d_in(31 downto 0);
i_cnt<="0000";
elsif (clk'EVENT AND clk='1') THEN
a_reg<=a;
b_reg<=b;
if(state=S1) THEN
state <=S2;
a_reg<=d_in(63 downto 32);
b_reg<=d_in(31 downto 0);
i_cnt<="0001";

elsif (state=S2) then 
if(i_cnt="1100") then
i_cnt<="0000";
state <=S3;
state <= S1;
d_out<=a&b;
else 
i_cnt<=i_cnt +1;
state <= S2;
end if;


else
state <=S2;
a_reg<=d_in(63 downto 32);
b_reg<=d_in(31 downto 0);
i_cnt <= "0001";
end if;
end if;
end process;
end Behavioral;
