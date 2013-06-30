library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;

--Entidad del banco de pruebas...
entity test_DesacumuladorN is
end test_DesacumuladorN;

--Arquitectura del banco de pruebas...
architecture test of test_DesacumuladorN is

	--Pegamos el acumulador...
	component DesacumuladorN is 
		port(data_in: in std_logic_vector(n-1 downto 0);load, reset, clk:in std_logic;
		data_out : out std_logic_vector(n-1 downto 0); equal_zero: out std_logic);
	end component;

	signal data_in, data_out: std_logic_vector(n-1 downto 0);
	signal load,reset,clk, equal_zero: std_logic:= '0';
	
begin
	
	etiqueta: DesacumuladorN port map (data_in,load, reset, clk, data_out,equal_zero);
	load <= not(load) after 50 ns;
	data_in<=
	conv_std_logic_vector(1,8), conv_std_logic_vector(100,8) after 100 ns, 
	conv_std_logic_vector(110,8) after 200 ns, conv_std_logic_vector(130,8) after 300 ns;
	clk<=load after 10 ns;
	reset<= '1', '0' after 50 ns;
	 
end test;