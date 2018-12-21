require_relative 'Jugada.rb'
require_relative 'Estrategia.rb'

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

class Partida

    attr_reader :mapa_partida, :nombres, :estrategias 
    
    def initialize(mapa)

        # Verificar que hay exactamente dos jugadores y que 
        # en efecto se trata de estrategias
        temp = []
        mapa.each_value {|value| temp.push(value) }
        temp1 = temp[0].instance_of?(Estrategia)
        temp2 = temp[1].instance_of?(Estrategia)
        keys = []
        mapa.each_key {|key| keys.push(key)}
        if mapa.length == 2
            if temp1 && temp2
                $mapa_partida = mapa
                $estrategias = temp
                $nombres = keys
            else
                return "Debe ingresar estrategias"
            end
        else
            return "El número de jugadores deben ser exactamente 2."
        end
    end

    def rondas(n)
        jugador0 = estrategias[0]
        jugador1 = estrategias[1]
        for i in 0..n
            if jugador0.instance_of?(Copiar) && i > 0
            elsif jugador1.instance_of?(Copiar) && i > 0
            end
        end
    end
end