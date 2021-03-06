=begin
En este archivo se implementa la clase Jugada, esta clase representa 
las jugadas hechas por cada uno de los jugadores en las rondas. Tendra como
subclases:
    - Piedra    - Papel     - Lagarto 
    - Spock     - Tijera

Y los metodos son solo dos:
    - to_s ---> que retorna el String human-readable para mostrar por pantalla 
    - puntos(j) ---> Tupla que representa la ganancia de puntos entre el invocante
    y el contricante
=end 

# Clase que representa las jugadas del juego
class Jugada

    # * +jugadas+ almacena todas las jugadas posibles del juego y las mapeas a un string sencillo de manejar
    attr_reader :jugadas
    # * +puntos_por_jugada+ es una variable que almacena todas las posibles combinaciones de jugadas y sus puntajes asociados
    attr_reader :puntos_por_jugada
    
    # Variables utilizadas 
    # Estas son las posibles jugadas que se puede realizar
    $jugadas = {
        "Piedra" => "pi",
        "Papel" => "pa",
        "Tijera" => "ti",
        "Spock" => "sp",
        "Lagarto" => "la"
    }

     # Estos son los puntos asociados por cada forma posible de terminar una ronda
    $puntos_por_jugada = {
        "pi, pa" => [0, 1],
        "pi, la" => [1, 0],
        "pi, sp" => [0, 1],
        "pi, ti" => [1, 0],
        "pa, sp" => [1, 0],
        "pa, pi" => [1, 0],
        "pa, ti" => [0, 1],
        "pa, la" => [0, 1],
        "ti, la" => [1, 0],
        "ti, pa" => [1, 0],
        "ti, sp" => [0, 1],
        "ti, pi" => [0, 1],
        "la, sp" => [1, 0],
        "la, pa" => [1, 0],
        "la, pi" => [0, 1],
        "la, ti" => [0, 1],
        "sp, ti" => [1, 0],
        "sp, pi" => [1, 0],
        "sp, pa" => [0, 1],
        "sp, la" => [0, 1]
    }

    # Constructor del objeto jugada
    # @param [String] jugada_realizada, aqui va la jugada escogida
    def initialize(jugada_realizada)
        if $jugadas[jugada_realizada] != nil
            @jugada = $jugadas[jugada_realizada]
        else
            @jugada = nil 
        end
    end

    # Metodo que me dice si una Jugada es valida
    # @return true si la jugada no es nil, false en caso contrario
    def jugada_valida?
        not @jugada.nil?
    end

    # Metodo to_s
    # @return [String] que es la jugada escogida
    def to_s()
        @jugada
    end

    # Metodo puntos(j)
    # @param [Jugada] que es la jugada del contrincante
    # @return [Array] que es los puntos obtenidos 
    def puntos(j)
        jugador_1 = @jugada 
        jugador_2 = j.to_s
        empate = [0, 0]
        if jugador_1 == jugador_2
            return empate
        else
            ronda = jugador_1 + ", " + jugador_2
            return $puntos_por_jugada[ronda] 
        end
    end
end