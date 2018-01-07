f=open("Pokemon Crystal.gbc",'rb')
f.seek(0x90627)
a=[]
for i in range(1,256):
    ptr = int.from_bytes(f.read(2), 'little')
    f.read(4)
    if 0xE000 <= ptr <= 0xFDFF:
        ptr -= 0x2000
    print('%02X: %04X'%(i,ptr))
    if ptr >= 0xd47b and ptr <= 0xDFF5:
        a.append('%04X: %02X'%(ptr,i))
a.sort()
for s in a:
    print(s)
