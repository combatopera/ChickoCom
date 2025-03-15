from lagoon.sic.text import vasmm68k_mot
from PIL import Image
from struct import pack

chunksize = 16

def _encodecomponent(ste):
    return ((ste & 0x1) << 3) | ((ste >> 1) & 0x7)

def main():
    with Image.open('statline.png') as im, open('statline.pi1', 'wb') as g:
        g.write(b'\0\0')
        palette = [_encodecomponent(round(component / 0xff * 0xf)) for component in im.getpalette()]
        for i in range(16):
            g.write(pack('=BB', palette[i * 3], (palette[i * 3 + 1] << 4) | palette[i * 3 + 2]))
        data = im.getdata()
        for k in range(0, 320 * 200, chunksize):
            words = [0] * 4
            for i in range(k, k + chunksize):
                value = data[i]
                for b in range(4):
                    words[b] = (words[b] << 1) | ((value >> b) & 0x1)
            g.write(pack('>HHHH', *words))
    vasmm68k_mot._Ftos._devpac[print]('-o', 'chickoco.prg', 'chickoco.s')

if '__main__' == __name__:
    main()
