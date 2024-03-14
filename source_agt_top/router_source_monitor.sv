//------------------------------------------
// SOURCE MONITOR CLASS
//------------------------------------------

class router_source_monitor extends uvm_monitor;

	//factory registration
	`uvm_component_utils(router_source_monitor)

	//declaration of tlm analysis port
	uvm_analysis_port #(source_xtn) monitor_port;

	//declare source agent config handle
	router_source_agent_config m_source_cfg;
	
	//declare virtual interface handle
	virtual src_if vif;
	
	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);

		//create tlm instance
		monitor_port = new("monitor_port",this);

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
		
		//in forever loop
		forever

			//call task collect data
			collect_data();
		
	endtask
	
	//collect data task
	task collect_data();
		
		//create instance of source xtn
		source_xtn xtnh;
		xtnh = source_xtn::type_id::create("xtnh");

		while((vif.src_mon_cb.busy !== 1'b0) || (vif.src_mon_cb.pkt_valid !== 1'b1))
			@(vif.src_mon_cb);
		
		//get header from data in
		xtnh.header=vif.src_mon_cb.data_in;
		xtnh.payload = new[xtnh.header[7:2]];

		@(vif.src_mon_cb);

		//get payload from data in
		foreach(xtnh.payload[i])
			begin
				while(vif.src_mon_cb.busy !== 1'b0)
					@(vif.src_mon_cb);
				xtnh.payload[i]=vif.src_mon_cb.data_in;
					@(vif.src_mon_cb);
			end

		while((vif.src_mon_cb.busy !== 1'b0) || (vif.src_mon_cb.pkt_valid !== 1'b0))
			@(vif.src_mon_cb);
		
		//get parity from data in
		xtnh.parity=vif.src_mon_cb.data_in;

		repeat(2)
			@(vif.src_mon_cb);

		//get error from dut
		xtnh.error = vif.src_mon_cb.error;

		@(vif.src_mon_cb);
	
		`uvm_info("ROUTER_SOURCE_MONITOR",$sformatf("printing from monitor \n %s", xtnh.sprint()),UVM_LOW)

		monitor_port.write(xtnh);

	endtask
	
endclass
