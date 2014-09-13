all: compile

compile:
	flex pylex.l
	g++ pylex.cpp -o pylex
clean:
	rm pylex.cpp pylex ejemplo.pyl

run: 	
	./pylex ejemplo.py
