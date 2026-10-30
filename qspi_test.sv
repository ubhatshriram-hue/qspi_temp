class qspi_test extends uvm_test;
  `uvm_component_utils(qspi_test)

  qspi_env env;

  apb_CONTROL_FILL_sequence  apb_fill;
  apb_CONTROL_READ_sequence  apb_read;
  ahb_sucess_read_sequence   ahb_read;

  function new(string name="qspi_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = qspi_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    apb_fill = apb_CONTROL_FILL_sequence::type_id::create("apb_fill");
    apb_read = apb_CONTROL_READ_sequence::type_id::create("apb_read");
    ahb_read = ahb_sucess_read_sequence ::type_id::create("ahb_read");

    #100;

    apb_fill.start(env.apb_active_agent.sequencer);
    apb_read.start(env.apb_active_agent.sequencer);
    ahb_read.start(env.ahb_active_agent.sequencer);

    #200;
    phase.drop_objection(this);
  endtask

endclass
