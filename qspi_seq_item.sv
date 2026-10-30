class seq_item extends uvm_sequence_item;

  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(PSEL,      UVM_ALL_ON)
    `uvm_field_int(PENABLE,   UVM_ALL_ON)
    `uvm_field_int(PWRITE,    UVM_ALL_ON)
    `uvm_field_int(PSTRB,     UVM_ALL_ON)
    `uvm_field_int(PADDR,     UVM_ALL_ON)
    `uvm_field_int(PWDATA,    UVM_ALL_ON)
    `uvm_field_int(PRDATA,    UVM_ALL_ON)
    `uvm_field_int(PREADY,    UVM_ALL_ON)
    `uvm_field_int(PSLVERR,   UVM_ALL_ON)
    `uvm_field_int(HSEL,      UVM_ALL_ON)
    `uvm_field_int(HADDR,     UVM_ALL_ON)
    `uvm_field_int(HTRANS,    UVM_ALL_ON)
    `uvm_field_int(HWRITE,    UVM_ALL_ON)
    `uvm_field_int(HSIZE,     UVM_ALL_ON)
    `uvm_field_int(HBURST,    UVM_ALL_ON)
    `uvm_field_int(HWDATA,    UVM_ALL_ON)
    `uvm_field_int(HREADY,    UVM_ALL_ON)
    `uvm_field_int(HRDATA,    UVM_ALL_ON)
    `uvm_field_int(HREADYOUT, UVM_ALL_ON)
    `uvm_field_int(HRESP,     UVM_ALL_ON)
    `uvm_field_int(xip_en,    UVM_ALL_ON)
    `uvm_field_int(spi_cs_n,  UVM_ALL_ON)
    `uvm_field_int(spi_sclk,  UVM_ALL_ON)
    `uvm_field_int(Io,        UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="qspi_seq_item");
    super.new(name);
  endfunction

  //////////////////////////////////////APB//////////////////////////
  rand bit PSEL;
  rand bit PENABLE;
  rand bit PWRITE;
  rand bit [`APB_STRB-1:0]PSTRB;
  rand bit [`APB_ADD-1:0]PADDR;
  rand bit [`APB_DATA-1:0]PWDATA;

  bit [`APB_DATA-1:0]PRDATA;
  bit PREADY;
  bit PSLVERR;

  ///////////////////////////////AHB/////////////////////////////////
  rand bit HSEL;
  rand bit [`AHB_ADD-1:0]HADDR;
  rand bit [1:0]HTRANS;
  rand bit HWRITE;
  rand bit [`AHB_TRANFER_SIZE-1:0]HSIZE;
  rand bit [2:0]HBURST;
  rand bit [`AHB_DATA-1:0]HWDATA;
  rand bit HREADY;

  bit [`AHB_DATA-1:0]HRDATA;
  bit HREADYOUT;
  bit [1:0]HRESP;

  ///////////////////////////OTHER/////////////////////////
  rand bit xip_en;

  bit spi_cs_n;
  bit spi_sclk;

  rand bit [`IO_WIDTH-1:0]Io;

endclass
