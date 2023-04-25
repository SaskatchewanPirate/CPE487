-- adapted from Verilog file

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    PORT (
        clk : IN STD_LOGIC; -- input clk,
        I0 : IN STD_LOGIC; -- input I0,
        I1 : IN STD_LOGIC; -- input I1,
        O0 : OUT STD_LOGIC REGISTER; -- output reg O0,
        O1 : OUT STD_LOGIC REGISTER -- output reg O1
    );
end debouncer;

architecture Behavioral of debouncer is
    SIGNAL cnt0 : STD_LOGIC_VECTOR (4 DOWNTO 0) REGISTER; -- reg [4:0]cnt0, cnt1;
    SIGNAL cnt1 : STD_LOGIC_VECTOR (4 DOWNTO 0) REGISTER;
    SIGNAL Iv0 : STD_LOGIC REGISTER;
    SIGNAL Iv1 : STD_LOGIC REGISTER;
    SIGNAL out0 : STD_LOGIC REGISTER; -- reg out0, out1;
    SIGNAL out1 : STD_LOGIC REGISTER;
begin
    -- reg Iv0=0,Iv1=0;
    initial : PROCESS
    BEGIN
        Iv0 <= '0';
        Iv1 <= '1';
        WAIT;
    END PROCESS;
    
    proc : PROCESS -- always@(posedge(clk))begin
    BEGIN
        WAIT UNTIL rising_edge(clk);
        IF (I0 = Iv0) THEN -- if (I0==Iv0)begin
            IF (TO_INTEGER(UNSIGNED(cnt0)) = 19) THEN -- if (cnt0==19)O0<=I0;
                O0 <= I0;
            ELSE -- else cnt0<=cnt0+1;
                cnt0 <= STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(cnt0))+1, cnt0'length));
            END IF; -- end
        ELSE -- else begin
            cnt0 <= "00000"; -- cnt0<="00000";
            Iv0 <= I0; -- Iv0<=I0;
        END IF;-- end
        IF (I1 = Iv1) THEN -- if (I1==Iv1)begin
                IF (TO_INTEGER(UNSIGNED(cnt1)) = 19) THEN -- if (cnt1==19)O1<=I1;
                    O1 <= I1;
                ELSE -- else cnt1<=cnt1+1;
                    cnt1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(cnt1))+1, cnt1'length));
            END IF;-- end
        ELSE -- else begin
            cnt1 <= "00000"; -- cnt1<="00000";
            Iv1 <= I1; -- Iv1<=I1;
        END IF; -- end
    END PROCESS; -- end

end Behavioral;
