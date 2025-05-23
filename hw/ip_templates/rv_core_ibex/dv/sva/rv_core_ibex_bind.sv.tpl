// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module ${module_instance_name}_bind;

  bind ${module_instance_name} tlul_assert #(
    .EndpointType("Host")
  ) tlul_assert_host_instr (
    .clk_i,
    .rst_ni,
    .h2d  (tl_i_o),
    .d2h  (tl_i_i)
  );

  bind ${module_instance_name} tlul_assert #(
    .EndpointType("Host")
  ) tlul_assert_host_data (
    .clk_i,
    .rst_ni,
    .h2d  (tl_d_o),
    .d2h  (tl_d_i)
  );

endmodule
