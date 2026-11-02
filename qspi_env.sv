class qspi_env extends uvm_env;
  `uvm_component_utils(qspi_env)

  apb_agent   apb_active_agent;
  apb_agent   apb_passive_agent;
  ahb_agent   ahb_active_agent;
  ahb_agent   ahb_passive_agent;
  qspi_agent  spi_active_agent;
  qspi_agent  spi_passive_agent;

  scoreboard  scb;
  subscriber  sub;

  function new(string name = "qspi_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    apb_active_agent  = apb_agent ::type_id::create("apb_active_agent",  this);
    apb_passive_agent = apb_agent ::type_id::create("apb_passive_agent", this);
    ahb_active_agent  = ahb_agent ::type_id::create("ahb_active_agent",  this);
    ahb_passive_agent = ahb_agent ::type_id::create("ahb_passive_agent", this);
    spi_active_agent  = qspi_agent::type_id::create("spi_active_agent",  this);
    spi_passive_agent = qspi_agent::type_id::create("spi_passive_agent", this);

    scb = scoreboard::type_id::create("scb", this);
    sub = subscriber::type_id::create("sub", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // ---------- scoreboard ----------
    apb_active_agent.in_mon.apb_inp_mon_port.connect  (scb.apb_ip_fifo.analysis_export);
    apb_passive_agent.out_mon.apb_out_mon_port.connect(scb.apb_op_fifo.analysis_export);

    ahb_active_agent.in_mon.ahb_inp_mon_port.connect  (scb.ahb_ip_fifo.analysis_export);
    ahb_passive_agent.out_mon.ahb_out_mon_port.connect(scb.ahb_op_fifo.analysis_export);

    spi_active_agent.in_mon.qspi_inp_mon_port.connect  (scb.spi_ip_fifo.analysis_export);
    spi_passive_agent.out_mon.qspi_out_mon_port.connect(scb.spi_op_fifo.analysis_export);

    // ---------- subscriber ----------
    apb_active_agent.in_mon.apb_inp_mon_port.connect  (sub.analysis_export);
    apb_passive_agent.out_mon.apb_out_mon_port.connect(sub.out_mon);
    ahb_active_agent.in_mon.ahb_inp_mon_port.connect  (sub.ahb_ip);
    ahb_passive_agent.out_mon.ahb_out_mon_port.connect(sub.ahb_op);
    spi_active_agent.in_mon.qspi_inp_mon_port.connect (sub.qspi_mon);
  endfunction

endclass
