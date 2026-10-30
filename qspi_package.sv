`include "uvm_macros.svh"
`include "define.sv"

package qspi_pkg;
import uvm_pkg::*;

`include "qspi_seq_item.sv"

`include "qspi_sequence.sv"
`include "apb_sequencer.sv"
`include "ahb_sequencer.sv"
`include "qspi_sequencer.sv"

`include "qspi_virtual_sequencer.sv"

`include "qspi_virtual_sequence.sv"

//`include "qspi_virtual_sequencer.sv"
//`include "qspi_sequencer.sv"
//`include "apb_sequencer.sv"
//`include "ahb_sequencer.sv"

`include "qspi_config.sv"

`include "qspi_driver.sv"
`include "apb_driver.sv"
`include "ahb_driver.sv"

`include "qspi_input_monitor.sv"
`include "apb_input_monitor.sv"
`include "ahb_input_monitor.sv"
`include "qspi_output_monitor.sv"
`include "apb_output_monitor.sv"
`include "ahb_output_monitor.sv"

//`include "qspi_subscriber.sv"
`include "qspi_agent.sv"
`include "ahb_agent.sv"
`include "apb_agent.sv"

`include "qspi_scoreboard.sv"
`include "qspi_env.sv"
`include "qspi_test.sv"

endpackage
