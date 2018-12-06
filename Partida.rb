=begin
En este archivo se implementa la clase Partida, esta clase se encarga de
manejar las rondas del juego
    - Constructor   ---> El constructor recibe como entrada un mapa 
    con los nombres de los jugadores y las estrategias que se van a 
    utilizar.

    IMPORTANTE: Se tiene que verificar que el numero de jugadores sean
    exactamente 2 y lanzar excepciones si ocurren estos errores

Metodos de la clase:
    - rondas(n)     ---> n es un entero positivo, se completan n rondas
    y se retorna un mapa con los puntajes asociados a los jugadores 
    y las rondas jugadas
    - alcanzar(n)   ---> n es un entero positivo, se termina el juego 
    cuando alguno de los dos jugadores alcance n puntos, y se retorna
    lo mismo que el metodo anterior
    - reiniciar     ---> Lleva el juego a su estado inicial

IMPORTANTE: Es posible decidir continuar un juego

=end