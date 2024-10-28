Library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.std_logic_unsigned.all;
 
 Entity Parity is
	 generic (n : integer := 8);
	 port(
	 DIN : in std_logic_vector(n-1 downto 0);
	 PTY : out std_logic
	 );
 end Parity;
 
 Architecture DataFlow of Parity is
 begin
	 PTY <= (((DIN(7) XOR DIN(6)) XOR ((DIN(5) XOR DIN(4))) XOR (DIN(3) XOR DIN(2))) XOR (DIN(1) XOR DIN(0))); 
end DataFlow;