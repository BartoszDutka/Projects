library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity memory is
port
(
     ADR : in signed(31 downto 0);
     DO : in signed(15 downto 0);
     Smar, Smbr, WRin, RDin : in bit;
     AD : out signed (31 downto 0);
     DI : out signed(15 downto 0);
     WR, RD : out bit;
	  hex_MBR : out std_logic_vector(6 downto 0);
	  hex_DI : out std_logic_vector(6 downto 0)
);
end entity;
architecture compo of memory is
type mem is array(0 to 31) of signed(15 downto 0);
signal ram_block : mem;
component hex
   port (
         i : in signed(3 downto 0);
         o : out std_logic_vector (6 downto 0)
   );
end component;
begin
   process(Smar, ADR, Smbr, DO, WRin, RDin)
           variable MBR: signed(15 downto 0);
           variable MAR : signed(31 downto 0);		  	
	begin
        if(Smar='1') then
			  MAR := ADR;
		  end if;
        if(Smbr='1') then
		      MBR := DO;
		  end if;
        if (RDin='1') then
		      MBR := ram_block(to_integer(MAR));
		  end if;
        if (WRin='1') then
		      ram_block(to_integer(MAR)) <= MBR;
        end if;
        DI <= MBR;
        AD <= MAR;
        WR <= WRin;
        RD <= RDin;
   end process;
	 HEX1: hex port map (i=>ADR(3 downto 0),o=>hex_MBR);
	 HEX2: hex port map (i=>DO(3 downto 0),o=>hex_DI);
end compo;