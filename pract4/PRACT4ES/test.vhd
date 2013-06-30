library ieee; use ieee.std_logic_1164.all;
entity test_procesador is end test_procesador;
architecture test of test_procesador is
  component procesador
  port (
  ent_a, ent_B: in std_logic_vector (7 downto 0);
  sal_A, sal_B: inout std_logic_vector (7 downto 0);
  clk, reset: in std_logic);
  end component;

  component input_channel
  port (
  Data_Bus: inout std_logic_vector(7 downto 0);
  ReadReq: in std_logic;
  Ack: inout std_logic;
  Rdy: out std_logic;
  external_input: in std_logic_vector(7 downto 0));
  end component;

  component output_channel
  port (
  Data_Bus: inout std_logic_vector(7 downto 0);
  WriteReq: in std_logic;
  Ack: inout std_logic;
  Rdy: out std_logic;
  external_output: out std_logic_vector(7 downto 0)
  );
  end component;


  signal ent_B, sal_A, sal_B: std_logic_vector (7 downto 0);
  signal clk, reset: std_logic := '0';
  signal Rdy, Ack, BusEn, AckEn, ReadReq, WriteReq: std_logic;
  signal Data_Bus: std_logic_vector(7 downto 0);
  signal external_input, external_output: std_logic_vector (7 downto
  0);
  procedure sinc is begin wait until clk'event and clk = '1'; end sinc;
begin
  etiqueta1: procesador port map (Data_Bus,ent_b,sal_a,sal_b,clk,reset);
  etiqueta2: input_channel port map (Data_Bus,ReadReq,Ack,Rdy,external_input);
  etiqueta3: output_channel port map (Data_Bus,WriteReq,Ack,Rdy,external_output);
  --interfaz entre el procesador y el bus del sistema:
	Data_Bus <= sal_A when BusEn = '1' else "ZZZZZZZZ";
	Ack <= '1' when AckEn = '1' else 'Z';
  	--modelo de las resistencias de "pull down":
  	Rdy <= 'L';
  	Ack <= 'L';
  	ent_B(7 downto 2) <= "000000";
  	ent_B(1) <= Rdy;
  	ent_B(0) <= Ack;
	BusEn <= sal_B(3);
	AckEn <= sal_B(2);
	ReadReq <= sal_B(1);
	WriteReq <= sal_B(0);
  clk <= not(clk) after 50 ns;
  reset <= '1', '0' after 10 ns;
  external_input <= "10101010";
end test;
