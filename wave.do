onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TESTBENCH
add wave -noupdate -label CLK /tb_soneye_fpadder/CLK
add wave -noupdate -label RESET /tb_soneye_fpadder/RESET
add wave -noupdate -label Linenumber /tb_soneye_fpadder/LineNumber
add wave -noupdate -label {Floating Point Num 1} /tb_soneye_fpadder/Val_1
add wave -noupdate -label {Floating Point Num 2} /tb_soneye_fpadder/Val_2
add wave -noupdate -label {Final Output} /tb_soneye_fpadder/Output_Final_FP
add wave -noupdate -label {Expected Output} /tb_soneye_fpadder/Exp_Output_Final_FP
add wave -noupdate -label Test_Output /tb_soneye_fpadder/Test_Output
add wave -noupdate -divider {SMALL ALU}
add wave -noupdate -label Sel /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALL_ALU/Sel
add wave -noupdate -label Val_1 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALL_ALU/Val_1
add wave -noupdate -label Val_2 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALL_ALU/Val_2
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALL_ALU/Output
add wave -noupdate -divider {EXPONENT MUX}
add wave -noupdate -label Sel /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_EXPONENT_MUX/Sel
add wave -noupdate -label Val_1 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_EXPONENT_MUX/Val_1
add wave -noupdate -label Val_2 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_EXPONENT_MUX/Val_2
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_EXPONENT_MUX/Output
add wave -noupdate -divider SMALLER_FP_MANTISSA
add wave -noupdate -label Sel /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALLER_FP_MANTISSA/Sel
add wave -noupdate -label Val_1 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALLER_FP_MANTISSA/Val_1
add wave -noupdate -label Val_2 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALLER_FP_MANTISSA/Val_2
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALLER_FP_MANTISSA/Output
add wave -noupdate -divider {SMALLER_FP_MANTISSA Right Shifter}
add wave -noupdate -label Val_1 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALL_FP_MANTISSA_RIGHT_SHIFTER/Val_1
add wave -noupdate -label Shift_Dir /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALL_FP_MANTISSA_RIGHT_SHIFTER/Shift_Dir
add wave -noupdate -label {Shift amount} /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALL_FP_MANTISSA_RIGHT_SHIFTER/Shift_amount
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_SMALL_FP_MANTISSA_RIGHT_SHIFTER/Output
add wave -noupdate -divider LARGER_FP_MANTISSA
add wave -noupdate -label Sel /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_LARGER_FP_MANTISSA/Sel
add wave -noupdate -label Val_1 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_LARGER_FP_MANTISSA/Val_1
add wave -noupdate -label Val_2 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_LARGER_FP_MANTISSA/Val_2
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_LARGER_FP_MANTISSA/Output
add wave -noupdate -divider {BIG ALU}
add wave -noupdate -label Sel /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_BIG_ALU/Sel
add wave -noupdate -label Val_1 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_BIG_ALU/Val_1
add wave -noupdate -label Val_2 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_BIG_ALU/Val_2
add wave -noupdate -label {Sign Output} /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_BIG_ALU/Output
add wave -noupdate -label {Absolute Val Output} /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_abs_FP/Output
add wave -noupdate -divider REGISTERS
add wave -noupdate -divider {Larger Exponent Reg}
add wave -noupdate -label Input /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Larger_Exponent_Reg/Op_A
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Larger_Exponent_Reg/Op_Q
add wave -noupdate -divider Shift_Dir_Reg
add wave -noupdate -label Input /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Shift_Dir_Reg/Op_A
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Shift_Dir_Reg/Op_Q
add wave -noupdate -divider {Shift FP Amt Reg}
add wave -noupdate -label Input /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Shift_FP_Amt_Reg/Op_A
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Shift_FP_Amt_Reg/Op_Q
add wave -noupdate -divider {Inc_Exp_Amt Reg}
add wave -noupdate -label Input /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Inc_Exp_Amt_Reg/Op_A
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Inc_Exp_Amt_Reg/Op_Q
add wave -noupdate -divider {BIG ALU OUT abs}
add wave -noupdate -label Input /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_BIG_ALU_OUT_abs_Reg/Op_A
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_BIG_ALU_OUT_abs_Reg/Op_Q
add wave -noupdate -divider {BIG ALU OUT sign}
add wave -noupdate -label Input /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_BIG_ALU_OUT_sign_Reg/Op_A
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_BIG_ALU_OUT_sign_Reg/Op_Q
add wave -noupdate -divider {END OF REGISTERS}
add wave -noupdate -divider {FP Shift Left/Right}
add wave -noupdate -label Val_1 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_FP_Shifter/Val_1
add wave -noupdate -label Shift_Dir /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_FP_Shifter/Shift_Dir
add wave -noupdate -label Shift_amount /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_FP_Shifter/Shift_amount
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_FP_Shifter/Output
add wave -noupdate -divider Increment/Decrement
add wave -noupdate -label Val_1 /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Inc_or_Dec/Val_1
add wave -noupdate -label Inc_Dec_amt /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Inc_or_Dec/Inc_Dec_amt
add wave -noupdate -label Output /tb_soneye_fpadder/Inst_Soneye_FPadder/Inst_Inc_or_Dec/Output
add wave -noupdate -divider {Final Output}
add wave -noupdate -label Output_Final_FP /tb_soneye_fpadder/Output_Final_FP
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22303 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 197
configure wave -valuecolwidth 319
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {8026 ps} {85556 ps}
