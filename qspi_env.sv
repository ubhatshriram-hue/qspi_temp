class qspi_env extends uvm_env;
  `uvm_component_utils(qspi_env)

  apb_agent   apb_active_agent;
  apb_agent   apb_passive_agent;
  ahb_agent   ahb_active_agent;
  ahb_agent   ahb_passive_agent;
  qspi_agent  spi_active_agent;
  qspi_agent  spi_passive_agent;

  qspi_scoreboard scb;

  qspi_config cfg;

  function new(string name = "qspi_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(qspi_config)::get(this, "apb_active_agent*",  "cfg", cfg);
    uvm_config_db#(qspi_config)::get(this, "ahb_active_agent*",  "cfg", cfg);
    uvm_config_db#(qspi_config)::get(this, "spi_active_agent*",  "cfg", cfg);
    uvm_config_db#(qspi_config)::get(this, "apb_passive_agent*", "cfg", cfg);
    uvm_config_db#(qspi_config)::get(this, "ahb_passive_agent*", "cfg", cfg);
    uvm_config_db#(qspi_config)::get(this, "spi_passive_agent*", "cfg", cfg);

    apb_active_agent  = apb_agent ::type_id::create("apb_active_agent",  this);
    apb_passive_agent = apb_agent ::type_id::create("apb_passive_agent", this);
    ahb_active_agent  = ahb_agent ::type_id::create("ahb_active_agent",  this);
    ahb_passive_agent = ahb_agent ::type_id::create("ahb_passive_agent", this);
    spi_active_agent  = qspi_agent::type_id::create("spi_active_agent",  this);
    spi_passive_agent = qspi_agent::type_id::create("spi_passive_agent", this);

    scb = qspi_scoreboard::type_id::create("scb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    apb_active_agent.in_mon.ap.connect (scb.apb_in_export);
    ahb_active_agent.in_mon.ap.connect (scb.ahb_in_export);
    spi_active_agent.in_mon.ap.connect (scb.spi_in_export);

    apb_passive_agent.out_mon.ap.connect(scb.apb_out_export);
    ahb_passive_agent.out_mon.ap.connect(scb.ahb_out_export);
    spi_passive_agent.out_mon.ap.connect(scb.spi_out_export);
  endfunction

endclass
