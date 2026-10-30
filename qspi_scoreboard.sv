class scoreboard extends uvm_scoreboard;

    `uvm_component_utils(scoreboard)

    seq_item apb_ip;
    seq_item apb_op;
    seq_item ahb_ip;
    seq_item ahb_op;
    seq_item spi_ip;
    seq_item spi_op;

    seq_item ref_var;

    uvm_tlm_analysis_fifo#(seq_item) apb_ip_fifo;
    uvm_tlm_analysis_fifo#(seq_item) apb_op_fifo;
    uvm_tlm_analysis_fifo#(seq_item) ahb_ip_fifo;
    uvm_tlm_analysis_fifo#(seq_item) ahb_op_fifo;
    uvm_tlm_analysis_fifo#(seq_item) spi_ip_fifo;
    uvm_tlm_analysis_fifo#(seq_item) spi_op_fifo;

    int PASS,FAIL;

    int mem[int];

    int actual_control;
    int actual_opcode;
    int actual_address;
    int actual_mode;
    int actual_dummy;
    int actual_length;
    bit [7:0]actual_data;
    
    int apb_engine_count;
    int ahb_engine_count;

    bit apb_req_engine;
    bit ahb_req_engine;

    bit apb_has_engine;
    bit ahb_has_engine;

    int apb_opcode_count;
    int apb_address_count;
    int apb_mode_count;
    int apb_dummy_count;
    int apb_data_count;

    int apb_task_counter;

    bit [7:0]apb_data_transmit_fifo[$:255];
    bit [7:0]apb_data_receive_fifo[$:255];

    bit opcode_phase;
    bit address_phase;
    bit mode_phase;
    bit dummy_phase;
    bit data_phase;

    function new(string name="scoreboard",uvm_component parent=null);
        super.new(name,parent);
        ref_var = seq_item::type_id::create("ref_var");
    endfunction

    task run_phase(uvm_phase phase);
        forever
        begin
            apb_ip_fifo.get(apb_ip);
            apb_op_fifo.get(apb_op);

            ahb_ip_fifo.get(ahb_ip);
            ahb_op_fifo.get(ahb_op);

            spi_ip_fifo.try_get(spi_ip);
            spi_op_fifo.try_get(spi_op);

            ref_task();
            apb_variable_clear();
            checkk();
        end
    endtask    

    task ref_task();
        if(ref_var.PSLVERR==1)
        begin
            ref_var.PSLVERR=0;
        end
        if(apb_ip.PSEL==1 && apb_ip.PENABLE==1 && apb_op.PREADY==1)
        begin
            if(apb_ip.PWRITE==0)
            begin
                case(apb_ip.PADDR)
                    //////////control
                    32'd4:
                        ref_var.PRDATA=actual_control;
                    /////////opcode
                    32'd8:
                        ref_var.PRDATA=actual_opcode;
                    ///////address
                    32'd12: 
                        ref_var.PRDATA=actual_address;
                    ///////mode
                    32'd16: 
                        ref_var.PRDATA=actual_mode;
                    ///////dummy
                    32'd20: 
                        ref_var.PRDATA=actual_dummy;
                    ///////length
                    32'd24: 
                        ref_var.PRDATA=actual_length;
                    ///////data
                    32'd28: 
                        if(apb_data_receive_fifo.size()>0)
                        begin
                            ref_var.PRDATA[7:0]=apb_data_receive_fifo.pop_front();
                        end
                        else 
                        begin
                            $display("APB PATH TRYING TO READ FROM EMPTY QUEUE NOW DUT IN DEADLOCK");    
                        end
                endcase
            end
        end
        if(apb_ip.PSEL==1 && apb_ip.PENABLE==1 && apb_op.PREADY==1)
        begin
            if(apb_ip.PWRITE==1)
            begin
                case(apb_ip.PADDR)
                    //////////control
                    32'd4:
                    begin
                        if(apb_ip.PSTRB==4'b0111)
                            actual_control = ((apb_ip.PWDATA)&(apb_ip.PSTRB));
                        else
                            ref_var.PSLVERR=1;
                    end
                    /////////opcode
                    32'd8:
                    begin
                        if(apb_ip.PSTRB==4'b0101)
                            actual_opcode = ((apb_ip.PWDATA)&(apb_ip.PSTRB));
                        else
                            ref_var.PSLVERR=1;
                    end
                    ///////address
                    32'd12: 
                    begin
                        if(apb_ip.PSTRB==4'b1111)
                            actual_address = ((apb_ip.PWDATA)&(apb_ip.PSTRB));
                        else
                            ref_var.PSLVERR=1;
                    end
                    ///////mode
                    32'd16: 
                    begin
                        if(apb_ip.PSTRB==4'b0001)
                            actual_mode = ((apb_ip.PWDATA)&(apb_ip.PSTRB));
                        else
                            ref_var.PSLVERR=1;
                    end
                    ///////dummy
                    32'd20: 
                    begin
                        if(apb_ip.PSTRB==4'b0001)
                            actual_dummy = ((apb_ip.PWDATA)&(apb_ip.PSTRB));
                        else
                            ref_var.PSLVERR=1;
                    end
                    ///////length
                    32'd24: 
                    begin
                        if(apb_ip.PSTRB==4'b0001)
                            actual_length = ((apb_ip.PWDATA)&(apb_ip.PSTRB));
                        else
                            ref_var.PSLVERR=1;
                    end
                    ///////data
                    32'd28: 
                    begin
                        // actual_data = ((apb_ip.PWDATA)&(apb_ip.PSTRB));
                        if(apb_ip.PSTRB==4'b1111)
                        begin
                            if(apb_data_transmit_fifo.size()<253)
                            begin
                                apb_data_transmit_fifo.push_back(apb_ip.PWDATA[7:0]);
                                apb_data_transmit_fifo.push_back(apb_ip.PWDATA[15:8]);
                                apb_data_transmit_fifo.push_back(apb_ip.PWDATA[23:16]);
                                apb_data_transmit_fifo.push_back(apb_ip.PWDATA[31:24]);
                            end
                        end
                        else if(apb_ip.PSTRB==4'b0111)
                        begin
                            if(apb_data_transmit_fifo.size()<254)
                            begin
                                apb_data_transmit_fifo.push_back(apb_ip.PWDATA[7:0]);
                                apb_data_transmit_fifo.push_back(apb_ip.PWDATA[15:8]);
                                apb_data_transmit_fifo.push_back(apb_ip.PWDATA[23:16]);
                                // apb_data_transmit_fifo.push_back(PWDATA[31:24]);
                            end
                        end
                        else if(apb_ip.PSTRB==4'b0011)
                        begin
                            if(apb_data_transmit_fifo.size()<255)
                            begin
                                apb_data_transmit_fifo.push_back(apb_ip.PWDATA[7:0]);
                                apb_data_transmit_fifo.push_back(apb_ip.PWDATA[15:8]);
                                // apb_data_transmit_fifo.push_back(PWDATA[23:16]);
                                // apb_data_transmit_fifo.push_back(PWDATA[31:24]);
                            end
                        end
                        else if(apb_ip.PSTRB==4'b0001)
                        begin
                            if(apb_data_transmit_fifo.size()<256)
                            begin
                                apb_data_transmit_fifo.push_back(apb_ip.PWDATA[7:0]);
                                // apb_data_transmit_fifo.push_back(PWDATA[15:8]);
                                // apb_data_transmit_fifo.push_back(PWDATA[23:16]);
                                // apb_data_transmit_fifo.push_back(PWDATA[31:24]);
                            end
                        end
                        else
                            ref_var.PSLVERR=1;
                    end
                endcase
            end
        end

        if(apb_ip.PSEL==1 && apb_ip.PENABLE==1)
        begin
            if(apb_ip.PWRITE==1)
            begin
                if(apb_ip.PADDR==4 && apb_ip.PWDATA[0]==1)
                begin
                    actual_control = ((apb_ip.PWDATA)&(apb_ip.PSTRB));
                end
            end
        end

        if(actual_control[0]==1)
        begin
            apb_engine_count++;
        end

        if(apb_engine_count==10)
        begin
            apb_req_engine=1;
            apb_engine_count=0;
        end

        if(apb_req_engine==1 && ahb_has_engine==0)
        begin
            apb_req_engine=0;
            apb_has_engine=1;
        end

        if(apb_has_engine==1)
        begin
            if((actual_control[1]==0) || ((actual_control[5]==1) && (actual_control[6]==1)))
            begin
                ref_var.PSLVERR = 1;
            end
            
            else 
            begin
                if(spi_op.spi_cs_n==0)
                begin
                    ///////////////////////opcode
                    if(actual_control[1]==1)
                    begin
                        if(actual_control[8:7]==2'b00)
                        begin
                            apb_opcode_count=8;
                        end
                        else if(actual_control[8:7]==2'b01)
                        begin
                            apb_opcode_count=4;
                        end
                        else if(actual_control[8:7]==2'b10)
                        begin
                            apb_opcode_count=2;
                        end
                        else 
                        begin
                            ref_var.PSLVERR = 1;
                            ////////have to add all clear condition
                        end
                    end
                    else 
                    begin
                        ref_var.PSLVERR=1;    
                    end
                    //////////////////////address
                    if(actual_control[2]==1)
                    begin
                        if(actual_control[16]==1)
                        begin
                            if(actual_control[10:9]==2'b00)
                            begin
                                apb_address_count=32;
                            end
                            else if(actual_control[10:9]==2'b01)
                            begin
                                apb_address_count=16;
                            end
                            else if(actual_control[10:9]==2'b10)
                            begin
                                apb_address_count=8;
                            end
                            else 
                            begin
                                ref_var.PSLVERR = 1;
                                ////////have to add all clear condition
                            end
                        end
                        else
                        begin
                            if(actual_control[10:9]==2'b00)
                            begin
                                apb_address_count=24;
                            end
                            else if(actual_control[10:9]==2'b01)
                            begin
                                apb_address_count=12;
                            end
                            else if(actual_control[10:9]==2'b10)
                            begin
                                apb_address_count=6;
                            end
                            else 
                            begin
                                ref_var.PSLVERR = 1;
                                ////////have to add all clear condition
                            end
                        end
                    end
                    ////////////////////////mode
                    if(actual_control[3]==1)
                    begin
                        if(actual_control[15:14]==2'b00)
                        begin
                            apb_mode_count=8;
                        end
                        else if(actual_control[15:14]==2'b01)
                        begin
                            apb_mode_count=4;
                        end
                        else if(actual_control[15:14]==2'b10)
                        begin
                            apb_mode_count=2;
                        end
                        else 
                        begin
                            ref_var.PSLVERR = 1;
                            ////////have to add all clear condition
                        end
                    end
                    ////////////////////////dummy
                    if(actual_control[4]==1)
                    begin
                        apb_dummy_count=actual_dummy;
                    end
                    ////////////////////////data 
                    if((actual_control[5])|(actual_control[6]))
                    begin
                        if(actual_control[12:11]==2'b00)
                        begin
                            apb_data_count=(actual_length*8);
                        end
                        else if(actual_control[12:11]==2'b01)
                        begin
                            apb_data_count=(actual_length*4);
                        end
                        else if(actual_control[12:11]==2'b10)
                        begin
                            apb_data_count=(actual_length*2);
                        end
                        else 
                        begin
                            ref_var.PSLVERR = 1;
                            ////////have to add all clear condition
                        end
                    end
                end   
            end
            /////////////opcode driving into ref_var pins
            if(opcode_phase==0)
            begin
                if(actual_control[1]==1)
                begin
                    if(actual_control[8:7]==2'b00)
                    begin
                        ref_var.Io = {actual_opcode[apb_task_counter],3'bzzz};
                    end
                    else if(actual_control[8:7]==2'b01)
                    begin
                        ref_var.Io = {actual_opcode[2*apb_task_counter],actual_opcode[(2*apb_task_counter)+1],2'bzz};
                    end
                    else if(actual_control[8:7]==2'b10)
                    begin
                        ref_var.Io = {actual_opcode[4*apb_task_counter],actual_opcode[(4*apb_task_counter)+1],actual_opcode[(4*apb_task_counter)+2],actual_opcode[(4*apb_task_counter)+3]};
                    end
                    if(apb_task_counter==(apb_opcode_count-1))
                    begin
                        opcode_phase = 1;
                        apb_task_counter = 0;
                    end
                    apb_task_counter++;
                end
            end
            /////////////address driving into ref_var pins
            if(opcode_phase==1 && address_phase==0)
            begin
                if(actual_control[2]==1)
                begin
                    if(actual_control[10:9]==2'b00)
                    begin
                        ref_var.Io = {actual_address[apb_task_counter],3'bzzz};
                    end 
                    else if(actual_control[10:9]==2'b01)
                    begin
                        ref_var.Io = {actual_address[2*apb_task_counter],actual_address[(2*apb_task_counter)+1],2'bzz};
                    end 
                    else if(actual_control[10:9]==2'b10) 
                    begin
                        ref_var.Io = {actual_address[4*apb_task_counter],actual_address[(4*apb_task_counter)+1],actual_address[(4*apb_task_counter)+2],actual_address[(4*apb_task_counter)+3]};
                    end    
                    if(apb_task_counter==(apb_address_count-1))
                    begin
                        address_phase = 1;
                        apb_task_counter=0;
                    end
                    apb_task_counter++;                  
                end
            end
            /////////////mode driving into ref_var pins
            if(opcode_phase==1 && address_phase==1 && mode_phase==0)
            begin
                if(actual_control[3]==1)
                begin
                    if(actual_control[15:14]==2'b00)
                    begin
                        ref_var.Io = {actual_mode[apb_task_counter],3'bzzz};
                    end 
                    else if(actual_control[15:14]==2'b01)
                    begin
                        ref_var.Io = {actual_mode[2*apb_task_counter],actual_mode[(2*apb_task_counter)+1],2'bzz};
                    end 
                    else if(actual_control[15:14]==2'b10) 
                    begin
                        ref_var.Io = {actual_mode[4*apb_task_counter],actual_mode[(4*apb_task_counter)+1],actual_mode[(4*apb_task_counter)+2],actual_mode[(4*apb_task_counter)+3]};
                    end    
                    if(apb_task_counter==(apb_mode_count-1))
                    begin
                        mode_phase=1;
                        apb_task_counter=0;
                    end
                    apb_task_counter++;                  
                end
            end
            /////////////dummy wait
            if(opcode_phase==1 && address_phase==1 && mode_phase==1 && dummy_phase==0)
            begin
                if(actual_control[4]==1)
                begin
                    if(apb_task_counter==(apb_dummy_count-1))
                    begin
                        dummy_phase=1;
                        apb_task_counter=0;
                    end
                    apb_task_counter++;   
                end
            end
            /////////////data driving into ref_var pins
            if(opcode_phase==1 && address_phase==1 && mode_phase==1 && dummy_phase==1 && data_phase==0)
            begin
                if(actual_control[5]==1 && actual_control[6]==0)
                begin
                    if(actual_control[12:11]==2'b00)
                    begin
                        if(apb_task_counter%8==0)
                        begin
                            if(apb_data_transmit_fifo.size()>0)
                            begin
                                actual_data = apb_data_transmit_fifo.pop_front();
                            end
                            else 
                            begin
                                $display("apb data FIFO is empty still trying to read");
                                actual_data = 0;    
                            end
                        end
                        ref_var.Io = {actual_data[apb_task_counter%8],3'bzzz};
                    end 
                    else if(actual_control[12:11]==2'b01)
                    begin
                        if(apb_task_counter%4==0)
                        begin
                            if(apb_data_transmit_fifo.size()>0)
                            begin
                                actual_data = apb_data_transmit_fifo.pop_front();
                            end
                            else 
                            begin
                                $display("apb data FIFO is empty still trying to read");
                                actual_data = 0;    
                            end
                        end
                        ref_var.Io = {actual_data[2*(apb_task_counter%4)],actual_data[(2*(apb_task_counter%4))+1],2'bzz};
                    end 
                    else if(actual_control[12:11]==2'b10)
                    begin
                        if(apb_task_counter%2==0)
                        begin
                            if(apb_data_transmit_fifo.size()>0)
                            begin
                                actual_data = apb_data_transmit_fifo.pop_front();
                            end
                            else 
                            begin
                                $display("apb data FIFO is empty still trying to read");
                                actual_data = 0;    
                            end
                        end
                        ref_var.Io = {actual_data[4*(apb_task_counter%2)],actual_data[(4*(apb_task_counter%2))+1],actual_data[(4*(apb_task_counter%2))+2],actual_data[(4*(apb_task_counter%2))+3]};
                    end
                    if(apb_task_counter==(apb_data_count-1))
                    begin
                        data_phase=1;
                        apb_task_counter=0;
                    end
                    apb_task_counter++;      
                end
                else if(actual_control[5]==0 && actual_control[6]==1)
                begin
                    ref_var.Io=spi_ip.Io;
                    if(actual_control[12:11]==2'b00)
                    begin
                        actual_data[7-(apb_task_counter%8)]=spi_ip.Io[0];
                        if(apb_task_counter%8==7)
                        begin
                            if(apb_data_receive_fifo.size()<256)
                                apb_data_receive_fifo.push_back(actual_data);
                        end
                    end
                    if(actual_control[12:11]==2'b01)
                    begin
                        actual_data[7-(2*(apb_task_counter%4))]=spi_ip.Io[0];
                        actual_data[7-((2*(apb_task_counter%4))+1)]=spi_ip.Io[1];
                        if(apb_task_counter%4==3)
                        begin
                            if(apb_data_receive_fifo.size()<256)
                                apb_data_receive_fifo.push_back(actual_data);
                        end
                    end
                    if(actual_control[12:11]==2'b10)
                    begin
                        actual_data[7-(2*(apb_task_counter%2))]=spi_ip.Io[0];
                        actual_data[7-((2*(apb_task_counter%2))+1)]=spi_ip.Io[1];
                        actual_data[7-((2*(apb_task_counter%2))+2)]=spi_ip.Io[2];
                        actual_data[7-((2*(apb_task_counter%2))+3)]=spi_ip.Io[3];
                        if(apb_task_counter%2==1)
                        begin
                            if(apb_data_receive_fifo.size()<256)
                                apb_data_receive_fifo.push_back(actual_data);
                        end
                    end
                    if(apb_task_counter==(apb_data_count-1))
                    begin
                        apb_has_engine=0;
                        data_phase=1;
                        apb_task_counter=0;
                        apb_opcode_count=0;
                        apb_address_count=0;
                        apb_mode_count=0;
                        apb_dummy_count=0;
                        apb_data_count=0;
                    end
                    apb_task_counter++;
                end
            end
        end

    endtask

    task apb_variable_clear();
        if(data_phase==1)
        begin
            data_phase=0;
        end
    endtask

    task checkk();
if((ref_var.PRDATA==apb_op.PRDATA) && (ref_var.PSLVERR==apb_op.PSLVERR) && (ref_var.Io==spi_ip.Io))
        begin
            PASS++;
            $display("%0d: PASS",PASS);
        end
        else 
        begin
            FAIL++;
            $display("%0d: FAIL",FAIL);
        end
    endtask

endclass

