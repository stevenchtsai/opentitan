# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@rules_rust//rust:defs.bzl", "rust_binary", "rust_test")
load("@rules_pkg//pkg:mappings.bzl", "pkg_filegroup", "pkg_files")

package(default_visibility = ["//visibility:public"])

rust_binary(
    name = "opentitantool",
    srcs = [
        "src/command/bfv.rs",
        "src/command/bootstrap.rs",
        "src/command/certificate.rs",
        "src/command/clear_bitstream.rs",
        "src/command/console.rs",
        "src/command/ecdsa.rs",
        "src/command/emulator.rs",
        "src/command/fpga.rs",
        "src/command/gpio.rs",
        "src/command/hello.rs",
        "src/command/i2c.rs",
        "src/command/image.rs",
        "src/command/lc.rs",
        "src/command/load_bitstream.rs",
        "src/command/mod.rs",
        "src/command/otp.rs",
        "src/command/ownership.rs",
        "src/command/rescue.rs",
        "src/command/rsa.rs",
        "src/command/sam3x.rs",
        "src/command/set_pll.rs",
        "src/command/spi.rs",
        "src/command/spx.rs",
        "src/command/status_cmd.rs",
        "src/command/tpm.rs",
        "src/command/transport.rs",
        "src/command/uart.rs",
        "src/command/update_usr_access.rs",
        "src/command/version.rs",
        "src/command/xmodem.rs",
        "src/main.rs",
    ],
    proc_macro_deps = [
        "//sw/host/opentitanlib/opentitantool_derive",
    ],
    rustc_env_files = [
        "stamp-env.txt",
    ],
    # stamping is necessary because opentitantool builds version.rs that needs it
    stamp = -1,
    deps = [
        "//sw/host/opentitanlib",
        "//sw/host/ot_certs",
        "//sw/host/sphincsplus",
        "//util:bfv_decoder",
        "@crate_index//:anyhow",
        "@crate_index//:clap",
        "@crate_index//:directories",
        "@crate_index//:env_logger",
        "@crate_index//:erased-serde",
        "@crate_index//:hex",
        "@crate_index//:humantime",
        "@crate_index//:log",
        "@crate_index//:mio",
        "@crate_index//:mio-signals",
        "@crate_index//:regex",
        "@crate_index//:serde",
        "@crate_index//:serde_bytes",
        "@crate_index//:serde_json",
        "@crate_index//:shellwords",
        "@crate_index//:thiserror",
        "@lowrisc_serde_annotate//serde_annotate",
    ],
)

pkg_files(
    name = "binary",
    srcs = [":opentitantool"],
)

pkg_filegroup(
    name = "package",
    srcs = [
        ":binary",
    ],
    prefix = "opentitantool",
)

rust_test(
    name = "opentitantool_test",
    crate = ":opentitantool",
    # stamping is necessary because opentitantool builds version.rs that needs it
    stamp = 1,
)
