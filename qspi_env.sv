class qspi_env extends uvm_env;
  `uvm_component_utils(qspi_env)

  apb_agent  apb_active_agent;
  apb_agent  apb_passive_agent;
  
  ahb_agent  ahb_active_agent;
  ahb_agent  ahb_passive_agent;
  
  qspi_agent  spi_active_agent;
  qspi_agent  spi_passive_agent;

  qspi_config  agent_config; 

  function new(string name = "qspi_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent_config = qspi_config::type_id::create("agent_config");

    if (!uvm_config_db#(virtual qspi_controller_if)::get(this, "", "vif", agent_config.vif))
      `uvm_fatal("ENV", "Could not get vif")

    uvm_config_db#(qspi_config)::set(this, "*", "cfg", agent_config);

    apb_active_agent  = apb_agent::type_id::create("apb_active_agent",  this);
    apb_passive_agent = apb_agent::type_id::create("apb_passive_agent", this);
    ahb_active_agent  = ahb_agent::type_id::create("ahb_active_agent",  this);
    ahb_passive_agent = ahb_agent::type_id::create("ahb_passive_agent", this);
    spi_active_agent  = qspi_agent::type_id::create("spi_active_agent",  this);
    spi_passive_agent = qspi_agent::type_id::create("spi_passive_agent", this);

    apb_active_agent.is_active  = agent_config.apb_act;
    apb_passive_agent.is_active = agent_config.apb_pas;
    ahb_active_agent.is_active  = agent_config.ahb_act;
    ahb_passive_agent.is_active = agent_config.ahb_pas;
    spi_active_agent.is_active  = agent_config.spi_act;
    spi_passive_agent.is_active = agent_config.spi_pas;
  endfunction

endclass
