Library IEEE;
use IEEE.std_logic_1164.all;

Entity Receiver_FSM is
	port( RST : in  std_logic;
	      CLK : in  std_logic;
	      RXD : in  std_logic;  -- Pin de entrada serial
	      EDG : in  std_logic;  -- Señal de contador (Baud) termindo 
	      BTC : in  std_logic;  -- Contador de estados terminado 
	      STC : out std_logic;  -- Habilitador contador (Baud)
	      ETC : out std_logic;  -- Habilitador bus target counter (contador de estados) 
	      LDO : out std_logic;  -- Habilitador de registro de carga para valor final 
	      SHF : out std_logic;  -- Habilitador registro de desplazamiento 
	      STT : out std_logic); -- se mantiene en alto hasta que recibe el bit de entrada de datos RXD 1 -> 0	 
end Receiver_FSM;
	
	Architecture Behavioral of Receiver_FSM is
	TYPE StateType IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18);
	signal Sp, Sn: StateType;
	begin
		Combinatonal: Process(Sp, RXD, EDG, BTC)
		begin
			Case Sp is
				when S0 =>
					STC <= '0';
					LDO <= '0';
					SHF <= '0';	
					STT <= '1';
					ETC <= '0';
					if(RXD = '0')then
						Sn <= S1;
					else
						Sn <= S0;	
					end if;
				when S1 =>             -- Inicio del ciclo de lectura bit a bit
				    if(BTC = '1')then  -- si se terminaron los estados entonces 
				        Sn <= S6;      -- se salta al estado de bit de paro
				    else
				        Sn <= S2;      -- estado consecuente 
				    end if;
					STC <= '0';
					LDO <= '0';
					SHF <= '0';
					STT <= '0';
					ETC <= '1';
				when S2 => -- Estado espera 1 
					STC <= '1';
					LDO <= '0';
					SHF <= '0';
					STT <= '0';
					ETC <= '0';
					if(EDG = '1')then
						Sn <= S3;
					else
						Sn <= S2;
					end if;
				 when S3 => -- Estado muerto 2 
					 STC <= '0';
					 LDO <= '0';
					 SHF <= '0';
					 STT <= '0';
					 ETC <= '0';
					 Sn  <= S4;
				 when S4 => -- Estado espera 2
					 STC <= '1';
					 LDO <= '0';
					 SHF <= '0';
					 STT <= '0';
					 ETC <= '0';
					 if(EDG = '1')then
						 Sn <= S5;
					 else
						 Sn <= S4;
					 end if;
				 when S5 => -- Lectura de bit
					 STC <= '0';
					 LDO <= '0';
					 SHF <= '1';
					 STT <= '0';
					 ETC <= '0';
					 Sn  <= S1;	-- Regresa a estado inicial del ciclo 
			     when S6=> -- Nulo
                     STC <= '0';
                     LDO <= '0';
                     SHF <= '0';
                     STT <= '0';
                     ETC <= '0';
                     Sn  <= S7;   
                 when S7 => -- Espera 
                     STC <= '1';
                     LDO <= '0';
                     SHF <= '0';
					 STT <= '0';
					 ETC <= '0';
                     if(EDG = '1')then
						 Sn <= S8;
					 else
						 Sn <= S7;
					 end if;
				 when S8 => -- Nulo
					 STC <= '0';
					 LDO <= '0';
					 SHF <= '0';
					 STT <= '0';
					 ETC <= '0';
					 Sn  <= S9;
                 when S9 => -- Espera 
                     STC <= '1';
                     LDO <= '0';
                     SHF <= '0';
			         STT <= '0';
			         ETC <= '0';
                     if(EDG = '1')then
                         Sn <= S10;
                     else
                         Sn <= S9;
                     end if;
                 when S10 => -- Nulo
                     STC <= '0';
                     LDO <= '0';
                     SHF <= '0';
                     STT <= '0';
                     ETC <= '0';
                     Sn  <= S11; 
                 when S11 => -- Nulo
                     STC <= '0';
                     LDO <= '0';
                     SHF <= '0';
                     STT <= '0';
                     ETC <= '0';
                     Sn  <= S12; 
                 when S12 => -- Espera 
                     STC <= '1';
                     LDO <= '0';
                     SHF <= '0';
                     STT <= '0';
                     ETC <= '0';
                     if(EDG = '1')then
                        Sn <= S13;
                     else
                        Sn <= S12;
                     end if;
                 when S13 => -- Nulo
                     STC <= '0';
                     LDO <= '0';
                     SHF <= '0';
                     STT <= '0';
                     ETC <= '0';
                     Sn  <= S14; 
                 when S14 => -- Espera 
                     STC <= '1';
                     LDO <= '0';
                     SHF <= '0';
                     STT <= '0';
                     ETC <= '0';
                     if(EDG = '1')then
                        Sn <= S15;
                     else
                        Sn <= S14;
                     end if;
                 when S15 => -- bit de paro
                     STC <= '0';
                     LDO <= '0';
                     SHF <= '0';
				     STT <= '0';
				     ETC <= '0';
                     Sn <= S16;
				 when S16 => -- Nulo
				     STC <= '0';
				     LDO <= '0';
					 SHF <= '0';
					 STT <= '0';
					 ETC <= '0';
					 Sn <= S17; 
				 when S17 => -- Guardar valor final en registro de carga 
					 STC <= '0';
					 LDO <= '1';
					 SHF <= '0';
					 STT <= '0';
					 ETC <= '0';
					 Sn <= S18;
				 when others => -- Reiniciar 
					 STC <= '0';
					 LDO <= '0';
				     SHF <= '0';
					 STT <= '0';
					 ETC <= '0';
					 Sn <= S0;
        end case;
	end process Combinatonal;
	
    Sequential: Process(RST, CLK, Sn)
	begin
		if RST='0' then
			Sp<=S0;
		elsif CLK'event and CLK='1' then
			Sp<=Sn;
		end if;
	end process Sequential;
	
	end Behavioral;