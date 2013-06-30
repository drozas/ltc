library ieee; use ieee.std_logic_1164.all;
entity sistema is
port (
  external_input_1: in std_logic_vector (7 downto 0);
  external_input_2: in std_logic_vector (7 downto 0);
  external_output: out std_logic_vector (7 downto 0);
  clk, reset: in std_logic
);
end sistema;

architecture circuit of sistema is
---A RELLENAR
--PEGADA DE TIPO DE COMPONENTES
component procesador is
port (ent_A, ent_B: in std_logic_vector (7 downto 0);
sal_A, sal_B: inout std_logic_vector (7 downto 0);
clk, reset: in std_logic);
end component;

component input_channel_1 is
port (
  Data_Bus: inout std_logic_vector(7 downto 0);
  ReadReq: in std_logic;
  Ack: inout std_logic;
  Rdy: out std_logic;
  external_input_1: in std_logic_vector(7 downto 0)
);
end component;

component input_channel_2 is
port (
  Data_Bus: inout std_logic_vector(7 downto 0);
  ReadReq: in std_logic;
  Ack: inout std_logic;
  Rdy: out std_logic;
  external_input_2: in std_logic_vector(7 downto 0)
);
end component;

component output_channel is
port (
Data_Bus: inout std_logic_vector(7 downto 0);
WriteReq: in std_logic;
Ack: inout std_logic;
Rdy: out std_logic;
external_output: out std_logic_vector(7 downto 0)
);
end component;

component coprocessor is
port (
  Data_Bus: inout std_logic_vector(7 downto 0);
  ReadReq: in std_logic;
  WriteReq: in std_logic;
  Ack: inout std_logic;
  Rdy: out std_logic;
  clk, reset: in std_logic
);
end component;

  --Declaracion de variables...HE AGREGADO ent_A
  signal ent_B, sal_A, sal_B: std_logic_vector (7 downto 0);
  signal Rdy, Ack, BusEn, AckEn, ReadReq, WriteReq: std_logic;
  signal Data_Bus: std_logic_vector(7 downto 0);
begin
  --A RELLENAR: PEGADA DE COMPONENTES EN SI
  etiqueta1: input_channel_1 port map(Data_Bus,ReadReq,Ack,Rdy,external_input_1);

  etiqueta2: input_channel_2 port map(Data_Bus,ReadReq,Ack,Rdy,external_input_2);

  etiqueta3: output_channel port map(Data_Bus,WriteReq,Ack,Rdy,external_output);

  etiqueta4: procesador port map(Data_bus,ent_B,sal_A,sal_B,clk,reset);

  etiqueta5: coprocessor port map(Data_Bus,ReadReq,WriteReq,Ack,Rdy,clk,reset);

  Data_Bus <= sal_A when BusEn = '1' else "ZZZZZZZZ";
  Ack <= '1' when AckEn = '1' else 'Z';
  Rdy <= 'L';
  Ack <= 'L';
  ent_B(7 downto 2) <= "000000";
  ent_B(1) <= Rdy;
  ent_B(0) <= Ack;
  BusEn <= sal_B(3);
  AckEn <= sal_B(2);
  ReadReq <= sal_B(1);
  WriteReq <= sal_B(0);
end circuit;
