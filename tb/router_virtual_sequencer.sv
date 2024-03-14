//------------------------------------------
// VIRTUAL SEQUENCER CLASS
//------------------------------------------

class router_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);

	//factory registration
	`uvm_component_utils(router_virtual_sequencer)
	
	//declare physical sequencer handles
	router_dest_sequencer dst_sqrh[];
	router_source_sequencer src_sqrh;

	//declare env_config handle
	router_env_config m_env_cfg;
	
	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction

	//build_phase
	virtual function void build_phase(uvm_phase phase);

		// get env config
		if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_env_cfg))
			`uvm_fatal("CONFIG","cannot get() m_env_cfg from uvm_config_db. Have you set() it?") 

		super.build_phase(phase);

		//get dynamic array size for sequencer handles
		dst_sqrh = new[m_env_cfg.no_of_dest_config];

	endfunction

endclass
