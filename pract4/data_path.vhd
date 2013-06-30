library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;

--RUTA DE DATOS DE CIRCUITO Mcd (2.0)

--Entidad:

entity data_path_mcd is
	port (
	x, y: in std_logic_vector(n-1 downto 0);
	mcd: out std_logic_vector(n-1 downto 0);
	clk, reset: in std_logic;
	sel_a, sel_b, sel_c: in std_logic_vector(1 downto 0);
	sel_adder: in std_logic;
	a0, b0, sign, equal_zero: out std_logic);

end data_path_mcd;

--Arquitectura:
architecture rtl of data_path_mcd is

--Señales
	signal inp_a, inp_b, aDiv2, bDiv2, a, b, op_1, op_2 : std_logic_vector(n-1 downto 0);
	signal c, inp_c, cMas1: std_logic_vector(logn-1 downto 0);
	signal dif, op_1Aux, op_2Aux: std_logic_vector(n downto 0);
begin

--Multiplexor 1 (4:1): Elige la señal que entra al  registro 1
	with sel_a select inp_a <= a when "00", aDiv2 when "01",
	dif(n-1 downto 0) when "10", x when others;
	--en dif cogemos del n-1 al 0; ya que dif es de n bits

--Multiplexor 2 (4:1): Elige la señal que entra al registro 2
	with sel_b select inp_b <= b when "00", bDiv2 when "01",
	dif(n-1 downto 0) when "10", y when others;

--Multiplexor 3 (4:1): Elige la señal que entra al registro 3
	with sel_c select inp_c <= c when "00", cMas1 when "01",
	zero when others;

--Registro 1 (n-1 .. 0)
	process(reset, clk)
	begin
		if reset = '1' then a <= conv_std_logic_vector(0,n);
		elsif clk'event and clk = '1' then a <= inp_a; 
		end if;
	end process;

--Registro 2 (n-1 .. 0)
	process(reset, clk)
	begin
		if reset = '1' then b <= conv_std_logic_vector(0,n);
		elsif clk'event and clk = '1' then b <= inp_b; 
		end if;
	end process;

--Registro 3 (logn-1 .. 0)
	process(reset, clk)
	begin
		if reset = '1' then c <= conv_std_logic_vector(0,logn);
		elsif clk'event and clk = '1' then c <= inp_c; 
		end if;
	end process;

--Desplazador 1 bit 1: Desplaza a la derecha un bit de a, por lo que nos devuelve a/2
	aDiv2 <= shr(a,"1");

--Desplazador 1 bit 2: Desplazaza a la derecha un bit de b, por lo que nos devuelve b/2
	bDiv2 <= shr(b,"1");

--Sacamos el bit de menos peso de a y b
	a0<=a(0);
	b0<=b(0);


--Multiplexor 4 (2:1): Se utiliza para elegir a o b en el primer operando del restador

	with sel_adder select op_1<=a when '0', b when others;

--Multiplexor 5 (2:1): Se utilizar para elegir a o b en el segundo operando del restador

	with sel_adder select op_2<=b when '0', a when others;

	-- sel_adder:> 0->a-b; 1-> b-a

--Restador (n..0): Devuelve dif(n..0), el bit de signo y otro para indicar si son iguales
	
	--La operación utiliza n+1 bits; así que concatenamos un 0 a los operando auxiliares,
	--operamos en dif, y recogemos la información de signo e igualdad
	op_1Aux<='0'&op_1;
	op_2Aux<='0'&op_2;
	dif<=op_1Aux-op_2Aux;
	equal_zero <= '1' when conv_integer(dif) = 0 else '0';
	sign<=dif(n);

--Semisumador (logn-1..0): Devuelve c+1
	
	cMas1<= c + conv_std_logic_vector(1,logn);

--Desplazador de c bits a la izda (logn-1..0): es para elevar a c veces

	mcd <= shl(a,c);	



end rtl;