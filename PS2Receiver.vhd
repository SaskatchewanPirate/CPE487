-- adapted from Verilog file

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PS2Receiver is
    PORT (
        clk : IN STD_LOGIC; -- input clk,
        kclk : IN STD_LOGIC; -- input kclk,
        kdata : IN STD_LOGIC; -- input kdata,
        keycodeout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) -- output [31:0] keycodeout
        );
end PS2Receiver;

architecture Behavioral of PS2Receiver is
    COMPONENT debouncer IS
        PORT (
            clk : IN STD_LOGIC;
            I0 : IN STD_LOGIC;
            I1 : IN STD_LOGIC;
            O0: OUT STD_LOGIC;
            O1: OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL kclkf : STD_LOGIC; -- wire kclkf, kdataf;
    SIGNAL kdataf : STD_LOGIC;
    SIGNAL datacur : STD_LOGIC_VECTOR (7 DOWNTO 0) REGISTER; -- reg [7:0]datacur;
    SIGNAL dataprev : STD_LOGIC_VECTOR (7 DOWNTO 0) REGISTER; -- reg [7:0]dataprev;
    SIGNAL cnt : STD_LOGIC_VECTOR (3 DOWNTO 0) REGISTER; -- reg [3:0]cnt;
    SIGNAL keycode : STD_LOGIC_VECTOR (31 DOWNTO 0) REGISTER; -- reg [31:0]keycode;
    SIGNAL flag : STD_LOGIC REGISTER; -- reg flag;
begin
    initial : PROCESS -- initial begin
    BEGIN
        keycode <= X"00000000"; -- keycode[31:0]<=0'h00000000;
        cnt <= "0000"; -- cnt<=4'b0000;
        flag <= '0'; -- flag<=1'b0;
        WAIT;
    END PROCESS; -- end
    
    counter : PROCESS -- always@(negedge(kclkf))begin
    BEGIN
        WAIT UNTIL falling_edge(kclkf);
        CASE TO_INTEGER(UNSIGNED(cnt)) IS -- case(cnt)
            WHEN 0 => -- 0:;//Start bit
                NULL;
            WHEN 1 => -- 1:datacur[0]<=kdataf;
                datacur(0) <= kdataf;
            WHEN 2 => -- 2:datacur[1]<=kdataf;
                datacur(1) <= kdataf;
            WHEN 3 => -- 3:datacur[2]<=kdataf;
                datacur(2) <= kdataf;
            WHEN 4 => -- 4:datacur[3]<=kdataf;
                datacur(3) <= kdataf;
            WHEN 5 => -- 5:datacur[4]<=kdataf;
                datacur(4) <= kdataf;
            WHEN 6 => -- 6:datacur[5]<=kdataf;
                datacur(5) <= kdataf;
            WHEN 7 => -- 7:datacur[6]<=kdataf;
                datacur(6) <= kdataf;
            WHEN 8 => -- 8:datacur[7]<=kdataf;
                datacur(7) <= kdataf;
            WHEN 9 => -- 9:flag<=1'b1;
                flag <= '1';
            WHEN 10 => -- 10:flag<=1'b0;
                flag <= '0';
            WHEN OTHERS => 
                NULL;
        END CASE; -- endcase
        IF (TO_INTEGER(UNSIGNED(cnt)) <= 9) THEN -- if(cnt<=9) cnt<=cnt+1;
            cnt <= STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(cnt))+1, cnt'length));
        ELSE
            IF (TO_INTEGER(UNSIGNED(cnt)) = 10) THEN -- else if(cnt==10) cnt<=0;
                cnt <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, cnt'length));
            END IF;
       END IF;
    END PROCESS; -- end
    
    update_key : PROCESS -- always @(posedge flag)begin
    BEGIN
        WAIT UNTIL rising_edge(flag);
        IF (dataprev /= datacur) THEN -- if (dataprev!=datacur)begin
            keycode(31 DOWNTO 24) <= keycode(23 DOWNTO 16); -- keycode[31:24]<=keycode[23:16];
            keycode(23 DOWNTO 16) <= keycode(15 DOWNTO 8); -- keycode[23:16]<=keycode[15:8];
            keycode(15 DOWNTO 8) <= dataprev; -- keycode[15:8]<=dataprev;
            keycode(7 DOWNTO 0) <= datacur; -- keycode[7:0]<=datacur;
            dataprev <= datacur; -- dataprev<=datacur;
        END IF; -- end
    END PROCESS; -- end
    
    debounce : debouncer -- debouncer debounce
    PORT MAP(
        clk => clk, -- .clk(clk),
        I0 => kclk, -- .I0(kclk),
        I1 => kdata, -- .I1(kdata),
        O0 => kclkf, -- .O0(kclkf),
        O1 => kdataf -- .O1(kdataf)
    );
    
    keycodeout <= keycode; -- assign keycodeout=keycode;
end Behavioral;
