class qspi_config extends uvm_object;
  `uvm_object_utils(qspi_config)

  uvm_active_passive_enum apb_act = UVM_ACTIVE;
  uvm_active_passive_enum apb_pas = UVM_PASSIVE;
  
  uvm_active_passive_enum ahb_act = UVM_ACTIVE;
  uvm_active_passive_enum ahb_pas = UVM_PASSIVE;
  
  uvm_active_passive_enum spi_act = UVM_ACTIVE;
  uvm_active_passive_enum spi_pas = UVM_PASSIVE;

  virtual qspi_controller_if vif;

  function new(string name = "qspi_config");
    super.new(name);
  endfunction

endclass
