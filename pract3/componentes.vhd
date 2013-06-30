library ieee; use ieee.std_logic_1164.all;
use std.textio.all;
package definiciones is
type memoria_binaria is array (natural range <>, natural range <>) of std_logic;
procedure cargar (nombre_fichero: in string; nombre_memoria: out memoria_binaria);
procedure conversion (bin: in std_logic_vector; int: out integer);
procedure conversion (int: in integer; bin: out std_logic_vector);
end definiciones;

package body definiciones is
procedure cargar (nombre_fichero: in string;
nombre_memoria: out memoria_binaria) is
file fichero_entrada: text is nombre_fichero;
variable puntero, posicion: integer;
variable linea: line;
variable prov: character;
begin
for puntero in nombre_memoria'range(1) loop
readline (fichero_entrada, linea);
for posicion in nombre_memoria'range(2) loop
read (linea, prov);
if prov = '0' then nombre_memoria (puntero, posicion) := '0';
elsif prov = '1' then nombre_memoria (puntero, posicion) := '1'; end if;
end loop;
end loop;
end cargar;
procedure conversion (bin: in std_logic_vector; int: out integer) is
variable resultado: integer;
begin
resultado := 0;
for i in bin'range loop
if bin(i) = '1' then resultado := resultado + 2**i; end if;
end loop;
int := resultado;
end conversion;
procedure conversion (int: in integer; bin: out std_logic_vector) is
variable prov: integer;
begin
prov := int;
for i in 0 to bin'length - 1 loop
if prov mod 2 = 1 then bin(i) := '1';
else bin(i) := '0'; end if;
prov := prov/2;
end loop;
end conversion;
end definiciones;


library ieee; use ieee.std_logic_1164.all;
entity add_1 is
generic (retardo: time := 1 ns);
port (a, b, c: in std_logic; c_mas, s: out std_logic);
end add_1;

architecture funcional of add_1 is
begin
s <= a xor b xor c after retardo;
c_mas <= (a and b) or (a and c) or (b and c) after retardo;
end funcional;

library ieee; use ieee.std_logic_1164.all;
entity test_add is end test_add;

architecture test of test_add is
component add_1 
generic (retardo: time := 1 ns);
port (a, b, c: in std_logic; c_mas, s: out std_logic);
end component;
for all: add_1 use entity work.add_1(funcional);
signal a, b, c, c_mas, s: std_logic;
begin
etiqueta: add_1 port map (a, b, c, c_mas, s);
a<= '0', '1'after 100 ns, '0' after 200 ns, '1' after 300 ns, '0' after 400 ns,
'1' after 500 ns, '0' after 600 ns, '1' after 700 ns;
b<= '0', '1'after 200 ns, '0' after 400 ns, '1' after 600 ns;
c<= '0', '1'after 400 ns;
end test;

library ieee; use ieee.std_logic_1164.all;
entity afa is
generic (retardo: time := 1 ns);
port (a, b, c: in std_logic; s, g, p: out std_logic);
end afa;

architecture funcional of afa is
begin
s <= a xor b xor c after retardo;
p <= a xor b after retardo;
g <= a and b after retardo;
end funcional;

library ieee; use ieee.std_logic_1164.all;
entity and2 is
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end and2;

architecture funcional of and2 is
begin
s <= a and b after retardo;
end funcional;

library ieee; use ieee.std_logic_1164.all;
entity and3 is
generic (retardo: time := 1 ns);
port (a, b, c: in std_logic; d: out std_logic);
end and3;

architecture funcional of and3 is
begin
d <= a and b and c after retardo;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity cla is
generic (retardo: time := 1 ns; n: natural := 4);
port (cin: in std_logic; G, P: in std_logic_vector (n-1 downto 0); 
c: out std_logic_vector (n-1 downto 1); G_ext, P_ext: out std_logic);
end cla;

