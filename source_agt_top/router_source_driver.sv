//------------------------------------------
// SOURCE DRIVER CLASS
//------------------------------------------

class router_source_driver extends uvm_driver#(source_xtn);

	//factory registration
	`uvm_component_utils(router_source_driver)

	//declare source agent config handle
	router_source_agent_config m_source_cfg;
	
	//declare virtual interface handle
	virtual src_if vif;
	
	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction

	//build phase
	virtual function void build_phase(uvm_phase phase);
		
		//get source agent config	
		if(!uvm_config_db#(router_source_agent_config)::get(this,"","router_source_agent_config",m_source_cfg))
			`uvm_fatal("CONFIG","cannot get() m_source_cfg from uvm_config_db. Have you set() it?")
		
	endfunction
	
	//connect phase
	virtual function void connect_phase(uvm_phase phase);
		
		//assign source_agent_config's virtual interface to virtual interface declared
		vif = m_source_cfg.vif;
		
	endfunction

	//run phase
	task run_phase(uvm_phase phase);
	
		//reset the dut
		vif.src_drv_cb.rst <= 0;
		repeat(2)
			@(vif.src_drv_cb);
		vif.src_drv_cb.rst <= 1;

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
	task drive(source_xtn xtn);
		
		`uvm_info("ROUTER_SOURCE_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW)

		//check busy is low or not
		while(vif.src_drv_cb.busy !== 1'b0)
			@(vif.src_drv_cb);
		
		//make pkt_valid high
		vif.src_drv_cb.pkt_valid <= 1'b1;

		//assign header to data in
		vif.src_drv_cb.data_in <= xtn.header;

		@(vif.src_drv_cb);

		//assign payload to data in
		foreach(xtn.payload[i])
			begin
				while(vif.src_drv_cb.busy !== 1'b0)
					@(vif.src_drv_cb);
				vif.src_drv_cb.data_in <= xtn.payload[i];
					@(vif.src_drv_cb);
			end

		while(vif.src_drv_cb.busy !== 1'b0)
			@(vif.src_drv_cb);
		
		//make pkt_valid low
		vif.src_drv_cb.pkt_valid <= 1'b0;
		
		//assign parity to data in
		vif.src_drv_cb.data_in <= xtn.parity;

		repeat(2)
			@(vif.src_drv_cb);

		//sample error from dut
		xtn.error = vif.src_drv_cb.error;

		@(vif.src_drv_cb);

	endtask
	
endclass
