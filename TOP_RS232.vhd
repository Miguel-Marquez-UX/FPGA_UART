----------------------------------------------------------------------------------
-- Company: Cerditos felices 
-- Engineer: Mikecrophone
-- 
-- Create Date: 11.12.2016 13:43:44
-- Design Name: 
-- Module Name: TOP_RS232 - Structural
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP_RS232 is
    Port ( RST  : in  STD_LOGIC;
           CLK  : in  STD_LOGIC;
           --EN   : in  STD_LOGIC;
           RX_B : in  STD_LOGIC;
           --DATA : in  STD_LOGIC_VECTOR(7 downto 0);
           --LEDS : out STD_LOGIC_VECTOR(15 downto 0);
           TX_B : out STD_LOGIC );
end TOP_RS232;

architecture Structural of TOP_RS232 is

Component Transmitter_RS232 is 	
	port( 
RST : in  std_logic;
	      CLK : in  std_logic;
	      STT : in  std_logic; 					   -- Inicio de transmición
	      D   : in  std_logic_vector(7 downto 0 ); -- Trama de datos  
	      EOT : out std_logic; 					   -- Información de fin de transmición 
	      Tx  : out std_logic);	 			       -- Pin de transmición 
end component;

Component UART_RX_P6 is
    port( RST  : in  std_logic;
	      CLK  : in  std_logic;
	      RXD  : in  std_logic;
	      STT  : out std_logic;
	     -- PRT  : out std_logic;
	      LEDS : out std_logic_vector(7 downto 0));
end component;

Component Generic_Enabled_Counter is  
    generic ( n : integer := 4 );
	port( RST: in std_logic;
	 	  CLK: in std_logic;
	 	  ENI: in std_logic;
	 	  --CNT: out std_logic_vector( n - 1 downto 0 )
	 	  ENO : out std_logic);
end component;

Component Acquisition is
    Port ( RST  : in  STD_LOGIC;
           CLK  : in  STD_LOGIC;
           BIN  : in  STD_LOGIC_VECTOR(7 downto 0);
           TRG  : in  STD_LOGIC;
           TSS  : out STD_LOGIC;
           BOUT : out STD_LOGIC_VECTOR(23 downto 0));
end component;

Component Releaser is
    Port ( RST  : in  STD_LOGIC;
           CLK  : in  STD_LOGIC;
           TRG  : in  STD_LOGIC;
           BIN  : in  STD_LOGIC_VECTOR (23 downto 0);
           STT  : out STD_LOGIC;
           BOUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

Component Generic_Load_Register is
 generic( n : integer := 8 );
	port(
	RST  : in std_logic; -- Restaurar
	CLK  : in std_logic; -- Reloj
	LDR  : in std_logic; -- Señal de carga
	DIN  : in std_logic_vector( n - 1 downto 0 );	-- Dato de entrada
	DOUT : out std_logic_vector( n - 1 downto 0 )); -- Dato de salida
 
end component;

Component FlipFlopD is 
	port( RST : in  std_logic;
	      CLK : in  std_logic;
	      D   : in  std_logic;
	      Q   : out std_logic );
end component;

Component TOP_IIR_1 is
    Port ( RST  : in  STD_LOGIC;
           CLK  : in  STD_LOGIC;
           EN   : in  STD_LOGIC;  -- para la prueba del RS232 se emplea directo para el perdiodo de muestreo 
           XIN  : in  STD_LOGIC_VECTOR (23 downto 0);
           YR   : out STD_LOGIC;  -- señal agregada 
           YOUT : out STD_LOGIC_VECTOR (23 downto 0));
end component;

signal AT, STR, TS, DTS, YR1, YR2 : std_logic;
signal RDAT, DATA : std_logic_vector(7 downto 0);
signal INV, LINV, FDAT : std_logic_vector(23 downto 0);
begin

    --Delay       : Generic_Enabled_Counter generic map (1000000) port map (RST, CLK, EN, AT);
    Receiver    : UART_RX_P6        port map (RST, CLK, RX_B, STR, RDAT);
    DataIn      : Acquisition       port map (RST, CLK, RDAT, STR, TS, INV); 
    Latch       : Generic_Load_Register generic map (24) port map (RST, CLK, TS, INV, LINV);
    Delay_FFD1  : FlipFlopD         port map (RST, CLK, TS, DTS); 
    IIR_Filter  : TOP_IIR_1         port map (RST, CLK, DTS, LINV, YR1, FDAT);
    Delay_FFD2  : FlipFlopD         port map (RST, CLK, YR1, YR2);  
    DataOut     : Releaser          port map (RST, CLK, YR2, FDAT, AT, DATA);
    Transmitter : Transmitter_RS232 port map (RST, CLK, AT, DATA, open, TX_B); -- EOT => open, transmission ended
    
end Structural;
