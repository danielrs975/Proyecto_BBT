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

class Jugada

    # Constructor del objeto jugada
    def initialize(jugada_realizada)
        # Variables utilizadas 
        # Estas son las posibles jugadas que se puede realizar
        @jugadas = {
            "Piedra" => "pi",
            "Papel" => "pa",
            "Tijera" => "ti",
            "Spock" => "sp",
            "Lagarto" => "la"
        }

        # Estos son los puntos asociados por cada forma posible de terminar una ronda
        @puntos_por_jugada = {
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

        if @jugadas[jugada_realizada] != nil
            @jugada = jugada_realizada
        else
            puts "Jugada incorrecta"
        end
    end

    # Metodo to_s
    def to_s()
        @jugadas[@jugada]
    end

    # Metodo puntos(j)
    def puntos(j)
        jugador_1 = @jugada 
        jugador_2 = j.to_s
        empate = [0, 0]
        if jugador_1 == jugador_2
            return empate
        else
            ronda = jugador_1 + ", " + jugador_2
            return ronda 
        end
    end
end