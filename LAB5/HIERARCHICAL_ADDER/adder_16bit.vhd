library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_16bit is
    Port (
        a : in STD_LOGIC_VECTOR(15 downto 0);
        b : in STD_LOGIC_VECTOR(15 downto 0);
        cin : in STD_LOGIC;
        sum : out STD_LOGIC_VECTOR(15 downto 0);
        cout : out STD_LOGIC
    );
end adder_16bit;

architecture structural of adder_16bit is
    signal carry_in : STD_LOGIC_VECTOR(15 downto 0);
    
    component full_adder is
        Port (
            a : in STD_LOGIC;
            b : in STD_LOGIC;
            cin : in STD_LOGIC;
            sum : out STD_LOGIC;
            carry : out STD_LOGIC
        );
    end component;
    
begin
   
    FA0: full_adder port map(
        a => a(0),
        b => b(0),
        cin => cin, 
        sum => sum(0),
        carry => carry_in(0)
    );
    
    FULL_ADDERS: for i in 1 to 15 generate
        FA: full_adder port map(
            a => a(i),
            b => b(i),
            cin => carry_in(i-1),
            sum => sum(i),
            carry => carry_in(i)
        );
    end generate FULL_ADDERS;
    
  
    cout <= carry_in(15);
end structural;
