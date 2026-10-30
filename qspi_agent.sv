class qspi_agent extends uvm_agent;
  `uvm_component_utils(qspi_agent)

  qspi_config cfg;

  qspi_sequencer          sequencer;
  qspi_driver             driver;
  qspi_input_monitor      in_mon;
  qspi_output_monitor     out_mon;

  function new(string name = "qspi_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(qspi_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("qspi_agent", "Could not get cfg from config_db")

    uvm_config_db#(virtual qspi_controller_if)::set(this, "*", "vif", cfg.vif);


    if (is_active == UVM_ACTIVE) begin
      sequencer = qspi_sequencer    ::type_id::create("sequencer", this);
      driver    = qspi_driver       ::type_id::create("driver",    this);
      in_mon    = qspi_input_monitor::type_id::create("in_mon",    this);
    end
    else begin
      out_mon   = qspi_output_monitor::type_id::create("out_mon", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass
