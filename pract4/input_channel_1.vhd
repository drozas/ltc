--Modelo de canal de entrada 1: nos lo dan hecho
library ieee; use ieee.std_logic_1164.all;
entity input_channel_1 is
port (
  Data_Bus: inout std_logic_vector(7 downto 0);
  ReadReq: in std_logic;
  Ack: inout std_logic;
  Rdy: out std_logic;
  external_input_1: in std_logic_vector(7 downto 0)
);
end input_channel_1;
architecture functional of input_channel_1 is
begin
process
begin
  --Ponemos las señales en estado de alta impedancia: inicializacion
  Data_Bus <= "ZZZZZZZZ";
  Ack <= 'Z';
  Rdy <= 'Z';
  --Esperamos a que nos llegue señal de peticion de lectura, y q nos pongan nuestra dir: 47
  wait until ReadReq = '1' and Data_Bus = "00101111";
  wait for 100 ns;
  
  --Una vez nos enteramos, subimos nuestro acknowledge
  Ack <= '1';
  --Esperamos a que paren de pedirnos leer
  wait until ReadReq = '0';
  wait for 100 ns;
  --Reinicilizacion de acknowledw
  Ack <= 'Z';
  wait for 1000 ns;
  --Y ponemos en el bus, los datos que nos han pedido
  Data_Bus <= external_input_1;
  --Decimos q esta listo
  Rdy <= '1';
  --Esperamos, hasta que la CpU diga que se entero con Acknowledge (es comun a ambos)
  wait until Ack = '1';
  wait for 100 ns;
  Rdy <= 'Z';
  Data_Bus <= "ZZZZZZZZ";
end process;
end functional;

