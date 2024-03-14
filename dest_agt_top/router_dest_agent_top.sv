class router_dest_agent_top extends uvm_env;

	//factory registration
	`uvm_component_utils(router_dest_agent_top)
	
	//declare dest agent handle
	router_dest_agent agth[];
	
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
		
		//assign dynamic array size for agent 
		agth = new[m_env_cfg.no_of_dest_config];
		
		//set dest config and create dest agent intance
		foreach(agth[i])
			begin
				uvm_config_db#(router_dest_agent_config)::set(this,$sformatf("agth[%0d]*",i),"router_dest_agent_config",m_env_cfg.m_dest_cfg[i]);
				agth[i] = router_dest_agent::type_id::create($sformatf("agth[%0d]",i),this);
			end
			
	endfunction

endclass

