`ifndef QSPI_ASSERTIONS
`define QSPI_ASSERTIONS

module qspi_assertions(
input logic PCLK,
input logic PRESETn,
input logic PSEL,
input logic PENABLE,
input logic PWRITE,
input logic [3:0] PSTRB,
input logic [7:0] PADDR,
input logic [31:0] PWDATA,
input logic PREADY,
input logic PSLVERR,
input logic spi_cs_n,
 
input logic HCLK,
input logic HRESETn,
input logic HSEL,
input logic [31:0] HADDR,
input logic [1:0] HTRANS,
input logic HWRITE,
input logic [2:0] HSIZE,
input logic [2:0] HBURST,
input logic [31:0] HWDATA,
input logic HREADY,
input logic [31:0] HRDATA,
input logic HREADYOUT,
input logic [1:0] HRESP,
 
input logic SCLK,
input logic SRESETn,
input logic spi_sclk,
input logic [3:0] Io,
input logic xip_en);
 
localparam logic [7:0] ADDR_CONTROL=8'h04;
localparam logic [7:0] ADDR_OPCODE=8'h08;
localparam logic [7:0] ADDR_ADDRESS=8'h0C;
localparam logic [7:0] ADDR_MODE=8'h10;
localparam logic [7:0] ADDR_DUMMY=8'h14;
localparam logic [7:0] ADDR_LENGTH=8'h18;
localparam logic [7:0] ADDR_DATA=8'h1C;
 
property setup_to_access;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&!PENABLE)|=>(PSEL&&PENABLE);
endproperty
assert property(setup_to_access)
else
$error("setup to access error");
 
property enable_after_setup;
@(posedge PCLK)disable iff(!PRESETn)
$rose(PENABLE)|->$past(PSEL&&!PENABLE);
endproperty
assert property(enable_after_setup)
else
$error("enable after setup error");
 
property pwrite_stable;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&!(PENABLE&&PREADY))|=>$stable(PWRITE);
endproperty
assert property(pwrite_stable)
else
$error("pwrite stable error");
 
property paddr_stable;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&PENABLE&&!PREADY)|=>$stable(PADDR);
endproperty
assert property(paddr_stable)
else
$error("paddr stable error");
 
property pwdata_stable;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&PENABLE&&!PREADY&&PWRITE)|=>$stable(PWDATA);
endproperty
assert property(pwdata_stable)
else
$error("pwdata stable error");
 
property pstrb_stable;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&PENABLE&&!PREADY&&PWRITE)|=>$stable(PSTRB);
endproperty
assert property(pstrb_stable)
else
$error("pstrb stable error");
 
//Arbitration
parameter int AHB_TIMEOUT=50000;
property ahb_xip_timeout_error;
@(posedge HCLK)disable iff(!HRESETn)
(HSEL&&HTRANS[1]&&HREADY&&!HWRITE&&xip_en&&!HREADYOUT)##1(!HREADYOUT)[*AHB_TIMEOUT]|->(HRESP==2'b01);
endproperty
assert property(ahb_xip_timeout_error)
else
$error("ahb xip timeout error did not pass");
 
property ahb_valid_response;
@(posedge HCLK)disable iff(!HRESETn)
(HSEL&&HTRANS[1]&&HREADYOUT)|->(HRESP inside {2'b00,2'b01});
endproperty
assert property(ahb_valid_response)
else
$error("ahb valid response error");
 
property ahb_error_two_cycles;
@(posedge HCLK)disable iff(!HRESETn)
(HRESP==2'b01&&!HREADYOUT)|=>(HRESP==2'b01&&HREADYOUT);
endproperty
assert property(ahb_error_two_cycles)
else
$error("ahb error two cycles did not pass");
 
parameter int APB_TIMEOUT=250000000;
property apb_start_timeout_error;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&PENABLE&&PWRITE&&PADDR==ADDR_CONTROL&&PWDATA[0]&&!PREADY)##1(!PREADY)[*APB_TIMEOUT]|->(PREADY&&PSLVERR);
endproperty
assert property(apb_start_timeout_error)
else
$error("apb start timeout error did not pass");
 
property apb_start_completes;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&PENABLE&&PWRITE&&PADDR==ADDR_CONTROL&&PWDATA[0])|->##[0:APB_TIMEOUT]PREADY;
endproperty
assert property(apb_start_completes)
else
$error("apb start completes error");
 
property pslverr_requires_pready;
@(posedge PCLK)disable iff(!PRESETn)
PSLVERR|->PREADY;
endproperty
assert property(pslverr_requires_pready)
else
$error("pslverr requires pready error");
 
