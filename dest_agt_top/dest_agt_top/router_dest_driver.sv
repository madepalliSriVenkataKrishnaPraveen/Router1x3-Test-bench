//------------------------------------------
// DESTINATION DRIVER CLASS
//------------------------------------------

class router_dest_driver extends uvm_driver#(dest_xtn);

	//factory registration	
	`uvm_component_utils(router_dest_driver)

	//declare dest agent config handle
	router_dest_agent_config m_dest_cfg;
	
	//declare virtual interface handle
	virtual dst_if vif;
	
	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	//build phase
	virtual function void build_phase(uvm_phase phase);
		
		//get dest agent config	
		if(!uvm_config_db#(router_dest_agent_config)::get(this,"","router_dest_agent_config",m_dest_cfg))
			`uvm_fatal("CONFIG","cannot get() m_dest_cfg from uvm_config_db. Have you set() it?")
		
	endfunction
	
	//connect phase
	virtual function void connect_phase(uvm_phase phase);
		
		//assign dest_agent_config's virtual interface to virtual interface declared
		vif = m_dest_cfg.vif;
		
	endfunction

	//run phase
	task run_phase(uvm_phase phase);

		//inside forever loop
		forever
			begin
				
				//request items from sequence
				seq_item_port.get_next_item(req);
				
				//drive the signals to dut
				drive(req);
				
				//send the acknowledgement to sequence
				seq_item_port.item_done();
			end

	endtask

	//drive 
	task drive(dest_xtn xtn);
		
		`uvm_info("ROUTER_DEST_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW)

		//check valid_out is high or not
		while(vif.dst_drv_cb.valid_out !== 1'b1)
			@(vif.dst_drv_cb);
		
		//repeat for the no_of_cycle
		repeat(xtn.no_of_cycle)
			@(vif.dst_drv_cb);

		//make read_enable high
		vif.dst_drv_cb.read_enable <= 1'b1;
 		@(vif.dst_drv_cb);

		//check valid_out is low or not
		while(vif.dst_drv_cb.valid_out !== 1'b0)
			@(vif.dst_drv_cb);

		//make read_enable low
		vif.dst_drv_cb.read_enable <= 1'b0;
		repeat(2)
		@(vif.dst_drv_cb);

	endtask

	
endclass
