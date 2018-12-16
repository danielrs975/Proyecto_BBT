require_relative 'Jugada.rb'

=begin
En este archivo se implementa la clase Estrategia, esta clase representa a los 
jugadores participantes tendra como subclases:
    - Manual    ---> Aqui el usuario participa directamente en el juego, es decir,
    escoge la jugada que quiera hacer
    - Uniforme  ---> En esta subclase se recibe una lista de movimientos 
    y se selecciona una de ellos siguiendo una distribucion uniforme.
    - Sesgada   ---> Recibe un mapa de movimientos con sus probabilidades que sean
    escogido. Las probabilidades son enteros.

    (Para las ultimas dos debe existir por lo menos un movimiento y sin duplicados)

    - Copiar    ---> Se recibe solo la primera jugada. Desde la 2da ronda para 
    adelante se hace el mismo movimiento que haga el otro jugador
    - Pensar    ---> Recordar las jugadas previas del contrincante y decidir en
    base a eso:
        > Tener guardado la frecuencia de jugadas por cada Subclase de la clase
        Jugada
        > Generar un numero al azar entre el 0 hasta la suma de todas las frecuen
        cias menos uno 
        > Se jugara un movimiento si cae en su rango (Ver enunciado para el rango)

    NOTA: Usar la libreria random de ruby y usar como semilla para generar numeros
    al azar el 42

Tambien se hara la implementacion de los siguientes metodos:
    - prox(m)   ---> Genera la proxima jugada. Puede pasarle una
    jugada j para ayudarlo a decidir. Retorna una instancia de 
    Jugada
    - to_s      ---> Pasa a un string al invocante en este caso
    una instancia de Estrategia
    - reset     ---> Lleva la estrategia a su estado inicial
=end 

class Estrategia
    attr_reader :posibles_jugadas, :sin_jugada

    # Un diccionario que contiene el mapeo entre la jugada mostrada por el 
    # objeto Jugada a un formato mas amigable 
    $posibles_jugadas = {
        "pi" => "Piedra",
        "pa" => "Papel",
        "ti" => "Tijera",
        "sp" => "Spock",
        "la" => "Lagarto"
    }

    # Tiene un string que contiene la respuesta en caso de 
    # que no se halla seleccionado una jugada
    $sin_jugada = "No se ha seleccionado una jugada"

    # Esta es una plantilla de la funcion pues cambiara 
    # segun la especializacion
    # Funcion que genera la proxima jugada
    def prox(m)
    end

    # Muestra la clase en formato Human-Readable
    def to_s()
    end
    
    # Regresa el juego a su estado original
    def reset()
    end

    # En esta seccion iran los metodos privados de la clase 

    private

    # Metodo que se encargara de eliminar los duplicados de una 
    # lista o diccionario

    def eliminar_duplicados(lista)
    end
    
end 

# Clase Manual que hereda de estrategia 
class Manual < Estrategia
    
    # Constructor de la clase
    def initialize()
        @mano = $sin_jugada
    end

    # Muestra la clase en un formato Human-Readable
    def to_s()
        if @mano.instance_of?(Jugada)
            "Su mano actual es " + $posibles_jugadas[@mano.to_s]
        else
            @mano
        end
    end

    # Este metodo pide al usuario que introduzca una jugada
    def prox()
        entrada = gets
        entrada.downcase! # Lleva todo el input a minusculas 
        entrada.capitalize! # Convierte a la primera letra en mayusculas
        entrada = entrada.slice(0,entrada.length - 1) # Quita el salto de linea
        @mano = Jugada.new(entrada) # Se crea una instancia de Jugada
        
        # Manejador si ocurre que el usuario ingresa una opcion no valida 
        if not @mano.jugada_valida? 
            @mano = $sin_jugada
            return "Esta jugada no es válida, introduzca una opción que lo sea"
        end 
    end

end


class Uniforme < Estrategia
    
    # Constructor de la clase
    def initialize(lista_movimientos)

    end

end