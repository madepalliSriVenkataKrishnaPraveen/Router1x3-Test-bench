//------------------------------------------
// SOURCE AGENT TOP CLASS
//------------------------------------------

class router_source_agent_top extends uvm_env;

	//factory registration
	`uvm_component_utils(router_source_agent_top)

	//declare source agent handle
	router_source_agent agth;

	//declare env_config handle
	router_env_config m_env_cfg;

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	//build_phase
	virtual function void build_phase(uvm_phase phase);

		//get env config
		if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_env_cfg))
			`uvm_fatal("CONFIG","cannot get() m_env_cfg from uvm_config_db. Have you set() it?") 

		super.build_phase(phase);
		
		//set source config and create source agent intance
		uvm_config_db#(router_source_agent_config)::set(this,"agth*","router_source_agent_config",m_env_cfg.m_source_cfg);
		agth = router_source_agent::type_id::create("agth",this);

	endfunction

endclass

