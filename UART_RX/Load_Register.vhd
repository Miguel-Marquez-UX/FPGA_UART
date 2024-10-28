 Library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_arith.all;
 
 Entity LoadRegister is
	 port(
	 RST: in std_logic;	--Reset Asincrono
	 CLK: in std_logic;	--Relog Maestro
	 LDR: in std_logic;	--Enable del MUX
	 DIN: in std_logic_vector(7 downto 0);	--Dato de Entrada
	 DOUT: out std_Logic_vector(7 downto 0)	--Dato de Salida
	 );
 end LoadRegister;
 
 Architecture Behavioral of LoadRegister is
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
	 
	 
	 