class uart_base_test extends uvm_test;
	`uvm_component_utils(uart_base_test)
	
	virtual uart_if lhs_vif;
	virtual uart_if rhs_vif;

	uart_configuration lhs_cfg;
	uart_configuration rhs_cfg;
	
	uart_environment uart_env;

	uart_error_catcher err_catcher;
	
	function new(string name = "uart_base_test", uvm_component parent);
		super.new(name, parent);
	endfunction: new
	
// ===== Setter functions for lhs_cfg =====
  virtual function void set_lhs_mode(uart_configuration::uart_mode_enum mode);
    lhs_cfg.mode = mode;
  endfunction

  virtual function void set_lhs_baudrate(int baudrate);
    lhs_cfg.baudrate = baudrate;
  endfunction

  virtual function void set_lhs_data_bits(int data_bits);
    lhs_cfg.data_bits = data_bits;
  endfunction

  virtual function void set_lhs_stop_bits(int stop_bits);
    lhs_cfg.stop_bits = stop_bits;
  endfunction

  virtual function void set_lhs_use_parity(bit use_parity);
    lhs_cfg.use_parity = use_parity;
  endfunction

  virtual function void set_lhs_parity_even(bit parity_even);
    lhs_cfg.parity_even = parity_even;
  endfunction

  // ===== Setter functions for rhs_cfg =====
  virtual function void set_rhs_mode(uart_configuration::uart_mode_enum mode);
    rhs_cfg.mode = mode;
  endfunction

  virtual function void set_rhs_baudrate(int baudrate);
    rhs_cfg.baudrate = baudrate;
  endfunction

  virtual function void set_rhs_data_bits(int data_bits);
    rhs_cfg.data_bits = data_bits;
  endfunction

  virtual function void set_rhs_stop_bits(int stop_bits);
    rhs_cfg.stop_bits = stop_bits;
  endfunction

  virtual function void set_rhs_use_parity(bit use_parity);
    rhs_cfg.use_parity = use_parity;
  endfunction

  virtual function void set_rhs_parity_even(bit parity_even);
    rhs_cfg.parity_even = parity_even;
  endfunction


	virtual function void build_phase (uvm_phase phase); 
		super.build_phase(phase);
	`uvm_info("build_phase","Entered...",UVM_HIGH)
	
	if(!uvm_config_db #(virtual uart_if)::get(this,"","lhs_vif",lhs_vif))
		`uvm_fatal(get_type_name(),$sformatf("Failed to get lhs_vif from uvm_config_db"))
	if(!uvm_config_db #(virtual uart_if)::get(this,"","rhs_vif",rhs_vif))
		`uvm_fatal(get_type_name(),$sformatf("Failed to get rhs_vif from uvm_config_db"))

	uart_env = uart_environment::type_id::create("uart_env", this);
	
	err_catcher = uart_error_catcher::type_id::create("err_catcher");
	uvm_report_cb::add(null,err_catcher);

	lhs_cfg = uart_configuration::type_id::create("lhs_cfg", this);	
	lhs_cfg.mode         = uart_configuration::TX;
	lhs_cfg.baudrate     = 115200;
	lhs_cfg.data_bits    = 8;
	lhs_cfg.stop_bits    = 1;
	lhs_cfg.use_parity   = 1;
	lhs_cfg.parity_even  = 0; // odd parity		

	rhs_cfg = uart_configuration::type_id::create("rhs_cfg", this);	
	rhs_cfg.mode         = uart_configuration::RX;
	rhs_cfg.baudrate     = 115200;
	rhs_cfg.data_bits    = 8;
	rhs_cfg.stop_bits    = 1;
	rhs_cfg.use_parity   = 1;
	rhs_cfg.parity_even  = 0; // odd parity
	
	uvm_config_db #(virtual uart_if)::set(this,"uart_env","lhs_vif", lhs_vif);
	uvm_config_db #(virtual uart_if)::set(this,"uart_env","rhs_vif", rhs_vif);
	
	uvm_config_db #(uart_configuration)::set(this,"uart_env","lhs_cfg", lhs_cfg);
	uvm_config_db #(uart_configuration)::set(this,"uart_env","rhs_cfg", rhs_cfg);

	`uvm_info("build_phase","Exitting...",UVM_HIGH)
	endfunction: build_phase

	virtual function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("start_of_simulation_phase","Entered...", UVM_HIGH)
		uvm_top.print_topology();	
		`uvm_info("start_of_simulation_phase","Exitting...", UVM_HIGH)
	endfunction


	virtual function void final_phase(uvm_phase phase);
  	uvm_report_server svr;
    super.final_phase (phase);
    `uvm_info("final_phase", "Entered...", UVM_HIGH)
    svr = uvm_report_server::get_server();
    if(svr.get_severity_count (UVM_FATAL) + svr.get_severity_count (UVM_ERROR) > 0) begin
      $display("\n======================================");
      $display("     ###Status: TEST FAILED###          ");
      $display("=======================================\n");
    end
    else begin
      $display("\n=======================================");
      $display("    ###Status: TEST PASSED###            ");
      $display("=======================================\n");
    end
    `uvm_info("final_phase", "Exiting...",UVM_HIGH)
  endfunction: final_phase
	

endclass: uart_base_test
