------------------------------------------------------
-- Design Name: SONEYE_FPaddervhd
--
-- Description: FINAL FP Adder (Data and Control Path)
--
-- Name: Anuoluwapo Soneye
-- ID: @03019490
-- Final FP Adder Project
-- Computer Architecture
-- Date: 03/30/23
--
------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SONEYE_FPadder is
	port(
		CLK: IN STD_LOGIC;
		RESET: IN STD_LOGIC;
		Val_1: IN STD_LOGIC_VECTOR (31 downto 0);
		Val_2: IN STD_LOGIC_VECTOR (31 downto 0);
		Output_Final_FP: OUT STD_LOGIC_VECTOR (31 downto 0)
	);
end SONEYE_FPadder;

architecture SONEYE_FPadder_Arch of SONEYE_FPadder is 
-------------------------------------------------------
-- COMPONENTS
-------------------------------------------------------

COMPONENT SONEYE_ALU is
	generic(
		N: integer:= 8
	);
	port(
		Sel: in std_logic;
		Val_1, Val_2: in std_logic_vector((N-1) downto 0);
		Output: out std_logic_vector((N-1) downto 0)
	);
END COMPONENT;

COMPONENT Soneye_MUX_21 is 
	generic(
		N: integer:= 8
	);
	port(	
		Sel: in std_logic;
		Val_1, Val_2: in std_logic_vector((N-1) downto 0);
		Output: out std_logic_vector((N-1) downto 0)
	);
END COMPONENT;

COMPONENT Soneye_Shifter is 
	generic(N: integer:= 24;
		R: integer := 9
	);
	port(
		Val_1: in std_logic_vector((N-1) downto 0);
		Shift_Dir: in std_logic; --'0' for left and '1' for right
		Shift_amount: in std_logic_vector((R-1) downto 0);
		Output: out std_logic_vector((N-1) downto 0)
	);
END COMPONENT;

COMPONENT Soneye_Inc is
	generic(N: integer:= 8
	);
	port(
		Val_1: in std_logic_vector((N-1) downto 0);
		Inc_Dec_amt: in std_logic_vector((N-1) downto 0);
		Output: out std_logic_vector((N-1) downto 0)
	);
END COMPONENT;

COMPONENT SONEYE_FPadder_FSM is 
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
END COMPONENT;

COMPONENT SONEYE_Gen_Bit_Register is
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
END COMPONENT;
 
-------------------------------------------------------
-- INTERMEDIATE SIGNALS
-------------------------------------------------------
SIGNAL S_SMALL_ALU_OUT: std_logic_vector(8 downto 0); 
SIGNAL S_EXPONENT_SEL: std_logic;
SIGNAL S_MUX1_OUT, S_MUX1_OUT_pip_out: std_logic_vector(7 downto 0); 

SIGNAL S_SMALLER_NUM_MANTISSA_SEL, S_LARGER_NUM_MANTISSA_SEL: std_logic;
SIGNAL S_MUX2_OUT, S_MUX3_OUT: std_logic_vector(22 downto 0);
SIGNAL S_SHIFTED_SMALL_FP_MANTISSA: std_logic_vector(23 downto 0);

SIGNAL S_MUX2_SIGN_OUT, S_MUX3_SIGN_OUT: std_logic_vector(1 downto 0);
SIGNAL S_BIG_ALU_OUT, S_BIG_ALU_OUT_pip_out, S_BIG_ALU_OUT_abs, S_BIG_ALU_OUT_abs_pip_out: std_logic_vector(25 downto 0);
SIGNAL S_Shifted_sign_mantissa, S_MUX3_sign_mantissa: std_logic_vector(23 downto 0);
SIGNAL S_SHIFTED_SMALL_FP_MANTISSA_signed_input, S_MUX3_OUT_signed_input, S_SHIFTED_SMALL_FP_MANTISSA_alu_input, S_MUX3_OUT_alu_input: std_logic_vector(25 downto 0);


