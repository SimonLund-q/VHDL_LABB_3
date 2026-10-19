library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dice is
    port (
        clk, reset, roll, fake : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        dp : out std_logic;
        an : out std_logic_vector(3 downto 0)
    );
end dice;

architecture rtl of dice is

    constant PROM : prom_type := (
        0 => "001",
        1 => "010",
        2 => "011",
        3 => "100",
        4 => "101",
        5 => "000",
        6 | 7 => "000",

        8 => "001",
        9 => "010",
        10 => "011",
        11 => "100",
        12 => "101",
        13 => "110",
        14 => "111",
        15 => "000"
    );

    signal q, q_plus : std_logic_vector(2 downto 0);
    signal address : std_logic_vector(3 downto 0);
    signal varde : std_logic_vector(3 downto 0);

begin

    address <= fake & q;
    q_plus <= PROM(to_integer(unsigned(address)));

    process(clk, reset)
    begin
        if reset = '1' then
            q <= "000";
        elsif rising_edge(clk) then
            if roll = '1' then
                q <= q_plus;
            end if;
        end if;
    end process;

    with q select
    varde <= "0001" when "0000",
             "0010" when "0001",
             "0011" when "0010",
             "0100" when "0011",
             "0101" when "0100",
             "0110" when "0101",
             "0110" when "0110",
             "0110" when "0111",
             "0000" when others;


    with varde select
        seg <= "1111001" when "0001",
               "0100100" when "0010",
               "0110000" when "0011",
               "0011001" when "0100",
               "0010010" when "0101",
               "0000010" when "0110",
               "1111111" when others;

    dp <= '1';
    an <= "1110";

end rtl;
