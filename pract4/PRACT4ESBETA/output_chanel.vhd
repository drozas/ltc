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
  Data_Bus <= "ZZZZZZZZ";
  Ack <= 'Z';
  Rdy <= 'Z';
  wait until Writereq = '1' and Data_Bus = "00110000";
  wait for 100 ns;
  Ack <= '1';
  wait until WriteReq = '0';
  wait for 100 ns;
  Ack <= 'Z';
  wait for 1000 ns;
  external_output <= Data_Bus;
  Rdy <= '1';
  wait until Ack = '1';
  wait for 100 ns;
  Rdy <= 'Z';
  Data_Bus <= "ZZZZZZZZ";
end process;
end functional;
