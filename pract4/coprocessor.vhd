--Coprocesador... a rellenar

library ieee; use ieee.std_logic_1164.all;
use work.constantes.all;
entity coprocessor is
port (
  Data_Bus: inout std_logic_vector(7 downto 0);
  ReadReq: in std_logic;
  WriteReq: in std_logic;
  Ack: inout std_logic;
  Rdy: out std_logic;
  clk, reset: in std_logic
);
end coprocessor;

architecture circuit of coprocessor is
  -- A RELLENAR...CAMBIE LOS TAMAÑOS DE X E Y A PALO SECO
  component circuit_mcd is
	port (
	x, y: in std_logic_vector(7 downto 0);
	mcd: out std_logic_vector(7 downto 0);
	clk, reset, start: in std_logic;
	done: out std_logic);
  end component;
  signal x, y, mcd: std_logic_vector (7 downto 0);
  signal start, done: std_logic;
begin
etiqueta: circuit_mcd port map (x, y, mcd, clk, reset, start, done);
--generación de start (detección de escritura en la dirección 1):
process
begin
  Data_Bus <= "ZZZZZZZZ";
  Ack <= 'Z';
  Rdy <= 'Z';
  start <= '0';
  wait until WriteReq = '1' and Data_Bus = "00000001";
  wait for 100 ns;
  Ack <= '1';
  wait until WriteReq = '0';
  wait for 100 ns;
  Ack <= 'Z';
  wait for 1000 ns;
  Rdy <= '1';
  wait until Ack = '1';
  wait for 100 ns;
  start <= '1';
  wait for 100 ns;
  start <= '0';
  Rdy <= 'Z';
  end process;
--escritura de x (escritura en la dirección 2)
process
begin
  Data_Bus <= "ZZZZZZZZ";
  Ack <= 'Z';
  Rdy <= 'Z';
  wait until WriteReq = '1' and Data_Bus = "00000010";
  wait for 100 ns;
  Ack <= '1';
  wait until WriteReq = '0';
  wait for 100 ns;
  Ack <= 'Z';
  wait for 1000 ns;
  Rdy <= '1';
  wait until Ack = '1';
  wait for 100 ns;
  x <= Data_Bus;
  wait for 100 ns;
  Rdy <= 'Z';
end process;

--escritura de y (escritura en la dirección 3)  A RELLENAR->CAMBIO DE DIR=3

process
begin
  Data_Bus <= "ZZZZZZZZ";
  Ack <= 'Z';
  Rdy <= 'Z';
  wait until WriteReq = '1' and Data_Bus = "00000011"; 
  wait for 100 ns;
  Ack <= '1';
  wait until WriteReq = '0';
  wait for 100 ns;
  Ack <= 'Z';
  wait for 1000 ns;
  Rdy <= '1';
  wait until Ack = '1';
  wait for 100 ns;
  y <= Data_Bus;
  wait for 100 ns;
  Rdy <= 'Z';
end process;

--lectura de done (lectura de la dirección 1)

process
begin
  Data_Bus <= "ZZZZZZZZ";
  Ack <= 'Z';
  Rdy <= 'Z';
  wait until ReadReq = '1' and Data_Bus = "00000001";
  wait for 100 ns;
  Ack <= '1';
  wait until ReadReq = '0';
  wait for 100 ns;
  Ack <= 'Z';
  wait for 1000 ns;
  if done = '1' then Data_Bus <= "11111111"; else Data_Bus <=
  "00000000"; end if;
  Rdy <= '1';
  wait until Ack = '1';
  wait for 100 ns;
  Rdy <= 'Z';
  Data_Bus <= "ZZZZZZZZ";
end process;

--lectura de mcd (lectura de la dirección 2): A RELLENAR-> CAMBIO DE DIR=2 -> CAMBIO DONE POR START

process
begin
  Data_Bus <= "ZZZZZZZZ";
  Ack <= 'Z';
  Rdy <= 'Z';
  wait until ReadReq = '1' and Data_Bus = "00000010";
  wait for 100 ns;
  Ack <= '1';
  wait until ReadReq = '0';
  wait for 100 ns;
  Ack <= 'Z';
  wait for 1000 ns;
  if done = '1' then Data_Bus <= mcd; else Data_Bus <=
  "ZZZZZZZZ"; end if;
  Rdy <= '1';
  wait until Ack = '1';
  wait for 100 ns;
  Rdy <= 'Z';
  Data_Bus <= "ZZZZZZZZ";
end process;

end circuit;