architecture funcional of cla is
begin
process (cin, G, P)
variable a, b: std_logic_vector (0 to n-1);
begin
a(0) := G(0);
b(0) := P(0);
c(1) <= a(0) or (cin and b(0)) after retardo;
for i in 1 to n-2 loop
a(i) := G(i) or (a(i-1) and P(i));
b(i) := P(i) and b(i-1);
c(i+1) <= a(i) or (cin and b(i)) after retardo;
end loop;
a(n-1) := G(n-1) or (a(n-2) and P(n-1));
b(n-1) := P(n-1) and b(n-2);
G_ext <= a(n-1) after retardo;
P_ext <= b(n-1) after retardo;
end process;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity cy_ch is
generic (retardo: time := 1 ns);
port (G, P, c: in std_logic; c_mas: out std_logic);
end cy_ch;

architecture funcional of cy_ch is
begin
c_mas <= G or (c and P) after retardo;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity inv is
generic (retardo: time := 1 ns);
port (a: in std_logic; s: out std_logic);
end inv;

architecture funcional of inv is
begin
s <= not (a) after retardo;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity nor4 is
generic (retardo: time := 1 ns);
port (a, b, c, d: in std_logic; e: out std_logic);
end nor4;

architecture funcional of nor4 is
begin
e <= not (a or b or c or d) after retardo;
end funcional;


library ieee; use ieee.std_logic_1164.all;
use work.definiciones.all;
entity decod_4 is
port (dir: in std_logic_vector (3 downto 0); 
row: out std_logic_vector (15 downto 0));
end decod_4;

architecture circuito of decod_4 is

component inv
generic (retardo: time := 1 ns);
port (a: in std_logic; s: out std_logic);
end component;

component nor4
generic (retardo: time := 1 ns);
port (a, b, c, d: in std_logic; e: out std_logic);
end component;

signal dirb: std_logic_vector(3 downto 0);
type entradas is array (3 downto 0, 15 downto 0) of std_logic;
signal x: entradas;

begin

etiqueta0: for i in 3 downto 0 generate
etiqueta1: inv port map (dir(i), dirb(i));
end generate;

process (dir, dirb)
variable j: natural;
variable y: std_logic_vector (3 downto 0);
begin
for j in 15 downto 0 loop 
conversion(j, y);
for i in 3 downto 0 loop
if y(i) = '1' then  x(i,j) <= dirb(i); else x(i,j) <= dir(i); end if;
end loop;
end loop;
end process;

etiqueta2: for j in 0 to 15 generate
etiqueta3: nor4 port map (x(3,j), x(2,j), x(1,j), x(0,j), row(j));
end generate;
end circuito;


library ieee; use ieee.std_logic_1164.all;
entity dff is
generic (retardo: time := 1 ns; t_SU: time := 2 ns);
port (d, clk: in std_logic; q, qb: out std_logic);
begin
assert(not(clk='1' and clk'event and not d'stable(t_SU)))
report "violacion del tiempo de establecimiento"
severity warning;
end dff;

architecture funcional of dff is
begin
process
begin
wait until clk'last_value = '0' and clk'event and clk = '1';
q <= d after retardo;
qb <= not (d) after retardo;
end process;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity test_dff is
end test_dff;

architecture test of test_dff is
component dff 
generic (retardo: time := 1 ns; t_SU: time := 2 ns);
port (d, clk: in std_logic; q, qb: out std_logic);
end component;
signal d, clk, q, qb: std_logic := '0';
begin
etiqueta: dff generic map(750 ps, 1500 ps) port map (d, clk, q, qb);
clk <= not(clk) after 50 ns;
d <= '1' after 49 ns, '0' after 149 ns, '1' after 245 ns, '0' after 345 ns,
'1' after 445 ns, '0' after 549 ns, '1' after 645 ns, '0' after 745 ns;
end test;


library ieee; use ieee.std_logic_1164.all;
entity dffcp is
generic (retardo: time := 1 ns; t_SU: time := 2 ns);
port (d, clk, clear, preset: in std_logic; q, qb: out std_logic);
begin
assert(not(clk='1' and clk'event and not d'stable(t_SU)))
report "violacion del tiempo de establecimiento"
severity warning;
end dffcp;

