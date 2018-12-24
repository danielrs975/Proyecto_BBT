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

# Clase que representa las partidas del juego

class Partida
    # * +mapa_partida+ representa un mapeo entre el nombre de los jugadores y sus estrategias
    attr_reader :mapa_partida
    # * +nombres+ lista de los nombres de los jugadores
    attr_reader :nombres
    # * +estrategias+ lista de las estrategias de los jugadores
    attr_reader :estrategias 
    
    # Constructor del objeto Partida
     # @param Hash mapa, mapa de los nombres de los jugadores con sus estrategias respectivas
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
                # estrategias de los dos jugadores
                @jugador0 = $estrategias[0]
                @jugador1 = $estrategias[1]
        
                #reconocer cuales son las estrategias del jugador 0 y 1 respectivamente
                @manual0 = @jugador0.instance_of?(Manual)
                @manual1 = @jugador1.instance_of?(Manual)
                @unif0 = @jugador0.instance_of?(Unif)
                @unif1 = @jugador1.instance_of?(Unif)
                @sesg0 = @jugador0.instance_of?(Sesg)
                @sesg1 = @jugador1.instance_of?(Sesg)
                @copiar0 = @jugador0.instance_of?(Copiar)
                @copiar1 = @jugador1.instance_of?(Copiar)
                @pensar0 = @jugador0.instance_of?(Pensar)
                @pensar1 = @jugador1.instance_of?(Pensar)
            else
                return "Debe ingresar estrategias"
            end
        else
            return "El número de jugadores deben ser exactamente 2."
        end
    end

    # Metodo que con n un entero positivo, debe completar n rondas en el juego y producir un mapa
    # indicando los puntos obtenidos por cada jugador y la cantidad de rondas jugadas.
    # @param Integer n siendo n el numero de rondas
    # return Hash de los jugadores con los puntos obtenidos en las rondas respectivamente
    def rondas(n)
        puntos0 = 0
        puntos1 = 0
        for i in 0..n
            if i > 0 # segunda ronda
                if @copiar0 || @pensar0
                    jugada0 = @jugador0.prox(old_jugada1)
                end
                if @copiar1 || @pensar1
                    jugada1 = @jugador1.prox(jugada0)
                end
                if @manual0 || @unif0 || @sesg0
                    jugada0 = @jugador0.prox()
                end
                if @manual1 || @unif1 || @sesg1
                    jugada1 = @jugador1.prox()
                end
                oldjugada1 = jugada1 # se actualiza la ultima jugada del jugador1 para ser utilizada por jugador0
            else # primera ronda
                old_jugada0 = @jugador0.prox()
                old_jugada1 = @jugador1.prox()
            end
            # puntos
            puntos0 += jugada0.puntos(jugada1)[0]
            puntos1 += jugada0.puntos(jugada1)[1]
        end

        return {$nombres[0] => puntos0, $nombres[1] => puntos1, :Rondas => n}
    end


    # Metodo que con n un entero positivo, debe completar tantas rondas como sea necesario
    # hasta que alguno de los jugadores alcance n puntos, produciendo un mapa indicando los puntos
    # obtenidos por cada jugador y la cantidad de rondas jugadas.
    # @param Integer n siendo n el numero de puntos
    # return Hash de los jugadores con los puntos obtenidos en las rondas respectivamente
    def alcanzar(n)
        puntos0 = 0
        puntos1 = 0
        rondas = 0
        while puntos0<n || puntos1<n
            rondas +=1
            if i > 0 # segunda ronda
                if @copiar0 || @pensar0
                    jugada0 = @jugador0.prox(old_jugada1)
                end
                if @copiar1 || @pensar1
                    jugada1 = @jugador1.prox(jugada0)
                end
                if @manual0 || @unif0 || @sesg0
                    jugada0 = @jugador0.prox()
                end
                if @manual1 || @unif1 || @sesg1
                    jugada1 = @jugador1.prox()
                end
                oldjugada1 = jugada1
            else # primera ronda
                old_jugada0 = @jugador0.prox()
                old_jugada1 = @jugador1.prox()
            end
            # puntos
            puntos0 += jugada0.puntos(jugada1)[0]
            puntos1 += jugada0.puntos(jugada1)[1]
        end
        return {$nombres[0] => puntos0, $nombres[1] => puntos1, :Rondas => rondas}
    end

end
