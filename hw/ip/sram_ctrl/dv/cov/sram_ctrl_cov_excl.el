// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// The following exclusions were manually added.

// The reason for this exclusion is the same as for the rv_dm module (see lowRISC/opentitan#24276).
// In tlul_lc_gate, there is an FSM state called StFlush. The intention is that when the gate is
// open (in state StActive), a flush request causes us to go into the StFlush state, where we block
// commands. The u_tlul_lc_gate instance has the flush_req_i input wired to zero but UNR doesn't
// mark the StFlush state as unreachable. We could get there by disabling and enabling debug on two
// consecutive cycles (going through states StActive, StOutstanding, StFlush, StActive). Disabling
// debug a second time on the third cycle would replace the last state (StActive) with StError.
//
// While this sequence is theoretically possible, the "glitchy" transition between StActive and
// StError doesn't really correspond to something we expect to see. We're testing this state and its
// transitions for other instances of the module (where flush_req_i is not always zero), so we don't
// have any risk of a bug in the module not being seen.
INSTANCE: tb.dut.u_tlul_lc_gate
Fsm state_q "3443824386"
State StFlush "76"
Transition StFlush->StActive "76->289"
Transition StFlush->StError "76->186"
Transition StOutstanding->StFlush "231->76"

// The following excludes the `if (outstanding_txn != '0)` condition in the `StErrorOutstanding`
// state of the FSM inside the tlul_lc_gate module.
//
// There are two possible ways of entering the `StErrorOutstanding` state:
// - (1) When the `lc_en_i` signal gets invalid, we follow `StActive -> StOutstanding -> StError`.
//       We only can escape the `StError` state and enter `StErrorOutstanding` when the `lc_en_i`
//       signal gets again valid.
// - (2) The reset default state of this FSM is `StError`. When the `lc_en_i` signal gets valid, we
//       enter the `StErrorOutstanding` state.
//
// (1) cannot happen in the `sram_ctrl module` as in this module `lc_en_i` is driven by the local
// escalation register. Once we have escalated, we cannot set `lc_en_i` valid anymore.
//
// (2) happens as in the `sram_ctrl module` the `lc_en_i` is valid at reset. Hence, at reset, the
// FSM immediately follows `StError` (cycle 0) -> `StErrorOutstanding` (cycle 1). To meet the
// condition we are excluding here (i.e., `outstanding_txn` is nonzero), we would need no enqueue
// a transaction in cycle 0. This would definitely be possible in the DV environment. However,
// for Earl Grey this cannot happen as the only host that accesses the SRAM is Ibex. As the
// boot address of Ibex points to the ROM and not the SRAM controller, a TL-UL request to the
// SRAM in the first cycle cannot happen.
CHECKSUM: "998580748 3219254590"
INSTANCE: tb.dut.u_tlul_lc_gate
Branch 2 "1850090820" "state_q" (12) "state_q StErrorOutstanding ,-,-,-,-,-,-,0"

// The following exclusions were generated by UNR.
CHECKSUM: "3523621980"
ANNOTATION: "[UNR] all inputs are constant"
INSTANCE:tb.dut.u_seed_anchor.u_secure_anchor_buf.gen_generic.u_impl_generic

CHECKSUM: "1424864498"
ANNOTATION: "[UNR] all inputs are constant"
INSTANCE:tb.dut.u_tlul_adapter_sram.u_tlul_data_integ_enc_instr.u_data_gen

CHECKSUM: "1424864498"
ANNOTATION: "[UNR] all inputs are constant"
INSTANCE:tb.dut.u_tlul_adapter_sram.u_tlul_data_integ_enc_data.u_data_gen

CHECKSUM: "2503688253 3812101441"
INSTANCE: tb.dut.u_reg_regs.u_reg_if.u_rsp_intg_gen
ANNOTATION: "[UNR] all inputs are constant"
Block 1 "461445014" "assign rsp_intg = tl_i.d_user.rsp_intg;"
ANNOTATION: "[UNR] all inputs are constant"
Block 2 "2643129081" "assign data_intg = tl_i.d_user.data_intg;"

CHECKSUM: "281300783 1779845869"
INSTANCE: tb.dut.u_reg_regs.u_status_bus_integ_error.wr_en_data_arb
ANNOTATION: "[UNR] all inputs are constant"
Block 2 "1620753216" "assign wr_data = d;"
INSTANCE: tb.dut.u_reg_regs.u_status_init_error.wr_en_data_arb
ANNOTATION: "[UNR] all inputs are constant"
Block 2 "1620753216" "assign wr_data = d;"

