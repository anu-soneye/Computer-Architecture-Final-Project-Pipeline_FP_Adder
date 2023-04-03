------------------------------------------------------
-- Design Name: SONEYE_TB_FPadder.vhd
-- Description: Testbench for FP Adder
--
-- Name: Anuoluwapo Soneye
-- ID: @03019490
-- Final FP Adder Project
-- Computer Architecture
-- Date: 03/30/23
--
------------------------------------------------------



LIBRARY IEEE;
USE work.CLOCKS.all;   -- Entity that uses CLOCKS
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_textio.all;
USE std.textio.all;
USE work.txt_util.all;

ENTITY TB_Soneye_FPadder IS
END;

ARCHITECTURE TESTBENCH OF TB_Soneye_FPadder IS


---------------------------------------------------------------
-- COMPONENTS
---------------------------------------------------------------

COMPONENT Soneye_FPadder 			-- In/out Ports
	port(
		CLK: IN STD_LOGIC;
		RESET: IN STD_LOGIC;
		Val_1: IN STD_LOGIC_VECTOR (31 downto 0);
		Val_2: IN STD_LOGIC_VECTOR (31 downto 0);
		Output_Final_FP: OUT STD_LOGIC_VECTOR (31 downto 0)
	);
END COMPONENT;

COMPONENT CLOCK
	port(CLK: out std_logic);
END COMPONENT;

---------------------------------------------------------------
-- Read/Write FILES
---------------------------------------------------------------


FILE in_file : TEXT open read_mode is 	"SONEYE_FPadder_INPUT.txt";   -- Inputs: Reset, Val_1, Val_
FILE exo_file : TEXT open read_mode is 	"SONEYE_FPadder_EXP_OUTPUT.txt";   -- Expected output (binary)
FILE out_file : TEXT open  write_mode is  "SONEYE_Class_Example_dataout_dacus.txt";
FILE xout_file : TEXT open  write_mode is "SONEYE_Class_Example_TestOut_dacus.txt";
FILE hex_out_file : TEXT open  write_mode is "SONEYE_Class_Example_hex_out_dacus.txt";

---------------------------------------------------------------
-- SIGNALS 
---------------------------------------------------------------

  SIGNAL Val_1, Val_2: STD_LOGIC_VECTOR(31 downto 0):= (others => 'X'); 
  SIGNAL Output_Final_FP, Exp_Output_Final_FP: STD_LOGIC_VECTOR(31 downto 0):= (others => 'X'); 
  SIGNAL CLK, RESET: STD_LOGIC;	
  SIGNAL Test_Output : STD_LOGIC:= 'X';
  SIGNAL LineNumber: integer:=0;

---------------------------------------------------------------
-- BEGIN 
---------------------------------------------------------------

BEGIN

---------------------------------------------------------------
-- Instantiate Components 
---------------------------------------------------------------


U0: CLOCK port map (CLK );
Inst_Soneye_FPadder: Soneye_FPadder port map (CLK, RESET, Val_1, Val_2, Output_Final_FP);

---------------------------------------------------------------
-- PROCESS 
---------------------------------------------------------------
PROCESS

variable in_line, exo_line, out_line, xout_line : LINE;
variable comment, xcomment : string(1 to 128);
variable i : integer range 1 to 128;
variable simcomplete : boolean;

variable var_Reset: std_logic := 'X';
variable var_Val_1, var_Val_2: std_logic_vector(31 downto 0):= (OTHERS => 'X');
variable var_Output_Final_FP, var_Exp_Output_Final_FP: std_logic_vector(31 downto 0):= (OTHERS => 'X');
variable var_Test_Output : std_logic := '0';
variable vlinenumber: integer;

BEGIN

simcomplete := false;

while (not simcomplete) LOOP
  
	if (not endfile(in_file) ) then
		readline(in_file, in_line);
	else
		simcomplete := true;
	end if;

	if (not endfile(exo_file) ) then
		readline(exo_file, exo_line);
	else
		simcomplete := true;
	end if;
	
	if (in_line(1) = '-') then  --Skip comments
		next;
	elsif (in_line(1) = '.')  then  --exit Loop
	  Test_Output <= 'Z';
		simcomplete := true;
	elsif (in_line(1) = '#') then        --Echo comments to out.txt
	  i := 1;
	  while in_line(i) /= '.' LOOP
		comment(i) := in_line(i);
		i := i + 1;
	  end LOOP;

	elsif (exo_line(1) = '-') then  --Skip comments
		next;
	elsif (exo_line(1) = '.')  then  --exit Loop
	  	  Test_Output  <= 'Z';
		   simcomplete := true;
	elsif (exo_line(1) = '#') then        --Echo comments to out.txt
	     i := 1;
	   while exo_line(i) /= '.' LOOP
		 xcomment(i) := exo_line(i);
		 i := i + 1;
	   end LOOP;

	
	  write(out_line, comment);
	  writeline(out_file, out_line);
	  
	  write(xout_line, xcomment);
	  writeline(xout_file, xout_line);

	  
	ELSE      --Begin processing

		read(in_line, var_Reset);
		Reset  <= var_Reset;

		read(in_line, var_Val_1);
		Val_1  <= var_Val_1;

		read(in_line, var_Val_2);
		Val_2  <= var_Val_2;

		read(exo_line, var_Exp_Output_Final_FP);
		Exp_Output_Final_FP <= var_Exp_Output_Final_FP;
		--read(exo_line, vTest_Out_Q );
		--vTest_Out_Q:= Test_Out_Q;

    vlinenumber :=LineNumber;
    
    write(out_line, vlinenumber);
    write(out_line, STRING'("."));
    write(out_line, STRING'("    "));

    if (Exp_Output_Final_FP = Output_Final_FP) then
      Test_Output <= '0';
    else
      Test_Output <= 'X';
    end if;
    
    CYCLE(1,CLK);

		--vTest_Out_Q:= Test_Out_Q;
          		
		--write(out_line, var_Output, left, 32);
		--write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		--write(out_line, var_Test_Output, left, 5);                           --ht is ascii for horizontal tab
		--write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		--write(out_line, var_Exp_Output, left, 32);
		--write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		--writeline(out_file, out_line);
		print(xout_file,"LINENUMBER: " & str(LineNumber) & " INPUT: " & str(Val_1) & ", " & str(Val_2) & " OUTPUT: " &  str(Output_Final_FP) & " Expected OUTPUT: " &   str(Exp_Output_Final_FP)  & " TEST_OUT_Q: " & str(Test_Output) );
	
	END IF;
	LineNumber <= LineNumber+1;

	END LOOP;
	WAIT;
	
	END PROCESS;

END TESTBENCH;


CONFIGURATION cfg_TB_Soneye_FPadder OF TB_Soneye_FPadder IS
	FOR TESTBENCH
		FOR Inst_Soneye_FPadder: Soneye_FPadder
			use entity work.Soneye_FPadder(Soneye_FPadder_Arch);
		END FOR;
	END FOR;
END;	
