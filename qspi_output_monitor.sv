class qspi_output_monitor extends uvm_monitor;
  `uvm_component_utils(qspi_output_monitor)
  uvm_analysis_port#(seq_item) qspi_out_mon_port;
	virtual qspi_controller_if.qspi_op_mon vif;
	qspi_config m_cfg;
	seq_item t;

  function new(string name="qspi_output_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(qspi_config)::get(this,"","cfg",m_cfg))
			`uvm_fatal(get_type_name(),"QSPI Output monitor failed")
    qspi_out_mon_port=new("qspi_out_mon_port",this);
	endfunction
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=m_cfg.vif;
	endfunction
	task run_phase(uvm_phase phase);
		forever begin
			t=seq_item::type_id::create("t");
			collect_data();
			qspi_out_mon_port.write(t);
    `uvm_info("QSPI_Output_Monitor",$sformatf("QSPI Output Monitor\n %s",t.sprint()),UVM_HIGH)
		end
	endtask
	virtual task collect_data();
			@(vif.qspi_op_mon_cb);
			t.spi_cs_n=vif.qspi_op_mon_cb.spi_cs_n;
			t.spi_sclk=vif.qspi_op_mon_cb.spi_sclk;
	endtask
endclass
