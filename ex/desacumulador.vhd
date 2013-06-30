library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;

-- Entidad del Desacumulador de n bits
entity DesacumuladorN is 
	port(data_in: in std_logic_vector(n-1 downto 0); load, reset, clk:in std_logic;
		data_out : out std_logic_vector(n-1 downto 0); equal_zero: out std_logic);
end DesacumuladorN;

-- Arquitectura  del desacumulador de n bits
architecture circuito of DesacumuladorN is
	-- Pegamos los componentes...
	--Primero el registro...
	component registro_n_clear is
		port (d:in std_logic_vector(n-1 downto 0);clk, ce, clear: in std_logic;
		q: out std_logic_vector(n-1 downto 0));
	end component;

	--Y despues el restador...
	component restador_n is
		port(a,b: in std_logic_vector(n-1 downto 0); 
		s: out std_logic_vector(n-1 downto 0); equal_zero: out std_logic);
	end component;

	--Declaracion de señales (lo que tendrias que cablear...)
	signal vectorN_1: std_logic_vector(n-1 downto 0);
	signal vectorN_2: std_logic_vector(n-1 downto 0);

	--Y comenzamos a conectar...
	begin
		
		--Conexiones del sumador
		--Vector1 es una señal auxiliar que recoge la salida del registro, y la mete en el restador
		--Vector2 es una señal auxiliar que recoge la salida del restador, y la introduce en la entrada del reg
		restador: restador_n port map(data_in,vectorN_1,vectorN_2,equal_zero);
		registro: registro_n_clear port map(vectorN_2,clk,load,reset,vectorN_1);
		data_out <=vectorN_1;
	end;
	




