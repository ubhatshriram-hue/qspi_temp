class ahb_driver extends uvm_driver #(seq_item);
  `uvm_component_utils(ahb_driver)
 
  virtual qspi_controller_if.ahb_drv vif;
  qspi_config m_cfg;
 
  function new(string name="ahb_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    if(!uvm_config_db#(qspi_config)::get(this, "", "m_cfg", m_cfg))
      `uvm_fatal(get_type_name(), "AHB driver failed to get m_cfg")
 
    uvm_config_db#(bit)::set(null, "*", "xip_read", 0);
  endfunction
 
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.vif;
  endfunction
 
  task run_phase(uvm_phase phase);
    @(vif.ahb_drv.ahb_drv_cb);
 
  
 
    forever begin
      seq_item_port.get_next_item(req);
      drive_ahb(req);
      seq_item_port.item_done();
    end
  endtask
 
  task drive_ahb(seq_item tr);
 
    @(vif.ahb_drv.ahb_drv_cb);
 
    vif.ahb_drv.ahb_drv_cb.HRESETn <= tr.HRESETn;
 
    uvm_config_db#(bit)::set(null, "*", "xip_read", tr.xip_en);
 
    vif.ahb_drv.ahb_drv_cb.HSEL   <= t.HSEL;
    vif.ahb_drv.ahb_drv_cb.HADDR  <= tr.HADDR;
    vif.ahb_drv.ahb_drv_cb.HTRANS <= tr.HTRANS;
    vif.ahb_drv.ahb_drv_cb.HWRITE <= tr.HWRITE;
    vif.ahb_drv.ahb_drv_cb.HSIZE  <= tr.HSIZE;
    vif.ahb_drv.ahb_drv_cb.HBURST <= tr.HBURST;
    vif.ahb_drv.ahb_drv_cb.xip_en <= tr.xip_en;
 
    do begin
      @(vif.ahb_drv.ahb_drv_cb);
    end while (vif.ahb_drv.ahb_drv_cb.HREADY !== 1'b1);
 uvm_config_db#(bit)::set(null, "*", "xip_read", 0);
 
  endtask
 
endclass