architecture funcional of dffcp is
begin
process (clear, preset, clk)
variable qint: std_logic;
begin
if clear = '1' then qint := '0';
elsif preset = '1' then qint := '1';
elsif clk'event and clk = '1' then qint := d; end if;
q <= qint after retardo;
qb <= not (qint) after retardo;
end process;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity test_dffcp is
end test_dffcp;

architecture test of test_dffcp is
component dffcp 
generic (retardo: time := 1 ns; t_SU: time := 2 ns);
port (d, clk, clear, preset: in std_logic; q, qb: out std_logic);
end component;
for all: dffcp use entity work.dffcp(funcional);
signal d, clk, clear, preset, q, qb: std_logic := '0';
begin
etiqueta: dffcp generic map(750 ps, 1500 ps) port map (d, clk, clear, preset, q, qb);
clk <= not(clk) after 50 ns;
preset <= '1', '0' after 10 ns, '1' after 900 ns, '0' after 1010 ns;
--d <= not(d) after 100 ns;
d <= '1' after 49 ns, '0' after 149 ns, '1' after 245 ns, '0' after 345 ns,
'1' after 445 ns, '0' after 549 ns, '1' after 645 ns, '0' after 745 ns;
clear <= '0', '1' after 400 ns, '0' after 510 ns;
end test;


library ieee; use ieee.std_logic_1164.all;
entity half_add is
generic (retardo: time := 1 ns);
port (a, c: in std_logic; c_mas, s: out std_logic);
end half_add;

architecture funcional of half_add is
begin
s <= a xor c after retardo;
c_mas <= a and c after retardo;
end funcional;

library ieee; use ieee.std_logic_1164.all;
entity test_half_add is end test_half_add;

architecture test of test_half_add is
component half_add
generic (retardo: time := 1 ns);
port (a, c: in std_logic; c_mas, s: out std_logic);
end component;
for all: half_add use entity work.half_add(funcional);
signal a, c, c_mas, s: std_logic;
begin
etiqueta: half_add port map (a, c, c_mas, s);
a<= '0', '1'after 100 ns, '0' after 200 ns, '1' after 300 ns, '0' after 400 ns,
'1' after 500 ns, '0' after 600 ns, '1' after 700 ns;
c<= '0', '1'after 200 ns, '0' after 400 ns, '1' after 600 ns;
end test;


library ieee; use ieee.std_logic_1164.all;
entity latch is
generic (retardo: time := 1 ns);
port (d, en: in std_logic; q, qb: out std_logic);
end latch;

architecture funcional of latch is
begin
process (d, en)
variable qint: std_logic;
begin
if  en = '1' then qint := d; end if;
q <= qint after retardo;
qb <= not (qint) after retardo;
end process;
end funcional;

library ieee; use ieee.std_logic_1164.all;
entity test_latch is
end test_latch;

architecture test of test_latch is
component latch 
generic (retardo: time := 1 ns);
port (d, en: in std_logic; q, qb: out std_logic);
end component;
for all: latch use entity work.latch(funcional);
signal d, en, q, qb: std_logic;
begin
etiqueta: latch generic map (2 ns) port map (d, en, q, qb);
en <= '1', '0' after 100 ns, '1' after 200 ns, '0' after 300 ns, '1' after 400 ns;
d <= '1', '0' after 50 ns, '1' after 90 ns, '0' after 150 ns, '1' after 225 ns,
'0' after 275 ns, '1' after 350 ns;
end test;


library ieee; use ieee.std_logic_1164.all;
entity mux2to1 is
generic (retardo: time := 1 ns);
port (a, b, c: in std_logic; s: out std_logic);
end mux2to1;

architecture funcional of mux2to1 is
begin
s <= (not(c) and a) or (c and b) after retardo;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity mux4to1 is
generic (retardo: time := 1 ns);
port (a, b, c, d, e, f: in std_logic; s: out std_logic);
end mux4to1;

architecture funcional of mux4to1 is
begin
s <= (not(e) and not(f) and a) or (not(e) and f and b) or (e and not(f) and c) or (e and f and a) after retardo;
end funcional;

