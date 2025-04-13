# NASM_Triangle
Welcome, here, is my first render on assembly(NASM). Here is been render triangle on assembly. Here is very musch registers etc. This is OC for Linux(Arch, etc). So, u can to look and learn this code. If u Good luck!

# HOW TO COMPILE!
That's to compile, u need to write the command(for example):
```
nasm -f elf64 -g -F dwarf triangle.asm -o triangle.o
```
Next u need to linking:
```
g++ -g triangle.o -o triangle -lglfw -lGLEW -lGL -no-pie
```
The next just output:
```
./triangle
```

# Enjoy!
![img](https://github.com/tornado4444/NASM_Triangle/blob/main/triangle.png)
