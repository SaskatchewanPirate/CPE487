library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
entity debouncer is
    Port (
        clk  : in  std_logic;
        I0   : in  std_logic;
        I1   : in  std_logic;
        O0   : out std_logic;
        O1   : out std_logic
    );
end debouncer;

architecture Behavioral of debouncer is

    signal cnt0, cnt1 : std_logic_vector (4 downto 0);
    signal Iv0, Iv1 : std_logic := '0';
    signal out0, out1 : std_logic;

begin
    process(clk) 
        begin
        if rising_edge(clk) then
            if (I0=Iv0) then
                if cnt0="10011" then
                    O0 <= I0;
                else
                    cnt0 <= std_logic_vector(unsigned(cnt0)+1);
                end if;
            else
                cnt0 <= "00000";
                Iv0 <= I0;
            end if;
            
            if (I1=Iv1) then
                if (cnt1="10011") then
                    O1 <= I1;
                else
                    cnt1 <= std_logic_vector(unsigned(cnt1)+1);
                end if;
            else
                cnt1 <= "00000";
                Iv1 <= I1;
            end if;
        end if;
    end process;
end Behavioral;
