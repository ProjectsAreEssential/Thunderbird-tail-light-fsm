// Logic to compute next-state bits
module thunderbird_combo(
	Q2, Q1, Q0, L, R, H,
	Q2next, Q1next, Q0next,
	Lc, Lb, La, Ra, Rb, Rc
);

	// Declare inputs and outputs
	input Q2, Q1, Q0, L, R, H;
	output Q2next, Q1next, Q0next;
	output Lc, Lb, La, Ra, Rb, Rc;

	// Inverted signals
	wire not_Q2, not_Q1, not_Q0, not_L, not_R, not_H;

	// Product terms for tail lights
	wire q1_q0;
	wire not_q2_q1, not_q2_q0;
	wire q2_q0, q2_q1;

	// Product terms for next-state logic
	wire idle_state, haz_state;
	wire l1_state, l2_state, l3_state;
	wire r1_state, r2_state, r3_state;
	wire go_haz, go_left1, go_right1;
	wire n2_t1, n2_t2, n2_t3;
	wire n1_t1, n1_t2, n1_t3;
	wire n0_t1, n0_t2;

	// Inverters
	not(not_Q2, Q2);
	not(not_Q1, Q1);
	not(not_Q0, Q0);
	not(not_L, L);
	not(not_R, R);
	not(not_H, H);

	// Tail Light Output Logic

	// Lc = Q1 * Q0
	and(q1_q0, Q1, Q0);
	or(Lc, q1_q0, q1_q0);

	// Lb = (~Q2 * Q1) + (Q1 * Q0)
	and(not_q2_q1, not_Q2, Q1);
	or(Lb, not_q2_q1, q1_q0);

	// La = (~Q2 * Q0) + (~Q2 * Q1) + (Q1 * Q0)
	and(not_q2_q0, not_Q2, Q0);
	or(La, not_q2_q0, not_q2_q1, q1_q0);

	// Ra = Q2
	or(Ra, Q2, Q2);

	// Rb = (Q2 * Q0) + (Q2 * Q1)
	and(q2_q0, Q2, Q0);
	and(q2_q1, Q2, Q1);
	or(Rb, q2_q0, q2_q1);

	// Rc = Q2 * Q1
	or(Rc, q2_q1, q2_q1);

	// Present State
	and(idle_state, not_Q2, not_Q1, not_Q0);
	and(haz_state, Q2, Q1, Q0);

	and(l1_state, not_Q2, not_Q1, Q0);
	and(l2_state, not_Q2, Q1, not_Q0);
	and(l3_state, not_Q2, Q1, Q0);
	and(r1_state, Q2, not_Q1, not_Q0);
	and(r2_state, Q2, not_Q1, Q0);
	and(r3_state, Q2, Q1, not_Q0);

	// Conditions from idle (000)
	and(go_haz, idle_state, H);
	and(go_left1, idle_state, not_H, L, not_R);
	and(go_right1, idle_state, not_H, R, not_L);

	// Q2next: 111 (hazard entry), 100 (R1), 101 (R2), 110 (R3)
	and(n2_t1, r1_state, not_H);
	and(n2_t2, r2_state, not_H);
	and(n2_t3, r3_state, not_H);
	or(Q2next, go_haz, go_right1, n2_t1, n2_t2, n2_t3);

	// Q1next: 111 (hazard entry), 010 (L2), 011 (L3), 110 (R3)
	and(n1_t1, l1_state, not_H);
	and(n1_t2, l2_state, not_H);
	and(n1_t3, r2_state, not_H);
	or(Q1next, go_haz, n1_t1, n1_t2, n1_t3);

	// Q0next: 111 (hazard entry), 001 (L1), 011 (L3), 101 (R2)
	and(n0_t1, l2_state, not_H);
	and(n0_t2, r1_state, not_H);
	or(Q0next, go_haz, go_left1, n0_t1, n0_t2);
endmodule

// Connecting logic to 3 D flip-flops
module thunderbird_main(
	clk, clear, L, R, H,
	Q2, Q1, Q0,
	Lc, Lb, La, Ra, Rb, Rc
);

	// Declare inputs and outputs
	input clk, clear, L, R, H;
	output Q2, Q1, Q0;
	output Lc, Lb, La, Ra, Rb, Rc;

	// Current state and next-state wires
	wire Q2, Q1, Q0;
	wire Q2_bar, Q1_bar, Q0_bar;
	wire Q2next, Q1next, Q0next;

	// Instantiate subcircuit
	thunderbird_combo u_combo(
  		.Q2(Q2), .Q1(Q1), .Q0(Q0),
  		.L(L), .R(R), .H(H),
  		.Q2next(Q2next), .Q1next(Q1next), .Q0next(Q0next),
  		.Lc(Lc), .Lb(Lb), .La(La),
  		.Ra(Ra), .Rb(Rb), .Rc(Rc)
	);

	// Instantiate three D flip-flops for state bits Q2, Q1, Q0
	dff ff2(.d(Q2next), .clk(clk), .clear(clear), .q(Q2), .q_bar(Q2_bar));
	dff ff1(.d(Q1next), .clk(clk), .clear(clear), .q(Q1), .q_bar(Q1_bar));
	dff ff0(.d(Q0next), .clk(clk), .clear(clear), .q(Q0), .q_bar(Q0_bar));
endmodule

// Provided D flip-flop module with active-low clear
module dff(d,clk,clear,q,q_bar);

	// Inputs and outputs -- note that this flipflop has clear but not preset
	input d,clk,clear;
	output q, q_bar;

	// Internal signals
	wire n1,n2,n3,q_bar_n;
	wire cn,dn,n4,n5,n6;

	// First Latch
	not (n1,d);
	nand (n2,d,clk);
	nand (n3,n1,clk);
	nand (dn,q_bar_n,n2);
	nand (q_bar_n,dn,n3,clear);

	// Inverter on the clock
	not (cn,clk);

	// Second Latch
	not (n4,dn);
	nand (n5,dn,cn);
	nand (n6,n4,cn);
	nand (q,q_bar,n5);
	nand (q_bar,q,n6,clear);
endmodule