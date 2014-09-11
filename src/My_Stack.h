#include <list>
/**
 * Clase que modela un TAD Pila. 
 */
class My_Stack{
	std::list<int> list;
	public:
		void push(int value);
		int get_Size();
		int pick();
		void pop();
		void print_Content();
		int suma();
};

/**
 * Función push tipica en el TAD Pila. 
 */
void My_Stack::push(int value){
	//printf("Insertando el valor %i\n",value);
	list.push_front(value);
}

/**
 * Función que nos dice cuantos elementos tiene el  TAD Pila. 
 */
int My_Stack::get_Size(){
	return list.size();
}

/**
 * Función pick tipica en el TAD Pila. 
 */
int My_Stack::pick(){
	return list.front();
}

/**
 * Función pop tipica en el TAD Pila. 
 */
void My_Stack::pop(){
	list.pop_front();
}

/**
 * Función que imprime el contenido de la Pila. 
 */
void My_Stack::print_Content(){
	printf("Printing content:\n");
	for(std::list<int>::iterator it=list.begin(); it != list.end(); ++it)
		printf("%i\n",*it);
		//printf("El elemento actual es %i\n",*it);
		
}

/**
 * Funcion que va a sumar los 2 primeros elementos de la pila y luego los saca. 
 */
int My_Stack::suma(){
	int x,y;
	x=pick();
	pop();
	y=pick();
	pop();
	
	return x+y;
}
