CXX = nasm
CXXFLAGS = -f elf64

TARGET = printf
SourcePrefix = src/
BuildPrefix = build/
BuildFolder = build
Include = -Iinclude 

Libs = -static -lc

Asm_files = to_hex.s custom_printf.s to_oct.s to_bin.s to_dec.s
Cpp_files = main.cpp

Cpp_src = $(addprefix $(SourcePrefix), $(Cpp_files))
Asm_src = $(addprefix $(SourcePrefix), $(Asm_files))
MainObject = $(patsubst %.cpp, $(BuildPrefix)%.o, $(Main))

Asm_objects = $(patsubst $(SourcePrefix)%.s, $(BuildPrefix)%.o, $(Asm_src))

.PHONY : all clean folder release debug

all : prepare folder $(TARGET)

prepare: 

$(BuildPrefix)%.o : $(SourcePrefix)%.s
	@echo [ASM] -c $< -o $@
	@nasm $(CXXFLAGS) $< -o $@

$(TARGET) : $(Asm_objects)
	@echo [CC] $^ -o $@
	@gcc -no-pie $^ $(Cpp_src) -o $@

clean :
	rm $(BuildFolder)/*.o
	rm $(TARGET)

folder :
	mkdir -p $(BuildFolder)