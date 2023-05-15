library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY siren IS
	PORT (
		dac_MCLK : OUT STD_LOGIC; -- outputs to PMODI2L DAC
		dac_LRCK : OUT STD_LOGIC;
		dac_SCLK : OUT STD_LOGIC;
		dac_SDIN : OUT STD_LOGIC;
		
		-- from Verilog tutorial file
		CLK100MHZ : IN STD_LOGIC; -- input CLK100MHZ,
		PS2_CLK : IN STD_LOGIC; -- input PS2_CLK,
		PS2_DATA : IN STD_LOGIC; -- input PS2_DATA,
		SEG : OUT STD_LOGIC_VECTOR (6 DOWNTO 0); -- output [6:0]SEG,
        AN : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- output [7:0]AN,
        DP : OUT STD_LOGIC; -- output DP,
        UART_TXD : OUT STD_LOGIC -- output UART_TXD
        -- end Verilog tutorial
	);
END siren;

ARCHITECTURE Behavioral OF siren is	
	COMPONENT dac_if IS
		PORT (
			SCLK : IN STD_LOGIC;
			L_start : IN STD_LOGIC;
			R_start : IN STD_LOGIC;
			L_data : IN signed (15 DOWNTO 0);
			R_data : IN signed (15 DOWNTO 0);
			SDATA : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT tone IS
		PORT (
			clk : IN STD_LOGIC;
			pitch : IN UNSIGNED (13 DOWNTO 0);
			data : OUT SIGNED (15 DOWNTO 0)
		);
	END COMPONENT;
	-- from Verilog file
	COMPONENT PS2Receiver IS
	   	PORT (
			clk : IN STD_LOGIC; -- input clk,
            		kclk : IN STD_LOGIC; -- input kclk,
            		kdata : IN STD_LOGIC; -- input kdata,
            		keycodeout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) -- output [31:0] keycodeout
       		);
	END COMPONENT;
    	COMPONENT seg7decimal IS
        	PORT (
            		-- x : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            		clk : IN STD_LOGIC;
            		note: IN STRING(1 TO 2);
            		seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            		an : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            		dp : OUT STD_LOGIC
        	);
    	END COMPONENT;
	-- end Verilog file
	COMPONENT pitch IS
	   	PORT (
	       		clk : IN STD_LOGIC;
	       		keycode : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	       		pitch : OUT UNSIGNED(13 DOWNTO 0);
	       		notename : OUT STRING(1 TO 2)
	   	);
	END COMPONENT;
	
	SIGNAL tcount : unsigned (19 DOWNTO 0) := (OTHERS => '0'); -- timing counter
	SIGNAL data_L, data_R : SIGNED (15 DOWNTO 0); -- 16-bit signed audio data
	SIGNAL dac_load_L, dac_load_R : STD_LOGIC; -- timing pulses to load DAC shift reg.
	SIGNAL slo_clk, sclk, audio_CLK : STD_LOGIC;
	
	-- from Verilog file
	SIGNAL CLK50MHZ : STD_LOGIC := '0'; -- reg CLK50MHZ=0;
    	SIGNAL keycode : STD_LOGIC_VECTOR (31 DOWNTO 0); -- wire [31:0]keycode;
    	-- end Verilog file
    
    	SIGNAL curr_tone : UNSIGNED (13 DOWNTO 0); -- = pitch(Hz) / 0.745
    	SIGNAL note : STRING(1 TO 2);
    
BEGIN
    	-- from Verilog file
	update_clk : PROCESS -- always @(posedge(CLK100MHZ))begin
    	BEGIN
        	WAIT UNTIL rising_edge(CLK100MHZ);
        	CLK50MHZ <= NOT CLK50MHZ; -- CLK50MHZ<=~CLK50MHZ;
    	END PROCESS;
    	-- end Verilog file
    
	-- this process sets up a 20 bit binary counter clocked at 50MHz. This is used
	-- to generate all necessary timing signals. dac_load_L and dac_load_R are pulses
	-- sent to dac_if to load parallel data into shift register for serial clocking
	-- out to DAC
	tim_pr : PROCESS
	BEGIN
		WAIT UNTIL rising_edge(CLK50MHZ);
		IF (tcount(9 DOWNTO 0) >= X"00F") AND (tcount(9 DOWNTO 0) < X"02E") THEN
			dac_load_L <= '1';
		ELSE
			dac_load_L <= '0';
		END IF;
		IF (tcount(9 DOWNTO 0) >= X"20F") AND (tcount(9 DOWNTO 0) < X"22E") THEN
			dac_load_R <= '1';
		ELSE dac_load_R <= '0';
		END IF;
		tcount <= tcount + 1;
	END PROCESS;
	
	dac_MCLK <= NOT tcount(1); -- DAC master clock (12.5 MHz)
	audio_CLK <= tcount(9); -- audio sampling rate (48.8 kHz)
	dac_LRCK <= audio_CLK; -- also sent to DAC as left/right clock
	sclk <= tcount(4); -- serial data clock (1.56 MHz)
	dac_SCLK <= sclk; -- also sent to DAC as SCLK
	
	-- from Verilog file
	keyboard : PS2Receiver -- PS2Receiver keyboard
	PORT MAP(
	   clk => CLK50MHZ, -- .clk(CLK50MHZ),
	   kclk => PS2_CLK, -- .kclk(PS2_CLK),
	   kdata => PS2_DATA, -- .kdata(PS2_DATA),
	   keycodeout => keycode -- .keycodeout(keycode[31:0]
	);
	sevenSeg : seg7decimal -- seg7decimal sevenSeg
	PORT MAP(
	   -- x => keycode, -- .x(keycode[31:0]),
	   clk => CLK100MHZ, -- .clk(CLK100MHZ),
	   note => note,
	   seg => SEG, -- .seg(SEG[6:0]),
	   an => AN, -- .an(AN[7:0]),
	   dp => DP -- .dp(DP)
	);
	-- end Verilog file
	pitch_lookup : pitch
	PORT MAP(
	   clk => CLK50MHZ,
	   keycode => keycode,
	   pitch => curr_tone,
	   notename => note
	   );
	dac : dac_if
	PORT MAP(
		SCLK => sclk, -- instantiate parallel to serial DAC interface
		L_start => dac_load_L, 
		R_start => dac_load_R, 
		L_data => data_L, 
		R_data => data_R, 
		SDATA => dac_SDIN 
		);
    	tgen : tone
	PORT MAP(
		clk => audio_clk, -- instance a tone module
		pitch => curr_tone,
		data => data_L
		);
    	data_R <= data_L; -- duplicate data on right channel
        
END Behavioral;
