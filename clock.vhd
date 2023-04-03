Library IEEE;
use IEEE.std_logic_1164.all;
use work.All;
use IEEE.std_logic_textio.all;
use std.textio.all;

package CLOCKS is
  -- declare CLOCKS package
procedure cycle(constant N : in NATURAL;
                        signal CLK: in std_logic);
procedure InitializeMemory;
procedure DumpMemory(constant startaddress : in integer;
                     constant numwords : in integer);

type Mem_Array_Type is array (0 to 65536) of
    std_logic_vector ( 15 downto 0 );

--shared variable LC3MEM : Mem_Array_Type;        
end CLOCKS;  --All components can have access to the cycle procedure

package body CLOCKS is




 procedure cycle(constant N : in NATURAL;
                        signal CLK: in std_logic) is
      begin       
	 for i in 1 to N loop
          wait until (CLK'EVENT) and (CLK = '1');
         end loop;
      end;

procedure DumpMemory(constant startaddress : in integer;
                     constant numwords : in integer) is
--FILE variables
--FILE out_file : TEXT IS OUT "lc3_memdump.dat";
FILE out_file : TEXT open  write_mode is "lc3_memdump.dat"; --mea
variable out_line : LINE;
variable vaddress : integer;
variable vdata : std_logic_vector(15 downto 0);
variable LC3MEM : Mem_Array_Type; --mea

      begin       
	vaddress := startaddress;

	 for i in 1 to numwords loop
        vdata := LC3MEM(vaddress);
	  

		write(out_line, vaddress );
		write(out_line,' ');
		write(out_line, vdata );


	writeline(out_file, out_line);

        vaddress := vaddress + 1; 
       end loop;
end;

 procedure InitializeMemory is 
--FILE variables
--FILE in_file : TEXT IS IN "lc3_meminit.dat";
FILE in_file : TEXT open read_mode is "lc3_meminit.dat"; --mea
variable in_line : LINE;
variable vstartaddress : integer;
variable vdata : std_logic_vector(15 downto 0);
variable LC3MEM : Mem_Array_Type; --mea

 begin
 readline(in_file, in_line);
 read(in_line, vstartaddress);

while (not endfile(in_file)) LOOP	

	readline(in_file, in_line);
	read(in_line, vdata);
	LC3MEM(vstartaddress):= vdata;
	vstartaddress := vstartaddress + 1;
 END LOOP;
 end;

        
end CLOCKS;

Library IEEE;
use IEEE.std_logic_1164.all;

entity CLOCK is
  port(CLK: out std_logic);
end;

architecture BEHAVIOR of CLOCK is


begin

  START:process 
  constant CLK_PERIOD: TIME:= 10 ns; -- CLOCK PERIOD  IN picOSECONDS
     begin
    CLK <= '1';
    wait for CLK_PERIOD/2;
 
    CLK <= '0';
    wait for CLK_PERIOD/2;
   
end process;


end BEHAVIOR;


