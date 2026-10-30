interface qspi_controller_if(
    input logic PCLK,
    input logic HCLK,
    input logic SCLK
);

    logic xip_en;

    logic PRESETn;
    logic PSEL;
    logic PENABLE;
    logic PWRITE;
    logic [`APB_STRB-1:0] PSTRB;
    logic [`APB_ADD-1:0] PADDR;
    logic [`APB_DATA-1:0] PWDATA;
    logic [`APB_DATA-1:0] PRDATA;
    logic PREADY;
    logic PSLVERR;

    logic HRESETn;
    logic HSEL;
    logic [`AHB_ADD-1:0] HADDR;
    logic [1:0] HTRANS;
    logic HWRITE;
    logic [`AHB_TRANFER_SIZE-1:0] HSIZE;
    logic [2:0] HBURST;
    logic [`AHB_DATA-1:0] HWDATA;
    logic HREADY;
    logic [`AHB_DATA-1:0] HRDATA;
    logic HREADYOUT;
    logic [1:0] HRESP;

    logic SRESETn;
    logic spi_cs_n;
    logic spi_sclk;
    tri   [`IO_WIDTH-1:0] Io;

    assign HREADY = HREADYOUT;

    clocking apb_drv_cb @(posedge PCLK);
        default input #1 output #1;
        output PSEL, PENABLE, PWRITE, PSTRB, PADDR, PWDATA;
        input PRDATA, PREADY, PSLVERR;
    endclocking

    clocking apb_ip_mon_cb @(posedge PCLK);
        default input #1;
        input PRESETn, PSEL, PENABLE, PWRITE, PSTRB, PADDR, PWDATA;
    endclocking

    clocking apb_op_mon_cb @(posedge PCLK);
        default input #1;
        input PRDATA, PREADY, PSLVERR;
    endclocking

    clocking ahb_drv_cb @(posedge HCLK);
        default input #1 output #1;
        output HSEL, HADDR, HTRANS, HWRITE, HSIZE, HBURST, HWDATA, xip_en;
        input HRDATA, HREADYOUT, HRESP, HREADY;
    endclocking

    clocking ahb_ip_mon_cb @(posedge HCLK);
        default input #1;
        input HRESETn, HSEL, HADDR, HTRANS, HWRITE, HSIZE, HBURST, HWDATA, HREADY, xip_en;
    endclocking

    clocking ahb_op_mon_cb @(posedge HCLK);
        default input #1;
        input HRDATA, HREADYOUT, HRESP;
    endclocking

    clocking qspi_drv_cb @(posedge SCLK);
        default input #1 output #1;
        input SRESETn, spi_cs_n, spi_sclk;
        inout Io;
    endclocking

    clocking qspi_ip_mon_cb @(posedge SCLK);
        default input #1;
        input SRESETn, spi_cs_n, spi_sclk;
        inout Io;
    endclocking

    clocking qspi_op_mon_cb @(posedge SCLK);
        default input #1;
        input spi_cs_n, spi_sclk;
        inout Io;
    endclocking

    modport apb_drv    (clocking apb_drv_cb,    input PCLK);
    modport apb_ip_mon (clocking apb_ip_mon_cb, input PCLK);
    modport apb_op_mon (clocking apb_op_mon_cb, input PCLK);

    modport ahb_drv    (clocking ahb_drv_cb,    input HCLK);
    modport ahb_ip_mon (clocking ahb_ip_mon_cb, input HCLK);
    modport ahb_op_mon (clocking ahb_op_mon_cb, input HCLK);

    modport qspi_drv    (clocking qspi_drv_cb,    input SCLK);
    modport qspi_ip_mon (clocking qspi_ip_mon_cb, input SCLK);
    modport qspi_op_mon (clocking qspi_op_mon_cb, input SCLK);

endinterface
