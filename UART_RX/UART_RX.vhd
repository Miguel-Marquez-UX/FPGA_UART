Library IEEE;
use IEEE.std_logic_1164.all;

Entity UART_RX is
    port( RST  : in  std_logic;
	      CLK  : in  std_logic;
	      RXD  : in  std_logic;
	      STT  : out std_logic;
	      --PRT  : out std_logic;
	      LEDS : out std_logic_vector(7 downto 0));
end UART_RX;

Architecture Structural of UART_RX is 
--Components Declaration------------------------

Component Receiver_FSM is
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
end Component;

 Component Asynchronus_Counter is
	 generic (n: integer :=	1302); 
	 port(
	 RST: in std_logic;
	 CLK: in std_logic;
	 STT: in std_logic;
	 ENG: out std_logic
	 );
 end Component;	
 
 Component ShiftRegister is 
  port(
  RST: in std_logic;
  CLK: in std_logic;
  SHF: in std_logic;
  BIN: in std_logic;
  DOUT : out std_logic_vector(7 downto 0)
  ); 
end Component;

Component LoadRegister is
	 port(
	 RST: in std_logic;	--Reset Asincrono
	 CLK: in std_logic;	--Relog Maestro
	 LDR: in std_logic;	--Enable del MUX
	 DIN: in std_logic_vector(7 downto 0);	--Dato de Entrada
	 DOUT: out std_Logic_vector(7 downto 0)	--Dato de Salida
	 );
end Component;	

-- Component Parity is
--	 generic (n : integer := 8);
--	 port(
--	 DIN : in std_logic_vector(n-1 downto 0);
--	 PTY : out std_logic
--	 );
-- end Component;	
 
Component Bus_Target_Counter is
	generic( n : integer := 10 );
	port( RST : in  std_logic;
	      CLK : in  std_logic;
	      ENI : in  std_logic;
	      DIN : in  std_logic_vector( n - 1 downto 0 );
	      CNT : out std_logic_vector( n - 1 downto 0 );
	      ENO : out std_logic );
end component;	
 
--Signal Declaration----------------------------- 
signal edgrx : std_logic;
signal stcrx : std_logic;  
signal ldo : std_logic;
signal shf : std_logic;
signal rxin: std_logic_vector(7 downto 0); 
signal rxout: std_logic_vector(7 downto 0);
signal FC, EC : std_logic; -- Contador de estados finalizado y habilitador 

begin
	--Concurrent Declarations------------------------- 
	LEDS <= rxout;
	STT  <= ldo;
	--Components Instances-----------------------------
	-- modifique el STT de la fsm para usarlo como aviso de que ya tiene el valor en el registro de carga guardado 
	U01 : Receiver_FSM port map(RST, CLK, RXD, edgrx, FC, stcrx, EC, ldo, shf, open);	
	U02 : Asynchronus_Counter generic map (5208) port map(RST, CLK, stcrx, edgrx);
	U03 : ShiftRegister port map(RST, CLK, shf, RXD, rxin); 
	U04 : LoadRegister port map(RST, CLK, ldo, rxin, rxout);
--	U06 : Parity port map(rxout, PRT);
	U07 : Bus_Target_Counter generic map (4) port map (RST, CLK, EC, "1000", open, FC); -- 1000 para 8 bits  
	
end Structural;