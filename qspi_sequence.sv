class apb_CONTROL_FILL_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(apb_CONTROL_FILL_sequence)

    function new(string name="apb_CONTROL_FILL_sequence");
        super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
        req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with
        {
            PWRITE==1;
            PADDR==4;
            PSTRB==4'b0111;
            //need to configure PWDATA here for different scenario 
            PWDATA==32'h0000B53E;
        };
        finish_item(req);
    endtask

endclass

class apb_CONTROL_START_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(apb_CONTROL_START_sequence)

    function new(string name="apb_CONTROL_START_sequence");
        super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
        req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with
        {
            PWRITE==1;
            PADDR==4;
            PSTRB==4'b0111;
            //need to configure PWDATA here for different scenario 
            PWDATA==32'h0000_B53F;
        };
        finish_item(req);
    endtask

endclass

class apb_OPCODE_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(apb_OPCODE_sequence)

    function new(string name="apb_OPCODE_sequence");
        super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
        req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with
        {
            PWRITE==1;
            PADDR==8;
            PSTRB==4'b0001;
            //need to configure PWDATA here for different scenario 
            //PWDATA is randomized as we are not bothered with the value opcode will consist.we will just randomize 	   //and send it. 
        };
        finish_item(req);
    endtask

endclass

class apb_ADDRESS_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(apb_ADDRESS_sequence)

    function new(string name="apb_ADDRESS_sequence");
        super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
        req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with
        {
            PWRITE==1;
            PADDR==12;
            PSTRB==4'b1111;
            //need to configure PWDATA here for different scenario 
            //PWDATA is randomized as we are not bothered with the value address will consist.we will just randomize 	   //and send it.
        };
        finish_item(req);
    endtask

endclass

class apb_MODE_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(apb_MODE_sequence)

    function new(string name="apb_MODE_sequence");
        super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
        req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with
        {
            PWRITE==1;
            PADDR==16;
            PSTRB==4'b0001;
            //need to configure PWDATA here for different scenario 
            //PWDATA is randomized as we are not bothered with the value mode will consist.we will just randomize 	   //and send it.
        };
        finish_item(req);
    endtask

endclass

class apb_DUMMY_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(apb_DUMMY_sequence)

    function new(string name="apb_DUMMY_sequence");
        super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
        req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with
        {
            PWRITE==1;
            PADDR==20;
            PSTRB==4'b0001;
            //need to configure PWDATA here for different scenario 
            //PWDATA is randomized as we are not bothered with the value dummy will consist.we will just randomize 	   //and send it.
        };
        finish_item(req);
    endtask

endclass

class apb_LENGTH_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(apb_LENGTH_sequence)

    function new(string name="apb_LENGTH_sequence");
        super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
        req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with
        {
            PWRITE==1;
            PADDR==24;
            PSTRB==4'b0001;
            //need to configure PWDATA here for different scenario 
            PWDATA==4;//consider the length as 4 bytes for now(32 bits) which we are sending.
        };
        finish_item(req);
    endtask

endclass

class apb_DATA_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(apb_DATA_sequence)

    function new(string name="apb_DATA_sequence");
        super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
        req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with
        {
            PWRITE==1;
            PADDR==28;
            PSTRB==4'b1111;
            //need to configure PWDATA here for different scenario 
            PWDATA==32'hABCD_ABCD;
        };
        finish_item(req);
    endtask

endclass

