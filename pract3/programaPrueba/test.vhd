library ieee; use ieee.std_logic_1164.all;

entity testsis is end testsis;
architecture test of testsis is

component procesador is
port (ent_A, ent_B: in std_logic_vector (7 downto 0);
sal_A, sal_B: inout std_logic_vector (7 downto 0);
clk, reset: in std_logic);
end component;

signal ent_A, ent_B: std_logic_vector (7 downto 0);
signal sal_A, sal_B: std_logic_vector (7 downto 0);
signal clk: std_logic := '0';
signal reset: std_logic;

begin
clk <= not (clk) after 50 ns;
reset <= '1', '0' after 100 ns;
ent_A <= "00000000"; ent_B <= "00000000";
etiqueta: procesador port map (ent_A, ent_B, sal_A, sal_B, clk,
reset);
end test;
