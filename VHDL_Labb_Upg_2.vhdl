library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    port (
        clk, reset, startknapp : in std_logic;
        alarm : out std_logic;
        seg : out std_logic_vector(6 downto 0);
        dp : out std_logic;
        an : out std_logic_vector(3 downto 0)
    );
end timer;

architecture rtl of timer is

    type prom_type is array (0 to 31) of std_logic_vector(3 downto 0);
    constant PROM : prom_type := (
        0  => "0000",
        16 => "1000",
        1 | 17 => "0000",
        2 | 18 => "0001",
        3 | 19 => "0010",
        4 | 20 => "0011",
        5 | 21 => "0100",
        6 | 22 => "0101",
        7 | 23 => "0110",
        8 | 24 => "0111",
        others => "0000"
    );

    signal q, q_plus : std_logic_vector(3 downto 0);
    signal address : std_logic_vector(4 downto 0);
    signal start_sync1, start_sync2, start_puls : std_logic;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            start_sync1 <= startknapp;
            start_sync2 <= start_sync1;
        end if;
    end process;

    start_puls <= start_sync1 and not start_sync2;


    address <= start_puls & q;
    q_plus <= PROM(to_integer(unsigned(address)));


    process(clk, reset)
    begin
        if reset = '1' then
            q <= "0000";
        elsif rising_edge(clk) then
            q <= q_plus;
        end if;
    end process;


    alarm <= '1' when q = "0000" else '0';


    with q select
        seg <= "1000000" when "0000",
               "1111001" when "0001",
               "0100100" when "0010",
               "0110000" when "0011",
               "0011001" when "0100",
               "0010010" when "0101",
               "0000010" when "0110",
               "1111000" when "0111",
               "0000000" when "1000",
               "1111111" when others;

    dp <= '1';
    an <= "1110";

end rtl;