architecture estructural of mux4to1 is
component mux2to1
generic (retardo: time := 1 ns);
port (a, b, c: in std_logic; s: out std_logic);
end component;
for all: mux2to1 use entity work.mux2to1(funcional);
signal s1, s2: std_logic;
begin
multiplexor_1: mux2to1 generic map (250 ps) port map(a, b, f, s1);
multiplexor_2: mux2to1 generic map (250 ps) port map (c, d, f, s2);
multiplexor_3: mux2to1 generic map (500 ps) port map (s1, s2, e, s);
end estructural;


library ieee; use ieee.std_logic_1164.all;
entity loadable_shift_reg is
generic (n: natural := 8);
port (serial_in, clk, load: in std_logic;
parallel_in: in std_logic_vector (n-1 downto 0);
q, qb: inout std_logic_vector (n-1 downto 0));
end loadable_shift_reg;

architecture circuito of loadable_shift_reg is

component dff
generic (retardo: time := 1 ns; t_SU: time := 2 ns);
port (d, clk: in std_logic; q, qb: out std_logic);
end component;

component mux2to1
generic (retardo: time := 1 ns);
port (a, b, c: in std_logic; s: out std_logic);
end component;

signal d: std_logic_vector (n-1 downto 0);

begin
etiqueta1: mux2to1 port map (serial_in, parallel_in(n-1), load, d(n-1));
etiqueta2: dff port map (d(n-1), clk, q(n-1), qb(n-1));
etiqueta3: for i in n-2 downto 0 generate
etiqueta4: mux2to1 port map (q(i+1), parallel_in(i), load, d(i));
etiqueta5: dff port map (d(i), clk, q(i), qb(i));
end generate;
end circuito;

library ieee; use ieee.std_logic_1164.all;
entity test_loadable_shift_reg is
end test_loadable_shift_reg;

architecture test of test_loadable_shift_reg is
component loadable_shift_reg 
port (serial_in, clk, load: in std_logic;parallel_in: std_logic_vector;
q, qb: inout std_logic_vector);
end component;

signal parallel_in, q, qb: std_logic_vector(7 downto 0);
signal load: std_logic;
signal serial_in: std_logic := '1';
signal clk: std_logic := '0';
begin
etiqueta: loadable_shift_reg port map (serial_in, clk, load, parallel_in, q, qb);
clk <= not(clk) after 100 ns;
load <= '1', '0' after 150 ns, '1' after 1050 ns, '0' after 1150 ns;
serial_in <= not(serial_in) after 200 ns;
parallel_in <= "01101101";
end test;


library ieee; use ieee.std_logic_1164.all;
entity nand2 is
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end nand2;

architecture funcional of nand2 is
begin
s <= not (a and b) after retardo;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity nand3 is
generic (retardo: time := 1 ns);
port (a, b, c: in std_logic; s: out std_logic);
end nand3;

architecture funcional of nand3 is
begin
s <= not (a and b and c) after retardo;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity nor2 is
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end nor2;

architecture funcional of nor2 is
begin
s <= not (a or b) after retardo;
end funcional;

library ieee; use ieee.std_logic_1164.all;
entity or2 is
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end or2;

architecture funcional of or2 is
begin
s <= a or b after retardo;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity reg_dff is
port (d: in std_logic_vector; clk, clear, preset: in std_logic;q, qb: out std_logic_vector);
end reg_dff;

architecture circuito of reg_dff is
component dffcp
generic (retardo: time := 1 ns; t_SU: time := 2 ns);
port (d, clk, clear, preset: in std_logic; q, qb: out std_logic);
end component;
begin
etiqueta1: for i in d'length -1 downto 0 generate
etiqueta2: dffcp port map (d(i), clk, clear, preset, q(i), qb(i));
end generate;
end circuito;

library ieee; use ieee.std_logic_1164.all;
entity test_reg_dff is
end test_reg_dff;

architecture test of test_reg_dff is
component reg_dff 
port (d: in std_logic_vector; clk, clear, preset: in std_logic;q, qb: out std_logic_vector);
end component;

