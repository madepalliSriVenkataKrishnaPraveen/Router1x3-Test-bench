//------------------------------------------
// DESTINATION MONITOR CLASS
//------------------------------------------

class router_dest_monitor extends uvm_monitor;

	//factory registration	
	`uvm_component_utils(router_dest_monitor)

	//declaration of tlm analysis port
	uvm_analysis_port #(dest_xtn) monitor_port;

	//declare dest agent config handle
	router_dest_agent_config m_dest_cfg;
	
	//declare virtual interface handle
	virtual dst_if vif;


	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);

		//create tlm instance
		monitor_port = new("monitor_port",this);

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
		
		//in forever loop
		forever

			//call task collect data
			collect_data();
		
	endtask
	
	//collect data task
	task collect_data();
		
		//create instance of dest xtn
		dest_xtn xtnh;
		xtnh = dest_xtn::type_id::create("xtnh");

		//check read_enable is high or not
		while(vif.dst_mon_cb.read_enable !== 1'b1)
			@(vif.dst_mon_cb);

		@(vif.dst_mon_cb);

		//get header from data in
		xtnh.header=vif.dst_mon_cb.data_out;
		xtnh.payload = new[xtnh.header[7:2]];

		@(vif.dst_mon_cb);

		//get payload from data in
		foreach(xtnh.payload[i])
			begin
				while(vif.dst_mon_cb.read_enable !== 1'b1)
					@(vif.dst_mon_cb);
				xtnh.payload[i]=vif.dst_mon_cb.data_out;
				@(vif.dst_mon_cb);
			end
		
		while(vif.dst_mon_cb.read_enable !== 1'b1)
			@(vif.dst_mon_cb);

		//get parity from data in
		xtnh.parity=vif.dst_mon_cb.data_out;
		
		repeat(2)
		@(vif.dst_mon_cb);
	
		`uvm_info("ROUTER_DEST_MONITOR",$sformatf("printing from monitor \n %s", xtnh.sprint()),UVM_LOW)

		monitor_port.write(xtnh);

	endtask

endclass
