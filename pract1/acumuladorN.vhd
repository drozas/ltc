library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;

-- Entidad del acumulador de n bits
entity acumuladorN is 
	port(data_in: in std_logic_vector(n-1 downto 0); c_in,load, reset, clk:in std_logic;
		data_out : out std_logic_vector(n-1 downto 0); c_out: out std_logic);
end acumuladorN;

-- Arquitectura  del acumulador de n bits
architecture circuito of acumuladorN is
	-- Pegamos los componentes...
	--Primero el registro...
	component registro_n_clear is
		port (d:in std_logic_vector(n-1 downto 0);clk, ce, clear: in std_logic;
		q: out std_logic_vector(n-1 downto 0));
	end component;

	--Y despues el sumador...
	component sumador_n is
		port(a,b: in std_logic_vector(n-1 downto 0); c_in: in std_logic; 
		s: out std_logic_vector(n-1 downto 0); c_out: out std_logic);
	end component;

	--Declaracion de señales (lo que tendrias que cablear...)
	signal vectorN_1: std_logic_vector(n-1 downto 0);
	signal vectorN_2: std_logic_vector(n-1 downto 0);

	--Y comenzamos a conectar...
	begin
		
		--Conexiones del sumador
		sumador: sumador_n port map(data_in,vectorN_1,c_in,vectorN_2,c_out);
		registro: registro_n_clear port map(vectorN_2,clk,load,reset,vectorN_1);
		data_out <=vectorN_1;
	end;
	




