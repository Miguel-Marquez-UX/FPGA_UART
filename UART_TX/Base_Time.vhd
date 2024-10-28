Library	IEEE;
use IEEE.std_logic_1164.all;  
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

Entity Base_Time is -- (9600[baud]) 10416
		port(  
		RST : in  std_logic;
		CLK : in  std_logic;
		B   : out std_logic
		);
end Base_Time; 

Architecture Structural of Base_Time is

signal Qn, Qp : std_logic_vector(13 downto 0);

begin  
	Combinational : process (Qp)
	begin
		if(Qp = "00000000000000")then
			B  <= '1';
			Qn <= "10100010110000"; -- 10416 
		else 
			B  <= '0';
			Qn <= Qp - 1;
		end if;
	end process Combinational;
	
	Sequential : process (RST, CLK, Qn)
	begin  
		if(RST = '0')then
			Qp <= (others => '0');
		elsif(CLK'event and CLK = '1')then
			Qp <= Qn;
		end if;
	end process Sequential;	 
	
end Structural;
