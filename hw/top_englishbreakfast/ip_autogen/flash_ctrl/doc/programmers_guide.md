# Programmer's Guide

## Issuing a Controller Read

To issue a flash read, the programmer must
*  Specify the address of the first flash word to read
*  Specify the number of total flash words to read, beginning at the supplied address
*  Specify the operation to be 'READ' type
*  Set the 'START' bit for the operation to begin

The above fields can be set in the [`CONTROL`](registers.md#control) and [`ADDR`](registers.md#addr) registers.
See [library code](https://github.com/lowRISC/opentitan/blob/master/sw/device/lib/dif/dif_flash_ctrl.c) for implementation.

It is acceptable for total number of flash words to be significantly greater than the depth of the read FIFO.
In this situation, the read FIFO will fill up (or hit programmable fill value), pause the flash read and trigger an interrupt to software.
Once there is space inside the FIFO, the controller will resume reading until the appropriate number of words have been read.
Once the total count has been reached, the flash controller will post OP_DONE in the [`OP_STATUS`](registers.md#op_status) register.

## Issuing a Controller Program

To program flash, the same procedure as read is followed.
However, instead of setting the [`CONTROL`](registers.md#control) register for read operation, a program operation is selected instead.
Software will then fill the program FIFO and wait for the controller to consume this data.
Similar to the read case, the controller will automatically stall when there is insufficient data in the FIFO.
When all desired words have been programmed, the controller will post OP_DONE in the [`OP_STATUS`](registers.md#op_status) register.

## Debugging a Read Error
Since flash has multiple access modes, debugging read errors can be complicated.
The following lays out the expected cases.

### Error Encountered by Software Direct Read
If software reads the flash directly, it may encounter a variety of errors (read data integrity / ECC failures, both reliability and integrity).
ECC failures create in-band error responses and should be recognized as a bus exception.
Read data integrity failures also create exceptions directly inside the processor as part of end-to-end transmission integrity.

From these exceptions, software should be able to determine the error address through processor specific means.
Once the address is discovered, further steps can be taken to triage the issue.

### Error Encountered by Software Initiated Controller Operations
A controller operation can encounter a much greater variety of errors, see [`ERR_CODE`](registers.md#err_code).
When such an error is encountered, as reflected by [`OP_STATUS`](registers.md#op_status) when the operation is complete, software can examine the [`ERR_ADDR`](registers.md#err_addr) to determine the error location.
Once the address is discovered, further steps can be taken to triage the issue.

### Hardware Initiated Reads

If the root secrets have been provisioned and the life cycle state is in either DEV, PROD* or RMA, the special info pages holding the creator and owner seeds will be read out automatically by the flash controller and sent to the keymanager upon flash initialization.
Hence, it is important that these pages are initialized with valid data, since otherwise the hardware will likely encounter ECC errors during the automatic readout.

Note that by default, hardware assumes that scrambling and ECC is enabled on these special info pages.
If software decides to not use scrambling or ECC on these partitions at the time of provisioning, software should disable these features in the [`HW_INFO_CFG_OVERRIDE`](registers.md#hw_info_cfg_override) register accordingly when initializing the flash controller.
Otherwise, a configuration mismatch between hardware interface and the software side will lead to corrupted seed values and ECC errors upon automatic readout.

### Correctable ECC Errors
Correctable ECC errors are by nature not fatal errors and do not stop operation.
Instead, if the error is correctable, the flash controller fixes the issue and registers the last address where a single bit error was seen.
See [`ECC_SINGLE_ERR_CNT`](registers.md#ecc_single_err_cnt) and [`ECC_SINGLE_ERR_ADDR`](registers.md#ecc_single_err_addr)

### Errors during Multi-Word Controller Reads

Note that upon experiencing the first error during any multi-word read operation, the flash controller aborts the internal read operation but still returns the requested amount of data.
For the word where the read error has been observed, the actual flash data is returned.
For subsequent words, the flash controller may return:
- An all-one word in case of an access permission error.
- An all-zero word in case of a flash read error (e.g. reliability ECC and ICV errors) and if the flash read pipeline remains idle.
- The data belonging to other read operations in case of a flash read error and if the flash read pipeline continues doing, e.g., host initiated read operations.
  In this case, the data returned for the subsequent words may contain further ECC and ICV errors.

## Granularity of Scrambling and Reliability ECC

While the minimum granularity for host and controller interface accesses is 32 bits, the scrambling as well as reliability ECC operate on full Flash words (64 bits).
Whenever reliability ECC and/or scrambling are enabled, read, program and erase operations should thus be based on 64-bit aligned addresses.

## Device Interface Functions (DIFs)

- [Device Interface Functions](../../../../../sw/device/lib/dif/dif_flash_ctrl.h)
