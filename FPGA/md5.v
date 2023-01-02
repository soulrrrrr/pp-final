`timescale 1ns / 1ps
module md5(
    input clk,
    input reset_n,
    input enable,
    input [63:0] data,
    output busy,
    output valid,
    output reg [63:0] echo,
    output reg [127:0] hash_value
);

localparam [1:0] S_MAIN_INIT = 0, S_MAIN_WAIT = 1, S_MAIN_FIND = 2, S_MAIN_SHOW = 3;
reg [1:0] Q, Q_next;
reg [7:0] r [0:63];
reg [31:0] k [0:63];
reg [3:0] x [0:63];
reg [31:0] h0;
reg [31:0] h1;
reg [31:0] h2;
reg [31:0] h3;
reg [31:0] a,b,c,d,f,g,u,temp;
reg [31:0] w [15:0];
reg [6:0] inner_counter;
reg [2:0] case_num;

assign valid = (Q == S_MAIN_SHOW);
assign busy =  (Q != S_MAIN_WAIT);


initial begin
    $readmemh("r.mem", r); // r.mem stores hex number 
    $readmemh("k.mem", k); // k.mem stores hex number 
    $readmemh("x.mem", x); // x.mem stores hex number
end

function [31:0] left_rotate;
    input [31:0] in;
    input [4:0] offset;
    begin
        case(offset)
            0:
                left_rotate = in;
            1:
                left_rotate = {in[30:0],in[31]};
            2:
                left_rotate = {in[29:0],in[31:30]};
            3:
                left_rotate = {in[28:0],in[31:29]};
            4:
                left_rotate = {in[27:0],in[31:28]};
            5:
                left_rotate = {in[26:0],in[31:27]};
            6:
                left_rotate = {in[25:0],in[31:26]};
            7:
                left_rotate = {in[24:0],in[31:25]};
            8:
                left_rotate = {in[23:0],in[31:24]};
            9:
                left_rotate = {in[22:0],in[31:23]};
            10:
                left_rotate = {in[21:0],in[31:22]};
            11:
                left_rotate = {in[20:0],in[31:21]};
            12:
                left_rotate = {in[19:0],in[31:20]};
            13:
                left_rotate = {in[18:0],in[31:19]};
            14:
                left_rotate = {in[17:0],in[31:18]};
            15:
                left_rotate = {in[16:0],in[31:17]};
            16:
                left_rotate = {in[15:0],in[31:16]};
            17:
                left_rotate = {in[14:0],in[31:15]};
            18:
                left_rotate = {in[13:0],in[31:14]};
            19:
                left_rotate = {in[12:0],in[31:13]};
            20:
                left_rotate = {in[11:0],in[31:12]};
            21:
                left_rotate = {in[10:0],in[31:11]};
            22:
                left_rotate = {in[ 9:0],in[31:10]};
            23:
                left_rotate = {in[ 8:0],in[31: 9]};
            24:
                left_rotate = {in[ 7:0],in[31: 8]};
            25:
                left_rotate = {in[ 6:0],in[31: 7]};
            26:
                left_rotate = {in[ 5:0],in[31: 6]};
            27:
                left_rotate = {in[ 4:0],in[31: 5]};
            28:
                left_rotate = {in[ 3:0],in[31: 4]};
            29:
                left_rotate = {in[ 2:0],in[31: 3]};
            30:
                left_rotate = {in[ 1:0],in[31: 2]};
            31:
                left_rotate = {in[   0],in[31: 1]};
            default:
                left_rotate = in;
        endcase
    end
    //left_rotate = (in << c) | (in >> (32 - c));
endfunction

// FSM
always @(posedge clk) begin
  if (~reset_n) begin
    Q <= S_MAIN_INIT;
  end
  else begin
    Q <= Q_next;
  end
end

always @(*) begin
  case (Q)
    S_MAIN_INIT:
      Q_next = S_MAIN_WAIT;
    S_MAIN_WAIT:
      if (enable) Q_next = S_MAIN_FIND;
      else Q_next = S_MAIN_WAIT;
    S_MAIN_FIND:
      if (inner_counter >= 64) Q_next = S_MAIN_SHOW;
      else Q_next = S_MAIN_FIND;
    S_MAIN_SHOW:
      Q_next = S_MAIN_INIT;
  endcase
end


always @(posedge clk) begin
  if (~reset_n || Q == S_MAIN_INIT) begin
      h0 = 32'h67452301;
      h1 = 32'hefcdab89;
      h2 = 32'h98badcfe;
      h3 = 32'h10325476;
      // for each 512-bit chunk of message
      // break chunk into sixteen 32-bit words w[j], 0 ? j ? 15
      w[0] = 32'h0;
      w[1] = 32'h0;
      w[2] = 32'h0;
      w[14] = 32'h0;
      a = h0;
      b = h1;
      c = h2;
      d = h3;
      
      inner_counter = 0;
      case_num = 0;  
      echo = 0;
  end else if (Q == S_MAIN_WAIT && enable) begin
      echo = data;
      // last 8 bytes of the last 512-bit block contains the 
      // bit length of the original message
      w[0] = {data[39-:8],data[47-:8],data[55-:8],data[63-:8]};
      w[1] = {data[ 7-:8],data[15-:8],data[23-:8],data[31-:8]};
      w[2] = 32'h80;
      w[14] = 32'h40;
  end else if (Q == S_MAIN_FIND && inner_counter < 64) begin
        case (case_num)
            0: begin
                if(inner_counter < 16)begin
                    f = (b & c) | ((~b) & d);
                end else if (inner_counter < 32) begin
                    f = (d & b) | ((~d) & c);
                end else if (inner_counter < 48) begin
                    f = b ^ c ^ d;
                end else begin
                    f = c ^ (b | (~d));
                end
                g = x[inner_counter]; // x.mem stores g value // have been process first in x.mem
                temp = d;
                d = c;
                c = b;
                u = a+f+k[inner_counter]+w[g];
                case_num = 1; // next case
            end
            1:begin
                b = b + left_rotate(u,r[inner_counter]);
                a = temp;
                inner_counter = inner_counter + 1;
                case_num = 0; // previous case
            end
        endcase
  end else if (Q == S_MAIN_SHOW) begin
        // Add this chunk's hash to the result so far:
        h0 = h0 + a;
        h1 = h1 + b;
        h2 = h2 + c;
        h3 = h3 + d;
        hash_value = {h0[7-:8],h0[15-:8],h0[23-:8],h0[31-:8],
        h1[7-:8],h1[15-:8],h1[23-:8],h1[31-:8],
        h2[7-:8],h2[15-:8],h2[23-:8],h2[31-:8],
        h3[7-:8],h3[15-:8],h3[23-:8],h3[31-:8]};
  end
end
endmodule
