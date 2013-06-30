library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;

-- Sumador de n bits

entity sumador_n is
port(a,b: in std_logic_vector(n-1 downto 0); c_in: in std_logic; 
s: out std_logic_vector(n-1 downto 0); c_out: out std_logic);
end sumador_n;

architecture funcional of sumador_n is
	signal long_a,long_b,long_carry,long_s:
	std_logic_vector(n downto 0);
begin
	-- Para adecuación de tipos...(es como ADA...muy tipado)
	long_a <= '0'&a;
	long_b <= '0'&b;
	long_carry <= conv_std_logic_vector(0,n)&c_in;
	long_s <= long_a + long_b + long_carry;
	s <= long_s(n-1 downto 0);
	c_out <= long_s(n);
end funcional;