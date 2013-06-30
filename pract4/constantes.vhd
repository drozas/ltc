
library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--Paquete de constantes

package constantes is

	constant n: natural := 16;
	constant logn: natural := 4;
	constant one: std_logic_vector(n-1 downto 0) := conv_std_logic_vector(1,n);
	constant zero: std_logic_vector(logn-1 downto 0) := conv_std_logic_vector(0,logn);
end constantes;