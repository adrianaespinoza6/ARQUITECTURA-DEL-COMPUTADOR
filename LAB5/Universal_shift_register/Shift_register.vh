library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register is
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
end shift_register;

architecture Behavioral of shift_register is
    signal Q_bus : std_logic_vector(7 downto 0) := (others=> '0');
begin
    
    process (clk, reset)
    begin
        if reset = '1' then
            Q_bus <= (others => '0');
        elsif rising_edge(clk) then
            case mode is
                when "00" =>  -- SISO
                    Q_bus <= serial_in & Q_bus(7 downto 1);
                    
                when "01" =>  -- SIPO
                    Q_bus <= serial_in & Q_bus(7 downto 1);
                    
                when "10" =>  -- PISO
                    if load = '1' then
                        Q_bus <= parallel_in;
                    else
                        Q_bus <= '0' & Q_bus(7 downto 1);
                    end if;
                    
                when "11" =>  -- PIPO
                    if load = '1' then
                        Q_bus <= parallel_in;
                    end if;
                    
                when others =>
                    null;
            end case;
        end if;
    end process;
    
    -- Salidas 
    serial_out <= Q_bus(0);
    parallel_out <= Q_bus;
    
end Behavioral;
