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

##
# Esta clase representa una estrategia arbitraria para un jugador 

class Estrategia
    
    # * +posibles_jugadas+ - Es una tabla de hash que contiene la transformacion de las jugadas en su nombre completo
    attr_reader :posibles_jugadas
    # * +sin_jugada+ - Este es un mensaje generico si una jugada no ha sido escogida 
    attr_reader :sin_jugada
    # * +simbolos_posibles+ - Son las etiquetas que son validas para el juego
    attr_reader :simbolos_posibles
    
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
    # ==== Attributes
    # 
    
    # * +r+ - Es el que almacena el objeto random para generar numeros random
    attr_accessor :r
    $r = Random.new(42)

    # Constructor de la clase 
    # @param no se recibe ningun parametro 
    def initialize()
        @mano = $sin_jugada
    end

    # Esta es una plantilla de la funcion pues cambiara 
    # segun la especializacion
    # Funcion que genera la proxima jugada
    # @param [Jugada] m es un objeto de tipo jugada 
    # @return [Jugada] retorna la proxima jugada del jugador
    def prox(m)
    end

    # Muestra la clase en formato Human-Readable
    # @return [String] que es la respuesta al usuario
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
    # @param [Array] recibe un arreglo
    # @return [Array] retorna un arreglo sin los elementos duplicados
    def eliminar_duplicados(lista)
        if lista.instance_of?(Array)
            return lista.uniq
        end
    end
    
end 

# Clase Manual que hereda de estrategia 
class Manual < Estrategia
    
    # Constructor de la clase
    def initialize() # :nodoc:
        super
    end

    # Este metodo pide al usuario que introduzca una jugada
    def prox() 
        print "Introduzca una jugada: "
        entrada = gets
        entrada.downcase! # Lleva todo el input a minusculas 
        entrada.capitalize! # Convierte a la primera letra en mayusculas
        entrada = entrada.slice(0,entrada.length - 1) # Quita el salto de linea
        @mano = Jugada.new(entrada) # Se crea una instancia de Jugada
        return @mano
        
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
    # @param [Array] lista_movimientos, es la listas de todos los movimientos de la estrategia
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
    def to_s() # :nodoc:
        mano_seleccionada = super.to_s # Hago un llamado al metodo to_s de mi padre que maneja
        # la impresion de la mano seleccionada
        if not @estrategias.nil?
            return "Las estrategias suministradas son " + @estrategias.to_s + " " + mano_seleccionada
        end
        return "La lista de estrategias provista no es valida"
    end

    # Este metodo crea la siguiente jugada a tomar 
    # @return [Jugada] retorna un objeto Jugada 
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
        return @mano       
    end

end

# Especializacion de Sesgada
class Sesgada < Estrategia 

    # Constructor de la clase 
    # @param [Hash] dic_movimientos, es un diccionario con todos los movimientos y sus probabilidades
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
    def to_s() # :nodoc:
        mano_seleccionada = super.to_s
        if not @movimientos.nil?
            return "Las estrategias suministradas son " + @movimientos.to_s + " " + mano_seleccionada
        end
        return "El diccionario de estrategias provista no es valida"
    end

    # Metodo que es escoge la mano con la cual se va a jugar 
    def prox() # :nodoc:
        numero_aleatorio = $r.rand(1..@rango)
        jugada_seleccionada = seleccion_jugada(numero_aleatorio)
        jugada_seleccionada = jugada_seleccionada.to_s
        @mano = Jugada.new(jugada_seleccionada)
        return @mano
    end

    private 
    # Funciones privadas para esta especializacion 
    # Esta funcion verifica si el diccionario introducido es valido 
    # @param [Hash] diccionario a verificar
    # @return true si el diccionario es valido, false en caso contrario 
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
    # @param [Integer] numero_random
    # @return [Jugada]
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
    # @param [Jugada] jugada, que es la jugada que va a realizar el usuario en su primer turno
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
    def prox(contrincante=nil) # :nodoc:
        if contrincante.nil?
            return @mano 
        end
        jugada_oponente = contrincante.to_s # Copio la jugada del oponente
        jugada_oponente = $posibles_jugadas[jugada_oponente] 
        @mano = Jugada.new(jugada_oponente) # La guardo como siguiente movimiento

        # Manejo si la jugada del oponente fue invalida 
        if not @mano.jugada_valida?
            @mano = $sin_jugada
        end
        return @mano
    end 

end

# Implementacion de la clase Pensar
class Pensar < Estrategia 
    
    # Constructor de la clase
    def initialize()
        super()
        # Diccionario que guarda las frecuencias de cada Jugada
        @frecuencia_jugadas = {
            "Piedra" => 1,
            "Papel" => 1,
            "Tijera" => 1,
            "Lagarto" => 1,
            "Spock" => 1
        }
    end
    

    # Metodo que define la siguiente jugada a tomar 
    def prox(jugada_oponente=nil)
        if not jugada_oponente.nil? and jugada_oponente.jugada_valida?
            mano_oponente = $posibles_jugadas[jugada_oponente.to_s] # La mano usada por el oponente
            @frecuencia_jugadas[mano_oponente] += 1 # Se le aumenta en uno a la jugada usada
        end

        @mano = seleccion_jugada
        return @mano

    end

    # Metodo para retornar el juego a su estado original
    def reset() # :nodoc:
        @frecuencia_jugadas = {
            "Piedra" => 1,
            "Papel" => 1,
            "Tijera" => 1,
            "Lagarto" => 1,
            "Spock" => 1
        }
    end
    
    private

    # Metodo que seleccion la jugada a tomar 
    # @return [Jugada]
    def seleccion_jugada()
        # Suma de todas las frecuencias 
        total_frecuencias = -1
        @frecuencia_jugadas.each_value do |valor|
            total_frecuencias += valor 
        end
        
        # Este bloque me permite saber si todas las frecuencias estan en 0 (Inicio del juego)
        # Si es asi el numero_aleatorio sera 0
        numero_aleatorio = $r.rand(0..total_frecuencias)

        # Calculo de rango para cada una de las jugadas
        frecuencia_piedra = @frecuencia_jugadas["Piedra"]
        frecuencia_papel = frecuencia_piedra + @frecuencia_jugadas["Papel"]
        frecuencia_tijera = frecuencia_papel + @frecuencia_jugadas["Tijera"]
        frecuencia_lagarto = frecuencia_tijera + @frecuencia_jugadas["Lagarto"]
        frecuencia_spock = frecuencia_lagarto + @frecuencia_jugadas["Spock"]


        # Bloque case para cada uno de los rangos 
        case numero_aleatorio
        when 0 .. (frecuencia_piedra - 1)
            return Jugada.new("Piedra")
        when frecuencia_piedra .. (frecuencia_papel - 1)
            return Jugada.new("Papel")
        when frecuencia_papel .. (frecuencia_tijera - 1)
            return Jugada.new("Tijera")
        when frecuencia_tijera .. (frecuencia_lagarto - 1)
            return Jugada.new("Lagarto")
        when frecuencia_lagarto .. (frecuencia_spock - 1)
            return Jugada.new("Spock") 
        end

    end

end