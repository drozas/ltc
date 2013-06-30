library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;


-- Registro de n bits con señal de clear
entity registro_n_clear is
port (d:in std_logic_vector(n-1 downto 0);
clk, ce, clear: in std_logic;
q: out std_logic_vector(n-1 downto 0));
end registro_n_clear;

architecture funcional of registro_n_clear is
begin
	process (clk,clear)
	begin
	if ce = '1' and clk'event and clk='1' then
		q<= d;
	end if;

-- Si llega la señal de clear por nivel alto... el registro se pone a 0
	if clear='1' then
		q <= conv_std_logic_vector(0,n);
		-- Utilizamos esta funcion, para introducir n 0s
	end if;
	end process;
end funcional;
