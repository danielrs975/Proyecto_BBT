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
    attr_reader :posibles_jugadas, :sin_jugada, :simbolos_posibles

    # Un diccionario que contiene el mapeo entre la jugada mostrada por el 
    # objeto Jugada a un formato mas amigable 
    $posibles_jugadas = {
        "pi" => "Piedra",
        "pa" => "Papel",
        "ti" => "Tijera",
        "sp" => "Spock",
        "la" => "Lagarto"
    }

    # Lista de simbolos posibles
    $simbolos_posibles = [
        :Piedra,
        :Papel,
        :Tijera,
        :Spock,
        :Lagarto
    ]

    # Tiene un string que contiene la respuesta en caso de 
    # que no se halla seleccionado una jugada
    $sin_jugada = "No se ha seleccionado una jugada"

    # Instancia de la clase Random para generar numeros aleatorios 
    $r = Random.new(42)

    # Constructor de la clase 
    def initialize()
        @mano = $sin_jugada
    end

    # Esta es una plantilla de la funcion pues cambiara 
    # segun la especializacion
    # Funcion que genera la proxima jugada
    def prox(m)
    end

    # Muestra la clase en formato Human-Readable
    def to_s()
        if @mano.instance_of?(Jugada)
            "Su mano actual es " + $posibles_jugadas[@mano.to_s]
        else
            @mano
        end
    end
    
    # Regresa el juego a su estado original
    def reset()
    end

    # En esta seccion iran los metodos privados de la clase 

    private

    # Metodo que se encargara de eliminar los duplicados de una 
    # lista o diccionario

    def eliminar_duplicados(lista)
        if lista.instance_of?(Array)
            lista.uniq!
        end
    end
    
end 

# Clase Manual que hereda de estrategia 
class Manual < Estrategia
    
    # Constructor de la clase
    def initialize()
        super
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

# Especializacion de Uniforme 
class Uniforme < Estrategia
    
    # Constructor de la clase
    def initialize(lista_movimientos)
        super()
        # Verifica que cada elemento sea un simbolo y ademas sea un simbolo valido
        lista_valida = lista_movimientos.all? {|estrategia| estrategia.instance_of?(Symbol) and $simbolos_posibles.member?(estrategia)}
        if lista_movimientos.length == 0 or (not lista_valida) 
            # Esto ultimo verifica que todos los elementos de la lista sean del mismo
            # tipo, Symbol
            @estrategias = nil 
            return
        end
        @estrategias = eliminar_duplicados(lista_movimientos)
    end

    # Muestra la clase en un formato Human-Readable
    def to_s()
        mano_seleccionada = super.to_s # Hago un llamado al metodo to_s de mi padre que maneja
        # la impresion de la mano seleccionada
        if not @estrategias.nil?
            return "Las estrategias suministradas son " + @estrategias.to_s + " " + mano_seleccionada
        end
        return "La lista de estrategias provista no es valida"
    end

    # Este metodo crea la siguiente jugada a tomar 
    def prox()
        # Como sigue una distribucion uniforme entonces 
        # cada uno de los movimientos tendra la misma
        # probabilidad. Esto se traduce en conseguir un
        # numero random entre 0 y el numero de estrategias
        # menos 1 
        posicion_jugada = $r.rand(0..(@estrategias.length - 1))
        jugada_seleccionada = @estrategias[posicion_jugada]
        jugada_seleccionada = jugada_seleccionada.to_s
        @mano = Jugada.new(jugada_seleccionada)       
    end

end

# Especializacion de Sesgada
class Sesgada < Estrategia 

    # Constructor de la clase 
    def initialize(dic_movimientos)
        super() # Inicializo el atributo mano
        if diccionario_valido?(dic_movimientos)
            @movimientos = dic_movimientos # Aqui se mantiene solo los casos favorables por cada movimiento
            @rangos = dic_movimientos.clone # Aqui se guardaran los rangos 
            @rango = 0
            @rangos.each_key do |jugada|
                @rangos[jugada] += @rango
                @rango = @rangos[jugada]
            end
        else
            @movimientos = nil 
        end
    end

    # Metodo que muestra la clase en un formato Human-Readable
    def to_s()
        mano_seleccionada = super.to_s
        if not @movimientos.nil?
            return "Las estrategias suministradas son " + @movimientos.to_s + " " + mano_seleccionada
        end
        return "El diccionario de estrategias provista no es valida"
    end

    # Metodo que es escoge la mano con la cual se va a jugar 
    def prox()
        numero_aleatorio = $r.rand(1..@rango)
        jugada_seleccionada = seleccion_jugada(numero_aleatorio)
        jugada_seleccionada = jugada_seleccionada.to_s
        @mano = Jugada.new(jugada_seleccionada)
    end

    private 
    # Funciones privadas para esta especializacion 

    def diccionario_valido?(dic)
        # Verifica que cada una de las llaves sea un simbolo, ademas que sea
        # un simbolo valido 
        dic.each_key do |jugada|
            if not jugada.instance_of?(Symbol) or not $simbolos_posibles.member?(jugada)
                return false
            end
        end 

        # Que la probabilidad sea un numero mayor o igual que 1 
        dic.each_value do |probabilidad|
            if probabilidad < 1
                return false 
            end
        end

        return true 
    end

    # Metodo que regresa una jugada dependiendo en que rango
    # caiga el numero aleatorio 
    def seleccion_jugada(numero_random)
        '''
            Explicacion de este metodo:
            Por ejemplo para una lista de movimientos como esta
                    {:Tijera => 3, :Papel => 2}
            Los rangos seran los siguientes 
                    {:Tijera => 3, :Papel => 5}
            Esto sera que si un numero random cae entre 
            1 y 3 (Inclusivo) devolvera Tijera
            si cae entre 4 y 5 devolvera Papel 
            Esto se modela con el <= del condicional
        '''
        @rangos.each_key do |jugada| # Se recorre el diccionario 
            if numero_random <= @rangos[jugada] # Cuando se consiga una jugada cuyo valor sea menor o igual
                # que el numero random se retorna dicha jugada
                return jugada 
            end
        end
    end
end

# Implementacion de la clase Copiar 
class Copiar < Estrategia

    # Constructor de la clase
    def initialize(jugada)
        # Esto es en el caso que le paso un string
        # como la jugada
        jugada.downcase!
        jugada.capitalize!
        @mano = Jugada.new(jugada)
        if not @mano.jugada_valida?
            @mano = $sin_jugada
        end
    end

    # Metodo que define la siguiente jugada a tomar 
    def prox(contrincante)
        jugada_oponente = contrincante.to_s # Copio la jugada del oponente
        jugada_oponente = $posibles_jugadas[jugada_oponente] 
        @mano = Jugada.new(jugada_oponente) # La guardo como siguiente movimiento

        # Manejo si la jugada del oponente fue invalida 
        if not @mano.jugada_valida?
            @mano = $sin_jugada
        end
    end 

end