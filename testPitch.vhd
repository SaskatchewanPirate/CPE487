library IEEE;
use IEEE.STD_LOGIC_1164.ALL, STD.textio.all;
USE IEEE.STD_logic_textio.all;
USE IEEE.NUMERIC_STD.ALL;
-- Testbench for pitch lookup module
entity testPitch is
end testPitch;

architecture io of testPitch is
    file vectors : text;
    file results : text;
    
    signal CLK50MHZ : STD_LOGIC;
    signal keycode : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal curr_tone : UNSIGNED(13 DOWNTO 0);
    signal note : STRING(1 TO 2);
    
begin
    g1: entity WORK.pitch
        port map (clk => CLK50MHZ, keycode => keycode, pitch => curr_tone, notename => note);
    p1: process is
        variable ILine, OLine : Line;
        variable clk_in : STD_LOGIC;
        variable key_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
        variable pitch_out : UNSIGNED(13 DOWNTO 0);
        variable note_out : STRING(1 TO 2);
        variable ch : CHARACTER;
    begin
        file_open(vectors, "C:/Users/deerf/Documents/CPE487/TestbenchFinalProj/TestbenchFinalProj.srcs/sources_1/new/vectors.txt", READ_MODE);
        file_open(results, "C:/Users/deerf/Documents/CPE487/TestbenchFinalProj/TestbenchFinalProj.srcs/sources_1/new/results.txt", WRITE_MODE);
        while not endfile(vectors) loop
            readline(vectors, ILine);
            read(ILine, clk_in);
            read(ILine, ch);
            hread(ILine, key_in);
            CLK50MHZ <= clk_in;
            keycode <= key_in;
            wait for 60 NS;
            pitch_out := curr_tone;
            note_out := note;
            write(OLine, to_integer(pitch_out), right, 0);
            write(OLine, ch, right, 0);
            write(OLine, note_out, right, 0);
        end loop;
        file_close(vectors);
        file_close(results);
    end process p1;
end architecture io;