SIGNAL S_Shift_FP_Amt, S_Shift_FP_Amt_pip_out, S_Inc_Exp_Amt, S_Inc_Exp_Amt_pip_out: std_logic_vector(7 downto 0);
SIGNAL S_Shift_Dir, S_Shift_Dir_pip_out: std_logic_vector(1 downto 0);
SIGNAL S_Incremented_exp, S_Incremented_exp_pip_out: std_logic_vector(7 downto 0) := (others => 'X');
SIGNAL S_shifted_mantissa_orginal_output, S_shifted_mantissa_orginal_output_pip_out: std_logic_vector(24 downto 0) := (others => 'X');
-------------------------------------------------------
-- Other SIGNALS
-------------------------------------------------------
SIGNAL ZERO: std_logic_vector(25 downto 0) := (OTHERS => '0');
SIGNAL Full_small_fp_bin: std_logic_vector(23 downto 0);
SIGNAL S_BIG_ALU_OUT_sign, S_BIG_ALU_OUT_sign_pip_out: std_logic_vector (1 downto 0);
-------------------------------------------------------
-- DECODING Floating Point Binary SIGNALS
-------------------------------------------------------
SIGNAL Val_1_sign: std_logic_vector(1 downto 0);
SIGNAL Val_1_exp: std_logic_vector(7 downto 0); 
SIGNAL Val_1_exp_sign: std_logic_vector(8 downto 0); 
SIGNAL Val_1_mantissa: std_logic_vector(22 downto 0);

SIGNAL Val_2_sign: std_logic_vector(1 downto 0);
SIGNAL Val_2_exp: std_logic_vector(7 downto 0); 
SIGNAL Val_2_exp_sign: std_logic_vector(8 downto 0); 
SIGNAL Val_2_mantissa: std_logic_vector(22 downto 0);

-------------------------------------------------------
-- BEGIN
------------------------------------------------------- 
BEGIN
Val_1_sign <= '0' & Val_1(31);
Val_1_exp <= Val_1(30 downto 23);
Val_1_exp_sign <= '0' & Val_1(30 downto 23);
Val_1_mantissa <= Val_1(22 downto 0);

Val_2_sign<= '0' & Val_2(31);
Val_2_exp <= Val_2(30 downto 23);
Val_2_exp_sign <= '0' & Val_2(30 downto 23);
Val_2_mantissa <= Val_2(22 downto 0);

-------------------------------------------------------
-- Concatenations
------------------------------------------------------- 

Full_small_fp_bin <= '1' & S_MUX2_OUT;

S_SHIFTED_SMALL_FP_MANTISSA_signed_input <= "00" & S_SHIFTED_SMALL_FP_MANTISSA;
S_MUX3_OUT_signed_input <= "001" & S_MUX3_OUT;

S_BIG_ALU_OUT_sign <= '0' & S_BIG_ALU_OUT(25);

-------------------------------------------------------
-- INSTANTIATIONS
-------------------------------------------------------

-- Subtract exponents to determine which is larger
Inst_SMALL_ALU: SONEYE_ALU
GENERIC MAP(N => 9)
PORT MAP ('1', Val_1_exp_sign, Val_2_exp_sign, S_SMALL_ALU_OUT);

Inst_EXPONENT_MUX: SONEYE_MUX_21
GENERIC MAP(N => 8)
PORT MAP(S_EXPONENT_SEL, Val_1_exp, Val_2_exp, S_MUX1_OUT);

---------------------------------------------------------------

-- Select mantissa and sign of smaller floating point number

Inst_SMALLER_FP_MANTISSA: SONEYE_MUX_21
GENERIC MAP(N => 23)
PORT MAP(S_SMALLER_NUM_MANTISSA_SEL, Val_1_mantissa, Val_2_mantissa, S_MUX2_OUT);

Inst_SMALLER_FP_MANTISSA_SIGN: SONEYE_MUX_21
GENERIC MAP(N => 2)
PORT MAP(S_SMALLER_NUM_MANTISSA_SEL, Val_1_sign, Val_2_sign, S_MUX2_SIGN_OUT);

-- Shift mantissa with '1' added to beginning

Inst_SMALL_FP_MANTISSA_RIGHT_SHIFTER: Soneye_Shifter
GENERIC MAP (N => 24, R => 9)
PORT MAP(Full_small_fp_bin, '1', S_SMALL_ALU_OUT, S_SHIFTED_SMALL_FP_MANTISSA);

---------------------------------------------------------------

-- Select mantissa and sign of larger floating point number

Inst_LARGER_FP_MANTISSA: SONEYE_MUX_21
GENERIC MAP(N => 23)
PORT MAP(S_LARGER_NUM_MANTISSA_SEL, Val_1_mantissa, Val_2_mantissa, S_MUX3_OUT);

Inst_LARGER_FP_MANTISSA_SIGN: SONEYE_MUX_21
GENERIC MAP(N => 2)
PORT MAP(S_LARGER_NUM_MANTISSA_SEL, Val_1_sign, Val_2_sign, S_MUX3_SIGN_OUT);

---------------------------------------------------------------

