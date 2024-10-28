----------------------------------------------------------------------------------
-- Company: Cerditos felices 
-- Engineer: Mikecrophone
-- 
-- Create Date: 11.12.2016 13:43:44
-- Design Name: 
-- Module Name: Load_Register - Structural
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
 Library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;
 
 Entity Load_Register is
 port(
	 RST: in std_logic;			-- Asynchronous Reset
	 CLK: in std_logic;			-- Master Clock
	 LDR: in std_logic;			-- MUX Enable
	 DIN: in std_logic_vector(7 downto 0);	-- Input Data
	 DOUT: out std_Logic_vector(7 downto 0)	-- Output Data
	 );
 end Load_Register;
 
 Architecture Behavioral of Load_Register is
 signal Qp, Qn : std_logic_vector(7 downto 0);
 begin
	 Combinational :Process(LDR, Qp, DIN)
	 begin
		 if LDR='1' then 
			 Qn<=DIN;
		 else
			 Qn<=Qp;
		 end if; 
			 DOUT<=Qp;
	 end Process Combinational;
	 Sequential : Process(RST, CLK, Qn)
	 begin
		 if RST='0' then
			 Qp <= (others => '0');
		 elsif CLK'event and CLK='1' then 
			 Qp <= Qn;		  
		 end if;
	end Process Sequential;
end Behavioral;
	 
	 
	 