signal d, q, qb: std_logic_vector(7 downto 0);
signal clk, clear, preset: std_logic;
begin
etiqueta: reg_dff port map (d, clk, clear, preset, q, qb);
clk <= '1', '0' after 100 ns, '1' after 200 ns, '0' after 300 ns, '1' after 400 ns;
clear <= '1', '0' after 20 ns;
preset <= '0', '1' after 170 ns, '0' after 180 ns;
d <= "10101010", "01010101" after 50 ns, "11111111" after 90 ns, "00000000" after 150 ns, 
"10011001" after 225 ns, "01101001" after 275 ns;
end test;


library ieee; use ieee.std_logic_1164.all;
entity reg_latch is
port (d: in std_logic_vector; en: in std_logic;q, qb: out std_logic_vector);
end reg_latch;

architecture circuito of reg_latch is
component latch
generic (retardo: time := 1 ns);
port (d, en: in std_logic; q, qb: out std_logic);
end component;
begin
etiqueta1: for i in d'length -1 downto 0 generate
etiqueta2: latch port map (d(i), en, q(i), qb(i));
end generate;
end circuito;

library ieee; use ieee.std_logic_1164.all;
entity test_reg_latch is
end test_reg_latch;

architecture test of test_reg_latch is
component reg_latch 
port (d: in std_logic_vector; en: in std_logic;q, qb: out std_logic_vector);
end component;

signal d, q, qb: std_logic_vector(7 downto 0);
signal en: std_logic;
begin
etiqueta: reg_latch port map (d, en, q, qb);
en <= '1', '0' after 100 ns, '1' after 200 ns, '0' after 300 ns, '1' after 400 ns;
d <= "10101010", "01010101" after 50 ns, "11111111" after 90 ns, "00000000" after 150 ns, 
"10011001" after 225 ns, "01101001" after 275 ns;
end test;


library ieee; use ieee.std_logic_1164.all;
use std.textio.all;
use work.definiciones.all;
entity rom is
generic (retardo: time := 20 ns; nombre_fichero: string := "data.rom");
port (direccion: in std_logic_vector; palabra: out std_logic_vector);
end rom;

architecture funcional of rom is
constant n: integer := 2**direccion'length;
constant m: integer := palabra'length;
begin
process
variable rombit: memoria_binaria (0 to n-1, m-1 downto 0);
variable dir: integer;
begin
cargar (nombre_fichero, rombit);
loop
conversion (direccion, dir);
for j in 0 to m-1 loop
palabra(j) <= rombit(dir, j) after retardo; 
end loop;
wait until direccion'event;
end loop;
end process;
end funcional;



library ieee; use ieee.std_logic_1164.all;
use std.textio.all;
use work.definiciones.all;
entity test_rom is
end test_rom;

architecture test of test_rom is
component rom 
generic (retardo: time := 20 ns; nombre_fichero: string := "data.rom");
port (direccion: in std_logic_vector; palabra: out std_logic_vector);
end component;
for all: rom use entity work.rom(funcional);
signal direccion: std_logic_vector (2 downto 0);
signal palabra: std_logic_vector (7 downto 0);
begin
etiqueta: rom generic map (10 ns, "rom.dat") port map (direccion, palabra);
direccion <= "000", "001" after 50 ns, "010" after 100 ns, 
"011" after 150 ns, "100" after 200 ns, "101" after 250 ns, 
"110" after 300 ns, "111" after 350 ns, "000" after 400 ns; 
end test;


library ieee; use ieee.std_logic_1164.all;
entity shift_reg is
generic (n: natural := 8);
port (serial_in, clk, clear, preset: in std_logic;q, qb: inout std_logic_vector (n-1 downto 0));
end shift_reg;

architecture circuito of shift_reg is
component dffcp
generic (retardo: time := 1 ns; t_SU: time := 2 ns);
port (d, clk, clear, preset: in std_logic; q, qb: out std_logic);
end component;
begin
etiqueta0: dffcp port map (serial_in, clk, clear, preset, q(n-1), qb(n-1));
etiqueta1: for i in n-2 downto 0 generate
etiqueta2: dffcp port map (q(i+1), clk, clear, preset, q(i), qb(i));
end generate;
end circuito;

library ieee; use ieee.std_logic_1164.all;
entity test_shift_reg is
end test_shift_reg;

