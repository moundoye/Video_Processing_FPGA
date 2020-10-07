/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2_gen2_0' in SOPC Builder design 'elimax_ghrd_nios_sys'
 * SOPC Builder design path: ../../elimax_ghrd_nios_sys.sopcinfo
 *
 * Generated: Fri Feb 07 18:34:52 CET 2020
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00040820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 100000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x13
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x00020020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 100000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x13
#define ALT_CPU_NAME "nios2_gen2_0"
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x00020000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00040820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 100000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x13
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x00020020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x13
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x00020000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_NIOS2_GEN2
#define __ALTPLL
#define __OPENCORES_I2C
#define __VIDEOSAMPLER


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "MAX 10"
#define ALT_IRQ_BASE NULL
#define ALT_LEGACY_INTERRUPT_API_PRESENT
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart_0"
#define ALT_STDERR_BASE 0x410a8
#define ALT_STDERR_DEV jtag_uart_0
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart_0"
#define ALT_STDIN_BASE 0x410a8
#define ALT_STDIN_DEV jtag_uart_0
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart_0"
#define ALT_STDOUT_BASE 0x410a8
#define ALT_STDOUT_DEV jtag_uart_0
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "elimax_ghrd_nios_sys"


/*
 * altpll_0 configuration
 *
 */

#define ALTPLL_0_BASE 0x41090
#define ALTPLL_0_IRQ -1
#define ALTPLL_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ALTPLL_0_NAME "/dev/altpll_0"
#define ALTPLL_0_SPAN 16
#define ALTPLL_0_TYPE "altpll"
#define ALT_MODULE_CLASS_altpll_0 altpll


/*
 * clear configuration
 *
 */

#define ALT_MODULE_CLASS_clear altera_avalon_pio
#define CLEAR_BASE 0x41080
#define CLEAR_BIT_CLEARING_EDGE_REGISTER 0
#define CLEAR_BIT_MODIFYING_OUTPUT_REGISTER 0
#define CLEAR_CAPTURE 0
#define CLEAR_DATA_WIDTH 1
#define CLEAR_DO_TEST_BENCH_WIRING 0
#define CLEAR_DRIVEN_SIM_VALUE 0
#define CLEAR_EDGE_TYPE "NONE"
#define CLEAR_FREQ 100000000
#define CLEAR_HAS_IN 0
#define CLEAR_HAS_OUT 1
#define CLEAR_HAS_TRI 0
#define CLEAR_IRQ -1
#define CLEAR_IRQ_INTERRUPT_CONTROLLER_ID -1
#define CLEAR_IRQ_TYPE "NONE"
#define CLEAR_NAME "/dev/clear"
#define CLEAR_RESET_VALUE 0
#define CLEAR_SPAN 16
#define CLEAR_TYPE "altera_avalon_pio"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * jtag_uart_0 configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart_0 altera_avalon_jtag_uart
#define JTAG_UART_0_BASE 0x410a8
#define JTAG_UART_0_IRQ 0
#define JTAG_UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_0_NAME "/dev/jtag_uart_0"
#define JTAG_UART_0_READ_DEPTH 64
#define JTAG_UART_0_READ_THRESHOLD 8
#define JTAG_UART_0_SPAN 8
#define JTAG_UART_0_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_0_WRITE_DEPTH 64
#define JTAG_UART_0_WRITE_THRESHOLD 8


/*
 * led configuration
 *
 */

#define ALT_MODULE_CLASS_led altera_avalon_pio
#define LED_BASE 0x41070
#define LED_BIT_CLEARING_EDGE_REGISTER 0
#define LED_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED_CAPTURE 0
#define LED_DATA_WIDTH 2
#define LED_DO_TEST_BENCH_WIRING 0
#define LED_DRIVEN_SIM_VALUE 0
#define LED_EDGE_TYPE "NONE"
#define LED_FREQ 100000000
#define LED_HAS_IN 0
#define LED_HAS_OUT 1
#define LED_HAS_TRI 0
#define LED_IRQ -1
#define LED_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED_IRQ_TYPE "NONE"
#define LED_NAME "/dev/led"
#define LED_RESET_VALUE 0
#define LED_SPAN 16
#define LED_TYPE "altera_avalon_pio"


