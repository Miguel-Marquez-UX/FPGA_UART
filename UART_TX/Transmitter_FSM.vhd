Library	IEEE;
use IEEE.std_logic_1164.all;

Entity Transmitter_FSM is 
	port( 
		RST : in  std_logic;
		CLK : in  std_logic;
		B   : in  std_logic;
		STT : in  std_logic;
		EOT : out std_logic;
		M   : out std_logic_vector(3 downto	0)
	);
end Transmitter_FSM;

Architecture Control of Transmitter_FSM is 

signal Qn, Qp : std_logic_vector(3 downto 0); -- Estados internos 

begin	 
	Combinational : process (Qp, STT, B)
	begin  
		case(Qp)is
			-- S0
			when "0000" =>
			if(STT = '0')then
				Qn <= Qp;
			else
				Qn <= "0001";
			end if;
			EOT <= '1';
			M   <= "1111";
			-- S1
			when "0001" =>
			if(B = '0')then
				Qn <= Qp;
			else 
				Qn <= "0010";
			end if;
			EOT <= '0';
			M <= "1111";
			-- S2
			when "0010" =>
			if(B = '0')then 
				Qn <= Qp;
			else
				Qn <= "0011";
			end if;
			EOT <= '0';
			M <= "0000";
			--S3
			when "0011" => 
			if(B = '0')then 
				Qn <= Qp;
			else
				Qn <= "0100";
			end if;
			EOT <= '0';
			M <= "0001"; 
			-- S4
			when "0100" =>
			if(B = '0')then 
				Qn <= Qp;
			else
				Qn <= "0101";
			end if;
			EOT <= '0';
			M <= "0010";
			-- S5
			when "0101" =>
			if(B = '0')then 
				Qn <= Qp;
			else
				Qn <= "0110";
			end if;
			EOT <= '0';
			M <= "0011";
			-- S6
			when "0110" =>
			if(B = '0')then 
				Qn <= Qp;
			else
				Qn <= "0111";
			end if;
			EOT <= '0';
			M <= "0100";
			-- S7 
			when "0111" =>
			if(B = '0')then 
				Qn <= Qp;
			else
				Qn <= "1000";
			end if;
			EOT <= '0';
			M <= "0101";
			-- S8
			when "1000" => 
			if(B = '0')then 
				Qn <= Qp;
			else
				Qn <= "1001";
			end if;
			EOT <= '0';
			M <= "0110"; 
			-- S9
			when "1001" =>
			if(B = '0')then 
				Qn <= Qp;
			else
				Qn <= "1010";
			end if;
			EOT <= '0';
			M <= "0111"; 
			-- S10
			when "1010" =>
			if(B = '0')then 
				Qn <= Qp;
			else
				Qn <= "1011";
			end if;
			EOT <= '0';
			M <= "1000";
			-- S11
			when "1011" =>
			if(B = '0')then 
				Qn <= Qp;
			else
				Qn <= "0000";
			end if;
			EOT <= '0';
			M <= "1001";
			when others => 
			Qn  <= "0000";
			EOT <= '0';
			M   <= "1111";
		end case;	
	end process Combinational; 
	
	Sequential : process (CLK, RST, Qn)
	begin  
		if(RST = '0')then
			Qp <= "0000";
		elsif(CLK'event and CLK = '1')then
			Qp <= Qn;
		end if;
	end process Sequential;	
	
end Control;
