class apb_output_monitor extends uvm_monitor;
	`uvm_component_utils(apb_output_monitor)
	uvm_analysis_port#(seq_item) apb_out_mon_port;
	virtual qspi_controller_if.apb_op_mon apb_vif;
	qspi_config m_cfg;
	seq_item t;

	function new(string name="apb_output_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(qspi_config)::get(this,"","cfg",m_cfg))
			`uvm_fatal(get_type_name(),"APB Output monitor failed")
		apb_out_mon_port=new("apb_out_mon_port",this);
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		apb_vif=m_cfg.vif;
	endfunction
	task run_phase(uvm_phase phase);
		forever begin
			t=seq_item::type_id::create("t");
			collect_data();
			apb_out_mon_port.write(t);
			`uvm_info("APB Output_Monitor",$sformatf("APB Output Monitor\n %s",t.sprint()),UVM_LOW)
		end
	endtask
	virtual task collect_data();
			@(apb_vif.apb_op_mon_cb);
			t.PRDATA=apb_vif.apb_op_mon_cb.PRDATA;
			t.PREADY=apb_vif.apb_op_mon_cb.PREADY;
			t.PSLVERR=apb_vif.apb_op_mon_cb.PSLVERR;
	endtask
endclass