/*
 * onchip_memory2_0 configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_memory2_0 altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_0_BASE 0x20000
#define ONCHIP_MEMORY2_0_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_0_DUAL_PORT 0
#define ONCHIP_MEMORY2_0_GUI_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEMORY2_0_INIT_CONTENTS_FILE "elimax_ghrd_nios_sys_onchip_memory2_0"
#define ONCHIP_MEMORY2_0_INIT_MEM_CONTENT 1
#define ONCHIP_MEMORY2_0_INSTANCE_ID "NONE"
#define ONCHIP_MEMORY2_0_IRQ -1
#define ONCHIP_MEMORY2_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEMORY2_0_NAME "/dev/onchip_memory2_0"
#define ONCHIP_MEMORY2_0_NON_DEFAULT_INIT_FILE_ENABLED 1
#define ONCHIP_MEMORY2_0_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEMORY2_0_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEMORY2_0_SINGLE_CLOCK_OP 0
#define ONCHIP_MEMORY2_0_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_0_SIZE_VALUE 131072
#define ONCHIP_MEMORY2_0_SPAN 131072
#define ONCHIP_MEMORY2_0_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEMORY2_0_WRITABLE 1


/*
 * opencores_i2c_0 configuration
 *
 */

#define ALT_MODULE_CLASS_opencores_i2c_0 opencores_i2c
#define OPENCORES_I2C_0_BASE 0x41040
#define OPENCORES_I2C_0_IRQ 1
#define OPENCORES_I2C_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define OPENCORES_I2C_0_NAME "/dev/opencores_i2c_0"
#define OPENCORES_I2C_0_SPAN 32
#define OPENCORES_I2C_0_TYPE "opencores_i2c"


/*
 * sysid_qsys_0 configuration
 *
 */

#define ALT_MODULE_CLASS_sysid_qsys_0 altera_avalon_sysid_qsys
#define SYSID_QSYS_0_BASE 0x410a0
#define SYSID_QSYS_0_ID 0
#define SYSID_QSYS_0_IRQ -1
#define SYSID_QSYS_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_QSYS_0_NAME "/dev/sysid_qsys_0"
#define SYSID_QSYS_0_SPAN 8
#define SYSID_QSYS_0_TIMESTAMP 1581096736
#define SYSID_QSYS_0_TYPE "altera_avalon_sysid_qsys"


/*
 * trigger configuration
 *
 */

#define ALT_MODULE_CLASS_trigger altera_avalon_pio
#define TRIGGER_BASE 0x41000
#define TRIGGER_BIT_CLEARING_EDGE_REGISTER 0
#define TRIGGER_BIT_MODIFYING_OUTPUT_REGISTER 1
#define TRIGGER_CAPTURE 0
#define TRIGGER_DATA_WIDTH 1
#define TRIGGER_DO_TEST_BENCH_WIRING 0
#define TRIGGER_DRIVEN_SIM_VALUE 0
#define TRIGGER_EDGE_TYPE "NONE"
#define TRIGGER_FREQ 100000000
#define TRIGGER_HAS_IN 0
#define TRIGGER_HAS_OUT 1
#define TRIGGER_HAS_TRI 0
#define TRIGGER_IRQ -1
#define TRIGGER_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TRIGGER_IRQ_TYPE "NONE"
#define TRIGGER_NAME "/dev/trigger"
#define TRIGGER_RESET_VALUE 0
#define TRIGGER_SPAN 32
#define TRIGGER_TYPE "altera_avalon_pio"


/*
 * usbstatus configuration
 *
 */

#define ALT_MODULE_CLASS_usbstatus altera_avalon_pio
#define USBSTATUS_BASE 0x41060
#define USBSTATUS_BIT_CLEARING_EDGE_REGISTER 1
#define USBSTATUS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define USBSTATUS_CAPTURE 1
#define USBSTATUS_DATA_WIDTH 4
#define USBSTATUS_DO_TEST_BENCH_WIRING 0
#define USBSTATUS_DRIVEN_SIM_VALUE 0
#define USBSTATUS_EDGE_TYPE "RISING"
#define USBSTATUS_FREQ 100000000
#define USBSTATUS_HAS_IN 1
#define USBSTATUS_HAS_OUT 0
#define USBSTATUS_HAS_TRI 0
#define USBSTATUS_IRQ -1
#define USBSTATUS_IRQ_INTERRUPT_CONTROLLER_ID -1
#define USBSTATUS_IRQ_TYPE "NONE"
#define USBSTATUS_NAME "/dev/usbstatus"
#define USBSTATUS_RESET_VALUE 0
#define USBSTATUS_SPAN 16
#define USBSTATUS_TYPE "altera_avalon_pio"


/*
 * videosampler_0 configuration
 *
 */

#define ALT_MODULE_CLASS_videosampler_0 videosampler
#define VIDEOSAMPLER_0_BASE 0x41020
#define VIDEOSAMPLER_0_IRQ -1
#define VIDEOSAMPLER_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define VIDEOSAMPLER_0_NAME "/dev/videosampler_0"
#define VIDEOSAMPLER_0_SPAN 32
#define VIDEOSAMPLER_0_TYPE "videosampler"

#endif /* __SYSTEM_H_ */
