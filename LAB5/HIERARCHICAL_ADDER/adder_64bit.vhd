library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_64bit is
    Port (
        a : in STD_LOGIC_VECTOR(63 downto 0);
        b : in STD_LOGIC_VECTOR(63 downto 0);
        sum : out STD_LOGIC_VECTOR(63 downto 0);
        overflow : out STD_LOGIC
    );
end adder_64bit;

architecture hierarchical of adder_64bit is
    signal carry_in : STD_LOGIC_VECTOR(3 downto 0);
    
    component adder_16bit is
        Port (
            a : in STD_LOGIC_VECTOR(15 downto 0);
            b : in STD_LOGIC_VECTOR(15 downto 0);
            cin : in STD_LOGIC;
            sum : out STD_LOGIC_VECTOR(15 downto 0);
            cout : out STD_LOGIC
        );
    end component;
    
begin

    ADDER0: adder_16bit port map(
        a => a(15 downto 0),
        b => b(15 downto 0),
        cin => '0',
        sum => sum(15 downto 0),
        cout => carry_in(0)
    );
    
   
    ADDER1: adder_16bit port map(
        a => a(31 downto 16),
        b => b(31 downto 16),
        cin => carry_in(0),
        sum => sum(31 downto 16),
        cout => carry_in(1)
    );
    
 
    ADDER2: adder_16bit port map(
        a => a(47 downto 32),
        b => b(47 downto 32),
        cin => carry_in(1),
        sum => sum(47 downto 32),
        cout => carry_in(2)
    );
    
 
    ADDER3: adder_16bit port map(
        a => a(63 downto 48),
        b => b(63 downto 48),
        cin => carry_in(2),
        sum => sum(63 downto 48),
        cout => carry_in(3)
    );
    
    overflow <= carry_in(3);
end hierarchical;
