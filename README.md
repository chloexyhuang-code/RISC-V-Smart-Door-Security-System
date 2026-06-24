# 1. 專題名稱

RISC-V Smart Door Security System(RISC-V 智慧門禁安全系統)

本專題利用 PicoRV32 RISC-V CPU 與 Basys3 FPGA 開發板實作智慧門禁安全系統，透過 Memory-Mapped I/O 控制 Switch、Button、LED 與七段顯示器，完成密碼驗證、錯誤鎖定及管理員解鎖功能。

---

# 2. 使用開發板

Digilent Basys3 FPGA Development Board

FPGA Device：

XC7A35T-1CPG236C

---

# 3. 使用工具版本

Vivado：2019.1

RISC-V Toolchain：

riscv-none-elf-gcc 15.2.0

作業系統：

Windows 11

---

# 4. 專案資料夾結構

```text
RISC-V-Smart-Door-Security-System
│
├─ firmware
│   ├─ main.c
│   ├─ start.s
│   ├─ linker.ld
│   ├─ firmware.elf
│   ├─ firmware.bin
│   └─ firmware.hex
│
├─ src
│   ├─ top.v
│   ├─ door_soc.v
│   ├─ picorv32.v
│   └─ basys3.xdc
│
└─ README.md
```

---

# 5. 如何產生 Bitstream

1. 開啟 Vivado 2019.1
2. 載入專案
3. 確認 firmware.hex 已更新
4. 執行 Run Synthesis
5. 執行 Run Implementation
6. 執行 Generate Bitstream
7. 產生 bitstream 完成

---

# 6. 如何載入或修改 RISC-V 程式

修改檔案：

```text
firmware/main.c
```

編譯程式：

```bash
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -T linker.ld start.s main.c -o firmware.elf
```

產生 Binary：

```bash
riscv-none-elf-objcopy -O binary firmware.elf firmware.bin
```

再將 firmware.bin 轉換成 firmware.hex。

最後重新執行：

```text
Run Synthesis
Run Implementation
Generate Bitstream
```

即可更新 FPGA 中執行的 RISC-V 程式。

---

# 7. 如何燒錄到 FPGA 開發板

1. 使用 USB 連接 Basys3
2. 開啟 Vivado Hardware Manager
3. Open Target
4. Auto Connect
5. Program Device
6. 選擇產生的 bitstream
7. 完成燒錄

---

# 8. 如何操作與測試

## 正確密碼驗證

輸入：

```text
SW = 0101
```

按下：

```text
BTNC
```

結果：

```text
七段顯示器顯示 1
```

表示密碼正確。

---

## 錯誤密碼驗證

輸入：

```text
SW = 0001
```

按下：

```text
BTNC
```

結果：

```text
七段顯示器顯示 E
```

表示密碼錯誤。

---

## 三次錯誤鎖定

連續三次輸入錯誤密碼。

結果：

```text
七段顯示器顯示 L
```

表示系統已鎖定。

---

## 管理員解鎖

按下：

```text
BTND
```

結果：

```text
七段顯示器顯示 A
```

表示系統解除鎖定。

---

# 9. 已知問題

目前尚未完成：

1. UART 事件紀錄功能
2. 密碼修改功能
3. 多使用者權限管理

本專題已完成核心功能驗證，能正常執行密碼驗證、錯誤鎖定及管理員解鎖功能。

---

# 10. 外部來源與授權說明

本專題使用以下外部資源：

1. PicoRV32 RISC-V CPU Core
   https://github.com/YosysHQ/picorv32

2. Digilent Basys3 FPGA Board Reference Manual
   https://digilent.com/reference/programmable-logic/basys-3/reference-manual?srsltid=AfmBOooHageXbk7eHVjZQ0Kzz9wqGwbiiEB96KjoQs_La3Rm1XSKaAQX

3. RISC-V Instruction Set Architecture (ISA)
   https://github.com/riscv/riscv-isa-manual
