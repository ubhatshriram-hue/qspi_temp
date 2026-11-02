class qspi_test extends uvm_test;
  `uvm_component_utils(qspi_test)

  qspi_env env;

  qspi_config act_cfg;
  qspi_config pas_cfg;

  apb_CONTROL_FILL_sequence  apb_fill;
  apb_CONTROL_READ_sequence  apb_read;
  ahb_sucess_read_sequence   ahb_read;

  function new(string name="qspi_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    act_cfg = qspi_config::type_id::create("act_cfg");
    pas_cfg = qspi_config::type_id::create("pas_cfg");
    
    if (!uvm_config_db#(virtual qspi_controller_if)::get(this, "", "vif", act_cfg.vif))
      `uvm_fatal("TEST", "Could not get vif")
    pas_cfg.vif = act_cfg.vif;

    pas_cfg.apb_act = UVM_PASSIVE;
    pas_cfg.ahb_act = UVM_PASSIVE;
    pas_cfg.spi_act = UVM_PASSIVE;

    // active agents get act_cfg
    uvm_config_db#(qspi_config)::set(this, "env.apb_active_agent*",  "cfg", act_cfg);
    uvm_config_db#(qspi_config)::set(this, "env.ahb_active_agent*",  "cfg", act_cfg);
    uvm_config_db#(qspi_config)::set(this, "env.spi_active_agent*",  "cfg", act_cfg);

    // passive agents get pas_cfg
    uvm_config_db#(qspi_config)::set(this, "env.apb_passive_agent*", "cfg", pas_cfg);
    uvm_config_db#(qspi_config)::set(this, "env.ahb_passive_agent*", "cfg", pas_cfg);
    uvm_config_db#(qspi_config)::set(this, "env.spi_passive_agent*", "cfg", pas_cfg);

    // env must be created AFTER the sets
    env = qspi_env::type_id::create("env", this);
  endfunction

  // run_phase: unchanged
endclass
