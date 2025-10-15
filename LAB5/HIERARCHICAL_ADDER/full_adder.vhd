library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port (
        a : in STD_LOGIC;
        b : in STD_LOGIC;
        cin : in STD_LOGIC;
        sum : out STD_LOGIC;
        carry : out STD_LOGIC
    );
end full_adder;

architecture structural of full_adder is
    signal s1, c1, c2 : STD_LOGIC;
    
    component half_adder is
        Port (
            a : in STD_LOGIC;
            b : in STD_LOGIC;
            sum : out STD_LOGIC;
            carry : out STD_LOGIC
        );
    end component;
    
begin
    HA1: half_adder port map(a, b, s1, c1);
    HA2: half_adder port map(s1, cin, sum, c2);
    carry <= c1 or c2;
end structural;
