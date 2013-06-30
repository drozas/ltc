library ieee; use ieee.std_logic_1164.all;
use work.definiciones.all;
entity ram_es is
port (Rj, Rk, ent_A, ent_B: in std_logic_vector (7 downto 0); 
dato: out std_logic_vector (7 downto 0);
sal_A, sal_B: inout std_logic_vector (7 downto 0);
clk, EscMem: in std_logic);
end ram_es;

architecture flujo of ram_es is
component sram
generic (retardo: time := 10 ns);
port
(address: in std_logic_vector;
data_in: in std_logic_vector;
data_out: out std_logic_vector;
WE, ME: in std_logic);
end component;
signal data_mem, data_port: std_logic_vector (7 downto 0);
signal WE, ME, sel_port, write_A, write_B: std_logic;
begin
sel_port <=  Rj(7) and Rj(6) and Rj(5) and Rj(4) and Rj(3) and Rj(2) and Rj(1);
ME <= '1';
WE <= EscMem and not(clk);
write_A <= not(Rj(0)) and sel_port and EscMem;
write_B <= Rj(0) and sel_port and EscMem;
with Rj(0) select data_port  <=  ent_A when '0', ent_B when '1', "XXXXXXXX" when others;
with sel_port select dato <= data_port when '1', data_mem when '0', "XXXXXXXX" when others;
sal_A <= Rk when write_A = '1' and clk'event and clk = '1' else sal_A;
sal_B <= Rk when write_B = '1' and clk'event and clk = '1' else sal_B;
etiqueta: sram generic map (8 ns) port map (Rj, Rk, data_mem, WE, ME);
end flujo;

library ieee; use ieee.std_logic_1164.all;
use work.definiciones.all;
entity dpreg is
port (entrada: in std_logic_vector (7 downto 0); 
dir_esc, dir_a, dir_b: in std_logic_vector (3 downto 0);
escribir, clk: in std_logic; 
sal_a, sal_b: out std_logic_vector (7 downto 0));
end dpreg;

architecture circuito of dpreg is
component inv 
generic (retardo: time := 1 ns);
port (a: in std_logic; s: out std_logic);
end component;
component nor2
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end component;
component nand2
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end component;
component tri_buf
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end component;
component decod_4
port (dir: in std_logic_vector (3 downto 0); 
row: out std_logic_vector (15 downto 0));
end component;
component dff
generic (retardo: time := 1 ns; t_SU: time := 2 ns);
port (d, clk: in std_logic; q, qb: out std_logic);
end component;
signal reg, regb: memoria_binaria (15 downto 0, 7 downto 0);
signal esc, a, b, clock: std_logic_vector (15 downto 0);
signal escribirb, we: std_logic;
begin
etiqueta1: decod_4 port map (dir_esc, esc);
etiqueta2: decod_4 port map (dir_a, a);
etiqueta3: decod_4 port map (dir_b, b);
etiqueta4: inv port map (escribir, escribirb);
etiqueta5: nor2 port map (escribirb, clk, we);
etiqueta6: for i in 15 downto 0 generate
etiqueta7: nand2 port map (we, esc(i), clock(i));
etiqueta8: for j in 7 downto 0 generate
etiqueta9: dff port map (entrada(j), clock(i), reg(i,j), regb(i,j));
etiqueta10: tri_buf port map (reg(i,j), a(i), sal_a(j));
etiqueta11: tri_buf port map (reg(i,j), b(i), sal_b(j));
end generate;
end generate;
end circuito;		

library ieee; use ieee.std_logic_1164.all;
use work.definiciones.all;
entity cont_prog is
generic (m: natural);
port (entrada: in std_logic_vector (m-1 downto 0);
salida: inout std_logic_vector (m-1 downto 0);
escribir, clk, reset: in std_logic);
end cont_prog;

architecture circuito of cont_prog is
component mux2to1
generic (retardo: time := 1 ns);
port (a, b, c: in std_logic; s: out std_logic);
end component;
component dffcp
generic (retardo: time := 1 ns; t_SU: time := 2 ns);
port (d, clk, clear, preset: in std_logic; q, qb: out std_logic);
end component;
component half_add
generic (retardo: time := 1 ns);
port (a, c: in std_logic; c_mas, s: out std_logic);
end component;
signal reg_in, mas_1, salidab: std_logic_vector (m-1 downto 0);
signal acarreo: std_logic_vector (m downto 0); signal cero: std_logic;
begin
acarreo(0) <= '1'; cero <= '0';
contador: for i in m-1 downto 0 generate
multiplexores: mux2to1 port map (mas_1(i), entrada(i), escribir, reg_in(i));
biestables: dffcp generic map (5 ns, 0 ns)
port map (reg_in(i), clk, reset, cero, salida(i), salidab(i));
sumador: half_add port map (salida(i), acarreo(i), acarreo(i+1), mas_1(i));
end generate;
end circuito;

