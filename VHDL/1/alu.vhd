library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
port (
      A 			: in signed(15 downto 0);
      B 			: in signed(15 downto 0);
      Salu 		: in bit_vector(4 downto 0);
      LDF 		: in bit;
      clk 		: in bit;
      Y 			: out signed (15 downto 0);
      C,Z,S 	: out std_logic;
		HEX0		: out std_logic_vector(6 downto 0);
		HEX1		: out std_logic_vector(6 downto 0);
		HEX2		: out std_logic_vector(6 downto 0); 
		HEX3		: out std_logic_vector(6 downto 0) 	
);
end entity;
architecture comp of ALU is


signal AToHex1 	: std_logic_vector(3 downto 0);
signal BToHex2 	: std_logic_vector(3 downto 0);
signal YToHex3 	: std_logic_vector(3 downto 0);
signal codeToHex0 : std_logic_vector(3 downto 0); 
 

component hex_encoder is									
port (
		inhex	   	: in std_logic_vector(3 downto 0); 
		outhex 		: out std_logic_vector(6 downto 0)
);
end component;
begin
  process (Salu, A, B, clk)
       variable res, AA, BB,CC: signed (16 downto 0);
       variable CF,ZF,SF : std_logic;
       begin
         AA(16) := A(15);
         AA(15 downto 0) := A;
         BB(16) := B(15);
         BB(15 downto 0) := B;
         CC(0) := CF;
         CC(16 downto 1) := "0000000000000000";
         case Salu is
             when "00000" => res := AA;
             when "00001" => res := BB;
				 when "00010" => res := AA + BB;
             when "00011" => res := AA - BB;
				 when "00100" => res := AA or BB;
             when "00101" => res := AA and BB;
				 when "00110" => res := AA xor BB;
             when "00111" => res := AA xnor BB;
				 when "01000" => res := not AA;
             when "01001" => res := -AA;
				 when "01010" => res := "00000000000000000";
				 when "01011" => res := AA + BB + CC;
				 when "01100" => res := AA - BB - CC;
				 when "01101" => res := AA + 1;
				 when "01110" => res := shift_left(AA, 1);
				 when "01111" => res := shift_right(AA, 1);
				 when "10000" => res := AA - 1;
				 when "10001" => res := AA rol 1;
				 when "10010" => res := AA nand BB;
				 when "10011" => res := AA ror 1;
				 when "10100" => res := not BB;
				 when others => res := "00000000000000000"; 				 
         end case;
         Y <= res(15 downto 0);
			YToHex3 <= std_logic_vector(res(3 downto 0)); 
			 AToHex1 <= std_logic_vector(AA(3 downto 0));
				BToHex2 <= std_logic_vector(BB(3 downto 0));			
         Z <= ZF;
         S <= SF;
         C <= CF;
         if (clk'event and clk='1') then
             if (LDF='1') then
                 if (res = "00000000000000000") then ZF:='1';
                 else ZF:='0';
                 end if;
             if (res(15)='1') then SF:='1';
             else SF:='0'; end if;
             CF := res(16) xor res(15);
             end if;
         end if;
  end process;
  hex_encoder_0 : hex_encoder port map(inhex => codeToHex0, outhex => HEX0);
  hex_encoder_1 : hex_encoder port map(inhex => AToHex1, outhex => HEX1);
  hex_encoder_2 : hex_encoder port map(inhex => BToHex2, outhex => HEX2);
  hex_encoder_3 : hex_encoder port map(inhex => YToHex3, outhex => HEX3);
 codeToHex0 <= to_stdlogicvector(Salu(3 downto 0));
end comp;

