class ahb_driver extends uvm_driver #(seq_item);
  `uvm_component_utils(ahb_driver)

  virtual qspi_controller_if vif;
  qspi_config m_cfg;

  function new(string name="ahb_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(qspi_config)::get(this, "", "cfg", m_cfg))
      `uvm_fatal(get_type_name(), "AHB driver failed to get cfg")

    uvm_config_db#(bit)::set(null, "*", "xip_read", 0);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    vif.ahb_drv_cb.HSEL   <= 1'b0;
    vif.ahb_drv_cb.HTRANS <= 2'b00;
    vif.ahb_drv_cb.HWRITE <= 1'b0;
    vif.ahb_drv_cb.xip_en <= 1'b0;
    forever begin
      seq_item_port.get_next_item(req);
      drive_ahb(req);
      seq_item_port.item_done();
    end
  endtask

  task drive_ahb(seq_item tr);

    if (!(tr.HSEL && tr.HTRANS[1])) begin
      @(vif.ahb_drv_cb);
      vif.ahb_drv_cb.HSEL   <= 1'b0;
      vif.ahb_drv_cb.HTRANS <= 2'b00;
      vif.ahb_drv_cb.HWRITE <= 1'b0;
      return;
    end

    uvm_config_db#(bit)::set(null, "*", "xip_read", tr.xip_en);

    @(vif.ahb_drv_cb);
    vif.ahb_drv_cb.HSEL   <= 1'b1;
    vif.ahb_drv_cb.HADDR  <= tr.HADDR;
    vif.ahb_drv_cb.HTRANS <= tr.HTRANS;
    vif.ahb_drv_cb.HWRITE <= tr.HWRITE;
    vif.ahb_drv_cb.HSIZE  <= tr.HSIZE;
    vif.ahb_drv_cb.HBURST <= tr.HBURST;
    vif.ahb_drv_cb.xip_en <= tr.xip_en;

    do @(vif.ahb_drv_cb); while (vif.ahb_drv_cb.HREADY !== 1'b1);

    vif.ahb_drv_cb.HSEL   <= 1'b0;
    vif.ahb_drv_cb.HTRANS <= 2'b00;
    do @(vif.ahb_drv_cb); while (vif.ahb_drv_cb.HREADY !== 1'b1);

    tr.HREADY    = vif.ahb_drv_cb.HREADY;
    tr.HREADYOUT = vif.ahb_drv_cb.HREADYOUT;
    tr.HRDATA    = vif.ahb_drv_cb.HRDATA;
    tr.HRESP     = vif.ahb_drv_cb.HRESP;

    vif.ahb_drv_cb.xip_en <= 1'b0;
    uvm_config_db#(bit)::set(null, "*", "xip_read", 0);
  endtask

endclass
