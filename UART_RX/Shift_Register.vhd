library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
 
Entity ShiftRegister is 
  port(
  RST: in std_logic;
  CLK: in std_logic;
  SHF: in std_logic;
  BIN: in std_logic;
  DOUT : out std_logic_vector(7 downto 0)
  ); 
end ShiftRegister;

Architecture Behavioral of ShiftRegister is 
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