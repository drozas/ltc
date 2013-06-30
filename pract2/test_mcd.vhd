library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;

--BANCO DE PRUEBAS DEL CIRCUITO DE CÁLUCO DE Mcd:
-- 		mcd(3456,2664)->72 y mcd(816,2720)->272

--Entidad (vacía, por ser un banco de pruebas)
entity test_mcd is end test_mcd;

--Arquitectura:

architecture test of test_mcd is

--Pegada del componente
component circuit_mcd is
	port (
	x, y: in std_logic_vector(n-1 downto 0);
	mcd: out std_logic_vector(n-1 downto 0);
	clk, reset, start: in std_logic;
	done: out std_logic);
end component;

	--Declaración de señales (todo, como si fueran internas)
	signal x, y, mcd: std_logic_vector(n-1 downto 0);
	signal clk, reset, start, done: std_logic := '0';

begin

	--Etiqueta del componente
	circuito_test: circuit_mcd port map(x, y, mcd, clk, reset, start, done);

	--Asignación de valores de prueba
	clk <= not(clk) after 5 ns;
	reset <= '1', '0' after 20 ns;
	x <= conv_std_logic_vector(3456,n), conv_std_logic_vector(816,n)
	after 1000 ns;
	y <= conv_std_logic_vector(2664,n), conv_std_logic_vector(2720,n)
	after 1000 ns;
	start <= '0',  '1' after 100 ns, '0' after 120 ns, '1' after 1100
	ns, '0' after 1200 ns;
end test;
