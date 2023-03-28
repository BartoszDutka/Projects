library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity LAB2 is
   port
   (
       
        Sbb : in signed (3 downto 0);
        Sbc : in signed (3 downto 0);
        Sba : in signed (3 downto 0);
        Sid : in signed (2 downto 0);
        Sa : in signed (1 downto 0);
        BB : out signed (15 downto 0);
        BC : out signed (15 downto 0);
        ADR : out signed (31 downto 0);
        IRout : out signed (15 downto 0);
		  SbbOut : out signed (3 downto 0);
		  SbcOut : out signed (3 downto 0);
		  SbaOut : out signed (3 downto 0);
		  SidOut : out signed (2 downto 0);
		  SaOut :  out signed (1 downto 0);
		  clk : in std_logic;
        DI : in signed (15 downto 0);
        BA : in signed (15 downto 0) 
   );
end entity;
 
architecture comp of LAB2 is
begin
process (clk, Sbb, Sbc, Sba, Sid, Sa, DI)
         variable IR, TMP, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10: signed (15 downto 0);
         variable AD, PC, SP, ATMP : signed (31 downto 0);
       begin
		 
		 SbbOut <= Sbb;
		 SbcOut <= Sbc;
		 SbaOut <= Sba;
		 SidOut <= Sid;
		 SaOut  <= Sa;
		 
       if (clk'event and clk='1') then
         case Sid is
                   when "001" =>
                       PC := PC + 1;
                   when "010" =>
                       SP := SP + 1;
                   when "011" =>
                       SP := SP - 1;
						 when "100" =>
                       AD := AD + 1;
						 when "101" =>
                       AD := AD - 1;
                   when others =>
                       null;
         end case;
         case Sba is
                   when "0000" => IR := BA;
                   when "0001" => TMP := BA;
                   when "0010" => R1 := BA;
                   when "0011" => R2 := BA;
                   when "0100" => R3 := BA;
                   when "0101" => R4 := BA;
                   when "0110" => R5 := BA;
                   when "0111" => R6 := BA;
                   when "1000" => R7 := BA;
                   when "1001" => R8 := BA;
                   when "1010" => R9 := BA;
                   when "1011" => R10 := BA;
                   when "1100" => PC (15 downto 0):= BA;
                   when "1101" => SP (31 downto 16) := BA;
                   when "1110" => ATMP (15 downto 0) := BA;
                   when "1111" => ATMP (31 downto 16) := BA;
						 when others => null;
         end case;
       end if;
         case Sbb is
                   when "0000" => BB <= DI;
                   when "0001" => BB <= TMP;
                   when "0010" => BB <= R1;
                   when "0011" => BB <= R2;
                   when "0100" => BB <= R3;
                   when "0101" => BB <= R4;
                   when "0110" => BB <= R5;
                   when "0111" => BB <= R6;
                   when "1000" => BB <= R7;
                   when "1001" => BB <= R8;
                   when "1010" => BB <= R9;
                   when "1011" => BB <= R10;
                   when "1110" => BB <= ATMP (15 downto 0);
                   when "1111" => BB <= ATMP (31 downto 16);
						 when others => null;
         end case;
         case Sbc is
                   when "0000" => BC <= DI;
                   when "0001" => BC <= TMP;
                   when "0010" => BC <= R1;
                   when "0011" => BC <= R2;
                   when "0100" => BC <= R3;
                   when "0101" => BC <= R4;
                   when "0110" => BC <= R5;
                   when "0111" => BC <= R6;
                   when "1000" => BC <= R7;
                   when "1001" => BC <= R8;
                   when "1010" => BC <= R9;
                   when "1011" => BC <= R10;
                   when "1110" => BC <= ATMP (15 downto 0);
                   when "1111" => BC <= ATMP (31 downto 16);
						 when others => null;
         end case;
         case Sa is
                  when "00" => ADR <= AD;
                  when "01" => ADR <= PC;
                  when "10" => ADR <= SP;
                  when "11" => ADR <= ATMP;
         end case;
         IRout <= IR;
end process;
end comp;