class apb_opcode_disabled_sequence extends uvm_sequence#(seq_item);
`uvm_object_utils(apb_opcode_disabled_sequence)
function new(string name="apb_opcode_disabled_sequence");
super.new(name);
endfunction
task body();
	req=seq_item::type_id::create("req");
	start_item(req);
	req.randomize(PWRITE,PADDR,PWDATA,PSTRB)with{
		PWRITE==1'b1;
		PADDR==8'h04;
		PSTRB==4'b0111;
		PWDATA==32'h0000_B53D;
	};
	finish_item(req);
endtask
endclass

class apb_both_data_requests_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(apb_both_data_requests_sequence)
function new(string name="apb_both_data_requests_sequence");
super.new(name);
endfunction
task body();
	req=seq_item::type_id::create("req");
	start_item(req);
	req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with {
		PWRITE==1'b1;
		PADDR==8'h04;
		PSTRB==4'b0111;
		PWDATA==32'h0000_B57F;
	};
	finish_item(req);
endtask
endclass

class apb_invalid_address_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(apb_invalid_address_sequence)
function new(string name="apb_invalid_address_sequence");
super.new(name);
endfunction
task body();
	req=seq_item::type_id::create("req");
	start_item(req);
	req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with{
		PWRITE==1'b1;
		PADDR==8'h20;
		PSTRB==4'b0001;
		PWDATA==32'h0000_005A;
	};
	finish_item(req);
endtask
endclass

class apb_invalid_strobe_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(apb_invalid_strobe_sequence)
function new(string name="apb_invalid_strobe_sequence");
super.new(name);
endfunction
task body();
	req=seq_item::type_id::create("req");
	start_item(req);
	req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with{
		PWRITE==1'b1;
		PADDR==8'h04;
		PSTRB==4'b1111;
		PWDATA==32'h0000_B53E;
	};
	finish_item(req);
endtask
endclass

class apb_3byte_address_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(apb_3byte_address_sequence)
function new(string name="apb_3byte_address_sequence");
super.new(name);
endfunction
task body();
	req=seq_item::type_id::create("req");
	start_item(req);
	req.randomize(PWRITE,PADDR,PWDATA,PSTRB)with{
		PWRITE==1'b1;
		PADDR==8'h04;
		PSTRB==4'b0111;
		PWDATA==32'h0000_B53F;
	};
	finish_item(req);
endtask
endclass

class apb_4byte_address_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(apb_4byte_address_sequence)
function new(string name="apb_4byte_address_sequence");
super.new(name);
endfunction
task body();
	req=seq_item::type_id::create("req");
	start_item(req);
	req.randomize(PWRITE,PADDR,PWDATA,PSTRB)with{
		PWRITE==1'b1;
		PADDR==8'h04;
		PSTRB==4'b0111;
		PWDATA==32'h0001_B53F;
	};
	finish_item(req);
endtask
endclass

class apb_single_line_data_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(apb_single_line_data_sequence)
function new(string name="apb_single_line_data_sequence");
super.new(name);
endfunction
task body();
	req=seq_item::type_id::create("req");
	start_item(req);
	req.randomize(PWRITE,PADDR,PWDATA,PSTRB)with{
		PWRITE==1'b1;
		PADDR==8'h04;
		PSTRB==4'b0111;
		PWDATA==32'h0000_A53F;//only data line width change
	};
	finish_item(req);
endtask
endclass

class apb_dual_line_data_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(apb_dual_line_data_sequence)
function new(string name="apb_dual_line_data_sequence");
super.new(name);
endfunction
task body();
	req=seq_item::type_id::create("req");
	start_item(req);
	req.randomize(PWRITE,PADDR,PWDATA,PSTRB)with{
		PWRITE==1'b1;
		PADDR==8'h04;
		PSTRB==4'b0111;
		PWDATA==32'h0000_AD3F;
	};
	finish_item(req);
endtask
endclass

class apb_quad_line_data_sequence extends uvm_sequence#(seq_item);
	`uvm_object_utils(apb_quad_line_data_sequence)
function new(string name="apb_quad_line_data_sequence");
super.new(name);
endfunction
task body();
	req=seq_item::type_id::create("req");
	start_item(req);
	req.randomize(PWRITE,PADDR,PWDATA,PSTRB)with{
		PWRITE==1'b1;
		PADDR==8'h04;
		PSTRB==4'b0111;
		PWDATA==32'h0000_B53F;
	};
	finish_item(req);
endtask
endclass




//===============
//APB READ
//===========

