library ieee; use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constantes.all;

--UNIDAD DE CONTROL DEL CIRCUITO Mcd

--Entidad
entity control_mcd is
port (
	clk, reset, start, sign, equal_zero, a0, b0: in std_logic;
	sel_a, sel_b, sel_c: out std_logic_vector(1 downto 0);
	sel_adder, done: out std_logic);
end control_mcd;

--Arquitectura
architecture rtl of control_mcd is
	--Subtipos y señales
	subtype states is natural range 0 to 9;
	signal state: states;
begin
--Se tienen que declarar dos procesos: uno para las transiciones y otro para las salidas


-- Proceso 1: Transiciones entre estados
process
begin
--Partimos del estado 0
	state <= 0;
main: loop
	wait until clk'event and clk = '1';
	case state is
		--Los dos primeros estados son de espera, pero hay dos para simular el flanco de subida:_|
		when 0 => if start = '0' then state <= 1; 
				end if;
		when 1 => if start = '1' then state<=2;
				end if;
		--El estado dos es el de inicialización de los valores
		when 2 => state<=3;			
		--En el estado 3 se toma la decisión
		when 3 => 	--Si a y b son pares, vamos al estado 4
				if a0 = '0' and b0 ='0' then state <= 4;
				--Si a es par y b impar vamos al estado 5
				elsif a0 = '0' and b0 = '1' then state <= 5;
				--Si a es impar y b es par, vamos al estado 6
				elsif a0 = '1' and b0 = '0' then state <= 6;
				-- Si a es impar y b es impar, tenemos dos casos
				elsif a0 = '1' and b0 = '1' then
					-- Si son iguales, hemos acabado... al estado 9
					if equal_zero='1' then
						state <= 9;
					-- Si a es mayor que b, al estado 7
					elsif sign = '0' then
						state <=7;
					-- Si  a es menor que b...al estado 8
					elsif sign ='1' then
						state <=8;
					end if;
				end if;
		--Del estado 4 al 8..volvemos al 3
		when 4 to 8 => state <= 3;
		--En el estado 9, hemos acabado...vuelta al estado 0
		when 9 => state <= 0;

	end case;

		if reset = '1' then exit main; 
		end if;
end loop main;
end process;


--Proceso 2: Valor de señales de salida
process (state)
	begin
	case state is
	--Si estamos en el estado 0: en a a, en b b y en c c. Además inicializamos el done
	when 0 => sel_a <= "00"; sel_b <= "00"; sel_c <= "00";
		sel_adder <= '0'; done<='1'; 
	--Si estamos en el estado 1: en a a, en b b y en c c e inicialización de done
	when 1 => sel_a <= "00"; sel_b <= "00"; sel_c <= "00";
		sel_adder <= '0'; done<='1';
	--Si estamos en el estado 2: hay que meter x en a, y en b y 0 en c, 
	when 2 => sel_a <= "11"; sel_b <= "11"; sel_c <= "11";
		sel_adder <= '0'; done<='0'; 
	--Si estamos en el estado 3, reintroducimos valores iniciales (no hay que alterar nada) 
	when 3 => sel_a <="00" ; sel_b <="00" ; sel_c <="00" ;
		sel_adder <= '0';
	--Si estamos en el estado 4: en a aDiv2, en b bDiv2 y en c cMas1
	when 4 => sel_a <= "01"; sel_b <= "01"; sel_c <= "01";
		sel_adder <= '0';
	--Si estamos en el estado 5: en a aDiv2
	when 5 => sel_a <= "01"; sel_b<="00"; sel_c<="00"; sel_adder <= '0';
	--Si estamos en el estado 6: en b bDiv2
	when 6 => sel_a <="00"; sel_b <= "01"; sel_c<="00"; sel_adder <= '0';
	--Si estamos en el estado 7: resta a-b, hay que activar sel_adder
	when 7 => sel_adder<='0'; sel_a<="10"; sel_b<="00"; sel_c<="00";
	--Si estamos en el estado 8: resta b-a, hay que activar sel_adder
	when 8 => sel_adder<='1'; sel_a<="00"; sel_b<="10"; sel_c<="00";
	--Si estamos en el estado 9: voilá!
	when others => done<='1';

	

	
end case;
end process;


end rtl;
