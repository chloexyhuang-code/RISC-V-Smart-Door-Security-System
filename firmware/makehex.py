data = open("firmware.bin", "rb").read()

while len(data) % 4 != 0:
    data += b"\x00"

with open("firmware.hex", "w") as f:
    for i in range(0, len(data), 4):
        word = data[i] | (data[i+1] << 8) | (data[i+2] << 16) | (data[i+3] << 24)
        f.write("{:08x}\n".format(word))