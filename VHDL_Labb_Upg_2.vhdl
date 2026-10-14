library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer_prom is
    port (
        clk, reset, 
        s : in std_logic;
        u : out std_logic;
        num : out std_logic_vector(3 downto 0)
    );
end timer_prom;

architecture rtl of timer_prom is
    type prom_type is array (0 to 31) of std_logic_vector(4 downto 0);
    constant PROM : prom_type := (
        0 => "10000",
        16 => "01000",
        1 | 17 => "00000", -- 1 -> 0
        2 | 18 => "00001", -- 2 -> 1
        3 | 19 => "00010", -- 3 -> 2
        4 | 20 => "00011", -- 4 -> 3
        5 | 21 => "00100", -- 5 -> 4
        6 | 22 => "00101", -- 6 -> 5
        7 | 23 => "00110", -- 7 -> 6
        8 | 24 => "00111", -- 8 -> 7
        others => "00000"
    );
    signal q, q_plus : std_logic_vector(3 downto 0);
    signal address : std_logic_vector(4 downto 0);
    signal data : std_logic_vector(4 downto 0);
begin
    num <= q;
    address <= s & q;
    data <= PROM(to_integer(unsigned(address)));
    u <= data(4);
    q_plus <= data(3 downto 0);

    process(clk, reset)
    begin
        if reset = '1' then
            q <= "0000";
        elsif rising_edge(clk) then
            q <= q_plus;
        end if;
    end process;
end rtl;
