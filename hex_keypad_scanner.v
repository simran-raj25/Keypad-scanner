
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2024 12:14:27 AM
// Design Name: 
// Module Name: hex_keypad_scanner
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hex_keypad_scanner( 

  
    input [3:0] Row,
    input S_Row,
    input clock,
    input reset,
    output reg [3:0] Code,
    output Valid,
    output reg [3:0] Col,
    output reg [5:0] state
    );
    
    
    
   // One-hot encoding
    parameter S_0 = 6'b000001, S_1 = 6'b000010, S_2 = 6'b000100;
    parameter S_3 = 6'b001000, S_4 = 6'b010000, S_5 = 6'b100000;
    
    reg [5: 0]  next_state; 
    
  
    
    always@ (state or S_Row or Row)                 // Next-state logic
    begin 
    next_state = state; 
    Col = 0;
    case (state)
        //Assert all columns
        S_0: begin Col = 15; if (S_Row) next_state =S_1; end
        //Assert column 0
        S_1: begin Col = 1; if (Row) next_state = S_5; else next_state = S_2; end
        //Assert column 1
        S_2: begin Col = 2; if (Row) next_state = S_5; else next_state = S_3; end
        // Assert column 2
        S_3: begin Col = 4; if (Row) next_state = S_5; else next_state= S_4; end
       // Assert column 3k
        S_4: begin Col = 8; if (Row) next_state = S_5; else next_state = S_0; end
        // Assert all rows
        S_5: begin Col = 15; if (Row ==0) next_state = S_0; end
    endcase
    end
    
      assign Valid = ((state == S_1) || (state == S_2) || (state == S_3) || (state == S_4)) && Row;
    
    always @ (Row or Col) begin 
    case ({Row, Col})
        8'b0001_0001: Code = 0; 
        8'b0001_0010: Code = 1;
        8'b0001_0100: Code = 2; 
        8'b0001_1000: Code = 3;
        8'b0010_0001: Code = 4; 
        8'b0010_0010: Code = 5;
        8'b0010_0100: Code = 6;
        8'b0010_1000: Code = 7;
        8'b0100_0001: Code = 8;
        8'b0100_0010: Code = 9;
        8'b0100_0100: Code = 10;        //A
        8'b0100_1000: Code = 11;        //B
        8'b1000_0001: Code = 12;        //C
        8'b1000_0010: Code = 13;        //D
        8'b1000_0100: Code = 14;        //E
        8'b1000_1000: Code = 15;        //F
        default: Code = 0;                     //Arbitrary choice
    endcase
    end 
    always @(posedge clock or posedge reset) begin
    if (reset) state <= S_0;
    else state <= next_state;
    end
endmodule
