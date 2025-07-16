class uart_monitor extends uvm_monitor;
	`uvm_component_utils(uart_monitor)

	//interface
	virtual uart_if uart_vif;

	//configuration
	uart_configuration cfg;
	//analysis port
	uvm_analysis_port #(uart_transaction) uart_observe_port_tx;	
	uvm_analysis_port #(uart_transaction) uart_observe_port_rx;
	
	
	function new(string name = "uart_monitor", uvm_component parent);
		super.new(name, parent);
		//new analysis port
		uart_observe_port_tx = new("uart_observe_port_tx",this);
		uart_observe_port_rx = new("uart_observe_port_rx",this);
	endfunction: new	
	
	//build_phase
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual uart_if)::get(this,"","uart_vif", uart_vif))
			`uvm_fatal(get_type_name(),$sformatf("Failed to get uart_vif from uvm_config_db"))
		if(!uvm_config_db #(uart_configuration)::get(this,"","cfg", cfg))	
			`uvm_fatal(get_type_name(),$sformatf("Failed to get cfg from uvm_config_db"))
		// create transaction
		
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		fork
			if(cfg.mode == uart_configuration::TX || cfg.mode == uart_configuration::TX_RX)
				capture_port(uart_vif.tx, 1);// 1: TX (expected frame)
			if(cfg.mode == uart_configuration::RX || cfg.mode == uart_configuration::TX_RX)	
				capture_port(uart_vif.rx, 0);// 0: RX (actual frame)
		join
		endtask: run_phase

		//calculate period from baudrate (ns)
		function time baud_period_ns(int baudrate); 
		return (baudrate > 0) ? (1e9 / baudrate) : 0;
		endfunction

	task capture_port(ref logic port, input bit is_tx);
					
		//transaction
		uart_transaction trans;
		int data_bits = cfg.data_bits;
		int stop_bits = cfg.stop_bits;
		int baudrate 	= cfg.baudrate;
		time period 	= baud_period_ns(baudrate);
	
		forever begin 
			//wait for start bit (falling edge)
			@(negedge port);
				if(port !== 1'b0) continue;
			
			//middle of start bit
			#(period*1ns/2);	

			trans = uart_transaction::type_id::create("trans", this);
			
			//Data bits
			for(int i = 0; i < data_bits; i++) begin
				#(period*1ns);
				trans.data[i] = port;
			end
			
			//parity bis
			if(cfg.use_parity) begin
				#(period*1ns);
				trans.parity = port;
			end
			
			//stop bits
			trans.stopbit = 2'b00;
			for(int i = 0; i < stop_bits; i++) begin 
				#(period*1ns);
				trans.stopbit[i] = port;
				if(trans.stopbit[i] == 0) 
					`uvm_error(get_type_name(), $sformatf("Invalid stop bit"))
			end
		
			//Send transaction to analysis port
			if(is_tx)
				uart_observe_port_tx.write(trans);
			else
				uart_observe_port_rx.write(trans);
		end  
	
	endtask: capture_port

endclass: uart_monitor
