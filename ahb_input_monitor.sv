class ahb_input_monitor extends uvm_monitor;
	`uvm_component_utils(ahb_input_monitor)
	uvm_analysis_port#(seq_item) ahb_inp_mon_port;
	virtual qspi_controller_if.ahb_ip_mon ahb_vif;
	qspi_config m_cfg;
	seq_item t;

	function new(string name="ahb_input_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(qspi_config)::get(this,"","cfg",m_cfg))
			`uvm_fatal(get_type_name(),"AHB Input monitor failed")
		ahb_inp_mon_port=new("ahb_inp_mon_port",this);
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		ahb_vif=m_cfg.vif;
	endfunction
	task run_phase(uvm_phase phase);
		forever begin
			t=seq_item::type_id::create("t");
			collect_data();
			ahb_inp_mon_port.write(t);
			`uvm_info("AHB Input_Monitor",$sformatf("AHB Input Monitor\n %s",t.sprint()),UVM_LOW)
		end
	endtask
	virtual task collect_data();
			@(ahb_vif.ahb_ip_mon_cb);
			t.HRESETn = ahb_vif.ahb_ip_mon_cb.HRESETn;
			t.HSEL=ahb_vif.ahb_ip_mon_cb.HSEL;
			t.HTRANS=ahb_vif.ahb_ip_mon_cb.HTRANS;
			t.HWRITE=ahb_vif.ahb_ip_mon_cb.HWRITE;
			t.HSIZE=ahb_vif.ahb_ip_mon_cb.HSIZE;
			t.HBURST=ahb_vif.ahb_ip_mon_cb.HBURST;
			t.HADDR=ahb_vif.ahb_ip_mon_cb.HADDR;
			t.HWDATA=ahb_vif.ahb_ip_mon_cb.HWDATA;
			t.HREADY=ahb_vif.ahb_ip_mon_cb.HREADY;
			t.xip_en=ahb_vif.ahb_ip_mon_cb.xip_en;
	endtask
endclass
