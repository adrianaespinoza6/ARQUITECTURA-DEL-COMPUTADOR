
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_64bit_tb is
end ALU_64bit_tb;

architecture Behavioral of ALU_64bit_tb is
    component ALU_64bit
        Port (
            clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            A        : in  STD_LOGIC_VECTOR(63 downto 0);
            B        : in  STD_LOGIC_VECTOR(63 downto 0);
            operation  : in  STD_LOGIC_VECTOR(4 downto 0);
            result   : out STD_LOGIC_VECTOR(63 downto 0);
            zero     : out STD_LOGIC;
            overflow : out STD_LOGIC
        );
    end component;

    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '0';
    signal A        : STD_LOGIC_VECTOR(63 downto 0);
    signal B        : STD_LOGIC_VECTOR(63 downto 0);
    signal operation  : STD_LOGIC_VECTOR(4 downto 0);
    signal result   : STD_LOGIC_VECTOR(63 downto 0);
    signal zero     : STD_LOGIC;
    signal overflow : STD_LOGIC;
    
    constant CLK_PERIOD : time := 10 ns;

begin

    DUT: ALU_64bit
        port map (
            clk => clk,
            reset => reset,
            A => A,
            B => B,
            operation => operation,
            result => result,
            zero => zero,
            overflow => overflow
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

stim_proc: process
begin
    reset <= '1';
    wait for CLK_PERIOD;
    reset <= '0';
    wait for CLK_PERIOD; 
    
    -- Test Addition
    A <= X"0000000098000000";
    B <= X"00000140000E0003";
    operation <= "00000"; 
    wait for CLK_PERIOD;
    
    -- Test Subtraction
    operation <= "00001";  
    wait for CLK_PERIOD;
    
    -- Test AND
    A <= X"FFFFFFFFFFFFFFFF";
    B <= X"F0F0F0F0F0F0F0F0";
    operation <= "01000";  
    wait for CLK_PERIOD;
    
    -- Test OR
    operation <= "01001";  
    wait for CLK_PERIOD;
    
    -- Test XOR
    operation <= "01010";  
    wait for CLK_PERIOD;
    
    -- Test Left Shift
    A <= X"0000000000000001";
    B <= X"0000000000000004"; 
    operation <= "10000";  
    wait for CLK_PERIOD;
    
    -- Test Zero flag
    A <= X"0000000000000000";
    B <= X"0000000000000000";
    operation <= "00000"; 
    wait for CLK_PERIOD;
    
    wait;
end process;

end Behavioral;
