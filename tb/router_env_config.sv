//------------------------------------------
// ENVIRONMENT CONFIG CLASS
//------------------------------------------

class router_env_config extends uvm_object;

	//factory registration
	`uvm_object_utils(router_env_config)

	bit has_scoreboard =1;
	bit has_dest_agent =1;
	bit has_source_agent =1;
	bit has_virtual_sequencer =1;

	router_dest_agent_config m_dest_cfg[];
	router_source_agent_config m_source_cfg;

	int no_of_dest_config;
	
	//overriding constructor
	function new(string name="router_env_config");
		super.new(name);
	endfunction

endclass
