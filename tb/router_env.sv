//------------------------------------------
// ENVIRONMENT CLASS
//------------------------------------------

class router_env extends uvm_env;

	//factory registration
	`uvm_component_utils(router_env)

	//declare source_agent_top,dest_agent_top,scoreboard,virtual_sequencer handles
	router_source_agent_top source_agt_toph;
	router_dest_agent_top dest_agt_toph;
	router_scoreboard sb_h;
	router_virtual_sequencer vsqrh;
	
	//declare env config handle
	router_env_config m_env_cfg;

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	//build_phase
	virtual function void build_phase(uvm_phase phase);

		//get env_config
		if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_env_cfg))
			`uvm_fatal("CONFIG","cannot get() m_env_cfg from uvm_config_db. Have you set() it?") 

		//create source agent top instance
		if(m_env_cfg.has_source_agent)
			source_agt_toph=router_source_agent_top::type_id::create("source_agt_toph",this);

		//create dest agent top instance
		if(m_env_cfg.has_dest_agent)
			dest_agt_toph=router_dest_agent_top::type_id::create("dest_agt_toph",this);
		
		super.build_phase(phase);
		
		// create virtual sequencer
		if(m_env_cfg.has_virtual_sequencer)
			vsqrh=router_virtual_sequencer::type_id::create("vsqrh",this);

		//create scoreboard instance
		if(m_env_cfg.has_scoreboard)
			sb_h=router_scoreboard::type_id::create("sb_h",this);
	
	endfunction

	//connect_phase
	virtual function void connect_phase(uvm_phase phase);
	
		//connect physical sequencer to virtual sequencer
		if(m_env_cfg.has_virtual_sequencer)
			begin
				if(m_env_cfg.has_source_agent)
					begin
						vsqrh.src_sqrh=source_agt_toph.agth.sqrh;
					end
				if(m_env_cfg.has_dest_agent)
					begin
						for(int j = 0;j<m_env_cfg.no_of_dest_config;j++)
							vsqrh.dst_sqrh[j]=dest_agt_toph.agth[j].sqrh;
					end
			end

		//connect monitors to scoreboard
		if(m_env_cfg.has_scoreboard)
			begin
				source_agt_toph.agth.monh.monitor_port.connect(sb_h.fifo_src.analysis_export);
				for(int k = 0;k<m_env_cfg.no_of_dest_config;k++)
					dest_agt_toph.agth[k].monh.monitor_port.connect(sb_h.fifo_dst[k].analysis_export);
			end

	endfunction

endclass

