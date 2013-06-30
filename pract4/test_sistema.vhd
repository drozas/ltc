library ieee; use ieee.std_logic_1164.all;
entity test_sistema is end test_sistema;

architecture test of test_sistema is
  
  --A RELLENAR: PEGADA DEL TIPO DE COMPONENTE
component sistema is
port (
  external_input_1: in std_logic_vector (7 downto 0);
  external_input_2: in std_logic_vector (7 downto 0);
  external_output: out std_logic_vector (7 downto 0);
  clk, reset: in std_logic
);
end component;
  signal external_input_1, external_input_2, external_output:std_logic_vector (7 downto 0);
  signal clk, reset: std_logic := '0';
begin
  etiqueta: sistema port map (external_input_1, external_input_2, external_output, clk, reset);
  clk <= not(clk) after 50 ns;
  reset <= '1', '0' after 10 ns;
  external_input_1 <= "10110110";
  external_input_2 <= "11100111";
end test;
