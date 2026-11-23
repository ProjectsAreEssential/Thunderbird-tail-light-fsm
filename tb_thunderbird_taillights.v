/*
 * This is a testbench file for thunberbird_taillights
 * Author: Gavin Gray
 */

// Testbench driving 64 clock cycles to verify Thunderbird FSM states and lamp outputs.
module thunderbird_tb();

// Inputs sent to thunderbird_main()
reg clk, clear, L, R, H;

// Outputs received from thunderbird_main()
wire Q2, Q1, Q0;
wire Lc, Lb, La, Ra, Rb, Rc;

// Instantiate top-level module
thunderbird_main uut(
	.clk(clk), .clear(clear), .L(L), .R(R), .H(H),
	.Q2(Q2), .Q1(Q1), .Q0(Q0),
	.Lc(Lc), .Lb(Lb), .La(La),
	.Ra(Ra), .Rb(Rb), .Rc(Rc)
);

// 64 clock cycles
initial begin
	clk = 0;
    #50 clk = 1; #50 clk = 0; // cycle 1
	#50 clk = 1; #50 clk = 0; // cycle 2
    #50 clk = 1; #50 clk = 0; // cycle 3
    #50 clk = 1; #50 clk = 0; // cycle 4
    #50 clk = 1; #50 clk = 0; // cycle 5
    #50 clk = 1; #50 clk = 0; // cycle 6
    #50 clk = 1; #50 clk = 0; // cycle 7
    #50 clk = 1; #50 clk = 0; // cycle 8
    #50 clk = 1; #50 clk = 0; // cycle 9
    #50 clk = 1; #50 clk = 0; // cycle 10
    #50 clk = 1; #50 clk = 0; // cycle 11
    #50 clk = 1; #50 clk = 0; // cycle 12
    #50 clk = 1; #50 clk = 0; // cycle 13
    #50 clk = 1; #50 clk = 0; // cycle 14
    #50 clk = 1; #50 clk = 0; // cycle 15
    #50 clk = 1; #50 clk = 0; // cycle 16
    #50 clk = 1; #50 clk = 0; // cycle 17
    #50 clk = 1; #50 clk = 0; // cycle 18
    #50 clk = 1; #50 clk = 0; // cycle 19
    #50 clk = 1; #50 clk = 0; // cycle 20
    #50 clk = 1; #50 clk = 0; // cycle 21
    #50 clk = 1; #50 clk = 0; // cycle 22
    #50 clk = 1; #50 clk = 0; // cycle 23
    #50 clk = 1; #50 clk = 0; // cycle 24
    #50 clk = 1; #50 clk = 0; // cycle 25
    #50 clk = 1; #50 clk = 0; // cycle 26
    #50 clk = 1; #50 clk = 0; // cycle 27
    #50 clk = 1; #50 clk = 0; // cycle 28
    #50 clk = 1; #50 clk = 0; // cycle 29
    #50 clk = 1; #50 clk = 0; // cycle 30
    #50 clk = 1; #50 clk = 0; // cycle 31
    #50 clk = 1; #50 clk = 0; // cycle 32
    #50 clk = 1; #50 clk = 0; // cycle 33
    #50 clk = 1; #50 clk = 0; // cycle 34
    #50 clk = 1; #50 clk = 0; // cycle 35
    #50 clk = 1; #50 clk = 0; // cycle 36
    #50 clk = 1; #50 clk = 0; // cycle 37
    #50 clk = 1; #50 clk = 0; // cycle 38
    #50 clk = 1; #50 clk = 0; // cycle 39
    #50 clk = 1; #50 clk = 0; // cycle 40
    #50 clk = 1; #50 clk = 0; // cycle 41
    #50 clk = 1; #50 clk = 0; // cycle 42
    #50 clk = 1; #50 clk = 0; // cycle 43
    #50 clk = 1; #50 clk = 0; // cycle 44
    #50 clk = 1; #50 clk = 0; // cycle 45
    #50 clk = 1; #50 clk = 0; // cycle 46
    #50 clk = 1; #50 clk = 0; // cycle 47
    #50 clk = 1; #50 clk = 0; // cycle 48
    #50 clk = 1; #50 clk = 0; // cycle 49
    #50 clk = 1; #50 clk = 0; // cycle 50
    #50 clk = 1; #50 clk = 0; // cycle 51
    #50 clk = 1; #50 clk = 0; // cycle 52
    #50 clk = 1; #50 clk = 0; // cycle 53
    #50 clk = 1; #50 clk = 0; // cycle 54
    #50 clk = 1; #50 clk = 0; // cycle 55
    #50 clk = 1; #50 clk = 0; // cycle 56
    #50 clk = 1; #50 clk = 0; // cycle 57
    #50 clk = 1; #50 clk = 0; // cycle 58
    #50 clk = 1; #50 clk = 0; // cycle 59
    #50 clk = 1; #50 clk = 0; // cycle 60
    #50 clk = 1; #50 clk = 0; // cycle 61
    #50 clk = 1; #50 clk = 0; // cycle 62
    #50 clk = 1; #50 clk = 0; // cycle 63
    #50 clk = 1; #50 clk = 0; // cycle 64
end

// Different states
initial begin
	// Cycle 1: Clear state to 000
	clear = 0; L = 0; R = 0; H = 0; #100;

    // Cycle 2: Release clear and hold idle (000)
    clear = 1; #100;

    // Cycles 3-6: Left turn sequence (001 -> 010 -> 011 -> 000)
    L = 1; R = 0; H = 0; #400;

    // Cycle 7: Return to idle (000)
    L = 0; R = 0; H = 0; #100;

    // Cycles 8-11: Right turn sequence (100 -> 101 -> 110 -> 000)
    L = 0; R = 1; H = 0; #400;

    // Cycle 12: Return to idle (000)
    L = 0; R = 0; H = 0; #100;

    // Cycle 13: Hazard mode (111)
    L = 0; R = 0; H = 1; #100;

    // Cycle 14: Exit hazard back to idle (000)
    L = 0; R = 0; H = 0; #100;

    // Cycles 15-64: Hold idle to observe full 64-cycle waveform
    #5000;
end

endmodule