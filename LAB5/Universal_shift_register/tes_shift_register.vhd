library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tes_shift_register is
end tes_shift_register;

architecture Behavioral of tes_shift_register is
    signal clk          : std_logic := '0';
    signal mode         : std_logic_vector(1 downto 0) := "00";
    signal reset        : std_logic := '0';
    signal load         : std_logic := '0';
    signal serial_in    : std_logic := '0';
    signal serial_out   : std_logic;
    signal parallel_in  : std_logic_vector(7 downto 0) := (others => '0');
    signal parallel_out : std_logic_vector(7 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
    
    component shift_register
        port (
            clk          : in  std_logic;
            mode         : in  std_logic_vector(1 downto 0);
            reset        : in  std_logic;
            load         : in  std_logic;
            serial_in    : in  std_logic;
            serial_out   : out std_logic;
            parallel_in  : in  std_logic_vector(7 downto 0);
            parallel_out : out std_logic_vector(7 downto 0)
        );
    end component;
    
begin
    DUT: shift_register port map (
        clk => clk, mode => mode, reset => reset, load => load,
        serial_in => serial_in, serial_out => serial_out,
        parallel_in => parallel_in, parallel_out => parallel_out
    );
    
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    stim_process: process
    begin
        
        -- TEST 2: SISO (168)
        mode <= "00";
        reset <= '0';
        load <= '0';
        serial_in <= '0';
        parallel_in <= (others => '0');
        
        wait until rising_edge(clk);
        serial_in <= '1';
        wait until rising_edge(clk);
        serial_in <= '0';
        wait until rising_edge(clk);
        serial_in <= '1';
        wait until rising_edge(clk);
        serial_in <= '0';
        wait until rising_edge(clk);
        serial_in <= '1';
        wait until rising_edge(clk);
        serial_in <= '0';
        wait until rising_edge(clk);
        serial_in <= '0';
        wait until rising_edge(clk);
        serial_in <= '1';
        wait until rising_edge(clk);
        wait for CLK_PERIOD * 8;
        
        wait until rising_edge(clk);
        reset <= '1';
        wait until rising_edge(clk);
        reset <= '0';


       

        
        -- TEST 3: SIPO (202)
        mode <= "01";
        wait until rising_edge(clk);
        serial_in <= '1';
        wait until rising_edge(clk);
        serial_in <= '1';
        wait until rising_edge(clk);
        serial_in <= '0';
        wait until rising_edge(clk);
        serial_in <= '0';
        wait until rising_edge(clk);
        serial_in <= '1';
        wait until rising_edge(clk);
        serial_in <= '0';
        wait until rising_edge(clk);
        serial_in <= '1';
        wait until rising_edge(clk);
        serial_in <= '0';
        wait until rising_edge(clk);
        
        
        wait until rising_edge(clk);
        reset <= '1';
        wait until rising_edge(clk);
        reset <= '0'; 
        
        -- TEST 4: PISO (12)
        mode <= "10";
        parallel_in <= "00001100";
        wait until rising_edge(clk);
        load <= '1';  
        wait until rising_edge(clk);
        load <= '0';
        serial_in <= '0';  -- 
        wait until rising_edge(clk);
        wait for CLK_PERIOD * 8;
        
        wait until rising_edge(clk);
        reset <= '1';
        wait until rising_edge(clk);
        reset <= '0';
        
        
        -- TEST 5: PIPO 
        mode <= "11";
        parallel_in <= "10100001";
        wait until rising_edge(clk);
        load <= '1';
        wait until rising_edge(clk);
        load <= '0';
        wait for CLK_PERIOD * 3;
        
        parallel_in <= "01001011";
        wait until rising_edge(clk);
        load <= '1';
        wait until rising_edge(clk);
        load <= '0';
        wait for CLK_PERIOD * 2;
        
        parallel_in <= "10101010";
        wait until rising_edge(clk);
        load <= '1';
        wait until rising_edge(clk);
        load <= '0';
        
        wait for CLK_PERIOD * 5;
        wait;
    end process;
end Behavioral;
