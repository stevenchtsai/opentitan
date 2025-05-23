// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/testing/test_framework/status.h"

#include <stdatomic.h>

#include "sw/device/lib/arch/device.h"
#include "sw/device/lib/base/mmio.h"
#include "sw/device/lib/runtime/hart.h"
#include "sw/device/lib/runtime/log.h"

/**
 * Writes the test status to the test status device address.
 *
 * @param test_status current status of the test.
 */
static void test_status_device_write(test_status_t test_status) {
  uintptr_t status_addr = device_test_status_address();
  if (status_addr != 0) {
    mmio_region_t test_status_device_addr = mmio_region_from_addr(status_addr);
    mmio_region_write32(test_status_device_addr, 0x0, (uint32_t)test_status);
  }
}

void test_status_set(test_status_t test_status) {
  // This function is used to convey info to test harness, which may poke at
  // backdoor variables. Add a fence to provide corrrect synchronization.
  //
  // This technically should be a thread fence, but use a signal fence to avoid
  // emitting instructions as Ibex doesn't reorder memory accesses itself.
  atomic_signal_fence(memory_order_release);

  switch (test_status) {
    case kTestStatusPassed: {
      LOG_INFO("PASS!");
      test_status_device_write(test_status);
      abort();
      break;
    }
    case kTestStatusFailed: {
      LOG_INFO("FAIL!");
      test_status_device_write(test_status);
      abort();
      break;
    }
    default: {
      LOG_INFO("test_status_set to 0x%x", test_status);
      test_status_device_write(test_status);
      break;
    }
  }
}
