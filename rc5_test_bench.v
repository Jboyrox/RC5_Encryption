`timescale 1ns / 1ps

module test_rc5_enc();

    wire [63:0]t_din_enc;
    wire [63:0]t_din_dec;
    wire [63:0]t_dout_enc;
    wire [63:0]t_dout_dec;
    reg t_rst;
    reg t_clk;
    integer fp;
    reg [63:0] f_din_enc; //64 bit encoder input from file I/O
    reg [63:0] f_din_dec; //64 bit decoder inpput from file I/0
        
    assign t_din_enc = f_din_enc;
    assign t_din_dec = f_din_dec;
    
    encoder_rc5 dut( //encoder 
    .rst(t_rst),
    .clk(t_clk),
    .d_in(t_din_enc),
    .d_out(t_dout_enc)
    );

    decoder_rc5 U2( //decoder
    .rst(t_rst),
    .clk(t_clk),
    .d_in(t_din_dec),
    .d_out(t_dout_dec)
    );

    initial begin: Clock
        forever begin
            t_clk <=0;
            #1; 
            t_clk <=1;
            #1; 
        end
        end

     initial begin 
        fp = $fopen("testcases.mem","r"); //Tests to see if file can be opened
            if(fp == 0) 
            begin
                $display("File cannot be opened");
                $stop;
              end

      while(!$feof(fp))
        begin
            $fscanf(fp,"%h %h\n",f_din_enc,f_din_dec); //reads the encoder input first and then the decoder input
            
                t_rst <= 0; //turns the reset on
                #1;
                
                if(t_dout_enc != t_din_enc) //checks if reset works for encoder and input = output (din = dout)
                begin
                    $display("test case failed reset not functional for encoder", $time);
                    $stop;
                end 
                
                if(t_dout_dec != t_din_dec) //checks if reset works for decoder and input = output (din = dout)
                begin
                    $display("test cases failed reset not function for decoder", $time);
                    $stop;
                end
                #1
                t_rst <=1; //Turns the reset off
                #24; //12 clock cylces or 12 counts
                
                if(t_dout_enc != t_din_dec) //checks to see if encoder output is the same decoder input 
                begin
                    $display("test case for ecnryption failed", $time);
                    $stop;
                end 
                
                if(t_dout_dec != t_din_enc) //checks to see if decoder output is the same encoder input
                begin
                    $display("test cases for decode failed", $time);
                    $stop;
                end
        end
        
        $display("All encryption and decryptions performed successfully");
        
 end
 
endmodule


