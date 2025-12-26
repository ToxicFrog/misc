vs.svg: vs.dot
	<vs.dot neato -Tsvg >vs.svg

vs.dot: *.lua
	luajit graphviz.lua > vs.dot
