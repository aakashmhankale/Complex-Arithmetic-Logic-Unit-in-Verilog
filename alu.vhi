
-- VHDL Instantiation Created from source file alu.vhd -- 19:58:09 12/04/2015
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT alu
	PORT(
		a : IN std_logic_vector(7 downto 0);
		b : IN std_logic_vector(7 downto 0);
		cin : IN std_logic;          
		out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_alu: alu PORT MAP(
		out => ,
		a => ,
		b => ,
		cin => 
	);


