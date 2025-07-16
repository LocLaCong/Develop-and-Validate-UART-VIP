//=============================================================================
// Project       : UART VIP
//=============================================================================
// Filename      : test_pkg.sv
// Author        : La Cong Loc
// Company       : NO
// Date          : 30-June-2025
//=============================================================================
// Description   : 
//
//
//
//=============================================================================
`ifndef GUARD_UART_TEST_PKG__SV
`define GUARD_UART_TEST_PKG__SV

package test_pkg;
  import uvm_pkg::*;
  import uart_pkg::*;
  import seq_pkg::*;
  import env_pkg::*;

  // Include your file
	`include "uart_base_test.sv"

	//------------HALF_DUPLEX_LHS_RHS_TEST-------------//

	//DATA_BITS_TEST

	`include "half_lhs_rhs_5_data_bits.sv"
	`include "half_lhs_rhs_6_data_bits.sv"
	`include "half_lhs_rhs_7_data_bits.sv"
	`include "half_lhs_rhs_8_data_bits.sv"
	`include "half_lhs_rhs_9_data_bits.sv" 

	//BAUDRATE_TEST
	`include "half_lhs_rhs_4800.sv"
	`include "half_lhs_rhs_9600.sv"
	`include "half_lhs_rhs_19200.sv"
	`include "half_lhs_rhs_57600.sv"
	`include "half_lhs_rhs_115200.sv"
	`include "half_lhs_rhs_custom_128000.sv"

	//PARITY_TEST
	`include "half_lhs_rhs_no.sv"
	`include "half_lhs_rhs_even.sv"
	`include "half_lhs_rhs_odd.sv"

	//STOP_BITS_TEST
	`include "half_lhs_rhs_1_stop_bits.sv"
	`include "half_lhs_rhs_2_stop_bits.sv"	

	
	//------------HALF_DUPLEX_RHS_LHS_TEST------------// 

	//DATA_BITS_TEST

	`include "half_rhs_lhs_5_data_bits.sv"
	`include "half_rhs_lhs_6_data_bits.sv"
	`include "half_rhs_lhs_7_data_bits.sv"
	`include "half_rhs_lhs_8_data_bits.sv"
	`include "half_rhs_lhs_9_data_bits.sv"

	//BAUDRATE_TEST
	`include "half_rhs_lhs_4800.sv"
	`include "half_rhs_lhs_9600.sv"
	`include "half_rhs_lhs_19200.sv"
	`include "half_rhs_lhs_57600.sv"
	`include "half_rhs_lhs_115200.sv"
	`include "half_rhs_lhs_custom_128000.sv"

	//PARITY_TEST
	`include "half_rhs_lhs_no.sv"
	`include "half_rhs_lhs_even.sv"
	`include "half_rhs_lhs_odd.sv"

	//STOP_BITS_TEST
	`include "half_rhs_lhs_1_stop_bits.sv"
	`include "half_rhs_lhs_2_stop_bits.sv"


	//---------------FULL_DUPLEX_TEST----------------//

	//DATA_BITS_TEST

	`include "full_5_data_bits.sv"
	`include "full_6_data_bits.sv"
	`include "full_7_data_bits.sv"
	`include "full_8_data_bits.sv"
	`include "full_9_data_bits.sv"

	//BAUDRATE_TEST
	`include "full_4800.sv"
	`include "full_9600.sv"
	`include "full_19200.sv"
	`include "full_57600.sv"
	`include "full_115200.sv"
	`include "full_custom_128000.sv"

	//PARITY_TEST
	`include "full_no.sv"
	`include "full_even.sv"
	`include "full_odd.sv"

	//STOP_BITS_TEST
	`include "full_1_stop_bits.sv"
	`include "full_2_stop_bits.sv"



	//---------------INJECT_ERROR_TEST----------------//

	`include "data_bits_mismatch.sv"
	`include "baudrate_mismatch.sv"
	`include "parity_mismatch.sv"
	`include "stop_bits_mismatch.sv"


endpackage: test_pkg

`endif


