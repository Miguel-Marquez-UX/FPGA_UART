----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.09.2016 12:50:46
-- Design Name: 
-- Module Name: Generic_Enabled_Counter - Behavioral
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

    Library IEEE;
 	use IEEE.std_logic_1164.all;
 	use IEEE.STD_LOGIC_ARITH.ALL;
     use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
 	Entity Generic_Enabled_Counter is  
	   generic ( n : integer := 4 );
	    port( RST: in std_logic;
	 	      CLK: in std_logic;
	 	      ENI: in std_logic;
	 	      --CNT: out std_logic_vector( n - 1 downto 0 )
	 	      ENO : out std_logic);
 	end Generic_Enabled_Counter;
 
 	 Architecture Behavioral of Generic_Enabled_Counter is
 	
	 signal Qn, Qp, aux : integer := 0;
     signal CMP : std_logic;
     signal SEL : std_logic_vector(1 downto 0);
	 begin
     
     aux <= n;
    	
     Sequential : process( CLK, RST, Qn )
     begin
         if( RST = '0' )then
             Qp <= 0;
         elsif( CLK'event AND CLK = '1' )then
             Qp <= Qn;
         end if;
     end process Sequential; 
     
     Combinational : process( ENI, Qp, CMP, SEL, aux )
     begin
         if( Qp = n )then
             CMP <= '1';
         else 
             CMP <= '0';
         end if;
         
         SEL <= ENI & CMP; -- concatenación de bits del MSB al lsb 
         
         case SEL is
             when "10"   => Qn <= Qp + 1;
             when "11"   => Qn <= 0;
             when others => Qn <= Qp; 
         end case; 
         
         ENO <= CMP and ENI;
         --CNT <= Qp;  
     end process Combinational; 
		
	end Behavioral;
