library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ALU_64bit is
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
end ALU_64bit;

architecture Behavioral of ALU_64bit is
    
    signal reg_result   : STD_LOGIC_VECTOR(63 downto 0);
    signal reg_zero     : STD_LOGIC;
    signal reg_overflow : STD_LOGIC;
    signal add_result      : STD_LOGIC_VECTOR(63 downto 0);
    signal sub_result      : STD_LOGIC_VECTOR(63 downto 0);
    signal mult_result     : STD_LOGIC_VECTOR(63 downto 0);
    signal div_result      : STD_LOGIC_VECTOR(63 downto 0);
    signal mod_result      : STD_LOGIC_VECTOR(63 downto 0);
    signal add_overflow    : STD_LOGIC;
    signal sub_overflow    : STD_LOGIC;
    signal mult_overflow   : STD_LOGIC;
    
begin

    
    process(A, B, operation , add_result, sub_result, mult_result, div_result, mod_result)
        variable temp_mult : STD_LOGIC_VECTOR(127 downto 0);
        variable temp_div  : STD_LOGIC_VECTOR(63 downto 0);
        variable temp_mod  : STD_LOGIC_VECTOR(63 downto 0);
    begin
        
        ---Inicializar valores
        add_overflow <= '0';
        sub_overflow <= '0';
        mult_overflow <= '0';
        
        -- Addition
        add_result <= STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(B));
        if (A(63) = '0' and B(63) = '0' and add_result(63) = '1') or
           (A(63) = '1' and B(63) = '1' and add_result(63) = '0') then
            add_overflow <= '1';
        end if;
        
        -- Subtraction 
        sub_result <= STD_LOGIC_VECTOR(SIGNED(A) - SIGNED(B));
        if (A(63) = '0' and B(63) = '1' and sub_result(63) = '1') or
           (A(63) = '1' and B(63) = '0' and sub_result(63) = '0') then
            sub_overflow <= '1';
        end if;
        
        -- Multiplication (resultado en 64bits)
        temp_mult := STD_LOGIC_VECTOR(SIGNED(A) * SIGNED(B));
        mult_result <= temp_mult(63 downto 0);
        if (temp_mult(127 downto 64) /= (63 downto 0 => temp_mult(63))) then
            mult_overflow <= '1';
        end if;
        
        -- Division
        if B /= (63 downto 0 => '0') then
            div_result <= STD_LOGIC_VECTOR(SIGNED(A) / SIGNED(B));
            mod_result <= STD_LOGIC_VECTOR(SIGNED(A) mod SIGNED(B));
        else
            div_result <= (others => '0'); 
            mod_result <= (others => '0');
        end if;
    end process;

    -- Clocked process for operation selection
    process(clk, reset)
        variable shift_amount : integer;
    begin
        if reset = '1' then
            reg_result <= (others => '0');
            reg_zero <= '0';
            reg_overflow <= '0';
        elsif rising_edge(clk) then
            reg_overflow <= '0';  
            
            case operation  is
               
                when "00000" =>  -- Signed ADD
                    reg_result <= add_result;
                    reg_overflow <= add_overflow;
                    
                when "00001" =>  -- Signed SUB
                    reg_result <= sub_result;
                    reg_overflow <= sub_overflow;
                    
                when "00010" =>  -- Signed MULT
                    reg_result <= mult_result;
                    reg_overflow <= mult_overflow;
                    
                when "00011" =>  -- Signed DIV
                    reg_result <= div_result;

                    
                when "00100" =>  -- Signed MOD
                    reg_result <= mod_result;
                    
 
                when "01000" =>  -- AND
                    reg_result <= A and B;
                    
                when "01001" =>  -- OR
                    reg_result <= A or B;
                    
                when "01010" =>  -- XOR
                    reg_result <= A xor B;
                    
                when "01011" =>  -- NOT A
                    reg_result <= not A;
                    
                when "01100" =>  -- NOT B
                    reg_result <= not B;
                    
                when "01101" =>  -- NAND
                    reg_result <= A nand B;
                    
                when "01110" =>  -- NOR
                    reg_result <= A nor B;
                    
                when "01111" =>  -- XNOR
                    reg_result <= A xnor B;
                    
   
                when "10000" =>  -- Logic left shift
                    shift_amount := to_integer(unsigned(B(5 downto 0)));  
                    reg_result <= STD_LOGIC_VECTOR(shift_left(unsigned(A), shift_amount));
                    
                when "10001" =>  -- Logic right shift
                    shift_amount := to_integer(unsigned(B(5 downto 0)));
                    reg_result <= STD_LOGIC_VECTOR(shift_right(unsigned(A), shift_amount));
                    
                when "10010" =>  -- Arithmetic left shift
                    shift_amount := to_integer(unsigned(B(5 downto 0)));
                    reg_result <= STD_LOGIC_VECTOR(shift_left(signed(A), shift_amount));
                    
                when "10011" =>  -- Arithmetic right shift
                    shift_amount := to_integer(unsigned(B(5 downto 0)));
                    reg_result <= STD_LOGIC_VECTOR(shift_right(signed(A), shift_amount));
                    
                when "10100" =>  -- Left rotate
                    shift_amount := to_integer(unsigned(B(5 downto 0))) mod 64;
                    reg_result <= STD_LOGIC_VECTOR(rotate_left(unsigned(A), shift_amount));
                    
                when "10101" =>  -- Right rotate
                    shift_amount := to_integer(unsigned(B(5 downto 0))) mod 64;
                    reg_result <= STD_LOGIC_VECTOR(rotate_right(unsigned(A), shift_amount));
                    
                when others =>
                    reg_result <= (others => '0');
            end case;
            
            -- Zero flag 
            if reg_result = (63 downto 0 => '0') then
                reg_zero <= '1';
            else
                reg_zero <= '0';
            end if;
        end if;
    end process;

    -- salidas
    result <= reg_result;
    zero <= reg_zero;
    overflow <= reg_overflow;

end Behavioral;
