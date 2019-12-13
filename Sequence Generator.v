module TestMod;
   reg CLK;
   wire [0:16] Q;
   wire [0:7] C;

   always begin
      #1
      CLK = 1;
      #1;
      CLK = 0;
      #1;
   end

   RippleMod my_rip(CLK, Q);
   CoderMod my_c(Q, C);

   initial #49 $finish;

   initial begin
    
      $display("Time  \t CLK     Q                  Name");
      $monitor("%0d     \t  %b      %b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b    %c", $time, CLK, Q[0], Q[1], Q[2], Q[3], Q[4], Q[5], Q[6], Q[7], Q[8], Q[9], Q[10], Q[11], Q[12], Q[13], Q[14],Q[15], Q[16], C);

   end
endmodule

module CoderMod(Q, C);
   input [0:16]Q;
   output [0:7]C;

   nor(C[0],Q[0],Q[1],Q[2],Q[3],Q[4],Q[5],Q[6],Q[7],Q[8],Q[9],Q[10],Q[11],Q[12],Q[13],Q[14],Q[15],Q[16]);
   or (C[1],Q[0],Q[1],Q[2],Q[3],Q[4],Q[5],Q[6],Q[7],Q[9],Q[10],Q[11],Q[12],Q[13],Q[14],Q[15]);
   or (C[2],Q[1],Q[2],Q[3],Q[4],Q[5],Q[6],Q[7],Q[8],Q[10],Q[11],Q[12],Q[13],Q[14],Q[15],Q[16]);
   or (C[3],Q[3],Q[7],Q[11]);
   or (C[4],Q[1],Q[3],Q[5],Q[9],Q[10],Q[13],Q[14],Q[15]);
   or (C[5],Q[1],Q[2],Q[5],Q[6],Q[9],Q[10],Q[12],Q[13],Q[15]);
   or (C[6],Q[5],Q[7],Q[9],Q[10],Q[11],Q[13],Q[14],Q[15]);
   or (C[7],Q[0],Q[2],Q[4],Q[10],Q[11],Q[12],Q[14],Q[15]);
   

endmodule

module RippleMod(CLK, Q);
   input CLK;
   output [0:16]Q;

   reg [0:16]Q;

    always @(CLK) begin
      Q[0] <= Q[16]; 
      Q[1] <= Q[0];
      Q[2] <= Q[1];
      Q[3] <= Q[2];
      Q[4] <= Q[3];
      Q[5] <= Q[4];
      Q[6] <= Q[5];
      Q[7] <= Q[6];
      Q[8] <= Q[7];
      Q[9] <= Q[8];
      Q[10] <= Q[9];
      Q[11] <= Q[10];
      Q[12] <= Q[11];
      Q[13] <= Q[12];
      Q[14] <= Q[13];
      Q[15] <= Q[14];
      Q[16] <= Q[15];
      
   end

   initial begin
      Q[0] = 1;
      Q[1] = 0;
      Q[2] = 0;
      Q[3] = 0;
      Q[4] = 0;
      Q[5] = 0;
      Q[6] = 0;
      Q[7] = 0;
      Q[8] = 0;
      Q[9] = 0;
      Q[10] = 0;
      Q[11] = 0;
      Q[12] = 0;
      Q[13] = 0;
      Q[14] = 0;
      Q[15] = 0;
      Q[16] = 0;
// Q[16:0] =  17'b0000 0000 0000 00001
   end
endmodule