class apb_CONTROL_READ_sequence extends uvm_sequence #(seq_item);

    `uvm_object_utils(apb_CONTROL_READ_sequence)

    function new(string name="apb_CONTROL_READ_sequence");
        super.new(name);
    endfunction

    task body();

        req = seq_item::type_id::create("req");

        start_item(req);

        req.randomize(PWRITE,PADDR,PWDATA,PSTRB) with
        {
            PWRITE == 0;
            PADDR  == 4;
            PSTRB  == 4'b0000;
            PWDATA == 0;
        };

        finish_item(req);

    endtask

endclass





///////////////////////AHB==============///////////

///////////////////////////////////////////////////////////////////////////////AHB//////////////////////////////////////////////////////////////
class ahb_sucess_read_sequence extends uvm_sequence#(seq_item);

    `uvm_object_utils(ahb_sucess_read_sequence)

    function new(string name="ahb_sucess_read_sequence");
        super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
        req.randomize() with
        {
            HSEL == 1;
            HTRANS inside {2'b10,2'b11};
            HADDR inside {[32'h8000_0000:32'h807F_FFFF]};
            HWRITE == 0;
            HSIZE == 3'b010;
            xip_en == 1;
            HBURST == 3'b000;
        };
        finish_item(req);
    endtask

endclass


///==============AHB====================


class ahb_sucess_read_sequence_with_fix_address_0 extends uvm_sequence#(seq_item);

    `uvm_object_utils(ahb_sucess_read_sequence_with_fix_address_0)

  function new(string name="ahb_sucess_read_sequence_with_fix_address_0");
    super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
      if(!req.randomize() with
        {
            HSEL == 1;
            HTRANS inside {2'b10,2'b11};
            HADDR == 32'h8000_0000;
            HWRITE == 0;
            HSIZE == 3'b010;
            xip_en == 1;
            HBURST == 3'b000;
        })
        `uvm_error("SEQ", "Randomization fail")
        finish_item(req);
    endtask

endclass


class ahb_sucess_read_sequence_with_fix_address_1 extends uvm_sequence#(seq_item);

    `uvm_object_utils(ahb_sucess_read_sequence_with_fix_address_1)

  function new(string name="ahb_sucess_read_sequence_with_fix_address_1");
    super.new(name);
    endfunction 

    task body();
        req = seq_item::type_id::create("req");
        start_item(req);
      if(!req.randomize() with
        {
            HSEL == 1;
            HTRANS inside {2'b10,2'b11};
            HADDR == 32'hFF80_0000;
            HWRITE == 0;
            HSIZE == 3'b010;
            xip_en == 1;
            HBURST == 3'b000;
        })
        `uvm_error("SEQ", "Randomization fail")
        finish_item(req);
    endtask

endclass


//===3===
// AHB3 cache_hit: two reads
class ahb_cache_hit_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(ahb_cache_hit_sequence)

  function new(string name = "ahb_cache_hit_sequence");
    super.new(name);
  endfunction

  task body();
    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with { HSEL == 1; 
                               	HTRANS == 2'b10; 
                                HADDR == 32'h8000_0000; 
                                HWRITE == 0;
                                HSIZE == 3'b010; 
                               	xip_en == 1; 
                               	HBURST == 3'b000; })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);

    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with { HSEL == 1; 	
                               	HTRANS == 2'b10; 
                               	HADDR == 32'h8000_0004; 
                               	HWRITE == 0;
                                HSIZE == 3'b010; 
                               	xip_en == 1; 
                               	HBURST == 3'b000; })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);
  endtask

endclass


//====4====
//Miss in Cache meomory

class ahb_cache_miss_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(ahb_cache_miss_sequence)

  function new(string name = "ahb_cache_miss_sequence");
    super.new(name);
  endfunction

  task body();
    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with 
        {
          HSEL == 1; 
          HTRANS == 2'b10; 
          HADDR == 32'h8000_0000; 
          HWRITE == 0;
          HSIZE == 3'b010; 
          xip_en == 1; 
          HBURST == 3'b000; 
        })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);

    
    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with 
        {
          HSEL == 1; 
          HTRANS == 2'b10; 
          HADDR == 32'h8000_0020; 
          HWRITE == 0;
          HSIZE == 3'b010;
          xip_en == 1;
          HBURST == 3'b000; 
        })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);
  endtask

