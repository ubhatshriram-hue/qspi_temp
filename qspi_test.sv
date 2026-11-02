class qspi_test extends uvm_test;
  `uvm_component_utils(qspi_test)

  qspi_env env;
  qspi_config cfg;

  apb_CONTROL_FILL_sequence  apb_fill;
  apb_CONTROL_READ_sequence  apb_read;
  ahb_sucess_read_sequence   ahb_read;

  function new(string name="qspi_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg = qspi_config::type_id::create("cfg");

    if (!uvm_config_db#(virtual qspi_controller_if)::get(this, "", "vif", cfg.vif))
      `uvm_fatal("TEST", "Could not get vif")

    uvm_config_db#(qspi_config)::set(this, "env.*", "cfg", cfg);

    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.apb_active_agent",  "is_active", cfg.apb_act);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.apb_passive_agent", "is_active", cfg.apb_pas);
    
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.ahb_active_agent",  "is_active", cfg.ahb_act);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.ahb_passive_agent", "is_active", cfg.ahb_pas);
    
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.spi_active_agent",  "is_active", cfg.spi_act);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.spi_passive_agent", "is_active", cfg.spi_pas);

    env = qspi_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    apb_fill = apb_CONTROL_FILL_sequence::type_id::create("apb_fill");
    apb_read = apb_CONTROL_READ_sequence::type_id::create("apb_read");
    ahb_read = ahb_sucess_read_sequence ::type_id::create("ahb_read");

    apb_fill.start(env.apb_active_agent.sequencer);
    apb_read.start(env.apb_active_agent.sequencer);
    ahb_read.start(env.ahb_active_agent.sequencer);
    
    phase.drop_objection(this);
  endtask

endclass
