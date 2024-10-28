Library	IEEE;
use IEEE.std_logic_1164.all;

Entity Parity_Generator is 
	port(
	D : in  std_logic_vector(7 downto 0); 
	P : out std_logic
	);
end Parity_Generator;

Architecture Simple of Parity_Generator is
begin		
	P <= ((D(0) XOR D(1)) XOR (D(2) XOR D(3))) XOR ((D(4) XOR D(5)) XOR (D(6) XOR D(7)));
end Simple;
