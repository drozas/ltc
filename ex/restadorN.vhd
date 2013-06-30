library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;

-- Restador de n bits

entity restador_n is
port(a,b: in std_logic_vector(n-1 downto 0);
s: out std_logic_vector(n-1 downto 0); equal_zero: out std_logic);
end restador_n;

architecture funcional of restador_n is
	signal op_aAux,op_bAux,resAux: std_logic_vector(n downto 0);
begin
	-- Para adecuación de tipos...(es como ADA...muy tipado)
	op_aAux <= '0'&a;
	op_bAux <= '0'&b;
	resAux<=op_aAux - op_bAux;
	equal_zero <= '1' when conv_integer(resAux) = 0 else '0';
	s<= resAux(n-1 downto 0);
	
end funcional;