//AHB Assertion
property reset_values;
@(posedge HCLK)
!HRESETn|->(HREADYOUT==1'b1&&HRESP==2'b00&&HRDATA==32'b0);
endproperty
assert property(reset_values)
else
$error("reset values error");
 
property error_response_format;
@(posedge HCLK)disable iff(!HRESETn)
(HRESP==2'b01 && HREADYOUT==1'b0)|=>(HRESP==2'b01&&HREADYOUT==1'b1);
endproperty
assert property(error_response_format)
else
$error("error response format did not pass");
 
property address_stability;
@(posedge HCLK)disable iff(!HRESETn)
!HREADY|=>$stable({HADDR,HTRANS,HWRITE,HSIZE});
endproperty
assert property(address_stability)
else
$error("address stability error");
 
property invalid_read_size;
@(posedge HCLK)disable iff(!HRESETn)
(HSEL && HTRANS[1] &&HREADY&&!HWRITE&&xip_en&&(HSIZE!=3'b010))|->##[1:50000](HRESP==2'b01&&HREADYOUT==1'b0);
endproperty
assert property(invalid_read_size)
else
$error("invalid read size error");
 
property write_to_xip;
@(posedge HCLK)disable iff(!HRESETn)
(HSEL&&HTRANS[1]&&HREADY&&HWRITE)|->##[1:50000](HRESP==2'b01&&HREADYOUT==1'b0);
endproperty
assert property(write_to_xip)
else
$error("write to xip error");
 
property xip_disabled_read;
@(posedge HCLK)disable iff(!HRESETn)
(HSEL&&HTRANS[1]&&HREADY&&!HWRITE&&!xip_en&&(HSIZE==3'b010))|->##[1:50000](HRESP==2'b01&&HREADYOUT==1'b0);
endproperty
assert property(xip_disabled_read)
else
$error("xip disable read error");
 
property read_wait_state;
@(posedge HCLK)disable iff(!HRESETn)
(HSEL&&HTRANS[1]&&HREADY&&!HWRITE&&xip_en&&(HSIZE==3'b010)&&!HREADYOUT)|->!HREADYOUT;
endproperty
assert property(read_wait_state)
else
$error("read wait state error");
 
property read_completion;
@(posedge HCLK)disable iff(!HRESETn)
(HSEL&&HTRANS[1]&&HREADY&&!HWRITE&&xip_en&&(HSIZE==3'b010))|->##[1:50000](HREADYOUT&&HRESP==2'b00);
endproperty
assert property(read_completion)
else
$error("read completion error");
 
property idle_transfer;
@(posedge HCLK)disable iff(!HRESETn)
(!HSEL&&HTRANS==2'b00&&HREADY)|->(spi_cs_n==1'b1);
endproperty
assert property(idle_transfer)
else
$error("idle transfer error");
 
property busy_transfer;
@(posedge HCLK)disable iff(!HRESETn)
(!HSEL&&HTRANS==2'b01&&HREADY)|->(spi_cs_n==1'b1);
endproperty
assert property(busy_transfer)
else
$error("bust transfer error");
 
//APB Read Assertions
property apb_read_setup_to_access;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&PENABLE&&!PWRITE)|=>(PSEL&&PENABLE&&!PWRITE);
endproperty
assert property(apb_read_setup_to_access)
else
$error("apb read setup to access error");
 
property apb_read_address_stable;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&PENABLE&&!PWRITE&&!PREADY)|=>$stable(PADDR);
endproperty
assert property(apb_read_address_stable)
else
$error("apb read address stable error");
 
property apb_register_read;
@(posedge PCLK)disable iff(!PRESETn)
((PSEL&&PENABLE&&!PWRITE&&PADDR inside {8'h04,8'h08,8'h0C,8'h10,8'h14,8'h18})&&!PREADY)|=>(PREADY&&!PSLVERR);
endproperty
assert property(apb_register_read)
else
$error("apb register read error");
 
property apb_data_read;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&PENABLE&&!PWRITE&&PADDR==8'h1C&&PREADY)|->!PSLVERR;
endproperty
assert property(apb_data_read)
else
$error("apb data read error");
 
property apb_invalid_read_address;
@(posedge PCLK)disable iff(!PRESETn)
(PSEL&&PENABLE&&!PWRITE&&PREADY&&!(PADDR inside {8'h04,8'h08,8'h0C,8'h10,8'h14,8'h18,8'h1C}))|->PSLVERR;
endproperty
assert property(apb_invalid_read_address)
else
$error("apb invalid read address error");
 
endmodule


`endif