library ieee; use ieee.std_logic_1164.all;
entity ual is
generic (m: natural);
port (entrada_a, entrada_b: in std_logic_vector (m-1 downto 0);
salida: out std_logic_vector (m-1 downto 0);
operacion: in std_logic; acarreo: out std_logic);
end ual;

architecture circuito of ual is
component add_1
generic (retardo: time := 1 ns);
port (a, b, c: in std_logic; c_mas, s: out std_logic);
end component;
component xor2
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end component;
signal int: std_logic_vector (m-1 downto 0);
signal c: std_logic_vector (m downto 0);
begin
xor_gates: for i in m-1 downto 0 generate
comp: xor2 port map (entrada_b(i), operacion, int(i));
end generate;
c(0) <= operacion;
full_adders: for i in m-1 downto 0 generate
comp: add_1 port map (entrada_a(i), int(i), c(i), C(i+1), salida(i));
end generate;
acarreo <= c(m);
end circuito;

library ieee; use ieee.std_logic_1164.all;
entity nucleo is
port (Inst: in std_logic_vector (15 downto 0);
CP, Rj, Rk: inout std_logic_vector (7 downto 0);
dato: in std_logic_vector (7 downto 0); clk, reset: in std_logic; EscMem: out std_logic);
end nucleo;

architecture flujo of nucleo is
component cont_prog 
generic (m: natural);
port (entrada: in std_logic_vector (m-1 downto 0);
salida: inout std_logic_vector (m-1 downto 0);
escribir, clk, reset: in std_logic);
end component;
component dpreg
port (entrada: in std_logic_vector (7 downto 0); 
dir_esc, dir_a, dir_b: in std_logic_vector (3 downto 0);
escribir, clk: in std_logic; 
sal_a, sal_b: out std_logic_vector (7 downto 0));
end component;
component ual 
generic (m: natural);
port (entrada_a, entrada_b: in std_logic_vector (m-1 downto 0);
salida: out std_logic_vector (m-1 downto 0);
operacion: in std_logic; acarreo: out std_logic);
end component;
signal EscCP, EscC, C, acarreo: std_logic;
signal salual, entreg, entual2: std_logic_vector (7 downto 0);
begin
contador: cont_prog generic map (8) port map (salual, CP, EscCP, clk, reset);
banco: dpreg 
port map (entreg, Inst(11 downto 8), Inst (7 downto 4), Inst (3 downto 0), Inst (12), clk, Rj, Rk);
unidad: ual generic map (8) port map (Rj, entual2, salual, Inst(13), acarreo);
with Inst (15 downto 14) select entreg <= salual when "00",
Inst (7 downto 0) when "01", dato when "10", "XXXXXXXX" when others;
with EscCP select entual2 <= Rk when '0', CP when '1', "XXXXXXXX" when others;
C <= acarreo when clk'event and (clk = '1') and (EscC = '1') else C;
EscC <= not(Inst(15)) and not(Inst(14)) and Inst(12);
EscMem <= Inst(15) and Inst(14);
EscCP <= ( (not(Inst(15)) and Inst(14)) or (Inst(15) and not(Inst(14)) and C) )and not(Inst(13)) and not(Inst(12));
end flujo;

library ieee; use ieee.std_logic_1164.all;
entity procesador is
port (ent_A, ent_B: in std_logic_vector (7 downto 0);
sal_A, sal_B: inout std_logic_vector (7 downto 0);
clk, reset: in std_logic);
end procesador;

architecture bloques of procesador is
component nucleo 
port (Inst: in std_logic_vector (15 downto 0);
CP, Rj, Rk: inout std_logic_vector (7 downto 0);
dato: in std_logic_vector (7 downto 0); clk, reset: in std_logic; EscMem: out std_logic);
end component;
component rom 
generic (retardo: time := 20 ns; nombre_fichero: string := "data.rom");
port (direccion: in std_logic_vector; palabra: out std_logic_vector);
end component;
component ram_es 
port (Rj, Rk, ent_A, ent_B: in std_logic_vector (7 downto 0); 
dato: out std_logic_vector (7 downto 0);
sal_A, sal_B: inout std_logic_vector (7 downto 0);
clk, EscMem: in std_logic);
end component;
signal CP, Rj, Rk, dato: std_logic_vector (7 downto 0);
signal Inst: std_logic_vector (15 downto 0);
signal EscMem: std_logic;
begin
programa: rom generic map (10 ns, "programa.txt") port map (CP, Inst);
datos: ram_es port map (Rj, Rk, ent_A, ent_B, dato, sal_A, sal_B, clk, EscMem);
procesador: nucleo port map (Inst, CP, Rj, Rk, dato, clk, reset, EscMem);
end bloques;
