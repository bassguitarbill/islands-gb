Islands.gb: game.o
	rgblink -o Islands.gb game.o
	rgbfix -v -p 0 Islands.gb

run: Islands.gb
	gambatte Islands.gb

debug: Islands.gb
	wine ~/dev/bgb/bgb64.exe Islands.gb

game.o: game.asm hardware.inc
	rgbasm -o game.o game.asm

hardware.inc:
	git clone https://github.com/gbdev/hardware.inc hw
	cp hw/hardware.inc .
	rm -rf ./hw

clean:
	rm game.o Islands.gb hardware.inc
