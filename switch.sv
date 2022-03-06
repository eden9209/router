module switch (clk,reset,data_valid,data,port0,port1,port2,port3,ready_0,ready_1,ready_2, ready_3,read_0,read_1,read_2,read_3);
	input 			clk; 
	input 			reset;
	input 			data_valid;
	input 	[7:0] data;
	output	[7:0] port0;
	output   [7:0] port1;
	output   [7:0] port2;
	output   [7:0] port3;
	output   		ready_0; 
	output   		ready_1;
	output   		ready_2;
	output   		ready_3;
	input    		read_0; 
	input    		read_1;
	input    		read_2;
	input    		read_3;
	
	wire 				out_port_idle;
	wire 				out_port_idle0;
	wire 				out_port_idle1;
	wire 				out_port_idle2;
	wire 				out_port_idle3;
	wire 				mem0_full_wr;
	wire 				mem1_full_wr;
	wire 				mem2_full_wr;
	wire 				mem3_full_wr;
	wire 				mem_full_wr; 
	reg 		[7:0] data_in; 
	wire 				input_for_port0;
	wire 				input_for_port1;
	wire 				input_for_port2; 
	wire 				input_for_port3; 
	wire   	[7:0] mem0_s; 
	wire   	[7:0] mem1_s; 
	wire   	[7:0] mem2_s;
	wire   	[7:0] mem3_s; 
	
	reg    	[7:0]	port0;     
	reg      [7:0] int0_mem[0:50]; 
	reg      		ready_0;
	reg      		full0; 
	reg    	[7:0] port1; 
	reg      [7:0] int1_mem[0:50]; 
	reg 				ready_1;
	reg      		full1; 
	reg    	[7:0] port2;
	reg      [7:0] int2_mem[0:50]; 
	reg 				ready_2;
	reg      		full2; 
	reg    	[7:0] port3;
	reg      [7:0] int3_mem[0:50];
	reg 		   	ready_3;
	reg      		full3; 
	reg 		[7:0] data_out_fsm;
	reg    	[3:0] port_sel;
	reg      		fsm_input_to_port; 
	reg    	[3:0] preset_state; 
	reg    	[3:0] next_state; 
	reg 				busy;

	
	assign mem0_s = 8'h00; 
	assign mem1_s = 8'h01; 
	assign mem2_s = 8'h02;
	assign mem3_s = 8'h03; 
	assign input_for_port0 = port_sel[0] & fsm_input_to_port; 
	assign input_for_port1 = port_sel[1] & fsm_input_to_port; 
	assign input_for_port2 = port_sel[2] & fsm_input_to_port; 
	assign input_for_port3 = port_sel[3] & fsm_input_to_port; 
	assign out_port_idle0 = (~ready_0 | ( data_in != mem0_s)); 
	assign out_port_idle1 = (~ready_1 | ( data_in != mem1_s));  
	assign out_port_idle2 = (~ready_2 | ( data_in != mem2_s)); 
	assign out_port_idle3 = (~ready_3 | ( data_in != mem3_s)); 
	assign out_port_idle  = out_port_idle0 & out_port_idle1 & out_port_idle2 & out_port_idle3;
	assign mem0_full_wr = (full0 & (data_in == mem0_s)); 
	assign mem1_full_wr = (full1 & (data_in == mem1_s));  
	assign mem2_full_wr = (full2 & (data_in == mem2_s)); 
	assign mem3_full_wr = (full3 & (data_in == mem3_s));  
	assign mem_full_wr   = mem0_full_wr | mem1_full_wr | mem2_full_wr | mem3_full_wr;  
	
	integer        mem0_addr_in;
	integer        mem0_addr_out; 
	 
	always@(negedge reset)  begin   
		port0  			= 8'b0000_0000;     
		ready_0 			= 1'b0;     
		full0  			= 1'b0;    
		mem0_addr_in 	= 0;
		mem0_addr_out  = 0; 
	end 

	always @(posedge clk) begin
		if ((input_for_port0 == 1'b1) && (full0 == 1'b0)) begin        
			int0_mem[mem0_addr_in] = data_out_fsm;       
			ready_0 <= 1'b1;     
			mem0_addr_in = (mem0_addr_in + 1) % 16;
			if ( mem0_addr_out == mem0_addr_in ) begin      
				full0 <= 1'b1;       
			end  
		end  
		
		if ((read_0 == 1'b1) &&  (ready_0 == 1'b1)) begin
			port0 <= int0_mem[mem0_addr_out];  
			full0 <= 1'b0;      
			mem0_addr_out = (mem0_addr_out + 1) % 16;    
			if ( mem0_addr_out == mem0_addr_in ) begin    
				ready_0 <= 1'b0;     
			end       
		end    
	end     
	
	integer        mem1_addr_in; 
	integer        mem1_addr_out;   
	
	always@(negedge reset)   begin     
		port1  			= 8'b0000_0000;     
		ready_1 			= 1'b0;   
		full1  			= 1'b0;
      mem1_addr_in 	= 0;     
		mem1_addr_out  = 0;   
	end
	
	always @(posedge clk) begin
       if ((input_for_port1 == 1'b1) &&  (full1 == 1'b0)) begin         
			int1_mem[mem1_addr_in] = data_out_fsm;  
			ready_1 <= 1'b1;        
			mem1_addr_in = (mem1_addr_in + 1) % 16;      
			if ( mem1_addr_out == mem1_addr_in ) begin   
				full1 <= 1'b1; 
			end     
		end  
		if ((read_1 == 1'b1) &&  (ready_1 == 1'b1)) begin    
			port1 <= int1_mem[mem1_addr_out];   
			full1 <= 1'b0;      
			mem1_addr_out = (mem1_addr_out + 1) % 16;    
			if ( mem1_addr_out == mem1_addr_in ) begin  
				ready_1 <= 1'b0;       
			end   
		end   
	end         

	integer        mem2_addr_in; 
	integer        mem2_addr_out;  

	always@(negedge reset)   begin  
		port2  			= 8'b0000_0000;    
		ready_2 			= 1'b0;   
		full2  			= 1'b0;  
		mem2_addr_in 	= 0;     
		mem2_addr_out  = 0;  
	end 
 
	always @(posedge clk) begin 
		if ((input_for_port2 == 1'b1) && (full2 == 1'b0)) begin 
			int2_mem[mem2_addr_in] = data_out_fsm;     
			ready_2 <= 1'b1;   
			mem2_addr_in = (mem2_addr_in + 1) % 16;   
			if ( mem2_addr_out == mem2_addr_in ) begin
				full2 <= 1'b1;      
			end       
		end  
		if ((read_2 == 1'b1) &&  (ready_2 == 1'b1)) begin     
			port2 <= int2_mem[mem2_addr_out];    
			full2 <= 1'b0;  
			mem2_addr_out = (mem2_addr_out + 1) % 16;     
			if ( mem2_addr_out == mem2_addr_in ) begin        
				ready_2 <= 1'b0;    
			end     
		end
	end
      
	integer        mem3_addr_in;	
	integer        mem3_addr_out;  

	always@(negedge reset)   begin   
		port3  			= 8'b0000_0000;    
		ready_3 			= 1'b0;   
		full3  			= 1'b0;   
		mem3_addr_in 	= 0;  
		mem3_addr_out  = 0;  
	end

	always @(posedge clk) begin
		if ((input_for_port3 == 1'b1) &&  (full3 == 1'b0)) begin 		 
			int3_mem[mem3_addr_in] = data_out_fsm;    
			ready_3 <= 1'b1;   
			mem3_addr_in = (mem3_addr_in + 1) % 16;   
			if ( mem3_addr_out == mem3_addr_in ) begin    
				full3 <= 1'b1;         
			end      
		end  
		if ((read_3 == 1'b1) &&  (ready_3 == 1'b1)) begin 
			port3 <= int3_mem[mem3_addr_out];     
			full3 <= 1'b0;     
			mem3_addr_out = (mem3_addr_out + 1) % 16;    
			if ( mem3_addr_out == mem3_addr_in ) begin          
				ready_3 <= 1'b0;     
			end
		end 
   end
	
   parameter AAA = 4'b0000; 
	parameter DD  = 4'b0001; 
	parameter BB  = 4'b0010; 
	parameter CC  = 4'b0011;
	parameter EE  = 4'b0100;  
	
	always@(negedge reset)  begin    
		data_out_fsm      = 8'b0000_0000; 
		data_in           = 8'b00000000;      
		port_sel    		= 4'b0000;      
		fsm_input_to_port = 1'b0;  
		preset_state      = 4'b0000;  
		next_state        = 4'b0000;   
		busy      			= 1'b0;  
	end  
	
	always @(data_valid) begin  
		if (data_valid == 1'b1) begin    
			case (data)     
			mem0_s :  begin  
				port_sel[0] = 1'b1;    
				port_sel[1] = 1'b0;    
				port_sel[2] = 1'b0;    
				port_sel[3] = 1'b0;   
			end  
			mem1_s :  begin   
				port_sel[0] = 1'b0;  
				port_sel[1] = 1'b1;   
				port_sel[2] = 1'b0;    
				port_sel[3] = 1'b0;     
			end   
			mem2_s :  begin   
				port_sel[0] = 1'b0;   
				port_sel[1] = 1'b0;   
				port_sel[2] = 1'b1;  
				port_sel[3] = 1'b0;   
			end        
			mem3_s : begin 
				port_sel[0] = 1'b0;  
				port_sel[1] = 1'b0;  
				port_sel[2] = 1'b0;    
				port_sel[3] = 1'b1;    
			end   
			default :port_sel = 4'b0000;
			endcase    
		end  
	end 

	always @(posedge clk) begin  
		preset_state <= next_state;  
	end    
	
	always @(preset_state or data_valid or out_port_idle or mem_full_wr or data)  begin : fsm_core  
	next_state = preset_state;        
		case (preset_state)        
		AAA :   begin                  
			if ((data_valid == 1'b1) && ((mem0_s == data)||(mem1_s == data)||(mem3_s == data) ||(mem2_s == data))) begin 
				if (out_port_idle == 1'b1) begin 
					next_state = DD;    
				end
				else begin   
					next_state = EE;   
				end         
			end       
			busy = !out_port_idle;
			if ((data_valid == 1'b1) && ((mem0_s == data)||(mem1_s == data)||(mem3_s == data) ||(mem2_s == data)) && (out_port_idle == 1'b1)) begin      
				data_in = data;           
				data_out_fsm  = data;     
				fsm_input_to_port = 1'b1;      
			end
			else begin   
				fsm_input_to_port = 1'b0;                
			end           
		end      
		
		BB : begin      
			  next_state = AAA;        
			  data_out_fsm = data;                  
			  fsm_input_to_port = 1'b0;     
		end 
      
		DD : begin   
		  if ((data_valid == 1'b1) && (mem_full_wr == 1'b0)) begin 
			  next_state = DD;       
			end    
			else if ((data_valid == 1'b0) && (mem_full_wr == 1'b0)) begin   
			  next_state = BB;         
			end  
			else begin  
			  next_state = CC;
			end          
			busy = 1'b0;   
			if ((data_valid == 1'b1) &&  (mem_full_wr == 1'b0)) begin    
				data_out_fsm = data;          
				fsm_input_to_port = 1'b1;       
			end          
			else if ((data_valid == 1'b0) && (mem_full_wr == 1'b0)) begin    
				data_out_fsm = data;              
				fsm_input_to_port = 1'b1;       
			end        
			else begin  
				fsm_input_to_port = 1'b0;       
			end    
		end   
		
		CC :  begin  
			if (mem_full_wr == 1'b1) begin   
				next_state = CC;  
			end 
			else if ((mem_full_wr == 1'b0) && (data_valid == 1'b0)) begin    
				next_state = BB;          
			end     
			else begin    
				next_state = DD; 
			end
			if (mem_full_wr == 1'b1) begin        
				busy = 1'b1;                
				fsm_input_to_port = 1'b0;   
			end     
			else begin 
				fsm_input_to_port = 1'b1;   
				data_out_fsm = data;          
			end      
		end     

		EE :  begin   
			if (out_port_idle == 1'b0) begin   
				next_state = EE;    
			end    
         else begin 
				next_state = DD;     
			end     
         if (out_port_idle == 1'b0) begin     
				busy = 1'b1;
			end    
			else begin    
				data_in = data;    
				data_out_fsm  = data; 
				fsm_input_to_port = 1'b1;  
			end    
		end    
		endcase
	end
	
endmodule //router
