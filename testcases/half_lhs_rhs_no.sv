class half_lhs_rhs_no extends uart_base_test;
	`uvm_component_utils(half_lhs_rhs_no)
	
	uart_sequence lhs_seq;
	uart_sequence rhs_seq;
	uart_configuration cfg_tmp;

	
	function new(string name = "half_lhs_rhs_no", uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

				cfg_tmp = uart_configuration::type_id::create("cfg_tmp",this);
		assert(cfg_tmp.randomize() with {use_parity == 0;});
    // Config LHS
		cfg_tmp.mode = uart_configuration::TX;
    set_lhs_mode(cfg_tmp.mode);
		set_lhs_baudrate(cfg_tmp.baudrate);
    set_lhs_data_bits(cfg_tmp.data_bits);
    set_lhs_stop_bits(cfg_tmp.stop_bits);
    set_lhs_use_parity(cfg_tmp.use_parity);
    set_lhs_parity_even(cfg_tmp.parity_even); 
		`uvm_info(get_type_name(),$sformatf("Configuration LHS : \n%s",cfg_tmp.sprint()),UVM_LOW)	

    // Config RHS
		cfg_tmp.mode = uart_configuration::RX;
    set_rhs_mode(cfg_tmp.mode);
    set_rhs_baudrate(cfg_tmp.baudrate);
    set_rhs_data_bits(cfg_tmp.data_bits);
    set_rhs_stop_bits(cfg_tmp.stop_bits);
    set_rhs_use_parity(cfg_tmp.use_parity);
    set_rhs_parity_even(cfg_tmp.parity_even); 
		
		`uvm_info(get_type_name(),$sformatf("Configuration RHS: \n%s",cfg_tmp.sprint()),UVM_LOW)	
  endfunction	

	

	virtual task run_phase(uvm_phase phase); 
		phase.raise_objection(this);

		
		lhs_seq = uart_sequence::type_id::create("lhs_seq");
		//rhs_seq = uart_sequence::type_id::create("rhs_seq");
		
		fork
			lhs_seq.start(uart_env.uart_lhs_agent.sequencer);
			//rhs_seq.start(uart_env.uart_rhs_agent.sequencer);
		join
		
		phase.drop_objection(this);
	endtask

endclass
