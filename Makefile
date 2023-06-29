simulate: build
	ghdl -e testbench
	ghdl -r testbench --vcd=wave.vcd

wave: simulate
	gtkwave --autosavename wave.vcd

build:
	ghdl -a fsm.vhd
	ghdl -a data_path.vhd
	ghdl -a get_address.vhd
	ghdl -a ram.vhd
	ghdl -a rom.vhd
	ghdl -a rf.vhd
	ghdl -a mac.vhd
	ghdl -a relu.vhd
	ghdl -a rf16.vhd
	ghdl -a SSegment.vhd
	ghdl -a test.vhd
	ghdl -a testbench.vhd
	ghdl -e testbench
	ghdl -r testbench --vcd=wave.vcd

clean:
	del *.cf *.vcd
	IF exist verify (rmdir /s /q verify && echo 0) ELSE (echo 1)