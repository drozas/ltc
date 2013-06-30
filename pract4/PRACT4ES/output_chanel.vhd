-- A completar en la fase de prueba...

library ieee; use ieee.std_logic_1164.all;
entity output_channel is
port (
Data_Bus: inout std_logic_vector(7 downto 0);
WriteReq: in std_logic;
Ack: inout std_logic;
Rdy: out std_logic;
external_output: out std_logic_vector(7 downto 0)
);
end output_channel;
architecture functional of output_channel is
begin
process
begin
  --Inicializacion de variables
  Data_Bus <= "ZZZZZZZZ";
  Ack <= 'Z';
  Rdy <= 'Z';
  --Esperamos hasta que nos soliciten escritura, y digan que es nuestra direccion: 48
  wait until WriteReq = '1' and Data_Bus = "00110000";
  wait for 100 ns;
  --Si nos solicitaron, decimos que nos hemos enterado subiendo nuestro Ack
  Ack <= '1';
  --Esperamos a que nos bajen la señal de peticion
  wait until WriteReq = '0';
  wait for 100 ns;
  --Bajamos nuestro Ack
  Ack <= 'Z';
  wait for 1000 ns;
  --Decimos que estamos listos
  Rdy <= '1';
  --Y esperemos a que se entere la cpu y q nos lo indique con su acknowledge 
  wait until Ack = '1';
  wait for 100 ns;
  --Y despues....escribimos en el bus
  external_output <= Data_Bus;
  Rdy <= 'Z';
  Data_Bus <= "ZZZZZZZZ";
end process;
end functional;

