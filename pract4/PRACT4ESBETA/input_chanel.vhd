library ieee; use ieee.std_logic_1164.all;
entity input_channel is
port (
  Data_Bus: inout std_logic_vector(7 downto 0);
  ReadReq: in std_logic;
  Ack: inout std_logic;
  Rdy: out std_logic;
  external_input: in std_logic_vector(7 downto 0)
);
end input_channel;
architecture functional of input_channel is
begin
process
begin
  Data_Bus <= "ZZZZZZZZ";
  Ack <= 'Z';
  Rdy <= 'Z';
  wait until ReadReq = '1' and Data_Bus = "00101111";
  wait for 100 ns;
  Ack <= '1';
  wait until ReadReq = '0';
  wait for 100 ns;
  Ack <= 'Z';
  wait for 1000 ns;
  Data_Bus <= external_input;
  Rdy <= '1';
  wait until Ack = '1';
  wait for 100 ns;
  Rdy <= 'Z';
  Data_Bus <= "ZZZZZZZZ";
end process;
end functional;
