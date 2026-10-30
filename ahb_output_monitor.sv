class ahb_output_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_output_monitor)
	uvm_analysis_port#(seq_item) ahb_out_mon_port;
	virtual qspi_controller_if.ahb_op_mon ahb_vif;
	qspi_config m_cfg;
	seq_item t;

	function new(string name="ahb_output_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(qspi_config)::get(this,"","cfg",m_cfg))
			`uvm_fatal(get_type_name(),"AHB Output monitor failed")
		ahb_out_mon_port=new("ahb_out_mon_port",this);
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		ahb_vif=m_cfg.vif;
	endfunction
	task run_phase(uvm_phase phase);
		forever begin
			t=seq_item::type_id::create("t");
			collect_data();
			ahb_out_mon_port.write(t);
			`uvm_info("AHB Output_Monitor",$sformatf("AHB Output Monitor\n %s",t.sprint()),UVM_LOW)
		end
	endtask
	virtual task collect_data();
			@(ahb_vif.ahb_op_mon_cb);
			t.HRDATA=ahb_vif.ahb_op_mon_cb.HRDATA;
			t.HREADYOUT=ahb_vif.ahb_op_mon_cb.HREADYOUT;
			t.HRESP=ahb_vif.ahb_op_mon_cb.HRESP;
	endtask
endclass
