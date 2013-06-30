library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;

--Entidad del banco de pruebas...
entity test_acumuladorN is
end test_acumuladorN;

--Arquitectura del banco de pruebas...
architecture test of test_acumuladorN is

	--Pegamos el acumulador...
	component acumuladorN is 
		port(data_in: in std_logic_vector(n-1 downto 0); c_in,load, reset, clk:in std_logic;
		data_out : out std_logic_vector(n-1 downto 0); c_out: out std_logic);
	end component;

	signal data_in, data_out: std_logic_vector(n-1 downto 0);
	signal c_in, load,reset,clk, c_out: std_logic:= '0';
	
begin
	
	etiqueta: acumuladorN port map (data_in,c_in, load, reset, clk, data_out, c_out);
	clk <= not(clk) after 50 ns;
	data_in <= 
			conv_std_logic_vector(134,n),
			conv_std_logic_vector(28,n) after 100 ns,
			conv_std_logic_vector(230,n) after 200 ns,
			conv_std_logic_vector(111,n) after 300 ns,  
			conv_std_logic_vector(3,n) after 400 ns;
	c_in <= '0', '1' after 300 ns;
	load <='1', '0' after 200  ns, '1' after 400 ns;
	reset <= '1', '0' after 10 ns, '1' after 600 ns, '0' after 610 ns;
end test;