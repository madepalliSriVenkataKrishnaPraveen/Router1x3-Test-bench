//------------------------------------------
// BASE TEST CLASS
//------------------------------------------

class router_base_test extends uvm_test;

	//factory registration
	`uvm_component_utils(router_base_test)
	
	//declare env handle
	router_env envh;
	
	//declare env,dest_agent,source_agent config handles and addr
	router_env_config m_env_cfg;
	router_dest_agent_config m_dest_cfg[];
	router_source_agent_config m_source_cfg;
	bit[1:0] addr = 0;

	//assign value for has_dest_agent,has_source_agent,no_of_dest_config,no_of_source_config 
	bit has_dest_agent = 1;
	bit has_source_agent = 1;
	int no_of_dest_config = 3;
		
	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	//Build_phase
	virtual function void build_phase(uvm_phase phase);
		
		//create env_config instance
		m_env_cfg=router_env_config::type_id::create("m_env_cfg");
		
		//assign parameter to env_config
		if(has_source_agent)
			begin
				//create instance for source config 
				m_source_cfg=router_source_agent_config::type_id::create("m_source_cfg");

				//assign parameters for source config
				if(!uvm_config_db#(virtual src_if)::get(this,"","src_if",m_source_cfg.vif))
					`uvm_fatal("CONFIG","cannot get() virtual interface from uvm_config_db. Have you set() it?")
				m_source_cfg.is_active = UVM_ACTIVE;
						
				//assign source config to env's source config
				m_env_cfg.m_source_cfg = m_source_cfg;
			end
		if(has_dest_agent)
			begin
				
				//assign dynamic array size for dest_config
				m_env_cfg.m_dest_cfg = new[no_of_dest_config];
				m_dest_cfg = new[no_of_dest_config];
				foreach(m_dest_cfg[i])
					begin
						
						//create instance for dest config
						m_dest_cfg[i]=router_dest_agent_config::type_id::create($sformatf("m_dest_cfg[%0d]",i));
						
						//assign parameters for dest config
						if(!uvm_config_db#(virtual dst_if)::get(this,"",$sformatf("dst_if%0d",i),m_dest_cfg[i].vif))
							`uvm_fatal("CONFIG","cannot get() virtual interface from uvm_config_db. Have you set() it?")
						m_dest_cfg[i].is_active = UVM_ACTIVE;
						
						//assign dest config to env's dest config
						m_env_cfg.m_dest_cfg[i] = m_dest_cfg[i];
					end
			end
			
		//assign has_dest_agent,has_source_agent,no_of_dest_config,no_of_source_config to env's has_dest_agent,has_source_agent,no_of_dest_config,no_of_source_config
		m_env_cfg.has_dest_agent = has_dest_agent;
		m_env_cfg.has_source_agent = has_source_agent;
		m_env_cfg.no_of_dest_config = no_of_dest_config ;

		//set env_config
		uvm_config_db#(router_env_config)::set(this,"*","router_env_config",m_env_cfg);
		
		super.build_phase(phase);

		//create env instance
		envh = router_env::type_id::create("envh",this);
		
	endfunction

	//print topology
	virtual function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
	
	//run_phase
	task run_phase(uvm_phase phase);
		
		//randomize addr
		addr = {$urandom}%3;
		
		//set config for addr
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);

	endtask

endclass

//------------------------------------------
// RANDOM PACKET TEST CLASS
//------------------------------------------

class router_random_pkt_test extends router_base_test;

	//factory registration
	`uvm_component_utils(router_random_pkt_test)
	
	//declare router_random_pkt_vseq virtual sequence handle
	router_random_pkt_vseq rand_pkt;

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
		//rand_pkt=router_random_pkt_vseq::type_id::create("rand_pkt");

	endfunction

	//build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	//run phase
	task run_phase(uvm_phase phase);
		
		super.run_phase(phase);
 	
		//raise objection
        	phase.raise_objection(this);

		//create instance for sequence
          	rand_pkt=router_random_pkt_vseq::type_id::create("rand_pkt");
 		
		//start the sequence wrt virtual sequencer
          	rand_pkt.start(envh.vsqrh);
 	
		#200;

		//drop objection
         	phase.drop_objection(this);
	
	endtask   

endclass

//------------------------------------------
// SMALL PACKET TEST CLASS
//------------------------------------------

class router_small_pkt_test extends router_base_test;
	//factory registration
	`uvm_component_utils(router_small_pkt_test)
	
	//declare router_small_pkt_vseq virtual sequence handle
	router_small_pkt_vseq sml_pkt;

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction

	//build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	//run phase
	task run_phase(uvm_phase phase);
 	
		super.run_phase(phase);

		//raise objection
        	phase.raise_objection(this);
 		
		//create instance for sequence
          	sml_pkt=router_small_pkt_vseq::type_id::create("sml_pkt");
 		
		//start the sequence wrt virtual sequencer
          	sml_pkt.start(envh.vsqrh);

		#200;

		//drop objection
         	phase.drop_objection(this);
	
	endtask 
endclass

//------------------------------------------
// MEDIUM PACKET TEST CLASS
//------------------------------------------

class router_medium_pkt_test extends router_base_test;

	//factory registration
	`uvm_component_utils(router_medium_pkt_test)
	
	//declare router_medium_pkt_vseq virtual sequence handle
	router_medium_pkt_vseq med_pkt;

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction

	//build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	//run phase
	task run_phase(uvm_phase phase);
		
		super.run_phase(phase);
 	
		//raise objection
        	phase.raise_objection(this);
 		
		//create instance for sequence
          	med_pkt=router_medium_pkt_vseq::type_id::create("med_pkt");
 		
		//start the sequence wrt virtual sequencer
          	med_pkt.start(envh.vsqrh);
 		
		#200; 

		//drop objection
         	phase.drop_objection(this);
	
	endtask 

endclass

//------------------------------------------
// LARGE PACKET TEST CLASS
//------------------------------------------

class router_large_pkt_test extends router_base_test;

	//factory registration
	`uvm_component_utils(router_large_pkt_test)
	
	//declare router_large_pkt_vseq virtual sequence handle
	router_large_pkt_vseq lrg_pkt;

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction

	//build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	//run phase
	task run_phase(uvm_phase phase);
 	
		super.run_phase(phase);

		//raise objection
        	phase.raise_objection(this);
 		
		//create instance for sequence
          	lrg_pkt=router_large_pkt_vseq::type_id::create("lrg_pkt");
 		
		//start the sequence wrt virtual sequencer
          	lrg_pkt.start(envh.vsqrh);
 		
		#200;

		//drop objection
         	phase.drop_objection(this);
	
	endtask 

endclass

//------------------------------------------
// SOFT-RESET TEST CLASS
//------------------------------------------

class router_softreset_test extends router_base_test;

	//factory registration
	`uvm_component_utils(router_softreset_test)
	
	//declare router_large_pkt_vseq virtual sequence handle
	router_softreset_vseq sft_rst;

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction

	//build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	//run phase
	task run_phase(uvm_phase phase);
 	
		super.run_phase(phase);

		//raise objection
        	phase.raise_objection(this);
 		
		//create instance for sequence
          	sft_rst=router_softreset_vseq::type_id::create("sft_rst");
 		
		//start the sequence wrt virtual sequencer
          	sft_rst.start(envh.vsqrh);
 		
		#200;

		//drop objection
         	phase.drop_objection(this);
	
	endtask 

endclass

//------------------------------------------
// ERROR PACKET TEST CLASS
//------------------------------------------

class router_error_pkt_test extends router_base_test;

	//factory registration
	`uvm_component_utils(router_error_pkt_test)
	
	//declare router_large_pkt_vseq virtual sequence handle
	router_random_pkt_vseq rand_pkt;

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction

	//build phase
	function void build_phase(uvm_phase phase);

		super.build_phase(phase);

		//override source_xtn class to bad_xtn class
		set_type_override_by_type(source_xtn::get_type(),bad_xtn::get_type());

	endfunction

	//run phase
	task run_phase(uvm_phase phase);
 	
		super.run_phase(phase);

		//raise objection
        	phase.raise_objection(this);
 		
		//create instance for sequence
          	rand_pkt=router_random_pkt_vseq::type_id::create("rand_pkt");
 		
		//start the sequence wrt virtual sequencer
          	rand_pkt.start(envh.vsqrh);
 		
		#200;

		//drop objection
         	phase.drop_objection(this);
	
	endtask 

endclass