endclass


//=====5=====
//Address Out of range
    
class ahb_address_out_of_range_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(ahb_address_out_of_range_sequence)

  function new(string name = "ahb_address_out_of_range_sequence");
    super.new(name);
  endfunction

  task body();
    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with 
        {
          HSEL == 1; 
          HTRANS == 2'b10; 
          HADDR == 32'h8080_0000; 
          HWRITE == 0;
          HSIZE == 3'b010;
          xip_en == 1;
          HBURST == 3'b000; 
        })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);
    
  endtask

endclass


//===6===
//AHB6 Last word of the XIP window

class ahb_last_word_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(ahb_last_word_sequence)

  function new(string name = "ahb_last_word_sequence");
    super.new(name);
  endfunction

  task body();
    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with
        {
          HSEL == 1;
          HTRANS == 2'b10;
          HADDR inside {[32'h807F_FFFC:32'h807F_FFFF]};
          HWRITE == 0;
          HSIZE == 3'b010;
          xip_en == 1;
          HBURST == 3'b000;
        })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);
  endtask

endclass


//======7======
//Trying read from XIP path should give error

class ahb_write_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(ahb_write_sequence)

  function new(string name = "ahb_write_sequence");
    super.new(name);
  endfunction

  task body();
    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with 
        {
          HSEL == 1; 
          HTRANS == 2'b10; 
          HADDR == 32'h8000_0000; 
          HWRITE == 1;   // Trying Write           
          HSIZE == 3'b010; 
          xip_en == 1; 
          HBURST == 3'b000; 
        })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);
  endtask

endclass


//=======8=======
//Invalid Size

class ahb_invalid_size_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(ahb_invalid_size_sequence)

  function new(string name = "ahb_invalid_size_sequence");
    super.new(name);
  endfunction

  task body();
    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with 
        {
          HSEL == 1; 
          HTRANS == 2'b10; 
          HADDR == 32'h8000_0000; 
          HWRITE == 0;
          HSIZE != 3'b010; 
          xip_en == 1; 
          HBURST == 3'b000; 
        })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);
    
  endtask

endclass


//=====9====
//Read with xip_en = 0
class ahb_xip_disabled_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(ahb_xip_disabled_sequence)

  function new(string name = "ahb_xip_disabled_sequence");
    super.new(name);
  endfunction

  task body();
    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with 
        {
          HSEL == 1; 
          HTRANS == 2'b10; 
          HADDR == 32'h8000_0000; 
          HWRITE == 0;
          HSIZE == 3'b010; 
          xip_en == 0;        // Cant read with disable xip_en 
          HBURST == 3'b000; 
        })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);
  endtask

endclass


//=====14====
//HTRANS = 2 (NONSEQ) and HTRANS = 3 (SEQ) same
//AHB-14 wala testcase

class ahb_htrans_sequence extends uvm_sequence#(seq_item);
  `uvm_object_utils(ahb_htrans_sequence)

  function new(string name = "ahb_htrans_sequence");
    super.new(name);
  endfunction

  task body();
    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with
        {
          HSEL == 1;
          HTRANS == 2'b10;    // NONSEQ
          HADDR == 32'h8000_0000;
          HWRITE == 0;
          HSIZE == 3'b010;
          xip_en == 1;
          HBURST == 3'b000;
        })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);

    req = seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with
        {
          HSEL == 1;
          HTRANS == 2'b11;    // SEQ
          HADDR == 32'h8000_0000;
          HWRITE == 0;
          HSIZE == 3'b010;
          xip_en == 1;
          HBURST == 3'b000;
        })
      `uvm_error("SEQ", "Randomization failed")
    finish_item(req);
  endtask

endclass
