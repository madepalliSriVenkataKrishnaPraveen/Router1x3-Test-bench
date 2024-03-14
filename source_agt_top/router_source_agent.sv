//------------------------------------------
// SOURCE AGENT CLASS
//------------------------------------------

class router_source_agent extends uvm_agent;

	//factory registration
	`uvm_component_utils(router_source_agent)

	//declare source agent config 
	router_source_agent_config m_source_cfg;
	
	//declare monitor,driver,sequencer handles
	router_source_monitor monh;
	router_source_driver drvh;
	router_source_sequencer sqrh;

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	//build_phase
	virtual function void build_phase(uvm_phase phase);
		
		super.build_phase(phase);

		//get source_config
		if(!uvm_config_db#(router_source_agent_config)::get(this,"","router_source_agent_config",m_source_cfg))
			`uvm_fatal("CONFIG","cannot get() m_source_cfg from uvm_config_db. Have you set() it?")
		
		//create instance for monitor
		monh=router_source_monitor::type_id::create("monh",this);

		//create instance for sequencer and driver
		if(m_source_cfg.is_active == UVM_ACTIVE)
			begin
				drvh=router_source_driver::type_id::create("drvh",this);
				sqrh=router_source_sequencer::type_id::create("sqrh",this);
			end

	endfunction

	//connect_phase
	virtual function void connect_phase(uvm_phase phase);
		
		//connect driver to sequencer vio tlm 
		if(m_source_cfg.is_active == UVM_ACTIVE)
			drvh.seq_item_port.connect(sqrh.seq_item_export);
	
	endfunction

endclass

