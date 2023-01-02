`timescale 1ns / 1ps

module lab9(
  input clk,
  input reset_n,
  input [3:0] usr_btn,
  output [3:0] usr_led,
  output LCD_RS,
  output LCD_RW,
  output LCD_E,
  output [3:0] LCD_D
);

localparam [2:0] S_MAIN_INIT = 0, S_MAIN_WAIT = 1, S_MAIN_FIND = 2,
                 S_MAIN_POST = 3, S_MAIN_SHOW = 4, S_MAIN_STOP = 5;
reg  [2:0] P, P_next;
wire btn_level, btn_pressed;
reg prev_btn_level;
reg [19:0] clk_counter;
reg [31:0] valid_counter;
reg [7:0] post_counter;
reg [127:0] row_A, row_B;
reg [0:127] passwd_hash = 128'hef775988943825d2871e1cfa75473ec0;
//The hash code of 53589793 is:e8cd0953abdfde433dfec7faa70df7f6
//The hash code of 00000000 is:dd4b21e9ef71e1291183a46b913ae6f2
//The hash code of 50000000 is:8bf95db53b52762745b2190b9b211b17
//The hash code of 99999996 is:792f97d225bfce2e06600b74761bd695 //ok
//The hash code of 99999999 is:ef775988943825d2871e1cfa75473ec0
reg [63:0] text,otext,result,timer;
reg found;

localparam mach = 30;
reg [0:mach-1] en;
reg [63:0] din [0:mach-1];
wire [63:0] echo [0:mach-1];
wire [127:0] dout [0:mach-1];
wire [0:mach-1] busy;
wire [0:mach-1] valid;

LCD_module lcd0(
  .clk(clk),
  .reset(~reset_n),
  .row_A(row_A),
  .row_B(row_B),
  .LCD_E(LCD_E),
  .LCD_RS(LCD_RS),
  .LCD_RW(LCD_RW),
  .LCD_D(LCD_D)
);

debounce btn_db0(
  .clk(clk),
  .btn_input(usr_btn[3]),
  .btn_output(btn_level)
);

md5 mach_0(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[ 0]),
    .data(din [ 0]),
    .busy(busy[ 0]),
    .valid(valid [ 0]),
    .echo(echo[ 0]),
    .hash_value(dout[ 0])
);
md5 mach_1(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[ 1]),
    .data(din [ 1]),
    .busy(busy[ 1]),
    .valid(valid [ 1]),
    .echo(echo[ 1]),
    .hash_value(dout[ 1])
);
md5 mach_2(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[ 2]),
    .data(din [ 2]),
    .busy(busy[ 2]),
    .valid(valid [ 2]),
    .echo(echo[ 2]),
    .hash_value(dout[ 2])
);
md5 mach_3(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[ 3]),
    .data(din [ 3]),
    .busy(busy[ 3]),
    .valid(valid [ 3]),
    .echo(echo[ 3]),
    .hash_value(dout[ 3])
);
md5 mach_4(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[ 4]),
    .data(din [ 4]),
    .busy(busy[ 4]),
    .valid(valid [ 4]),
    .echo(echo[ 4]),
    .hash_value(dout[ 4])
);
md5 mach_5(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[ 5]),
    .data(din [ 5]),
    .busy(busy[ 5]),
    .valid(valid [ 5]),
    .echo(echo[ 5]),
    .hash_value(dout[ 5])
);
md5 mach_6(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[ 6]),
    .data(din [ 6]),
    .busy(busy[ 6]),
    .valid(valid [ 6]),
    .echo(echo[ 6]),
    .hash_value(dout[ 6])
);
md5 mach_7(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[ 7]),
    .data(din [ 7]),
    .busy(busy[ 7]),
    .valid(valid [ 7]),
    .echo(echo[ 7]),
    .hash_value(dout[ 7])
);
md5 mach_8(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[ 8]),
    .data(din [ 8]),
    .busy(busy[ 8]),
    .valid(valid [ 8]),
    .echo(echo[ 8]),
    .hash_value(dout[ 8])
);
md5 mach_9(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[ 9]),
    .data(din [ 9]),
    .busy(busy[ 9]),
    .valid(valid [ 9]),
    .echo(echo[ 9]),
    .hash_value(dout[ 9])
);
md5 mach_10(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[10]),
    .data(din [10]),
    .busy(busy[10]),
    .valid(valid [10]),
    .echo(echo[10]),
    .hash_value(dout[10])
);
md5 mach_11(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[11]),
    .data(din [11]),
    .busy(busy[11]),
    .valid(valid [11]),
    .echo(echo[11]),
    .hash_value(dout[11])
);
md5 mach_12(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[12]),
    .data(din [12]),
    .busy(busy[12]),
    .valid(valid [12]),
    .echo(echo[12]),
    .hash_value(dout[12])
);
md5 mach_13(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[13]),
    .data(din [13]),
    .busy(busy[13]),
    .valid(valid [13]),
    .echo(echo[13]),
    .hash_value(dout[13])
);
md5 mach_14(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[14]),
    .data(din [14]),
    .busy(busy[14]),
    .valid(valid [14]),
    .echo(echo[14]),
    .hash_value(dout[14])
);
md5 mach_15(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[15]),
    .data(din [15]),
    .busy(busy[15]),
    .valid(valid [15]),
    .echo(echo[15]),
    .hash_value(dout[15])
);
md5 mach_16(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[16]),
    .data(din [16]),
    .busy(busy[16]),
    .valid(valid [16]),
    .echo(echo[16]),
    .hash_value(dout[16])
);
md5 mach_17(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[17]),
    .data(din [17]),
    .busy(busy[17]),
    .valid(valid [17]),
    .echo(echo[17]),
    .hash_value(dout[17])
);
md5 mach_18(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[18]),
    .data(din [18]),
    .busy(busy[18]),
    .valid(valid [18]),
    .echo(echo[18]),
    .hash_value(dout[18])
);
md5 mach_19(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[19]),
    .data(din [19]),
    .busy(busy[19]),
    .valid(valid [19]),
    .echo(echo[19]),
    .hash_value(dout[19])
);
md5 mach_20(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[20]),
    .data(din [20]),
    .busy(busy[20]),
    .valid(valid [20]),
    .echo(echo[20]),
    .hash_value(dout[20])
);
md5 mach_21(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[21]),
    .data(din [21]),
    .busy(busy[21]),
    .valid(valid [21]),
    .echo(echo[21]),
    .hash_value(dout[21])
);
md5 mach_22(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[22]),
    .data(din [22]),
    .busy(busy[22]),
    .valid(valid [22]),
    .echo(echo[22]),
    .hash_value(dout[22])
);
md5 mach_23(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[23]),
    .data(din [23]),
    .busy(busy[23]),
    .valid(valid [23]),
    .echo(echo[23]),
    .hash_value(dout[23])
);
md5 mach_24(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[24]),
    .data(din [24]),
    .busy(busy[24]),
    .valid(valid [24]),
    .echo(echo[24]),
    .hash_value(dout[24])
);
md5 mach_25(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[25]),
    .data(din [25]),
    .busy(busy[25]),
    .valid(valid [25]),
    .echo(echo[25]),
    .hash_value(dout[25])
);
md5 mach_26(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[26]),
    .data(din [26]),
    .busy(busy[26]),
    .valid(valid [26]),
    .echo(echo[26]),
    .hash_value(dout[26])
);
md5 mach_27(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[27]),
    .data(din [27]),
    .busy(busy[27]),
    .valid(valid [27]),
    .echo(echo[27]),
    .hash_value(dout[27])
);
md5 mach_28(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[28]),
    .data(din [28]),
    .busy(busy[28]),
    .valid(valid [28]),
    .echo(echo[28]),
    .hash_value(dout[28])
);
md5 mach_29(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en[29]),
    .data(din [29]),
    .busy(busy[29]),
    .valid(valid [29]),
    .echo(echo[29]),
    .hash_value(dout[29])
);


function [63:0] add;
    input [63:0] txt;
    begin
        add = txt;
        if(txt[ 7-:8] != "9") begin
            add[ 7-:8] = txt[ 7-:8]+1;
        end 
        else begin
            add[ 7-:8] = "0";
            if(txt[15-:8] != "9") begin
                add[15-:8] = txt[15-:8]+1;
            end
            else begin
                add[15-:8] = "0";
                if (txt[23-:8] != "9") begin
                    add[23-:8] = txt[23-:8]+1;
                end
                else begin
                    add[23-:8] = "0";
                    if(txt[31-:8] != "9") begin
                        add[31-:8] = txt[31-:8]+1;
                    end
                    else begin 
                        add[31-:8] = "0";
                        if(txt[39-:8] != "9") begin
                            add[39-:8] = txt[39-:8]+1;
                        end
                        else begin
                            add[39-:8] = "0";
                            if(txt[47-:8] != "9") begin
                                add[47-:8] = txt[47-:8]+1;
                            end
                            else begin
                                add[47-:8] = "0";
                                if(txt[55-:8] != "9") begin
                                    add[55-:8] = txt[55-:8]+1;
                                end
                                else begin
                                    add[55-:8] = "0";
                                    if(txt[63-:8] != "9") begin
                                        add[63-:8] = txt[63-:8]+1;
                                    end
                                    else begin
                                        add[63-:8] = "0";
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
endfunction

function [63:0] minus;
    input [63:0] txt;
    begin
        minus = txt;
        if(txt[ 7-:8] != "0") begin
            minus[ 7-:8] = txt[ 7-:8]-1;
        end 
        else begin
            minus[ 7-:8] = "9";
            if(txt[15-:8] != "0") begin
                minus[15-:8] = txt[15-:8]-1;
            end
            else begin
                minus[15-:8] = "9";
                if (txt[23-:8] != "0") begin
                    minus[23-:8] = txt[23-:8]-1;
                end
                else begin
                    minus[23-:8] = "9";
                    if(txt[31-:8] != "0") begin
                        minus[31-:8] = txt[31-:8]-1;
                    end
                    else begin 
                        minus[31-:8] = "9";
                        if(txt[39-:8] != "0") begin
                            minus[39-:8] = txt[39-:8]-1;
                        end
                        else begin
                            minus[39-:8] = "9";
                            if(txt[47-:8] != "0") begin
                                minus[47-:8] = txt[47-:8]-1;
                            end
                            else begin
                                minus[47-:8] = "9";
                                if(txt[55-:8] != "0") begin
                                    minus[55-:8] = txt[55-:8]-1;
                                end
                                else begin
                                    minus[55-:8] = "9";
                                    if(txt[63-:8] != "0") begin
                                        minus[63-:8] = txt[63-:8]-1;
                                    end
                                    else begin
                                        minus[63-:8] = "9";
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
endfunction

function [7:0] ascii;
    input [3:0] in;
    begin
        ascii = (in < 10 ? in + 48 : in + 55);
    end
endfunction

always@(posedge clk) begin
	if (~reset_n) prev_btn_level <= 1;
  	else prev_btn_level <= btn_level;
end

assign btn_pressed = (btn_level == 1 && prev_btn_level == 0);
assign usr_led = P;

//Timer
always@(posedge clk) begin
  	if (~reset_n) begin
    	timer <= 64'h30_30_30_30_30_30_30_30; // 8 ascii zero
    	clk_counter <= 0;
  	end
  	else if (P == S_MAIN_FIND || P == S_MAIN_POST || P == S_MAIN_SHOW) begin
	    if(clk_counter >= 100000)begin
	        timer <= add(timer);
	        clk_counter <= 0;
	    end else begin
	        clk_counter <= clk_counter + 1;
	    end
  	end
end

// FSM
always@(posedge clk) begin
  	if (~reset_n) P <= S_MAIN_INIT;
  	else P <= P_next;
end
always@(*) begin
	case (P)
	    S_MAIN_INIT:
	      	P_next = S_MAIN_WAIT;
	    S_MAIN_WAIT:
	      	if (btn_pressed) P_next = S_MAIN_FIND;
	      	else P_next = S_MAIN_WAIT;
	    S_MAIN_FIND:
	      	if (valid_counter >= 100000030 || found) P_next = S_MAIN_POST;
	      	else P_next = S_MAIN_FIND;
	    S_MAIN_POST:
	        if(post_counter >= mach) P_next = S_MAIN_SHOW;
	        else P_next = S_MAIN_POST;
	    S_MAIN_SHOW:
	      	P_next = S_MAIN_STOP;
	    S_MAIN_STOP:
	      	P_next = S_MAIN_STOP;
	    default:
	      	P_next = S_MAIN_INIT;
	endcase
end

always @(posedge clk) begin
  	if (~reset_n) begin
	    en <= 0;
	    found <= 0;
	    valid_counter <= 0;
	    post_counter <= 0;
	    text <= 64'h30_30_30_30_30_30_30_30; // 8 ascii zero
  	end else if (P == S_MAIN_FIND && valid_counter < 100000030 && !found) begin
	    if(valid[ 0])begin
	        if(dout[ 0] == passwd_hash)begin
	            result <= echo[ 0];
	            found <= 1;
	        end
            else
	            valid_counter <= valid_counter + 1;
	    end
		if(valid[ 1])begin
	        if(dout[ 1] == passwd_hash)begin
	            result <= echo[ 1];
	            found <= 1;
	        end
            else
	            valid_counter <= valid_counter + 1;
	    end
		if(valid[ 2])begin
	        if(dout[ 2] == passwd_hash)begin
	            result <= echo[ 2];
	            found <= 1;
	        end
            else
	            valid_counter <= valid_counter + 1;
	    end
		if(valid[ 3])begin
	        if(dout[ 3] == passwd_hash)begin
	            result <= echo[ 3];
	            found <= 1;
	        end
            else
	            valid_counter <= valid_counter + 1;
	    end
		if(valid[ 4])begin
	        if(dout[ 4] == passwd_hash)begin
	            result <= echo[ 4];
	            found <= 1;
	        end
            else
	            valid_counter <= valid_counter + 1;
	    end
		if(valid[ 5])begin
	        if(dout[ 5] == passwd_hash)begin
	            result <= echo[ 5];
	            found <= 1;
	        end
            else
	            valid_counter <= valid_counter + 1;
	    end
		if(valid[ 6])begin
	        if(dout[ 6] == passwd_hash)begin
	            result <= echo[ 6];
	            found <= 1;
	        end
            else
	            valid_counter <= valid_counter + 1;
	    end
		if(valid[ 7])begin
	        if(dout[ 7] == passwd_hash)begin
	            result <= echo[ 7];
	            found <= 1;
	        end
            else
	            valid_counter <= valid_counter + 1;
	    end
		if(valid[ 8])begin
	        if(dout[ 8] == passwd_hash)begin
	            result <= echo[ 8];
	            found <= 1;
	        end
            else
	            valid_counter <= valid_counter + 1;
	    end
		if(valid[ 9])begin
	        if(dout[ 9] == passwd_hash)begin
	            result <= echo[ 9];
	            found <= 1;
	        end
            else
	            valid_counter <= valid_counter + 1;
	    end
		if(valid[10])begin
			if(dout[10] == passwd_hash)begin
				result <= echo[10];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[11])begin
			if(dout[11] == passwd_hash)begin
				result <= echo[11];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[12])begin
			if(dout[12] == passwd_hash)begin
				result <= echo[12];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[13])begin
			if(dout[13] == passwd_hash)begin
				result <= echo[13];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[14])begin
			if(dout[14] == passwd_hash)begin
				result <= echo[14];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[15])begin
			if(dout[15] == passwd_hash)begin
				result <= echo[15];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[16])begin
			if(dout[16] == passwd_hash)begin
				result <= echo[16];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[17])begin
			if(dout[17] == passwd_hash)begin
				result <= echo[17];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[18])begin
			if(dout[18] == passwd_hash)begin
				result <= echo[18];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[19])begin
			if(dout[19] == passwd_hash)begin
				result <= echo[19];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[20])begin
			if(dout[20] == passwd_hash)begin
				result <= echo[20];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[21])begin
			if(dout[21] == passwd_hash)begin
				result <= echo[21];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[22])begin
			if(dout[22] == passwd_hash)begin
				result <= echo[22];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[23])begin
			if(dout[23] == passwd_hash)begin
				result <= echo[23];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
        if(valid[24])begin
			if(dout[24] == passwd_hash)begin
				result <= echo[24];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[25])begin
			if(dout[25] == passwd_hash)begin
				result <= echo[25];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[26])begin
			if(dout[26] == passwd_hash)begin
				result <= echo[26];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[27])begin
			if(dout[27] == passwd_hash)begin
				result <= echo[27];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[28])begin
			if(dout[28] == passwd_hash)begin
				result <= echo[28];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end
		if(valid[29])begin
			if(dout[29] == passwd_hash)begin
				result <= echo[29];
				found <= 1;
			end
            else
	            valid_counter <= valid_counter + 1;
		end



		if(~busy[ 0]) begin
	        en [ 0] = 1;
	        din[ 0] = text;
	        text = add(text);
	    end else if(~busy[ 1]) begin
	        en [ 1] = 1;
	        din[ 1] = text;
	        text = add(text);
	    end else if(~busy[ 2]) begin
	        en [ 2] = 1;
	        din[ 2] = text;
	        text = add(text);
	    end else if(~busy[ 3]) begin
	        en [ 3] = 1;
	        din[ 3] = text;
	        text = add(text);
	    end else if(~busy[ 4]) begin
	        en [ 4] = 1;
	        din[ 4] = text;
	        text = add(text);
	    end else if(~busy[ 5]) begin
	        en [ 5] = 1;
	        din[ 5] = text;
	        text = add(text);
	    end else if(~busy[ 6]) begin
	        en [ 6] = 1;
	        din[ 6] = text;
	        text = add(text);
	    end else if(~busy[ 7]) begin
	        en [ 7] = 1;
	        din[ 7] = text;
	        text = add(text);
	    end else if(~busy[ 8]) begin
	        en [ 8] = 1;
	        din[ 8] = text;
	        text = add(text);
	    end else if(~busy[ 9]) begin
	        en [ 9] = 1;
	        din[ 9] = text;
	        text = add(text);
		end else if(~busy[10]) begin
	        en [10] = 1;
	        din[10] = text;
	        text = add(text);
	    end else if(~busy[11]) begin
	        en [11] = 1;
	        din[11] = text;
	        text = add(text);
	    end else if(~busy[12]) begin
	        en [12] = 1;
	        din[12] = text;
	        text = add(text);
	    end else if(~busy[13]) begin
	        en [13] = 1;
	        din[13] = text;
	        text = add(text);
	    end else if(~busy[14]) begin
	        en [14] = 1;
	        din[14] = text;
	        text = add(text);
	    end else if(~busy[15]) begin
	        en [15] = 1;
	        din[15] = text;
	        text = add(text);
	    end else if(~busy[16]) begin
	        en [16] = 1;
	        din[16] = text;
	        text = add(text);
	    end else if(~busy[17]) begin
	        en [17] = 1;
	        din[17] = text;
	        text = add(text);
	    end else if(~busy[18]) begin
	        en [18] = 1;
	        din[18] = text;
	        text = add(text);
	    end else if(~busy[19]) begin
	        en [19] = 1;
	        din[19] = text;
	        text = add(text);
		end else if(~busy[20]) begin
	        en [20] = 1;
	        din[20] = text;
	        text = add(text);
	    end else if(~busy[21]) begin
	        en [21] = 1;
	        din[21] = text;
	        text = add(text);
	    end else if(~busy[22]) begin
	        en [22] = 1;
	        din[22] = text;
	        text = add(text);
	    end else if(~busy[23]) begin
	        en [23] = 1;
	        din[23] = text;
	        text = add(text);
	    end else if(~busy[24]) begin
	        en [24] = 1;
	        din[24] = text;
	        text = add(text);
	    end else if(~busy[25]) begin
	        en [25] = 1;
	        din[25] = text;
	        text = add(text);
	    end else if(~busy[26]) begin
	        en [26] = 1;
	        din[26] = text;
	        text = add(text);
	    end else if(~busy[27]) begin
	        en [27] = 1;
	        din[27] = text;
	        text = add(text);
	    end else if(~busy[28]) begin
	        en [28] = 1;
	        din[28] = text;
	        text = add(text);
	    end else if(~busy[29]) begin
	        en [29] = 1;
	        din[29] = text;
	        text = add(text);
        end

  	end else if (P == S_MAIN_POST && post_counter < mach) begin
	    result = minus(result);
	    post_counter = post_counter + 1;
  	end
end

always @(posedge clk) begin
  	if (~reset_n) begin
	    row_A = "Press BTN3 to   ";
	    row_B = "show a message..";
  	end else if (P == S_MAIN_WAIT) begin
	    row_A = "Press BTN3 to   ";
	    row_B = "crack a md5 code";
	end else if (P == S_MAIN_FIND) begin
	    row_A <= {"Checked:",text};
	    row_B <= {"Time: ",timer[55:0]," ms"};
  	end else if (P == S_MAIN_SHOW) begin
	    if(found) row_A <= {"Passwd: ",result};
	    else row_A <= {"Passwd not found"};
	    row_B <= {"Time: ",timer[55:0]," ms"};
  	end
end
endmodule
