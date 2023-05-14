library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity seg7decimal is
    port (
        -- x   : in  std_logic_vector(31 downto 0); --data?
        clk : in  std_logic;                     --clock
        note: in string(1 to 2);
        seg : out std_logic_vector(6 downto 0);  --segment code for current digit
        an  : out std_logic_vector(7 downto 0);  --which anode
        dp  : out std_logic  
    );
end entity;

architecture Behavioral of seg7decimal is

    signal s    : std_logic_vector(2 downto 0); --dig equivalent
    signal aen  : std_logic_vector(7 downto 0);
    signal digit: string(1 to 1);
    
    signal clkdiv: std_logic_vector(19 downto 0);

begin
    dp <= '1';
    s  <= clkdiv(19 downto 17);
    aen <= "11111111"; --was 8 ones

    -- Quad 4-to-1 MUX
        -- Decoder for 7-segment display values

    process(clk)
        --variable digit: std_logic_vector(3 downto 0);
    begin
    if rising_edge(clk) then
        case s is
            when "000" =>
                digit <= note(2 to 2);
            when "001" =>
                digit <= note(1 to 1);
            when others =>
                digit <= " ";
            end case;      
        
        case digit is
            when "0" =>
                seg <= "1000000"; -- 0
            when "1" =>
                seg <= "1111001"; -- 1
            when "2" =>
                seg <= "0100100"; -- 2
            when "3" =>
                seg <= "0110000"; -- 3
            when "4" =>
                seg <= "0011001"; -- 4
            when "5" =>
                seg <= "0010010"; -- 5
            when "6" =>
                seg <= "0000010"; -- 6
            when "7" =>
                seg <= "1111000"; -- 7
            when "8" =>
                seg <= "0000000"; -- 8
            when "9" =>
                seg <= "0010000"; -- 9
            when "A" =>
                seg <= "0001000"; -- A
            when "B" =>
                seg <= "0000011"; -- B
            when "C" =>
                seg <= "1000110"; -- C
            when "D" =>
                seg <= "0100001"; -- D
            when "E" =>
                seg <= "0000110"; -- E
            when "F" =>
                seg <= "0001110"; -- F
            when "G" =>
                seg <= "1000010"; -- G
            when others =>
                seg <= "1111111";
        end case;
    end if;
    end process;

    -- Output enable signals for 7-segment displays
    process(aen, s) 
    begin
--    	an <= "11111110" WHEN s = "000" ELSE -- 0
--	          "11111101" WHEN s = "001" ELSE -- 1
--	          "11111011" WHEN s = "010" ELSE -- 2
--	          "11110111" WHEN s = "011" ELSE -- 3
--	          "11101111" WHEN s = "100" ELSE -- 4
--	          "11011111" WHEN s = "101" ELSE -- 5 
--	          "10111111" WHEN s = "110" ELSE -- 6
--	          "01111111" WHEN s = "111" ELSE -- 7
--	          "11111111";

        an <= "11111111";
        if aen(to_integer(unsigned(s))) = '1' then
            an(to_integer(unsigned(s))) <= '0';
        end if;
        
    end process;

    -- Clock divider
    process(clk) begin
        if rising_edge(clk) then
            clkdiv <= clkdiv + 1;
        end if;
    end process;

end architecture;
