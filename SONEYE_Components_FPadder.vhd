------------------------------------------------------
-- Design Name: SONEYE_Components_FPadder.vhd
--
-- Description: Contains all the components in for 2 stage FP Adder

-- Name: Anuoluwapo Soneye
-- ID: @03019490
-- Final FP Adder Project
-- Computer Architecture
-- Date: 03/30/23
--
------------------------------------------------------



-- GENERIC Register --
-- INPUTS:
-- 1) Synchronous controls, resets to 0
-- 2) 16 bit value input
-- OUTPUTS:
-- 1) 16 bit value

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity SONEYE_Gen_Bit_Register is
	generic(
		N: integer := 23
	);
	port(
		Clk: in std_logic ;	
		EN: in std_logic;
		RST: in std_logic ;	
		Op_A: in std_logic_vector ((N-1) downto 0);
		Op_Q: out std_logic_vector ((N-1) downto 0) 
	);
end SONEYE_Gen_Bit_Register;

architecture SONEYE_Gen_Bit_Register_Arch of SONEYE_Gen_Bit_Register is 
	SIGNAL sOp_Q : std_logic_vector ((N-1) downto 0) := (others => '0');

BEGIN
	
	PROCESS (Clk)
		BEGIN
			IF Clk = '1' and Clk'event THEN
				
				IF RST = '1' THEN
					sOp_Q <= (others => '0');
	
				ELSIF EN = '1' THEN
					sOp_Q <= Op_A;
				
				END IF;
			ELSE
				sOp_Q <= sOp_Q;
			END IF;
	END PROCESS;
	Op_Q <= sOp_Q;
	
end SONEYE_Gen_Bit_Register_Arch;


-------------------------------------------------
-- MUX -- (2 to 1)
-- inputs
-- 1) n bit choices
-- 2) Selector
--output
-- 2) Selected 8 bit choice
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


-- MUX 2 to 1 --
entity Soneye_MUX_21 is
	generic(
		N: integer:= 8
	);
	port(
		Sel: in std_logic;
		Val_1, Val_2: in std_logic_vector((N-1) downto 0);
		Output: out std_logic_vector((N-1) downto 0)
	);
end Soneye_MUX_21;

architecture Soneye_MUX_21_Arch of Soneye_MUX_21 is
BEGIN
	with Sel select
	      Output <= Val_1 when '0',
			Val_2 when others;

end Soneye_MUX_21_Arch;


-------------------------------------------------
-- ALU  --
-- inputs
-- 1) Two N bit exponent values
-- 2) Selector for which operation
--output
-- 1) Addition or Subtraction of two values
---------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;


entity SONEYE_ALU is
	generic(
		N: integer:= 9
	);
	port(
		Sel: in std_logic;
		Val_1, Val_2: in std_logic_vector((N-1) downto 0);
		Output: out std_logic_vector((N-1) downto 0)
	);
end SONEYE_ALU;

architecture SONEYE_ALU_Arch of SONEYE_ALU is 
	SIGNAL sVal_1, sVal_2 : std_logic_vector((N-1) downto 0);
	SIGNAL sOutput : std_logic_vector((N-1) downto 0);
	SIGNAL sSel: std_logic;
begin
	sSel <= Sel;
	sVal_1 <= Val_1;
	sVal_2 <= Val_2;


	with sSel select
	      sOutput <= sVal_1 + sVal_2 when '0',
			 sVal_1 - sVal_2 when others; 
	Output <= sOutput;

end SONEYE_ALU_Arch;

-------------------------------------------------
-- Shifter  --
-- inputs
-- 1) One N bit value
-- 2) How much to shift by
-- 3) Which direction (left or right)
--output
-- 1) Shifted value in 23 bits
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Soneye_Shifter is
	generic(N: integer:= 24;
		R: integer := 9
	);
	port(
		Val_1: in std_logic_vector((N-1) downto 0);
		Shift_Dir: in std_logic; --'0' for left and '1' for right
		Shift_amount: in std_logic_vector((R-1) downto 0);
		Output: out std_logic_vector((N-1) downto 0)
	);
end Soneye_Shifter;

architecture Soneye_Shifter_Arch of Soneye_Shifter is 
	SIGNAL S_Shift_amount : integer;
begin
	S_Shift_amount <= to_integer(abs(signed(Shift_amount)));

	with Shift_Dir select Output <=
		std_logic_vector(shift_left(unsigned(Val_1), S_Shift_amount)) when '0',
		std_logic_vector(shift_right(unsigned(Val_1), S_Shift_amount)) when others;
		