CHECKSUM: "281300783 1779845869"
INSTANCE: tb.dut.u_reg_regs.u_status_escalated.wr_en_data_arb
ANNOTATION: "[UNR] all inputs are constant"
Block 2 "1620753216" "assign wr_data = d;"

CHECKSUM: "1296247128 1854270750"
INSTANCE: tb.dut
ANNOTATION: "[UNSUPPORTED] ACK can't come without REQ"
Condition 18 "153333633" "(key_ack & ((~key_req)) & ((~local_esc))) 1 -1" (2 "101")
ANNOTATION: "[LOWRISK] we don't issue a new init when there is a unfinished init"
Condition 11 "1796319142" "(init_done & ((~init_trig)) & ((~local_esc))) 1 -1" (2 "101")

CHECKSUM: "704952876 1147758610"
INSTANCE: tb.dut.u_prim_sync_reqack_data.u_prim_sync_reqack
ANNOTATION: "[UNSUPPORTED] ACK can't come without REQ"
Condition 1 "1414883863" "(src_req_i & src_ack_o) 1 -1" (1 "01")

CHECKSUM: "2574923469 2212102968"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sram_byte
ANNOTATION: "[UNR] this should not happen because the read latency of prim_ram_1p_scr is always 1 cycle"
Condition 2 "3441602297" "(gen_integ_handling.sram_d_ack && gen_integ_handling.rd_wait) 1 -1" (1 "01")

CHECKSUM: "835220981 1390693035"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_rspfifo
ANNOTATION: "[UNR] when rspfifo is full, we don't expect to receive a request, as it's blocked at the req phase"
Condition 4 "786039886" "(wvalid_i & wready_o & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "[LOWRISK] we don't issue a req when it's under reset"
Condition 7 "1709501387" "(((~gen_normal_fifo.empty)) & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "10")

CHECKSUM: "835220981 869192578"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sramreqfifo
ANNOTATION: "[UNR] this fifo can never be full, because transactions can drain into u_rspfifo"
Condition 1 "644960181" "(gen_normal_fifo.full ? (2'(Depth)) : ((gen_normal_fifo.wptr_msb == gen_normal_fifo.rptr_msb) ? ((2'(gen_normal_fifo.wptr_value) - 2'(gen_normal_fifo.rptr_value))) : (((2'(Depth) - 2'(gen_normal_fifo.rptr_value)) + 2'(gen_normal_fifo.wptr_value))))) 1 -1" (2 "1")
ANNOTATION: "[UNR] this fifo can never be full, because transactions can drain into u_rspfifo"
Condition 5 "1324655787" "(rvalid_o & rready_i & ((~gen_normal_fifo.under_rst))) 1 -1" (2 "101")
ANNOTATION: "[UNR] this fifo can never be full, because transactions can drain into u_rspfifo"
Condition 8 "2721421913" "(gen_normal_fifo.fifo_wptr == (gen_normal_fifo.fifo_rptr ^ {1'b1, {(gen_normal_fifo.PTR_WIDTH - 1) {1'b0}}})) 1 -1" (2 "1")
ANNOTATION: "[UNR] this fifo can never be full, because transactions can drain into u_rspfifo"
Condition 6 "342355206" "(((~gen_normal_fifo.full)) & ((~gen_normal_fifo.under_rst))) 1 -1" (1 "01")

CHECKSUM: "432309571 1160560609"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sram_byte
ANNOTATION: "[UNR] this should not happen because the read latency of prim_ram_1p_scr is always 1 cycle"
Branch 1 "2309313685" "gen_integ_handling.state_q" (11) "gen_integ_handling.state_q StWaitRd ,-,-,-,-,-,-,-,1,0,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-"
ANNOTATION: "[UNR] this should not happen because prim_ram_1p_scr can always accept a read or write operation"
Branch 1 "2309313685" "gen_integ_handling.state_q" (14) "gen_integ_handling.state_q StWriteCmd ,-,-,-,-,-,-,-,-,-,0,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-"

CHECKSUM: "835220981 2115631974"
INSTANCE: tb.dut.u_tlul_adapter_sram.u_sramreqfifo
ANNOTATION: "[UNR] this fifo can never be full, because transactions can drain into u_rspfifo"
Branch 0 "1862733684" "gen_normal_fifo.full" (0) "gen_normal_fifo.full 1,-"

CHECKSUM: "826810526 1029109911"
INSTANCE: tb.dut.u_tlul_lc_gate
ANNOTATION: "[LOWRISK] This happens in the 1st cycle after exiting reset. In order to cover it, need to drive TL items during reset, which isn't supported in the agent."
Condition 4 "4047466955" "(outstanding_txn == '0) 1 -1"
