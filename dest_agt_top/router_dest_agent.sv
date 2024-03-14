//------------------------------------------
// DESTINATION AGENT CLASS
//------------------------------------------

class router_dest_agent extends uvm_agent;

	//factory registration
	`uvm_component_utils(router_dest_agent)

	//declare dest agent config 
	router_dest_agent_config m_dest_cfg;
	
	//declare monitor,driver,sequencer handles
	router_dest_monitor monh;
	router_dest_driver drvh;
	router_dest_sequencer sqrh;

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction

	//build_phase
	virtual function void build_phase(uvm_phase phase);
		
		super.build_phase(phase);

		//get dest_config
		if(!uvm_config_db#(router_dest_agent_config)::get(this,"","router_dest_agent_config",m_dest_cfg))
			`uvm_fatal("CONFIG","cannot get() m_dest_cfg from uvm_config_db. Have you set() it?")
		
		//create instance for monitor
		monh=router_dest_monitor::type_id::create("monh",this);

		//create instance for sequencer and driver
		if(m_dest_cfg.is_active == UVM_ACTIVE)
			begin
				drvh=router_dest_driver::type_id::create("drvh",this);
				sqrh=router_dest_sequencer::type_id::create("sqrh",this);
			end

	endfunction

	//connect_phase
	virtual function void connect_phase(uvm_phase phase);
		
		//connect driver to sequencer via tlm 
		if(m_dest_cfg.is_active == UVM_ACTIVE)
			drvh.seq_item_port.connect(sqrh.seq_item_export);
	
	endfunction

endclass