end Soneye_Shifter_Arch;

-- Incrementor/Decrementor  --
-- inputs
-- 1) One N bit value
-- 2) How much to increment by (integer)
--output
-- 1) N bit value reflecting updated value
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Soneye_Inc is
	generic(N: integer:= 8
	);
	port(
		Val_1: in std_logic_vector((N-1) downto 0);
		Inc_Dec_amt: in std_logic_vector((N-1) downto 0);
		Output: out std_logic_vector((N-1) downto 0)
	);
end Soneye_Inc;

architecture Soneye_Inc_Arch of Soneye_Inc is 
begin
	Output <= std_logic_vector(signed(Val_1) + signed(Inc_Dec_amt));
		
end Soneye_Inc_Arch;

-------------------------------------------------
-- FSM  --
-- inputs
-- 1) clk and rst
-- 2) IR_OUT and NZP_OUT
--output
-- 1) all Selectors and enables
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SONEYE_FPadder_FSM is 
	port (
		CLK: IN std_logic;
		RESET: IN std_logic;
		SMALL_ALU_OUT: IN STD_LOGIC_VECTOR(8 downto 0);	
		Val_1_mantissa: IN STD_LOGIC_VECTOR(22 downto 0);	
		Val_2_mantissa: IN STD_LOGIC_VECTOR(22 downto 0);
		BIG_ALU_OUT_abs: IN STD_LOGIC_VECTOR(24 downto 0);
	
		-- ENABLES AND SELECTORS
		EXPONENT_SEL: OUT STD_LOGIC;
		SMALLER_NUM_MANTISSA_SEL: OUT STD_LOGIC;
		LARGER_NUM_MANTISSA_SEL: OUT STD_LOGIC;
		Shift_Dir: OUT STD_LOGIC_VECTOR(1 downto 0);
		Shift_FP_Amt, Inc_Exp_Amt: OUT std_logic_vector(7 downto 0)
	);
end SONEYE_FPadder_FSM;


ARCHITECTURE SONEYE_FPadder_FSM_Arch OF SONEYE_FPadder_FSM IS
	TYPE STATE_TYPE is (CSA); -- CSA stands for compare, shift, and add

	SIGNAL cpu_state, next_state: STATE_TYPE;
BEGIN

NEXT_STATE_LOGIC: process(CLK)
BEGIN
	if (CLK'event and CLK = '1') then
		if (RESET = '1') then 
			cpu_state <= CSA;
		else 
			cpu_state <= next_state;
		end if;
	end if;
end process;


FSM: process (cpu_state, SMALL_ALU_OUT, BIG_ALU_OUT_abs)
	VARIABLE highest_bit_one : integer := 0;
	VARIABLE shift_amount : integer := 0;
	begin
	-- CSA (compare, shift, and add), and then Normalize
	CASE cpu_state is 
		-- Compare, Shift, and Add
		when CSA => 
			EXPONENT_SEL <= SMALL_ALU_OUT(8); 
			if (unsigned(SMALL_ALU_OUT) = 0) then
				if (unsigned(Val_2_mantissa) > unsigned(Val_1_mantissa)) then
					SMALLER_NUM_MANTISSA_SEL <= '0';
					LARGER_NUM_MANTISSA_SEL <= '1';
				else
					SMALLER_NUM_MANTISSA_SEL <= '1';
					LARGER_NUM_MANTISSA_SEL <= '0';
				end if;
			else
				SMALLER_NUM_MANTISSA_SEL <= not(SMALL_ALU_OUT(8));
				LARGER_NUM_MANTISSA_SEL <= SMALL_ALU_OUT(8);
			end if;

			for j in 0 to 24 loop
				if BIG_ALU_OUT_abs(j) = '1' then
					highest_bit_one := j;
				end if;
			end loop;
			shift_amount := 23 - highest_bit_one;
			Shift_FP_Amt <= std_logic_vector(to_unsigned(abs(shift_amount), Shift_FP_Amt'length));

			if (shift_amount > 0) then	
				Shift_Dir <= "00";
				Inc_Exp_Amt <= std_logic_vector(to_signed(-1 * shift_amount, Inc_Exp_Amt'length));
			else
				Shift_Dir <= "01";
				Inc_Exp_Amt <= std_logic_vector(to_signed(abs(shift_amount), Inc_Exp_Amt'length));
			end if;

			next_state <= CSA;

		when others =>
			next_state <= CSA;

	end case;
end process;
		
END SONEYE_FPadder_FSM_Arch;


