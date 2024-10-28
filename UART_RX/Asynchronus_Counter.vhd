Library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;
 -- (1/(9600 * 2)) / 10x10-9 = 5208
 -- (1/(19200 * 2)) / 10x10-9 = 2604
 Entity Asynchronus_Counter is
	 generic (n: integer :=	2604); 
	 port(
	 RST: in std_logic;
	 CLK: in std_logic;
	 STT: in std_logic;
	 ENG: out std_logic
	 );
 end Asynchronus_Counter;
 
 Architecture Behavioral of Asynchronus_Counter is
 Signal Qp, Qn: integer;
 begin
	 Combinational: Process (Qp, STT)
	 begin
		 if STT='1' then														  
			 if Qp=(n-1) then
				 Qn<= 0;
				 ENG<='1';
			 else
				 Qn<=Qp+1;
				 ENG<='0';
			 end if;
			 else
				 Qn<=Qp;
				 ENG<='0';
			 end if;
			 end Process Combinational;
			 
	 Sequential: process (CLK, RST,Qn)
	 begin
		 if(RST='0') then 
			 Qp<=0;
		 elsif (CLK'event and CLK='1') then
			 Qp<=Qn;
		 end if;
		 end process Sequential;
end Behavioral;