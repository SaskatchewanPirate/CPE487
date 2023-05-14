library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use ieee.std_logic_unsigned.all;

entity PS2Receiver is
    Port (
        clk       : in  std_logic;
        kclk      : in  std_logic;
        kdata     : in  std_logic;
        keycodeout: out std_logic_vector(31 downto 0)
    );
end PS2Receiver;

architecture Behavioral of PS2Receiver is
    component debouncer is
        Port (
            clk : in  std_logic;
            I0  : in  std_logic;
            I1  : in  std_logic;
            O0  : out std_logic;
            O1  : out std_logic
        );
    end component;

    signal kclkf, kdataf, flag: std_logic;
    shared variable datacur    : std_logic_vector(7 downto 0);
    shared variable dataprev   : std_logic_vector(7 downto 0);
    shared variable cnt        : std_logic_vector(3 downto 0);
    shared variable keycode    : std_logic_vector(31 downto 0);

begin

    debounce_inst: debouncer
    port map (
        clk => clk,
        I0  => kclk,
        I1  => kdata,
        O0  => kclkf,
        O1  => kdataf
    );

    process(kclkf)
    begin
    if falling_edge(kclkf) then
        case cnt is
            when "0000" =>
                null;
            when "0001" =>
                datacur(0) := kdataf;
            when "0010" =>
                datacur(1) := kdataf;
            when "0011" =>
                datacur(2) := kdataf;
            when "0100" =>
                datacur(3) := kdataf;
            when "0101" =>
                datacur(4) := kdataf;
            when "0110" =>
                datacur(5) := kdataf;
            when "0111" =>
                datacur(6) := kdataf;
            when "1000" =>
                datacur(7) := kdataf;
            when "1001" =>
                flag <= '1';
            when "1010" =>
                flag <= '0';
            when others =>
                null;
        end case;

        if cnt <= "1001" then
            cnt := std_logic_vector(unsigned(cnt) + 1);
        elsif cnt = "1010" then
            cnt := "0000";
        end if;
    end if;
    end process;

    process(flag)
    begin
    if rising_edge(flag) then
        if dataprev /= datacur then
            keycode(31 downto 24) := keycode(23 downto 16);
            keycode(23 downto 16) := keycode(15 downto 8);
            keycode(15 downto 8) := dataprev;
            keycode(7 downto 0)  := datacur;
            dataprev := datacur;
        end if;
    end if;
    end process;

    keycodeout <= keycode;
end Behavioral;
