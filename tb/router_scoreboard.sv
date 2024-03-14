//------------------------------------------
// SCOREBOARD CLASS
//------------------------------------------

class router_scoreboard extends uvm_scoreboard;

	//factory registration
	`uvm_component_utils(router_scoreboard)

	//tlm analysis fifo declaration
	uvm_tlm_analysis_fifo #(source_xtn) fifo_src;
	uvm_tlm_analysis_fifo #(dest_xtn) fifo_dst[];
	
	//declare env config handle
	router_env_config m_env_cfg;

	//declare transaction class
	source_xtn sxtn;
	dest_xtn dxtn;
	
	//source covergroup
	covergroup src_cg;
		option.per_instance=1;

		addr : coverpoint sxtn.header[1:0]{illegal_bins IB = {2'b11};}
		len : coverpoint sxtn.header[7:2]{bins low = {[1:16]};
						bins med = {[17:40]};
						bins lrg = {[41:63]};}
		err: coverpoint sxtn.error ;

		ADDRXLEN : cross addr,len;
	endgroup	
	covergroup src_cg1 with function sample(int i);
		option.per_instance=1;
	
		pyld : coverpoint sxtn.payload[i]{bins low = {[0:50]};
					bins low1 = {[51:100]};
					bins med = {[101:150]};
					bins lrg = {[151:200]};
					bins lrg1 = {[201:255]};}
	endgroup

	//dest covergroup
	covergroup dst_cg;
		option.per_instance=1;

		addr : coverpoint dxtn.header[1:0]{illegal_bins IB = {2'b11};}
		len : coverpoint dxtn.header[7:2]{bins low = {[1:16]};
						bins med = {[17:40]};
						bins lrg = {[41:63]};}
		ADDRXLEN : cross addr,len;
	endgroup
	covergroup dst_cg1 with function sample(int i);
		option.per_instance=1;
	
		pyld : coverpoint dxtn.payload[i]{bins low = {[0:50]};
					bins low1 = {[51:100]};
					bins med = {[101:150]};
					bins lrg = {[151:200]};
					bins lrg1 = {[201:255]};}
	endgroup

	//overriding constructor
	function new(string name,uvm_component parent = null);
		super.new(name,parent);
		src_cg = new();
		src_cg1 = new();
		dst_cg = new();
		dst_cg1 = new();
	endfunction
	
	//build_phase
	virtual function void build_phase(uvm_phase phase);
		
		//get env_config 
		if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_env_cfg))
			`uvm_fatal("CONFIG","cannot get() m_env_cfg from uvm_config_db. Have you set() it?") 

		//assign dynamic array size of tlm analysis fifo
		fifo_dst = new[m_env_cfg.no_of_dest_config];

		// create tlm analysis fifo
		fifo_src = new("fifo_src",this);
		foreach(fifo_dst[i])
			fifo_dst[i] = new($sformatf("fifo_dst[%0d]",i),this);
		
	endfunction

	//run_phase	
	task run_phase(uvm_phase phase);
		forever
			begin
				fifo_src.get(sxtn);
				foreach(fifo_dst[i])
					begin
						if(sxtn.header[1:0] == i)
							fifo_dst[i].get(dxtn);
					end
				compare();
				src_cg.sample();
				foreach(sxtn.payload[i])
					src_cg1.sample(i);
				dst_cg.sample();
				foreach(sxtn.payload[i])
					dst_cg1.sample(i);
			end
	endtask

	//task compare
	task compare();
		if(sxtn.header == dxtn.header)
			`uvm_info("COMPARE","Header is successfully compared",UVM_LOW)
		else
			`uvm_fatal("COMPARE","Header is not compared successfully")
		if(sxtn.payload == dxtn.payload)
			`uvm_info("COMPARE","Payload is successfully compared",UVM_LOW)
		else
			`uvm_fatal("COMPARE","Payload is not compared successfully")
		if(sxtn.parity == dxtn.parity)
			`uvm_info("COMPARE","Parity is successfully compared",UVM_LOW)
		else
			`uvm_fatal("COMPARE","Parity is not compared successfully")
	endtask
					
endclass
