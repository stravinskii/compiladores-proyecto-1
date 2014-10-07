all:
	flex pylex.l
	g++ pylex.cpp -o pylex
	./pylex pylex.py
debug:
	flex -d -v pylex.l
	g++ pylex.cpp -o pylex
	./pylex pylex.py
