class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)

  qspi_config cfg;

  ahb_sequencer          sequencer;
  ahb_driver             driver;
  ahb_input_monitor      in_mon;
  ahb_output_monitor     out_mon;

  function new(string name = "ahb_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(qspi_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("AHB_AGENT", "Could not get cfg from config_db")

    uvm_config_db#(virtual qspi_controller_if)::set(this, "*", "vif", cfg.vif);

    // active
    if (cfg.ahb_act == UVM_ACTIVE) begin
      sequencer = ahb_sequencer    ::type_id::create("sequencer", this);
      driver    = ahb_driver       ::type_id::create("driver",    this);
      in_mon    = ahb_input_monitor::type_id::create("in_mon",    this);
    end

    // passive
    if (cfg.ahb_pas == UVM_PASSIVE) begin
      out_mon   = ahb_output_monitor::type_id::create("out_mon", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.ahb_act == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass
