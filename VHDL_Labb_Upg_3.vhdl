library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tarning is
    port(
        clk, reset, roll, fake : in std_logic;
        varde : out std_logic_vector(3 downto 0)
    );
end tarning;

architecture rtl of tarning is

    type prom1_type is array(0 to 15)
        of std_logic_vector(2 downto 0);

    constant PROM1 : prom1_type := (
        0  => "000", 
        1  => "001",
        2  => "010", 
        3  => "011",
        4  => "100", 
        5  => "101",
        6  => "110", 
        7  => "000",
        8  => "001", 
        9  => "010",
        10 => "011", 
        11 => "100",
        12 => "101", 
        13 => "110",
        14 => "000", 
        15 => "000"
    );

    type prom2_type is array(0 to 3)
        of std_logic;

    constant PROM2 : prom2_type := (
        0 => '0', 
        1 => '1',
        2 => '1', 
        3 => '0'
    );

    signal q1, q1_plus : std_logic_vector(2 downto 0);
    signal q2, q2_plus : std_logic;
    signal a1 : std_logic_vector(3 downto 0);
    signal a2 : std_logic_vector(1 downto 0);

begin

    a1 <= roll & q1;
    a2 <= (fake and roll) & q2;


    q1_plus <= PROM1(to_integer(unsigned(a1)));
    q2_plus <= PROM2(to_integer(unsigned(a2)));


    process(clk, reset)
    begin
        if reset = '1' then
            q1 <= "000";
            q2 <= '0';
        elsif rising_edge(clk) then
            q1 <= q1_plus;
            q2 <= q2_plus;
        end if;
    end process;


    varde <= "0110" when q2 = '1' else
             '0' & q1;

end rtl;