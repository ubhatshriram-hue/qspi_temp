class apb_input_monitor extends uvm_monitor;
	`uvm_component_utils(apb_input_monitor)
	uvm_analysis_port#(seq_item) apb_inp_mon_port;
	virtual qspi_controller_if.apb_ip_mon apb_vif;
	qspi_config m_cfg;
	seq_item t;

	function new(string name="apb_input_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(qspi_config)::get(this,"","cfg",m_cfg))
			`uvm_fatal(get_type_name(),"APB Input monitor failed")
		apb_inp_mon_port=new("apb_inp_mon_port",this);
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		apb_vif=m_cfg.vif;
	endfunction
	task run_phase(uvm_phase phase);
		forever begin
			t=seq_item::type_id::create("t");
			collect_data();
			apb_inp_mon_port.write(t);
			`uvm_info("APB Input_Monitor",$sformatf("APB Input Monitor\n %s",t.sprint()),UVM_LOW)
		end
	endtask
	virtual task collect_data();
			@(apb_vif.apb_ip_mon_cb);
			t.PSEL=apb_vif.apb_ip_mon_cb.PSEL;
			t.PENABLE=apb_vif.apb_ip_mon_cb.PENABLE;
			t.PWRITE=apb_vif.apb_ip_mon_cb.PWRITE;
			t.PSTRB=apb_vif.apb_ip_mon_cb.PSTRB;
			t.PADDR=apb_vif.apb_ip_mon_cb.PADDR;
			t.PWDATA=apb_vif.apb_ip_mon_cb.PWDATA;
	endtask
endclass
