// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

use anyhow::Result;
use arrayvec::ArrayVec;

use ujson_lib::provisioning_data::PersoBlob;

pub fn ft_ext(endorsed_cert_concat: ArrayVec<u8, 5120>, received_perso_blob: &PersoBlob) -> Result<ArrayVec<u8, 5120>> {
    let _ = received_perso_blob;
    Ok(endorsed_cert_concat)
}
