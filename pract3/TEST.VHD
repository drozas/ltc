

library ieee; use ieee.std_logic_1164.all;

--En los bancos de prueba dejamos la entidad vacía
entity test_procesador is end test_procesador;

architecture test of test_procesador is

--Pegamos el componente
component procesador
	port (ent_A, ent_B: in std_logic_vector (7 downto 0);
		sal_A, sal_B: inout std_logic_vector (7 downto 0);
		clk, reset: in std_logic);
end component;

--Y hay que declarar todas las señales
signal ent_A, ent_B, sal_A, sal_B: std_logic_vector (7 downto 0);
signal clk, reset: std_logic := '0';

begin

	etiqueta: procesador port map (ent_A, ent_B, sal_A, sal_B, clk,reset);
	clk <= not(clk) after 50 ns;
	reset <= '1', '0' after 10 ns;
	process
	begin
		ent_B <= "00000000";
		wait for 500 ns;
		ent_A <= "01001001";
		wait for 500 ns;
		ent_B <= "11111111";
		wait for 500 ns;
		ent_B <= "00000000";
		wait for 500 ns;
		ent_A <= "10011001";
		wait for 500 ns;
		ent_B <= "11111111";
		wait for 500 ns;
		ent_B <= "00000000";
		wait for 500 ns;
		ent_A <= "00001011";
		wait for 500 ns;
		ent_B <= "11111111";
		wait for 500 ns;
		ent_B <= "00000000";
		wait for 500 ns;
		ent_A <= "00000001";
		wait for 500 ns;
		ent_B <= "11111111";
		wait for 500 ns;
		ent_B <= "00000000";
		wait;
	end process;
end test;
