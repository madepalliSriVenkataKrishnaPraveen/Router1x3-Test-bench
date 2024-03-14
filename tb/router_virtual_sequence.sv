//------------------------------------------
// VIRTUAL SEQUENCE BASE CLASS
//------------------------------------------

class router_virtual_base_sequence extends uvm_sequence#(uvm_sequence_item);

	//factory registration
	`uvm_object_utils(router_virtual_base_sequence)

	//declare physical sequencer and virtual sequencer handles
	router_dest_sequencer dst_sqrh[];
	router_source_sequencer src_sqrh;
	router_virtual_sequencer vsqrh;
	
	// declare env_config handle,addr
	router_env_config m_env_cfg;
	bit[1:0] addr;

	//declare sequence handles
	router_source_random_pkt src_rand_pkt;
	router_source_small_pkt src_sml_pkt;
	router_source_medium_pkt src_med_pkt;
	router_source_large_pkt src_lrg_pkt;
	router_dest_ideal dst_idl;
	router_dest_soft_rst dst_srst;

	//overriding constructor
	function new(string name="router_virtual_base_sequence");
		super.new(name);
	endfunction

	//body
	task body();
			
		//get env config
		if(!uvm_config_db#(router_env_config)::get(null,get_full_name(),"router_env_config",m_env_cfg))
			`uvm_fatal("CONFIG","cannot get() m_env_cfg from uvm_config_db. Have you set() it?") 
		
		//get addr
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal("CONFIG","cannot get() addr from uvm_config_db. Have you set() it?")
		
		//get dynamic array size for physical sequencer handles
		dst_sqrh = new[m_env_cfg.no_of_dest_config];

		// check compatibility of virtual sequencer and m_sequencer
		assert($cast(vsqrh,m_sequencer));
		
		// assign virtual sequencer's physical sequencer handle to physical sequencer handle of this class
		foreach(dst_sqrh[i])
			dst_sqrh[i]=vsqrh.dst_sqrh[i];
		src_sqrh=vsqrh.src_sqrh;

	endtask

endclass

//------------------------------------------
// VIRTUAL SEQUENCE RANDOM PACKET CLASS
//------------------------------------------

class router_random_pkt_vseq extends router_virtual_base_sequence;

	//factory registration
	`uvm_object_utils(router_random_pkt_vseq)

	//overriding constructor
	function new(string name="router_random_pkt_vseq");
		super.new(name);
	endfunction

	//task body
	task body();
		
		super.body();
repeat(2000) begin
		//create instance for source random sequence and dest ideal sequence
		src_rand_pkt=router_source_random_pkt::type_id::create("src_rand_pkt");
		dst_idl=router_dest_ideal::type_id::create("dst_idl");

		//start sequence on all source and dest sequencers 
		fork
			begin
				if(m_env_cfg.has_source_agent)
					src_rand_pkt.start(src_sqrh);
			end
			begin
				if(m_env_cfg.has_dest_agent)
					begin
						for(int i=0;i<m_env_cfg.no_of_dest_config;i++)
							begin
								if(addr==i)
									dst_idl.start(dst_sqrh[i]);
							end
					end
			end
		join
end
	endtask

endclass

//------------------------------------------
// VIRTUAL SEQUENCE SMALL PACKET CLASS
//------------------------------------------

class router_small_pkt_vseq extends router_virtual_base_sequence;

	//factory registration
	`uvm_object_utils(router_small_pkt_vseq)

	//overriding constructor
	function new(string name="router_small_pkt_vseq");
		super.new(name);
	endfunction

	//task body
	task body();
		
		super.body();
repeat(1000) begin
		//create instance for small sequence and dest ideal sequence
		src_sml_pkt=router_source_small_pkt::type_id::create("src_sml_pkt");
		dst_idl=router_dest_ideal::type_id::create("dst_idl");

		//start sequence on all source and dest sequencers 
		fork
			begin
				if(m_env_cfg.has_source_agent)
					src_sml_pkt.start(src_sqrh);
			end
			begin
				if(m_env_cfg.has_dest_agent)
					begin
						for(int i=0;i<m_env_cfg.no_of_dest_config;i++)
							begin
								if(addr==i)
									dst_idl.start(dst_sqrh[i]);
							end
		
					end
			end
		join
end
	endtask

endclass

//------------------------------------------
// VIRTUAL SEQUENCE MEDIUM PACKET CLASS
//------------------------------------------

class router_medium_pkt_vseq extends router_virtual_base_sequence;

	//factory registration
	`uvm_object_utils(router_medium_pkt_vseq)

	//overriding constructor
	function new(string name="router_medium_pkt_vseq");
		super.new(name);
	endfunction

	//task body
	task body();
		
		super.body();
repeat(1000) begin
		//create instance for medium sequence and dest ideal sequence
		src_med_pkt=router_source_medium_pkt::type_id::create("src_med_pkt");
		dst_idl=router_dest_ideal::type_id::create("dst_idl");

		//start sequence on all source and dest sequencers 
		fork
			begin
				if(m_env_cfg.has_source_agent)
					src_med_pkt.start(src_sqrh);
			end
			begin
				if(m_env_cfg.has_dest_agent)
					begin
						for(int i=0;i<m_env_cfg.no_of_dest_config;i++)
							begin
								if(addr==i)
									dst_idl.start(dst_sqrh[i]);
							end
					end
			end
		join
end
	endtask

endclass

//------------------------------------------
// VIRTUAL SEQUENCE LARGE PACKET CLASS
//------------------------------------------

class router_large_pkt_vseq extends router_virtual_base_sequence;

	//factory registration
	`uvm_object_utils(router_large_pkt_vseq)

	//overriding constructor
	function new(string name="router_large_pkt_vseq");
		super.new(name);
	endfunction

	//task body
	task body();
		
		super.body();
 repeat(1000) begin
		//create instance for large sequence and dest ideal sequence
		src_lrg_pkt=router_source_large_pkt::type_id::create("src_lrg_pkt");
		dst_idl=router_dest_ideal::type_id::create("dst_idl");

		//start sequence on all source and dest sequencers 
		fork
			begin
				if(m_env_cfg.has_source_agent)
					src_lrg_pkt.start(src_sqrh);
			end
			begin
				if(m_env_cfg.has_dest_agent)
					begin
						for(int i=0;i<m_env_cfg.no_of_dest_config;i++)
							begin
								if(addr==i)
									dst_idl.start(dst_sqrh[i]);
							end
					end
			end
		join
end
	endtask

endclass

//------------------------------------------
// VIRTUAL SEQUENCE SOFT RESET CLASS
//------------------------------------------

class router_softreset_vseq extends router_virtual_base_sequence;

	//factory registration
	`uvm_object_utils(router_softreset_vseq)

	//overriding constructor
	function new(string name="router_softreset_vseq");
		super.new(name);
	endfunction

	//task body
	task body();
		
		super.body();
 repeat(2000) begin
		//create instance for large sequence and dest ideal sequence
		src_rand_pkt=router_source_random_pkt::type_id::create("src_rand_pkt");
		dst_srst=router_dest_soft_rst::type_id::create("dst_srst");

		//start sequence on all source and dest sequencers 
		fork
			begin
				if(m_env_cfg.has_source_agent)
					src_rand_pkt.start(src_sqrh);
			end
			begin
				if(m_env_cfg.has_dest_agent)
					begin
						for(int i=0;i<m_env_cfg.no_of_dest_config;i++)
							begin
								if(addr==i)
									dst_srst.start(dst_sqrh[i]);
							end
					end
			end
		join
end
	endtask

endclass

