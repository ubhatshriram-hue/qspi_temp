class virtual_sequencer extends uvm_sequencer;
	`uvm_component_utils(virtual_sequencer)
	apb_sequencer seqr_apb;
	ahb_sequencer seqr_ahb;
	qspi_sequencer seqr_qspi_io;
	function new(string name="virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction
endclass
