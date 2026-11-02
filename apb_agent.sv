class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)

  qspi_config cfg;

  apb_sequencer          sequencer;
  apb_driver             driver;
  apb_input_monitor      in_mon;
  apb_output_monitor     out_mon;

  function new(string name = "apb_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(qspi_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("APB_AGENT", "Could not get cfg from config_db")

    uvm_config_db#(virtual qspi_controller_if)::set(this, "*", "vif", cfg.vif);

    //active
    if (cfg.apb_act == UVM_ACTIVE) begin
      sequencer = apb_sequencer    ::type_id::create("sequencer", this);
      driver    = apb_driver       ::type_id::create("driver",    this);
      in_mon    = apb_input_monitor::type_id::create("in_mon",    this);
    end

    // passive
    if (cfg.apb_pas == UVM_PASSIVE) begin
      out_mon   = apb_output_monitor::type_id::create("out_mon", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.apb_act == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass
