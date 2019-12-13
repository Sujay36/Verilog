module TestMod;
   parameter STDIN = 32'h8000_0000; // keyboard-input file-handle address

   reg clk;
   reg [6:0] str [1:8];  // to what's to be entered
   wire match;           // to be set 1 when matched
   reg [6:0] ascii;      // each input letter is an ASCII bitmap

   RecognizerMod my_recognizer(clk, ascii, match);

   initial begin
      $display("Enter the the magic sequence: ");
      str[1] = $fgetc(STDIN);  // 1st letter
      str[2] = $fgetc(STDIN);
      str[3] = $fgetc(STDIN);
      str[4] = $fgetc(STDIN);
      str[5] = $fgetc(STDIN);
      str[6] = $fgetc(STDIN);
      str[7] = $fgetc(STDIN);
      str[8] = $fgetc(STDIN);
      $display("Time clk    ascii       match");
      $monitor("%4d   %b    %c %b   %b", $time, clk, ascii, ascii, match);

      clk = 0;

      ascii = str[1];
      #1 clk = 1; #1 clk = 0;
      ascii = str[2];
      #1 clk = 1; #1 clk = 0;
      ascii = str[3];
      #1 clk = 1; #1 clk = 0;
      ascii = str[4];
      #1 clk = 1; #1 clk = 0;
	  ascii = str[5];
      #1 clk = 1; #1 clk = 0;
      ascii = str[6];
      #1 clk = 1; #1 clk = 0;
      ascii = str[7];
      #1 clk = 1; #1 clk = 0;
      ascii = str[8];
      #1 clk = 1; #1 clk = 0;

   end
endmodule



module RecognizerMod(clk, ascii, match);
   input clk;
   input [6:0] ascii;
   output match;

   wire [0:4] Q [0:6];
   wire [6:0] submatch;  // all bits matched (7 5-bit sequences)

   //inverted wires
   wire invQ54, invQ44, invQ43, invQ41, invQ40, invQ33, invQ32, invQ31;
   wire invQ24, invQ22, invQ13, invQ11, invQ10, invQ04, invQ02;
   
   //         654 3210   Q
   //     hex binary
   // 'A' 41  100 0001 < q4
   // 'l' 6C  110 1100 < q3
   // 'e' 65  110 0101 < q2
   // 'x' 78  111 1000 < q1
   // 'a' 61  110 0001 < q0

   RippleMod Ripple6(clk, ascii[6], Q[6]);
   RippleMod Ripple5(clk, ascii[5], Q[5]);
   RippleMod Ripple4(clk, ascii[4], Q[4]);
   RippleMod Ripple3(clk, ascii[3], Q[3]);
   RippleMod Ripple2(clk, ascii[2], Q[2]);
   RippleMod Ripple1(clk, ascii[1], Q[1]);
   RippleMod Ripple0(clk, ascii[0], Q[0]);
   
   
   //bit 6
   and(submatch[6], Q[6][4], Q[6][3], Q[6][2], Q[6][1], Q[6][0]);
   
   //bit 5
   not(invQ54, Q[5][4]);
   and(submatch[5], invQ54, Q[5][3], Q[5][2], Q[5][1], Q[5][0]);
   
   //bit 4
   not(invQ44, Q[4][4]);
   not(invQ43, Q[4][3]);
   not(invQ42, Q[4][2]);
   not(invQ40, Q[4][0]);
   and(submatch[4], invQ44, invQ43, invQ42, Q[4][1], invQ40);
   
   //bit 3
   not(invQ34, Q[3][4]);
   not(invQ32, Q[3][2]);
   not(invQ30, Q[3][0]);
   and(submatch[3], invQ34, Q[3][3], invQ32, Q[3][1], invQ30);
   
   //bit 2
   not(invQ24, Q[2][4]);
   not(invQ21, Q[2][1]);
   not(invQ20, Q[2][0]);
   and(submatch[2], invQ24, Q[2][3], Q[2][2], invQ21, invQ20);
   
   //bit 1
   not(invQ14, Q[1][4]);
   not(invQ13, Q[1][3]);
   not(invQ12, Q[1][2]);
   not(invQ11, Q[1][1]);
   not(invQ10, Q[1][0]);
   and(submatch[1], invQ14, invQ13, invQ12, invQ11, invQ10);
   
   //bit 0
   not(invQ03, Q[0][3]);
   not(invQ01, Q[0][1]);
   and(submatch[0], Q[0][4], invQ03, Q[0][2], invQ01, Q[0][0]);
   
   //full matcher
   and(match, submatch[6], submatch[5], submatch[4], submatch[3], submatch[2], submatch[1], submatch[0]);

endmodule


module RippleMod(clk, ascii_bit, q);
   input clk, ascii_bit;
   output [0:4] q;

   reg [0:4] q;          // flipflops

   always @(posedge clk) begin
      q[0] <= ascii_bit;
      q[1] <= q[0];
      q[2] <= q[1];
      q[3] <= q[2];
      q[4] <= q[3];
   end

   initial q = 5'bxxxxx;
endmodule