-- Turn both floating point numbers in form (XXX.XXXX ...) inot two's complement

Inst_signed_SMALLER_FP: SONEYE_ALU
GENERIC MAP(N => 26)
PORT MAP (S_MUX2_SIGN_OUT(0), Zero, S_SHIFTED_SMALL_FP_MANTISSA_signed_input, S_SHIFTED_SMALL_FP_MANTISSA_alu_input);

Inst_signed_LARGER_FP: SONEYE_ALU
GENERIC MAP(N => 26)
PORT MAP (S_MUX3_SIGN_OUT(0), Zero, S_MUX3_OUT_signed_input, S_MUX3_OUT_alu_input);

---------------------------------------------------------------

-- Add floating point numbers and take absolute value of the number

Inst_BIG_ALU: SONEYE_ALU
GENERIC MAP(N => 26)
PORT MAP ('0', S_SHIFTED_SMALL_FP_MANTISSA_alu_input, S_MUX3_OUT_alu_input, S_BIG_ALU_OUT);

Inst_abs_FP: SONEYE_ALU
GENERIC MAP(N => 26)
PORT MAP (S_BIG_ALU_OUT(25), Zero, S_BIG_ALU_OUT, S_BIG_ALU_OUT_abs);

---------------------------------------------------------------
-- Shift ALU result (left or right) and change exponent accordingly (increment or decrement)

Inst_FP_Shifter: Soneye_Shifter
GENERIC MAP (N => 25, R => 8)
PORT MAP(S_BIG_ALU_OUT_abs_pip_out(24 downto 0), S_Shift_Dir_pip_out(0), S_Shift_FP_Amt_pip_out, S_shifted_mantissa_orginal_output);

Inst_Inc_or_Dec: Soneye_Inc
GENERIC MAP (N => 8)
PORT MAP (S_MUX1_OUT_pip_out, S_Inc_Exp_Amt_pip_out, S_Incremented_exp); 

---------------------------------------------------------------
--FSM Insertion
---------------------------------------------------------------

Inst_FSM: SONEYE_FPadder_FSM
PORT MAP(CLK, RESET, S_SMALL_ALU_OUT, Val_1_mantissa, Val_2_mantissa, S_BIG_ALU_OUT_abs(24 downto 0), S_EXPONENT_SEL, S_SMALLER_NUM_MANTISSA_SEL, S_LARGER_NUM_MANTISSA_SEL, S_Shift_Dir, S_Shift_FP_Amt, S_Inc_Exp_Amt);

---------------------------------------------------------------
--- PIPELINE REGISTERS
---------------------------------------------------------------
--Store Larger Exponent
Inst_Larger_Exponent_Reg: SONEYE_Gen_Bit_Register
GENERIC MAP (N => 8)
PORT MAP (CLK, '1', RESET, S_MUX1_OUT, S_MUX1_OUT_pip_out);

-- Store control path signals 
Inst_Shift_Dir_Reg: SONEYE_Gen_Bit_Register
GENERIC MAP (N => 2)
PORT MAP (CLK, '1', RESET, S_Shift_Dir, S_Shift_Dir_pip_out);

Inst_Shift_FP_Amt_Reg: SONEYE_Gen_Bit_Register
GENERIC MAP (N => 8)
PORT MAP (CLK, '1', RESET, S_Shift_FP_Amt, S_Shift_FP_Amt_pip_out);

Inst_Inc_Exp_Amt_Reg: SONEYE_Gen_Bit_Register
GENERIC MAP (N => 8)
PORT MAP (CLK, '1', RESET, S_Inc_Exp_Amt, S_Inc_Exp_Amt_pip_out);


-- Store ALU results

Inst_BIG_ALU_OUT_sign_Reg: SONEYE_Gen_Bit_Register
GENERIC MAP (N => 2)
PORT MAP (CLK, '1', RESET, S_BIG_ALU_OUT_sign, S_BIG_ALU_OUT_sign_pip_out);

Inst_BIG_ALU_OUT_abs_Reg: SONEYE_Gen_Bit_Register
GENERIC MAP (N => 26)
PORT MAP (CLK, '1', RESET, S_BIG_ALU_OUT_abs, S_BIG_ALU_OUT_abs_pip_out);

---------------------------------------------------------------
-- Final Output
---------------------------------------------------------------

Output_Final_FP <= S_BIG_ALU_OUT_sign_pip_out(0) & S_Incremented_exp & S_shifted_mantissa_orginal_output(22 downto 0);

end SONEYE_FPadder_Arch;
