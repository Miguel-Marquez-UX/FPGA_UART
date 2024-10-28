-- Velocidad de transmición : 38400 baudios	(Divisor = 1302.0833...)
-- Datos por trama : 8 bits
-- Paridad : Par
Library	IEEE;
use IEEE.std_logic_1164.all;

Entity UART_TX is 	
   port( RST : in  std_logic;
         CLK : in  std_logic;
         STT : in  std_logic;                     -- Inicio de transmición
         D   : in  std_logic_vector(7 downto 0 ); -- Trama de datos  
         EOT : out std_logic;                     -- Información de fin de transmición 
         Tx  : out std_logic);                    -- Pin de transmición 
end UART_TX;

Architecture Structural of UART_TX is 

	Component Transmitter_FSM is
		port(
		RST : in  std_logic;
		CLK : in  std_logic;
		B   : in  std_logic;
		STT : in  std_logic;
		EOT : out std_logic;
		M   : out std_logic_vector(3 downto	0)
		);
	end Component;
	
	Component Base_Time is -- (1302)
		port(  
		RST : in  std_logic;
		CLK : in  std_logic;
		B   : out std_logic
		);
	end Component;
	
	Component Parity_Generator is 
		port(
		D : in  std_logic_vector(7 downto 0); 
		P : out std_logic	
		);
	end Component;
	
	Component Mux_11_1 is 
		port(
		M  : in  std_logic_vector(3 downto	0);
		D  : in  std_logic_vector(7 downto 0);
		P  : in  std_logic;
		Tx : out std_logic
		);
	end Component;
	
	signal P, B : std_logic;
	signal M    : std_logic_vector(3 downto	0);
	
begin 
	
	M01 : Transmitter_FSM  port map (RST, CLK, B, STT, EOT, M);
	M02 : Base_Time 	   port map (RST, CLK, B);
	M03 : Parity_Generator port map (D, P);
	M04 : Mux_11_1		   port map (M, D, P, Tx);
	
end Structural;
