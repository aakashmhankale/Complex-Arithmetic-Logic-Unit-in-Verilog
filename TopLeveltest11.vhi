
-- VHDL Instantiation Created from source file TopLeveltest11.vhd -- 23:13:37 12/04/2015
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT TopLeveltest11
	PORT(
		R1 : IN std_logic_vector(7 downto 0);
		R2 : IN std_logic_vector(7 downto 0);
		sel : IN std_logic_vector(2 downto 0);
		clk : IN std_logic;          
		out : OUT std_logic_vector(15 downto 0);
		Done : OUT std_logic;
		busy : OUT std_logic
		);
	END COMPONENT;

	Inst_TopLeveltest11: TopLeveltest11 PORT MAP(
		out => ,
		Done => ,
		R1 => ,
		R2 => ,
		sel => ,
		clk => ,
		busy => 
	);