architecture test of test_shift_reg is
component shift_reg 
port (serial_in, clk, clear, preset: in std_logic;q, qb: inout std_logic_vector);
end component;

signal q, qb: std_logic_vector(7 downto 0);
signal clear, preset: std_logic;
signal serial_in: std_logic := '1';
signal clk: std_logic := '0';
begin
etiqueta: shift_reg port map (serial_in, clk, clear, preset, q, qb);
clk <= not(clk) after 100 ns;
preset <= '0', '1' after 470 ns, '0' after 480 ns;
clear <= '1', '0' after 20 ns;
serial_in <= not(serial_in) after 200 ns;
end test;


library ieee; use ieee.std_logic_1164.all;
use work.definiciones.all;
entity sram is
generic (retardo: time := 10 ns);
port
(address: in std_logic_vector;
data_in: in std_logic_vector;
data_out: out std_logic_vector;
WE, ME: in std_logic);
end sram;

architecture funcional of sram is
constant n: integer := address'length;
constant m: integer := data_in'length;
begin
process (ME, WE, data_in, address)
variable contenido: memoria_binaria (0 to 2**n-1, m-1 downto 0);
variable fila: integer;
begin
--dirección
conversion (address, fila); 
-- escritura
if ME = '1' and WE = '1' then
for j in 0 to m-1 loop 
contenido (fila, j) := data_in (j); 
data_out(j) <= 'Z' after retardo;
end loop;
--lectura
elsif ME = '1' and WE = '0' then
for j in 0 to m-1 loop 
data_out (j) <= contenido (fila, j) after retardo; 
end loop;

else 
for j in 0 to m-1 loop 
data_out (j) <= 'Z' after retardo; 
end loop; 
end if;
end process;
end funcional;


library ieee; use ieee.std_logic_1164.all;
use work.definiciones.all;
entity test_sram is
end test_sram;

architecture test of test_sram is
component sram 
generic (retardo: time := 10 ns);
port
(address: in std_logic_vector;
data_in: in std_logic_vector;
data_out: out std_logic_vector;
WE, ME: in std_logic);
end component;
signal address: std_logic_vector (3 downto 0);
signal data_in, data_out: std_logic_vector (7 downto 0);
signal WE, ME: std_logic;
begin
etiqueta: sram generic map (5 ns) port map (address, data_in, data_out, WE, ME);

address <= "0000", "0001" after 100 ns, 
"0010" after 200 ns, "1110" after 300 ns, 
"1111" after 400 ns, "0000" after 500 ns, 
"0001" after 600 ns, "0010" after 700 ns, 
"1110" after 800 ns, "1111" after 900 ns,
"0000" after 1000 ns;
ME <= '0', '1' after 25 ns, '0' after 75 ns,
'1' after 125 ns, '0' after 175 ns, '1' after 225 ns, '0' after 275 ns,
'1' after 325 ns, '0' after 375 ns, '1' after 425 ns, '0' after 475 ns,
'1' after 525 ns, '0' after 575 ns, '1' after 625 ns, '0' after 675 ns,
'1' after 725 ns, '0' after 775 ns, '1' after 825 ns, '0' after 875 ns,
'1' after 925 ns, '0' after 975 ns, '1' after 1025 ns, '0' after 1075 ns;
WE <= '1', '0' after 500 ns;
data_in <= "01010101", "10101010" after 100 ns, 
"00110011" after 200 ns, "11001100" after 300 ns,
"11111111" after 400 ns, "00000000" after 500 ns;
end test;

library ieee; use ieee.std_logic_1164.all;
entity tri_buf is
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end tri_buf;

architecture funcional of tri_buf is
begin
with b select s <= a after retardo when '1', 'Z' after retardo when others;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity xnor2 is
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end xnor2;

architecture funcional of xnor2 is
begin
s <= not (a xor b) after retardo;
end funcional;


library ieee; use ieee.std_logic_1164.all;
entity xor2 is
generic (retardo: time := 1 ns);
port (a, b: in std_logic; s: out std_logic);
end xor2;

architecture funcional of xor2 is
begin
s <= a xor b after retardo;
end funcional;


