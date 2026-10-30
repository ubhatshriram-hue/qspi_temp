class qspi_driver extends uvm_driver #(seq_item);
    `uvm_component_utils(qspi_driver)
    virtual qspi_controller_if.qspi_drv vif;
    qspi_config m_cfg;
    bit [16:0] control;
    bit [7:0] dummy, length;
    bit apb_start;
    bit is_read;
    bit xip_read;
    int lines, total_bytes, wait_clk;
    
    function new(string name="qspi_driver",uvm_component parent);
        super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(qspi_config)::get(this,"","cfg",m_cfg))
            `uvm_fatal(get_type_name(),"QSPI driver failed")
    endfunction
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif=m_cfg.vif;
    endfunction
    task run_phase(uvm_phase phase);
        vif.qspi_drv_cb.Io<=4'bzzzz;
        forever begin
            @(vif.qspi_drv_cb);
            while(vif.qspi_drv_cb.spi_cs_n!=1'b0) begin
                @(vif.qspi_drv_cb);
            end
             if(!uvm_config_db#(bit)::get(this,"","apb_start",apb_start))
                `uvm_fatal(get_type_name(),"APB Start receive failed")
            if(!uvm_config_db#(bit[16:0])::get(this,"","control",control))
                `uvm_fatal(get_type_name(),"Control failed")
            if(!uvm_config_db#(bit [7:0])::get(this,"","dummy",dummy))
                `uvm_fatal(get_type_name(),"Dummy failed")
            if(!uvm_config_db#(bit [7:0])::get(this,"","length",length))
                `uvm_fatal(get_type_name(),"Length failed")
            if(!uvm_config_db#(bit)::get(this,"","xip_read",xip_read))
                `uvm_fatal(get_type_name(),"xip_read failed")
            
            if(apb_start) begin
                is_read=control[6] && !control[5];
                if(control[12:11]==2'b00) lines=1;
                else if(control[12:11]==2'b01) lines=2;
                else if(control[12:11]==2'b10) lines=4;
                else `uvm_fatal("QSPI Error","Invalid line encoding");

                total_bytes=length;
                wait_clk=0;
                if(control[1]) begin
                    if(control[8:7]==2'b00) wait_clk=wait_clk + 8;
                    else if (control[8:7]==2'b01) wait_clk=wait_clk + 4;
                    else if (control[8:7]==2'b10) wait_clk=wait_clk + 2; 
                    else `uvm_fatal("QSPI Error","Invalid line encoding"); 
                end
                if(control[2]) begin
                    if(control[10:9]==2'b00) wait_clk=wait_clk + (control[16] ? 32:24);
                    else if (control[10:9]==2'b01) wait_clk=wait_clk + ((control[16] ? 32:24)/2);
                    else if (control[10:9]==2'b10) wait_clk=wait_clk + ((control[16] ? 32:24)/4); 
                    else `uvm_fatal("QSPI Error","Invalid line encoding");
                end
                if(control[3]) begin
                    if(control[15:14]==2'b00) wait_clk=wait_clk + 8;
                    else if (control[15:14]==2'b01) wait_clk=wait_clk + 4;
                    else if (control[15:14]==2'b10) wait_clk=wait_clk + 2; 
                    else `uvm_fatal("QSPI Error","Invalid line encoding"); 
                end
                if(control[4])begin
                    wait_clk=wait_clk+dummy;
                end
            end
            else if(xip_read)begin
                    is_read=1;
                    lines=4;
                    total_bytes=32;
                    wait_clk=8+6+6;
                end

            if(is_read) begin
                seq_item_port.get_next_item(req);
                drive_data(req);
                seq_item_port.item_done();
            end
            while(vif.qspi_drv_cb.spi_cs_n!=1'b1) @(vif.qspi_drv_cb);
            uvm_config_db#(bit)::set(null ,"*","apb_start",0);
        end
    endtask
    virtual task drive_data(seq_item t);
        int xip_sent=0;
        bit[31:0] word;
        
        if(wait_clk >0) 
            repeat(wait_clk) @(vif.qspi_drv_cb);
        while(xip_sent<total_bytes && vif.qspi_drv_cb.spi_cs_n==1'b0) begin
            if(xip_sent%4==0) word=$urandom;
            drive_byte(word[7:0],lines);
            word=word>>8;
            xip_sent++;
        end
    endtask
    virtual task drive_byte( bit [7:0] b, int lines);
        case(lines)
            4: begin
                vif.qspi_drv_cb.Io<=b[7:4];
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<=b[3:0];
                @(vif.qspi_drv_cb);
            end
            2: begin
                vif.qspi_drv_cb.Io<={2'bzz,b[7:6]};
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<={2'bzz,b[5:4]};
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<={2'bzz,b[3:2]};
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<={2'bzz,b[1:0]};
                @(vif.qspi_drv_cb);
            end
            1: begin
                vif.qspi_drv_cb.Io<={3'bzzz,b[7]};
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<={3'bzzz,b[6]};
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<={3'bzzz,b[5]};
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<={3'bzzz, b[4]};
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<={3'bzzz,b[3]};
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<={3'bzzz,b[2]};
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<={3'bzzz,b[1]};
                @(vif.qspi_drv_cb);
                vif.qspi_drv_cb.Io<={3'bzzz,b[0]};
                @(vif.qspi_drv_cb);
            end
        endcase
    endtask
endclass
