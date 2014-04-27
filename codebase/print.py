'''
    imgIdx:
    inputFileName:
    base:
'''
import sys
WIDTH = 28
HEIGHT = 28
def printImage (img, base=1):
    pixels = img.split(",")
    pixels = pixels[base:]
    print pixels
    for y in range(HEIGHT):
        s = ""
        for x in range(WIDTH):
            if pixels[y*WIDTH+x] == '0':
                s += "0"
            else:
                s += " "
        print s
    return 

if __name__ == "__main__":
    imgIdx = int(sys.argv[1])
    print "imgIdx:", imgIdx
    inFilename = sys.argv[2]
    print "inFilename:", inFilename
    base = int(sys.argv[3])
    print "base:", base
    inFile = open(inFilename, 'r') 
    i = 1
    for line in inFile:
        if i == imgIdx:
            printImage (line, base)
        i = i + 1
    inFile.close()

