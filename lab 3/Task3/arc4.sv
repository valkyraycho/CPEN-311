module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here
    reg [7:0] s_addr,s_wrdata,s_rddata,init_s_addr,ksa_s_addr,prga_s_addr,init_s_wrdata,ksa_s_wrdata,prga_s_wrdata;
    reg s_wren,init_s_wren,ksa_s_wren,prga_s_wren,en_prga;
    reg [3:0] state,state_comb;

    reg [7:0] r_ct_addr,r_pt_addr,r_pt_wrdata;
    reg r_pt_wren;
    reg en_init;
    reg rdy_init,rdy_ksa,rdy_prga;

    assign ct_addr = r_ct_addr;
    assign pt_addr = r_pt_addr;
    assign pt_wrdata = r_pt_wrdata;
    assign pt_wren = r_pt_wren;
    assign state_comb = state;

    s_mem s(.address(s_addr),.clock(clk),.data(s_wrdata),
    .wren(s_wren),.q(s_rddata)
    );


    init i( 
        .clk(clk),.rst_n(rst_n),.en(en_init),.rdy(rdy_init),
        .addr(init_s_addr),.wrdata(init_s_wrdata),.wren(init_s_wren)
    );

    ksa k( 
        .clk(clk),.rst_n(rst_n),.en(rdy_init),.rdy(rdy_ksa),
        .key(key),.addr(ksa_s_addr),.rddata(s_rddata),
        .wrdata(ksa_s_wrdata),.wren(ksa_s_wren)

     );

    prga p(.clk(clk),.rst_n(rst_n),.en(en_prga),
    .rdy(rdy_prga),.key(key),.s_addr(prga_s_addr),
    .s_rddata(s_rddata),.s_wrdata(prga_s_wrdata),.s_wren(prga_s_wren),
    .ct_addr(r_ct_addr),.ct_rddata(ct_rddata),
    .pt_addr(r_pt_addr),.pt_rddata(pt_rddata),
    .pt_wrdata(r_pt_wrdata),
    .pt_wren(r_pt_wren)
    );

    // your code here

    always@(posedge clk) begin

        if((rdy_prga == 1) && (en_prga == 1)) begin
            state <= 2;
        end
        else if((rdy_init == 0) && (rdy_ksa == 1)) begin //Connect s wires to init
            state <= 0;
        end

        else if((rdy_init == 1) && (rdy_ksa == 1) && (rdy_prga == 1)) begin //Connect s wires to ksa
            state <= 1;
        end
        

    end

    always_comb begin 


        case(state_comb) 
            0:begin
                s_addr = init_s_addr;
	        	s_wren = init_s_wren;
		        s_wrdata = init_s_wrdata;
                en_prga = 1'b0;
            end
             1:begin
                s_addr = ksa_s_addr;
	        	s_wren = ksa_s_wren;
		        s_wrdata = ksa_s_wrdata;
                en_prga = rdy_ksa;
            end
             2:begin
                s_addr = prga_s_addr;
	        	s_wren = prga_s_wren;
		        s_wrdata = prga_s_wrdata;
                en_prga = 1'b0;
            end

            default: begin
                s_addr = init_s_addr;
	        	s_wren = init_s_wren;
		        s_wrdata = init_s_wrdata;
                en_prga = 1'b0;
            end

        endcase

        
    end

endmodule: arc4
