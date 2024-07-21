module music(input CLOCK_50, input CLOCK2_50, input [3:0] KEY, input [9:0] SW,
             input AUD_DACLRCK, input AUD_ADCLRCK, input AUD_BCLK, input AUD_ADCDAT,
             inout FPGA_I2C_SDAT, output FPGA_I2C_SCLK, output AUD_DACDAT, output AUD_XCK,
             output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2,
             output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5,
             output [9:0] LEDR);
			
// signals that are used to communicate with the audio core
// DO NOT alter these -- we will use them to test your design

reg read_ready, write_ready, write_s;
reg [15:0] writedata_left, writedata_right;
reg [15:0] readdata_left, readdata_right;	
wire reset, read_s;

// signals that are used to communicate with the flash core
// DO NOT alter these -- we will use them to test your design

reg flash_mem_read;
reg flash_mem_waitrequest;
reg [22:0] flash_mem_address;
reg [31:0] flash_mem_readdata;
reg flash_mem_readdatavalid;
reg [3:0] flash_mem_byteenable;
reg rst_n, clk;


integer cnt;
reg [4:0] state;
reg signed [15:0] sample;
reg signed [15:0] next_sample;
reg [3:0] flash_state;
reg start;
reg done;
reg [31:0] read32;


// DO NOT alter the instance names or port names below -- we will use them to test your design

clock_generator my_clock_gen(CLOCK2_50, reset, AUD_XCK);
audio_and_video_config cfg(CLOCK_50, reset, FPGA_I2C_SDAT, FPGA_I2C_SCLK);
audio_codec codec(CLOCK_50,reset,read_s,write_s,writedata_left, writedata_right,AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK,read_ready, write_ready,readdata_left, readdata_right,AUD_DACDAT);
flash flash_inst(.clk_clk(clk), .reset_reset_n(rst_n), .flash_mem_write(1'b0), .flash_mem_burstcount(1'b1),
                 .flash_mem_waitrequest(flash_mem_waitrequest), .flash_mem_read(flash_mem_read), .flash_mem_address(flash_mem_address),
                 .flash_mem_readdata(flash_mem_readdata), .flash_mem_readdatavalid(flash_mem_readdatavalid), .flash_mem_byteenable(flash_mem_byteenable), .flash_mem_writedata());





assign flash_mem_byteenable = 4'b1111;
assign read_s = 1'b0;
assign reset = ~(KEY[3]);
assign rst_n = ~reset;
assign clk = CLOCK_50;
// your code for the rest of this task here
always_ff @(posedge CLOCK_50)
   if (reset == 1'b1) begin
         state <= 0;
         write_s <= 1'b0;
         //cnt <= 0;
        start <= 0;
   end else begin
      case (state)
		
         0: begin
				 
				     // In this state, we set write_s to 0,
					 // and wait for write_ready to become 1.
					 // The write_ready signal will go 1 when the FIFOs
					 // are ready to accept new data.  We can't do anything
					 // until this signal goes to a 1.
					 //Tell flash to load next sample
                    start <= 1;
				    write_s <= 1'b0;
                if (write_ready == 1'b1 && done == 1)  begin
                    start <= 0;
	                state <= 1;
                end
             end // state_wait_until_ready				   
   
                 1: begin
				 
				  
					 
                     // send the sample to the core (it is added to the two FIFOs
                     // as explained in the handout.  We need to be sure to send data
					 // to both the right and left queue.  Since we are only playing a
					 // mono sound (not stereo) we send the same sample to both FIFOs.
					 // You will do the same in your implementation in the final task.

					 
				    writedata_right <= sample;
				    writedata_left <= sample;
			        write_s <= 1'b1;  // indicate we are writing a value
                    state <= 2;
				   end // state_send_sample
					


                

		       2: begin

                     // now we have to wait until the core has accepted
	                 // the value. We will know this has happened when
	                 // write_ready goes to 0.   Once it does, we can 
					 // go back to the top, set write_s to 0, and 
					 // wait until the core is ready for a new sample.
					 
				    if (write_ready == 1'b0) begin
				        state <= 3;
                        end
					end // state_wait_for_accepted

                3: begin

                    write_s <= 0;
					if (write_ready == 1'b1) begin
                    state <= 4;

                    end

                end 

                4: begin

               

                    writedata_right <= next_sample;
				    writedata_left <= next_sample;
			        write_s <= 1'b1;
                    state <= 5;
                end 

                5: begin

                     // now we have to wait until the core has accepted
	                 // the value. We will know this has happened when
	                 // write_ready goes to 0.   Once it does, we can 
					 // go back to the top, set write_s to 0, and 
					 // wait until the core is ready for a new sample.
					 
				    if (write_ready == 1'b0) begin
				        state <= 0;
                    end 
				    
					end // state_wait_for_accepted
					
	          default: begin
				 
				    // should never happen, but good practice
					 state <= 0;
               
				 end // default
			endcase
     end 


always_ff @(posedge clk) begin
    if(rst_n == 0)begin //Reset State
        flash_mem_read <= 0;
        flash_mem_address <= 0;
        flash_state <= 0;
        done <= 0;
    end

    else begin
        if(flash_mem_address < 1048576) begin 

            case (flash_state)
                0: begin //Set read high, assert read-address    
                if(start == 1 && done == 0) begin    
                    flash_mem_read <= 1;
                    flash_state <= 5;
                  
                end 
                else if (start == 0 && done == 1) begin
                    done <= 0;
                    flash_state <= 0;
                end
                else begin
                    flash_state <= 0;
                end
                end

                 5: begin //Set read high, assert read-address
                    if(flash_mem_waitrequest == 0)
                    flash_state <= 1;
                    else 
                    flash_state <= 5;
                end

                1: begin //Wait for readdatavalid to be asserted
                    if(flash_mem_readdatavalid == 1) begin //Data valid, set read to 0 and load data into read32
                        flash_mem_read <= 0;
                        read32 <= flash_mem_readdata;
                        flash_state <= 2;
                    end

                    else begin //Data not valid yet, wait for assertion
                        flash_state <= 1; 
                    end
                end
                2: begin //Load first set of 16 bits into s_mem
                    
					 
                    sample <= $signed(read32[15:0]) >>> 6;
                    flash_state <= 3;
                
                end
                3: begin
                    
					
					next_sample <= $signed(read32[31:16]) >>> 6;
                    flash_state <= 4;
                end

                4: begin //Increment flash_mem_address
                    flash_mem_address <= flash_mem_address + 1;
                    flash_state <= 0;
                    done <= 1;
                end
                


                default: begin
                    //State out of bounds 
                end 
            endcase

        end
        else begin
            flash_mem_address <= 0;
        end 

       
    
    end


end



endmodule: music
