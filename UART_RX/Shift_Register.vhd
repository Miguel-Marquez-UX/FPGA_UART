----------------------------------------------------------------------------------
-- Company: Cerditos felices 
-- Engineer: Mikecrophone
-- 
-- Create Date: 11.12.2016 13:43:44
-- Design Name: 
-- Module Name: Shift_Register - Structural
-- Project Name: UART_RX
-- Target Devices: Xilinx Artix - 7
-- Tool Versions: Vivado 2016
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
 
Entity Shift_Register is 
port(
	RST: in std_logic;
  	CLK: in std_logic;
  	SHF: in std_logic;
  	BIN: in std_logic;
  	DOUT : out std_logic_vector(7 downto 0)
  ); 
end Shift_Register;

Architecture Behavioral of Shift_Register is 
  signal Qp, Qn: std_logic_vector(8 downto 0):="000000000"; 
  begin 
   Combinational: process (SHF, BIN, Qp) 
   begin
	   if SHF = '1' then
		   Qn <= BIN & Qp(8 downto 1);
	   else
		   Qn <= Qp;
	   end if;
	   
	   DOUT<=Qp(8 downto 1);
    end process Combinational; 
	
	Sequential: Process(CLK, RST, Qp)
	begin
		if RST = '0' then
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
		end if;
	end Process Sequential;	
end Behavioral;
