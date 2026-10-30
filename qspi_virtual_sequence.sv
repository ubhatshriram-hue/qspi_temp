/*
class qspi_virtual_sequence extends uvm_sequence#(seq_item);
   apb_write_sequence aws;
   apb_read_sequence ars;
   ahb_read_Sequence ahrs;

  apb_sequencer seqr_apb;
   ahb_sequencer seqr_ahb;
 //qspi_sequencer seqr_qspi_io;
   `uvm_object_utils(qspi_virtual_sequence)
   `uvm_declare_p_sequencer(virtual_sequencer)

  function new(string name="qspi_virtual_sequence");
     super.new(name);
   endfunction

  task body();
     `uvm_info(get_type_name(),"qspi_virtual_sequence:Inside Body",UVM_LOW);
     aws=apb_write_sequence::type_id::create("aws");
     ars=apb_read_sequence::type_id::create("ars");
     ahrs=ahb_read_sequence::type_id::create("ahrs");

    aws.start(p_sequencer.seqr_apb);
     ars.start(p_sequencer.seqr_apb);
     ahrs.start(p_sequencer.seqr_ahb);
   endatsk
 endclass
*/










//////////////////////////////
/*
class qspi_virtual_sequence extends uvm_sequence #(seq_item);

  `uvm_object_utils(qspi_virtual_sequence)
  `uvm_declare_p_sequencer(virtual_sequencer)

  apb_CONTROL_FILL_sequence apb_control_fill;
  apb_CONTROL_START_sequence apb_control_start;
  apb_OPCODE_sequence apb_opcode;
  apb_ADDRESS_sequence apb_address;
  apb_MODE_sequence apb_mode;
  apb_DUMMY_sequence apb_dummy;
  apb_LENGTH_sequence apb_length;
  apb_DATA_sequence apb_data;
  apb_opcode_disabled_sequence apb_opcode_disabled;
  apb_both_data_requests_sequence apb_both_data;
  apb_invalid_address_sequence apb_invalid_address;
  apb_invalid_strobe_sequence apb_invalid_strobe;
  apb_3byte_address_sequence apb_3byte_address;
  apb_4byte_address_sequence apb_4byte_address;
  apb_single_line_data_sequence apb_single_line;
  apb_dual_line_data_sequence apb_dual_line;
  apb_quad_line_data_sequence apb_quad_line;

  ahb_sucess_read_sequence ahb_success_read;
  ahb_sucess_read_sequence_with_fix_address_0 ahb_fixed_addr_0;
  ahb_sucess_read_sequence_with_fix_address_1 ahb_fixed_addr_1;
  ahb_cache_hit_sequence ahb_cache_hit;
  ahb_cache_miss_sequence ahb_cache_miss;
  ahb_address_out_of_range_sequence ahb_out_of_range;
  ahb_last_word_sequence ahb_last_word;
  ahb_write_sequence ahb_write;
  ahb_invalid_size_sequence ahb_invalid_size;
  ahb_xip_disabled_sequence ahb_xip_disabled;
  ahb_htrans_sequence ahb_htrans;

  function new(string name = "qspi_virtual_sequence");
    super.new(name);
  endfunction

  task body();

    `uvm_info(get_type_name(), "Virtual sequence started", UVM_LOW)

    // APB sequences

    apb_control_fill = apb_CONTROL_FILL_sequence::type_id::create("apb_control_fill");
    apb_control_fill.start(p_sequencer.seqr_apb);

    apb_control_start = apb_CONTROL_START_sequence::type_id::create("apb_control_start");
    apb_control_start.start(p_sequencer.seqr_apb);

    apb_opcode = apb_OPCODE_sequence::type_id::create("apb_opcode");
    apb_opcode.start(p_sequencer.seqr_apb);

    apb_address = apb_ADDRESS_sequence::type_id::create("apb_address");
    apb_address.start(p_sequencer.seqr_apb);

    apb_mode = apb_MODE_sequence::type_id::create("apb_mode");
    apb_mode.start(p_sequencer.seqr_apb);

    apb_dummy = apb_DUMMY_sequence::type_id::create("apb_dummy");
    apb_dummy.start(p_sequencer.seqr_apb);

    apb_length = apb_LENGTH_sequence::type_id::create("apb_length");
    apb_length.start(p_sequencer.seqr_apb);

    apb_data = apb_DATA_sequence::type_id::create("apb_data");
    apb_data.start(p_sequencer.seqr_apb);

    apb_opcode_disabled = apb_opcode_disabled_sequence::type_id::create("apb_opcode_disabled");
    apb_opcode_disabled.start(p_sequencer.seqr_apb);

    apb_both_data = apb_both_data_requests_sequence::type_id::create("apb_both_data");
    apb_both_data.start(p_sequencer.seqr_apb);

    apb_invalid_address = apb_invalid_address_sequence::type_id::create("apb_invalid_address");
    apb_invalid_address.start(p_sequencer.seqr_apb);

    apb_invalid_strobe = apb_invalid_strobe_sequence::type_id::create("apb_invalid_strobe");
    apb_invalid_strobe.start(p_sequencer.seqr_apb);

    apb_3byte_address = apb_3byte_address_sequence::type_id::create("apb_3byte_address");
    apb_3byte_address.start(p_sequencer.seqr_apb);

    apb_4byte_address = apb_4byte_address_sequence::type_id::create("apb_4byte_address");
    apb_4byte_address.start(p_sequencer.seqr_apb);

    apb_single_line = apb_single_line_data_sequence::type_id::create("apb_single_line");
    apb_single_line.start(p_sequencer.seqr_apb);

    apb_dual_line = apb_dual_line_data_sequence::type_id::create("apb_dual_line");
    apb_dual_line.start(p_sequencer.seqr_apb);

    apb_quad_line = apb_quad_line_data_sequence::type_id::create("apb_quad_line");
    apb_quad_line.start(p_sequencer.seqr_apb);


    // AHB sequences

    ahb_success_read = ahb_sucess_read_sequence::type_id::create("ahb_success_read");
    ahb_success_read.start(p_sequencer.seqr_ahb);

    ahb_fixed_addr_0 = ahb_sucess_read_sequence_with_fix_address_0::type_id::create("ahb_fixed_addr_0");
    ahb_fixed_addr_0.start(p_sequencer.seqr_ahb);

    ahb_fixed_addr_1 = ahb_sucess_read_sequence_with_fix_address_1::type_id::create("ahb_fixed_addr_1");
    ahb_fixed_addr_1.start(p_sequencer.seqr_ahb);

    ahb_cache_hit = ahb_cache_hit_sequence::type_id::create("ahb_cache_hit");
    ahb_cache_hit.start(p_sequencer.seqr_ahb);

    ahb_cache_miss = ahb_cache_miss_sequence::type_id::create("ahb_cache_miss");
    ahb_cache_miss.start(p_sequencer.seqr_ahb);

    ahb_out_of_range = ahb_address_out_of_range_sequence::type_id::create("ahb_out_of_range");
    ahb_out_of_range.start(p_sequencer.seqr_ahb);

    ahb_last_word = ahb_last_word_sequence::type_id::create("ahb_last_word");
    ahb_last_word.start(p_sequencer.seqr_ahb);

    ahb_write = ahb_write_sequence::type_id::create("ahb_write");
    ahb_write.start(p_sequencer.seqr_ahb);

    ahb_invalid_size = ahb_invalid_size_sequence::type_id::create("ahb_invalid_size");
    ahb_invalid_size.start(p_sequencer.seqr_ahb);

    ahb_xip_disabled = ahb_xip_disabled_sequence::type_id::create("ahb_xip_disabled");
    ahb_xip_disabled.start(p_sequencer.seqr_ahb);

    ahb_htrans = ahb_htrans_sequence::type_id::create("ahb_htrans");
    ahb_htrans.start(p_sequencer.seqr_ahb);

    `uvm_info(get_type_name(), "Virtual sequence completed", UVM_LOW)

  endtask

endclass

*/

class qspi_virtual_sequence extends uvm_sequence #(seq_item);

    apb_CONTROL_FILL_sequence control_write;
    apb_CONTROL_READ_sequence control_read;

    `uvm_object_utils(qspi_virtual_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)

    function new(string name="qspi_virtual_sequence");
        super.new(name);
    endfunction

    task body();
        `uvm_info(get_type_name(),
                  "qspi_virtual_sequence: Inside Body",
                  UVM_LOW);

        control_write = apb_CONTROL_FILL_sequence::type_id::create("control_write");
        control_read = apb_CONTROL_READ_sequence::type_id::create("control_read");

        control_write.start(p_sequencer.seqr_apb);
        control_read.start(p_sequencer.seqr_apb);

    endtask

endclass
