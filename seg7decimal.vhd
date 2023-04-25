-- adapted from Verilog file

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seg7decimal is
    PORT (
        x : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- input [31:0] x,
        clk : IN STD_LOGIC; -- input clk,
        seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0) REGISTER; -- output reg [6:0] seg,
        an : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) REGISTER; -- output reg [7:0] an,
        dp : OUT STD_LOGIC -- output wire dp
    );
end seg7decimal;

architecture Behavioral of seg7decimal is
    SIGNAL s : STD_LOGIC_VECTOR (2 DOWNTO 0); -- wire [2:0] s;	 
    SIGNAL digit : STD_LOGIC_VECTOR (3 DOWNTO 0) REGISTER; -- reg [3:0] digit;
    SIGNAL aen : STD_LOGIC_VECTOR (7 DOWNTO 0) REGISTER; -- wire [7:0] aen;
    SIGNAL clkdiv : STD_LOGIC_VECTOR (19 DOWNTO 0) REGISTER; -- reg [19:0] clkdiv;
    
begin
    initial : PROCESS
    BEGIN
        dp <= '1'; -- assign dp = 1;
        s <= clkdiv(19 DOWNTO 17); -- assign s = clkdiv[19:17];
        aen <= B"11111111"; -- assign aen = 8'b11111111;
        WAIT;
    END PROCESS;

    value_get : PROCESS -- always @(posedge clk)// or posedge clr)
    BEGIN
        WAIT UNTIL rising_edge(clk);	
        CASE TO_INTEGER(UNSIGNED(s)) IS -- case(s)
	       WHEN 0 => -- 0:digit = x[3:0]; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
	           digit <= x(3 DOWNTO 0);
	       WHEN 1 => -- 1:digit = x[7:4]; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
	           digit <= x(7 DOWNTO 4);
	       WHEN 2 => -- 2:digit = x[11:8]; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8]
	           digit <= x(11 DOWNTO 8);
	       WHEN 3 => -- 3:digit = x[15:12]; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
	           digit <= x(15 DOWNTO 12);
	       WHEN 4 => -- 4:digit = x[19:16]; // s is 00 -->0 ;  digit gets assigned 4 bit value assigned to x[3:0]
	           digit <= x(19 DOWNTO 16);
           WHEN 5 => -- 5:digit = x[23:20]; // s is 01 -->1 ;  digit gets assigned 4 bit value assigned to x[7:4]
               digit <= x(23 DOWNTO 20);
           WHEN 6 => -- 6:digit = x[27:24]; // s is 10 -->2 ;  digit gets assigned 4 bit value assigned to x[11:8]
               digit <= x(27 DOWNTO 24);
           WHEN 7 => -- 7:digit = x[31:28]; // s is 11 -->3 ;  digit gets assigned 4 bit value assigned to x[15:12]
               digit <= x(31 DOWNTO 28);
           WHEN OTHERS => -- default:digit = x[3:0];
               digit <= x(3 DOWNTO 0);	
	   END CASE; -- endcase
	END PROCESS;
	   -- decoder or truth-table for 7seg display values
    leddec : PROCESS(digit) -- always @(*)
    BEGIN
        CASE TO_INTEGER(UNSIGNED(digit)) IS -- case(digit)
        -- MSB-LSB
        -- gfedcba
            WHEN 0 => -- 0:seg = 7'b1000000;////0000
                seg <= B"1000000";		
            WHEN 1 => -- 1:seg = 7'b1111001;////0001
                seg <= B"1111001";
            WHEN 2 => -- 2:seg = 7'b0100100;////0010
                seg <= B"0100100";
            WHEN 3 => -- 3:seg = 7'b0110000;////0011
                seg <= B"0110000";
            WHEN 4 => -- 4:seg = 7'b0011001;////0100
                seg <= B"0011001";
            WHEN 5 => -- 5:seg = 7'b0010010;////0101
                seg <= B"0010010";
            WHEN 6 => -- 6:seg = 7'b0000010;////0110
                seg <= B"0000010";
            WHEN 7 => -- 7:seg = 7'b1111000;////0111
                seg <= B"1111000";
            WHEN 8 => -- 8:seg = 7'b0000000;////1000
                seg <= B"0000000";
            WHEN 9 => -- 9:seg = 7'b0010000;////1001
                seg <= B"0010000";
            WHEN 10 => -- 'hA:seg = 7'b0001000; 
                seg <= B"0001000";
            WHEN 11 => -- 'hB:seg = 7'b0000011; 
                seg <= B"0000011";
            WHEN 12 => -- 'hC:seg = 7'b1000110;
                seg <= B"1000110";
            WHEN 13 => -- 'hD:seg = 7'b0100001;
                seg <= B"0100001";
            WHEN 14 => -- 'hE:seg = 7'b0000110;
                seg <= B"0000110";
            WHEN 15 => -- 'hF:seg = 7'b0001110;
                seg <= B"0001110";
            WHEN OTHERS => -- default: seg = 7'b0000000; // U
                seg <= B"0000000";
        END CASE; -- endcase
    END PROCESS;
    
    update_an : PROCESS(aen) -- always @(*)begin
    BEGIN
        an <= B"11111111"; -- an=8'b11111111;
        IF (aen(TO_INTEGER(UNSIGNED(s))) = '1') THEN -- if(aen[s] == 1)
            an(TO_INTEGER(UNSIGNED(s))) <= '0'; -- an[s] = 0;
        END IF; -- end
    END PROCESS;
    
    -- clkdiv
    update_clkdiv : PROCESS -- always @(posedge clk) begin
    BEGIN
        WAIT UNTIL rising_edge(clk);
        clkdiv <= STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(clkdiv))+1, clkdiv'length)); -- clkdiv <= clkdiv+1;
    END PROCESS; --end
    
end Behavioral;
