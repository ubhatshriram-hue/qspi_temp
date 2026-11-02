`include "uvm_macros.svh"
`include "define.sv"     
`include "qspi_controller_if.sv"
`include "qspi_package.sv"
`include "qspi_Controller.v"
`include "qspi_assertions.sv"

module top;

  import uvm_pkg::*;
  import qspi_pkg::*;

  bit PCLK,HCLK,SCLK;

  qspi_controller_if vif(.PCLK(PCLK),.HCLK(HCLK),.SCLK(SCLK));

  bind qspi_Controller qspi_assertions inst_assert (.*);

  qspi_Controller #(.XIP_LINE_BYTES(32), .XIP_LINE_SHIFT(5)) DUT (
      .PCLK      (PCLK),
      .PRESETn   (vif.PRESETn),
      .HCLK      (vif.HCLK),
      .HRESETn   (vif.HRESETn),
      .SCLK      (vif.SCLK),
      .SRESETn   (vif.SRESETn),
      .PSEL      (vif.PSEL),
      .PENABLE   (vif.PENABLE),
      .PWRITE    (vif.PWRITE),
      .PSTRB     (vif.PSTRB),
      .PADDR     (vif.PADDR),
      .PWDATA    (vif.PWDATA),
      .PRDATA    (vif.PRDATA),
      .PREADY    (vif.PREADY),
      .PSLVERR   (vif.PSLVERR),
      .HSEL      (vif.HSEL),
      .HADDR     (vif.HADDR),
      .HTRANS    (vif.HTRANS),
      .HWRITE    (vif.HWRITE),
      .HSIZE     (vif.HSIZE),
      .HBURST    (vif.HBURST),
      .HWDATA    (vif.HWDATA),
      .HREADY    (vif.HREADY),
      .HRDATA    (vif.HRDATA),
      .HREADYOUT (vif.HREADYOUT),
      .HRESP     (vif.HRESP),
      .xip_en    (vif.xip_en),
      .spi_cs_n  (vif.spi_cs_n),
      .spi_sclk  (vif.spi_sclk),
      .Io        (vif.Io)
  );

  initial begin
      PCLK=0;
      forever #5 PCLK=~PCLK;
  end

  initial begin
      HCLK=0;
      forever #5 HCLK=~HCLK;
  end

  initial begin
      SCLK=0;
      forever #25 SCLK=~SCLK;
  end

  initial begin
      vif.PRESETn=0;
      vif.HRESETn=0;
      vif.SRESETn=0;
      vif.PSEL=0;
      vif.PENABLE=0;
      vif.PWRITE=0;
      vif.PSTRB=0;            
      vif.PADDR=0;        
      vif.PWDATA=0;         
      vif.HSEL=0;
      vif.HTRANS=2'b00;
      vif.HWRITE=0;          
      vif.HSIZE=0;        
      vif.HBURST=0;        
      vif.HADDR=0; 
      vif.HWDATA=0;     
      vif.xip_en=0;
	  
      repeat (5) @(posedge SCLK);
      vif.PRESETn=1;
      vif.HRESETn=1;
      vif.SRESETn=1;
  end

  initial begin
      uvm_config_db #(virtual qspi_controller_if)::set(null,"*","vif",vif);
      run_test("qspi_test");
  end

endmodule
