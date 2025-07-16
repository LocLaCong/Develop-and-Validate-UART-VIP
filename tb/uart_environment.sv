class uart_environment extends uvm_env; 
	`uvm_component_utils(uart_environment)

	//interface
	virtual uart_if lhs_vif;
	virtual uart_if rhs_vif;
	//configuration;
	uart_configuration lhs_cfg;
	uart_configuration rhs_cfg;

	uart_scoreboard scoreboard;
	uart_agent uart_lhs_agent;
	uart_agent uart_rhs_agent; 
	
	function new(string name = "uart_environment", uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase (uvm_phase phase); 
		super.build_phase(phase);
		`uvm_info("build_phase","Entered...",UVM_HIGH)
		//GET uart_vif and uart_configuration from uvm_config_db
		if(!uvm_config_db #(virtual uart_if)::get(this,"","lhs_vif",lhs_vif))
			`uvm_fatal(get_type_name(),$sformatf("Failed to get lhs_vif from uvm_config_db"))		
		if(!uvm_config_db #(virtual uart_if)::get(this,"","rhs_vif",rhs_vif))
			`uvm_fatal(get_type_name(),$sformatf("Failed to get rhs_vif from uvm_config_db"))

		if(!uvm_config_db #(uart_configuration)::get(this,"","lhs_cfg",lhs_cfg))
			`uvm_fatal(get_type_name(),$sformatf("Failed to get lhs_cfg from uvm_config_db"))
		if(!uvm_config_db #(uart_configuration)::get(this,"","rhs_cfg",rhs_cfg))
			`uvm_fatal(get_type_name(),$sformatf("Failed to get rhs_cfg from uvm_config_db"))

			
		scoreboard = uart_scoreboard::type_id::create("scoreboard", this);
		uart_lhs_agent = uart_agent::type_id::create("uart_lhs_agent", this);
		uart_rhs_agent = uart_agent::type_id::create("uart_rhs_agent", this);

		//SET uart_vif and uart_configuration to agent
		uvm_config_db #(virtual uart_if)::set(this,"uart_lhs_agent","uart_vif", lhs_vif);
		uvm_config_db #(virtual uart_if)::set(this,"uart_rhs_agent","uart_vif", rhs_vif);
		uvm_config_db #(uart_configuration)::set(this,"uart_lhs_agent","cfg", lhs_cfg);
		uvm_config_db #(uart_configuration)::set(this,"uart_rhs_agent","cfg", rhs_cfg);

		`uvm_info("build_phase","Exitting...",UVM_HIGH)
	endfunction: build_phase

	virtual function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("connect_phase","Entered...", UVM_HIGH)	
		
		uart_lhs_agent.monitor.uart_observe_port_tx.connect(scoreboard.lhs_tx_export);
		uart_lhs_agent.monitor.uart_observe_port_rx.connect(scoreboard.lhs_rx_export);
		uart_rhs_agent.monitor.uart_observe_port_tx.connect(scoreboard.rhs_tx_export);
		uart_rhs_agent.monitor.uart_observe_port_rx.connect(scoreboard.rhs_rx_export);

		`uvm_info("connect_phase","Exitting...", UVM_HIGH)	

	endfunction: connect_phase 

endclass: uart_environment
