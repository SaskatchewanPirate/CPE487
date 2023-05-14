library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pitch is
    Port (
        clk     : in std_logic;
        keycode : in std_logic_vector(31 downto 0);
        pitch   : out unsigned(13 downto 0);
        notename: out string(1 to 2)
    );
end pitch;

architecture Behavioral of pitch is
    signal db       : std_logic_vector(7 downto 0);
    signal curr_key : std_logic_vector(7 downto 0);
begin
    process(clk) begin
        if rising_edge(clk) then
            db <= keycode(15 downto 8);
            if db = x"F0" then
                pitch <= to_unsigned(0, 14);
                notename <= "00";
            else
                curr_key <= keycode(7 downto 0);
                case curr_key is
                    when x"16" =>
                        pitch <= to_unsigned(131, 14);
                        notename <= "C3";
                    when x"1E" =>
                        pitch <= to_unsigned(147, 14);
                        notename <= "D3";
                    when x"26" =>
                        pitch <= to_unsigned(165, 14);
                        notename <= "E3";
                    when x"25" =>
                        pitch <= to_unsigned(175, 14);
                        notename <= "F3";
                    when x"2E" =>
                        pitch <= to_unsigned(196, 14);
                        notename <= "G3";
                    when x"36" =>
                        pitch <= to_unsigned(220, 14);
                        notename <= "A3";
                    when x"3D" =>
                        pitch <= to_unsigned(247, 14);
                        notename <= "B3";
                    when x"15" =>
                        pitch <= to_unsigned(262, 14);
                        notename <= "C4";
                    when x"1D" =>
                        pitch <= to_unsigned(294, 14);
                        notename <= "D4";
                    when x"24" =>
                        pitch <= to_unsigned(330, 14);
                        notename <= "E4";
                    when x"2D" =>
                        pitch <= to_unsigned(349, 14);
                        notename <= "F4";
                    when x"2C" =>
                        pitch <= to_unsigned(392, 14);
                        notename <= "G4";
                    when x"35" =>
                        pitch <= to_unsigned(440, 14);
                        notename <= "A4";
                    when x"3C" =>
                        pitch <= to_unsigned(494, 14);
                        notename <= "B4";
                    when x"1C" =>
                        pitch <= to_unsigned(523, 14);
                        notename <= "C5";
                    when x"1B" =>
                        pitch <= to_unsigned(587, 14);
                        notename <= "D5";
                    when x"23" =>
                        pitch <= to_unsigned(659, 14);
                        notename <= "E5";
                    when x"2B" =>
                        pitch <= to_unsigned(698, 14);
                        notename <= "F5";
                    when x"34" =>
                        pitch <= to_unsigned(784, 14);
                        notename <= "G5";
                    when x"33" =>
                        pitch <= to_unsigned(880, 14);
                        notename <= "A5";
                    when x"3B" =>
                        pitch <= to_unsigned(988, 14);
                        notename <= "B5";
                    when x"1A" =>
                        pitch <= to_unsigned(1047, 14);
                        notename <= "C6";
                    when x"22" =>
                        pitch <= to_unsigned(1175, 14);
                        notename <= "D6";
                    when x"21" =>
                        pitch <= to_unsigned(1319, 14);
                        notename <= "E6";
                    when x"2A" =>
                        pitch <= to_unsigned(1397, 14);
                        notename <= "F6";
                    when x"32" =>
                        pitch <= to_unsigned(1568, 14);
                        notename <= "G6";
                    when x"31" =>
                        pitch <= to_unsigned(1760, 14);
                        notename <= "A6";
                    when x"3A" =>
                        pitch <= to_unsigned(1975, 14);
                        notename <= "B6";
                    when x"29" =>
                        pitch <= to_unsigned(2093, 14);
                        notename <= "C7";
                    when others =>
                        pitch <= to_unsigned(0, 14);
                        notename <= "00";
                end case;
            end if;
    end if;
    end process;

end Behavioral;
