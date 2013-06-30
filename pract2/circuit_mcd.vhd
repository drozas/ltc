library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;

--CIRCUITO GENERAL DE CÁLCULO DEL Mcd

--Entidad:
entity circuit_mcd is
	port (
	x, y: in std_logic_vector(n-1 downto 0);
	mcd: out std_logic_vector(n-1 downto 0);
	clk, reset, start: in std_logic;
	done: out std_logic);
end circuit_mcd;

--Arquitectura:
architecture circuit of circuit_mcd is

--Pegada de componentes:

-- Ruta de Datos
component data_path_mcd is
	port (
	x, y: in std_logic_vector(n-1 downto 0);
	mcd: out std_logic_vector(n-1 downto 0);
	clk, reset: in std_logic;
	sel_a, sel_b, sel_c: in std_logic_vector(1 downto 0);
	sel_adder: in std_logic;
	a0, b0, sign, equal_zero: out std_logic);

end component;

-- Unidad de control
component control_mcd is
port (
	clk, reset, start, sign, equal_zero, a0, b0: in std_logic;
	sel_a, sel_b, sel_c: out std_logic_vector(1 downto 0);
	sel_adder, done: out std_logic);
end component;

--Señales internas (cables que van de la ruta de datos a la unidad de control):

	--Señales de control de multiplexores 4:1
	signal sel_a, sel_b, sel_c : std_logic_vector(1 downto 0);
	--Señal de control de multiplexores 2:1
	signal sel_adder: std_logic;
	--Bits de menos peso de a y b
	signal a0,b0: std_logic;
	--Señales de control de la operación resta
	signal sign, equal_zero: std_logic;


begin
--Etiquetas con los componentes

ruta_datos: data_path_mcd port map(x,y,mcd,clk,reset,sel_a,sel_b,sel_c,
						sel_adder,a0,b0,sign,equal_zero);

unidad_control: control_mcd port map(clk,reset,start,sign,equal_zero,a0,b0,
						sel_a,sel_b,sel_c,sel_adder,done);

end circuit;
