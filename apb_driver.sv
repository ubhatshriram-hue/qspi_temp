class apb_driver extends uvm_driver #(seq_item);
  `uvm_component_utils(apb_driver)

  virtual qspi_controller_if.apb_drv vif;
  qspi_config m_cfg;

  function new(string name="apb_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(qspi_config)::get(this, "", "m_cfg", m_cfg))
      `uvm_fatal(get_type_name(), "APB driver failed to get m_cfg")

    uvm_config_db#(bit)::set(null, "*", "apb_start", 0);
    uvm_config_db#(bit [16:0])::set(null, "*", "control", '0);
    uvm_config_db#(bit [7:0])::set(null, "*", "dummy", '0);
    uvm_config_db#(bit [7:0])::set(null, "*", "length", '0);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);

    forever begin
      seq_item_port.get_next_item(req);
      drive_apb(req);
      seq_item_port.item_done();
    end
  endtask

  task drive_apb(seq_item tr);

    if (tr.PWRITE) begin
      case (tr.PADDR[7:0])
        8'h04: begin
          uvm_config_db#(bit [16:0])::set(null, "*", "control", tr.PWDATA[16:0]);

          if (tr.PWDATA[0])
            uvm_config_db#(bit)::set(null, "*", "apb_start", 1);
        end

        8'h14:
          uvm_config_db#(bit [7:0])::set(null, "*", "dummy", tr.PWDATA[7:0]);

        8'h18:
          uvm_config_db#(bit [7:0])::set(null, "*", "length", tr.PWDATA[7:0]);
      endcase
    end

    @(vif.apb_drv.apb_drv_cb);
    vif.apb_drv.apb_drv_cb.PRESETn <= tr.PRESETn;
    vif.apb_drv.apb_drv_cb.PSEL    <= 1'b0;
    vif.apb_drv.apb_drv_cb.PENABLE <= 1'b0;

    @(vif.apb_drv.apb_drv_cb);
    vif.apb_drv.apb_drv_cb.PSEL    <= 1;
     vif.apb_drv.apb_drv_cb.PRESETn <= tr.PRESETn;
    vif.apb_drv.apb_drv_cb.PENABLE <= 1'b0;
    vif.apb_drv.apb_drv_cb.PWRITE  <= tr.PWRITE;
    vif.apb_drv.apb_drv_cb.PSTRB   <= tr.PWRITE ? tr.PSTRB : 4'b0000;
    vif.apb_drv.apb_drv_cb.PADDR   <= tr.PADDR;
    vif.apb_drv.apb_drv_cb.PWDATA  <= tr.PWDATA;

    @(vif.apb_drv.apb_drv_cb);
    vif.apb_drv.apb_drv_cb.PENABLE <= 1'b1;
    vif.apb_drv.apb_drv_cb.PSEL    <= 1;

    do begin
      @(vif.apb_drv.apb_drv_cb);
    end while (vif.apb_drv.apb_drv_cb.PREADY !== 1'b1);


  endtask

endclass
