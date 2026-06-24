# RISC-V 智慧門禁安全系統

## 專題簡介

本專題使用 Digilent Basys3 FPGA 開發板與 PicoRV32 RISC-V 處理器實作智慧門禁安全系統（Smart Door Security System）。

系統採用 Memory-Mapped I/O 架構，使 CPU 能夠與 FPGA 周邊設備進行資料交換。

已完成功能：

- 密碼驗證
- 錯誤偵測
- 三次錯誤自動鎖定
- 管理員解鎖
- LED 狀態顯示
- 七段顯示器結果顯示

---

# 開發平台

- FPGA 開發板：Digilent Basys3
- FPGA 晶片：Xilinx Artix-7 XC7A35T
- CPU 核心：PicoRV32 RISC-V Processor

---

# 開發工具

- Vivado 2019.1
- riscv-none-elf-gcc 15.2.0
- Windows PowerShell

---

# 專案架構

```text
RISC-V-Smart-Door-Security-System
│
├── firmware
│   ├── main.c
│   ├── start.s
│   ├── linker.ld
│   └── firmware.hex
│
├── src
│   ├── top.v
│   ├── door_soc.v
│   ├── picorv32.v
│   └── basys3.xdc
│
└── README.md
```

---

# Memory-Mapped I/O 位址配置

| 位址 | 功能 |
|--------|--------|
| 0x10000000 | INPUT_REG |
| 0x10000004 | LED_REG |
| 0x10000008 | SEG_REG |

---

# 如何產生 Firmware

## 編譯 C 程式

```bash
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -T linker.ld start.s main.c -o firmware.elf
```

## 轉換成 Binary

```bash
riscv-none-elf-objcopy -O binary firmware.elf firmware.bin
```

## 轉換成 Hex 檔

使用 PowerShell 將 firmware.bin 轉換為 firmware.hex。

---

# 如何產生 Bitstream

1. 開啟 Vivado 2019.1
2. Run Synthesis
3. Run Implementation
4. Generate Bitstream
5. Program Device

---

# 系統操作方式

## 正確密碼驗證

輸入：

```text
0101
```

操作：

```text
按下 BTNC
```

結果：

```text
顯示 1
```

代表密碼正確。

---

## 錯誤密碼驗證

輸入：

```text
0001
```

操作：

```text
按下 BTNC
```

結果：

```text
顯示 E
```

代表密碼錯誤。

---

## 系統鎖定功能

連續輸入錯誤密碼三次：

```text
顯示 L
```

代表系統已鎖定（Locked）。

---

## 管理員解鎖功能

操作：

```text
按下 BTND
```

結果：

```text
顯示 A
```

代表管理員成功解鎖（Admin Unlock）。

---

# I/O 配置

## Switch

| Switch | 功能 |
|----------|----------|
| SW0 ~ SW3 | 密碼輸入 |

## Button

| 按鈕 | 功能 |
|----------|----------|
| BTNC | 密碼確認 |
| BTND | 管理員解鎖 |

## 七段顯示器

| 顯示內容 | 意義 |
|------------|------------|
| 1 | 密碼正確 |
| E | 密碼錯誤 |
| L | 系統鎖定 |
| A | 管理員解鎖 |

---

# 測試結果

| 測試項目 | 預期結果 | 測試結果 |
|------------|------------|------------|
| 正確密碼驗證 | 顯示 1 | 通過 |
| 錯誤密碼驗證 | 顯示 E | 通過 |
| 三次錯誤鎖定 | 顯示 L | 通過 |
| 管理員解鎖 | 顯示 A | 通過 |
| 解鎖後重新登入 | 顯示 1 | 通過 |

---

# 已知限制

目前尚未完成：

- UART 事件紀錄功能
- 密碼修改功能
- 多使用者權限管理

---

# 使用之外部資源

- PicoRV32 RISC-V CPU Core https://github.com/YosysHQ/picorv32
- Digilent Basys3 Reference Manual 
- RISC-V ISA Documentation
- https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack
---

# 作者資訊

姓名：黃心瑜

學校：元智大學

系所：電機乙組

課程：數位系統設計與實驗
