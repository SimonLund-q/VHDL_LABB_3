library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kodlas is
    port(
        clk, reset: in std_logic;
        x1, x0    : in std_logic;
        u         : out std_logic
    );
end kodlas;

architecture rtl of kodlas is
    -- Using prom_type to avoid conflicts with the PROM constant name
    type prom_type is array (0 to 15) of std_logic_vector(2 downto 0); 
    
    constant PROM : prom_type := (
        0  => "001",
        1  => "000",
        2  => "000",
        3  => "000",
        4  => "001",
        5  => "010",
        6  => "000",
        7  => "000",
        8  => "000",
        9  => "010",
        10 => "000",
        11 => "011",
        12 => "100",
        13 => "111",
        14 => "111",
        15 => "111"
    );

    signal data : std_logic_vector(2 downto 0);
    signal addr : unsigned(3 downto 0);

    -- q0 and q1 represent our register state outputs
    signal q0, q1: std_logic;
    signal q0_plus, q1_plus: std_logic;

begin
    -- Combinational Logic: Create the ROM address from inputs and current states
    addr <= unsigned(std_logic_vector'(x1 & x0 & q1 & q0));
    data <= PROM(to_integer(addr));

    -- Assign current output and next-state signals from ROM bits
    u        <= data(2);
    q1_plus  <= data(1);
    q0_plus  <= data(0);

    -- Sequential Logic: Synchronous registers replacing the two D flip-flops
    registers : process(clk, reset)
    begin
        if reset = '1' then
            q1 <= '0';
            q0 <= '0';
        elsif rising_edge(clk) then
            q1 <= q1_plus;
            q0 <= q0_plus;
        end if;
    end process;

end architecture;