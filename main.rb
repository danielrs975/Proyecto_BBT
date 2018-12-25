=begin
En este archivo se encontrara la implementacion de la interfaz grafica 
para el proyecto 
=end
require_relative 'Estrategia.rb'
require_relative 'Jugada.rb'
require_relative 'Partida.rb'

# Hash que mapea las jugadas de strings a simbolos
$jugadas_a_simbolos = {
    "Piedra" => :Piedra,
    "Papel" => :Papel,
    "Tijera" => :Tijera,
    "Lagarto" => :Lagarto,
    "Spock" => :Spock
}

$estrategias =
"
1- Pensar
2- Uniforme
3- Sesgada
4- Copiar

Introduzca una opcion: "

$jugadas_disponibles =
"
1- Piedra
2- Papel
3- Tijera
4- Lagarto
5- Spock
6- Terminar

Introduzca una jugada: "

$modalidad_juegos = 
"
1- Rondas
2- Cantidad de puntos

Introduzca una modalidad: "

$opcion_invalida = "La opcion marcada no es valida"

# Metodo que devuelve una jugada en String 
def seleccionar_una_jugada()
    print $jugadas_disponibles 
    respuesta = gets
    respuesta = respuesta.to_i
    case respuesta 
    when 1
        system "clear"
        return "Piedra"
    when 2
        system "clear"
        return "Papel"
    when 3
        system "clear"
        return "Tijera"
    when 4
        system "clear"
        return "Lagarto"
    when 5
        system "clear"
        return "Spock"
    when 6
        system "clear"
        return nil
    else
        puts $opcion_invalida
        system "clear"
        return seleccionar_una_jugada
    end
end

# Menu del principal del juego 
def menu_principal()
    print "1- Jugar contra la computadora
2- Simular una partida
3- Salir del juego

Introduzca una opcion: "
    respuesta = gets
    respuesta.to_i
end

# Menu secundario del juego 
def menu_secundario()
    print $estrategias
    respuesta = gets
    respuesta = respuesta.to_i 
    case respuesta
    when 1
        # Implementacion de la opcion Pensar
        system "clear"
        return Pensar.new()
    when 2
        # Implementacion de la opcion Uniforme
        system "clear"
        lista_movimientos = []
        jugada = seleccionar_una_jugada
        while not jugada.nil?
            puts jugada
            lista_movimientos.append($jugadas_a_simbolos[jugada])
            jugada = seleccionar_una_jugada
        end
        if lista_movimientos.length > 0 
            system "clear"
            return Uniforme.new(lista_movimientos)
        else
            system "clear"
            puts "La lista de movimientos no esta vacio"
            return menu_secundario
        end
    when 3
        # Implementacion de la opcion Sesgada
        system "clear"
        dic_movimientos = {}
        jugada = seleccionar_una_jugada
        while not jugada.nil?
            print "Escriba una probabilidad (Un entero): "
            probabilidad = gets 
            probabilidad = probabilidad.to_i
            while probabilidad == 0
                puts "La probabilidad puesta no es un numero"
                print "Escriba una probabilidad (Un entero): "
                probabilidad = gets
                probabilidad = probabilidad.to_i
            end
            jugada = $jugadas_a_simbolos[jugada]
            dic_movimientos[jugada] = probabilidad
            jugada = seleccionar_una_jugada
        end
        if dic_movimientos.length > 0 
            system "clear"
            return Sesgada.new(dic_movimientos)
        end
        return "El diccionario de movimientos no esta vacio"
    when 4
        # Implementacion de la opcion Copiar
        system "clear"
        jugada_seleccionada = seleccionar_una_jugada
        if not jugada_seleccionada.nil?
            return Copiar.new(jugada_seleccionada)
        end
        return "La jugada seleccionada no es valida"
    else
        # Maneja si la opcion no es valida
        puts $opcion_invalida
        system "clear"
        return menu_secundario
    end
end

# Otro menu de para seleccionar que modalidad de juego se seleccionara 
def menu_modalidad(partida)
    print $modalidad_juegos
    respuesta = gets
    respuesta = respuesta.to_i
    case respuesta
    when 1
        system "clear"
        print "Introduzca un numero de rondas: "
        numero_rondas = gets
        numero_rondas = numero_rondas.to_i
        while numero_rondas == 0
            puts "El numero de rondas introducido no es valido"
            print "Introduzca un numero de rondas: "
            numero_rondas = gets 
            numero_rondas = numero_rondas.to_i
        end
        return partida.rondas(numero_rondas)
    when 2
        system "clear"
        print "Introduzca la cantidad de puntos: "
        numero_puntos = gets
        numero_puntos = numero_puntos.to_i
        while numero_puntos == 0
            puts "El numero de puntos introducido no es valido"
            print "Introduzca un numero de puntos: "
            numero_puntos = gets
            numero_puntos = numero_puntos.to_i
        end
        return partida.alcanzar(numero_puntos)
    else
        system "clear"
        puts $opcion_invalida
        return menu_modalidad
    end
end

# Main para el programa 
def main()
    # Loop principal del juego 
    while true
        respuesta = menu_principal 
        case respuesta
        when 1
            system "clear"
            estrategia_jugador = Manual.new()
            estrategia_pc = menu_secundario()
            mapa_de_jugadores = {
                :Jugador_1 => estrategia_jugador,
                :Computadora => estrategia_pc
            }
            partida = Partida.new(mapa_de_jugadores)
            resultado = menu_modalidad(partida)
            system "clear"
            puts resultado 
            exit
        when 2
            estrategia_pc_1 = menu_secundario()
            estrategia_pc_2 = menu_secundario()
            mapa_de_jugadores = {
                :Computadora_1 => estrategia_pc_1,
                :Computadora_2 => estrategia_pc_2
            }
            partida = Partida.new(mapa_de_jugadores)
            resultado = menu_modalidad(partida)
            puts resultado
            exit
        when 3
            exit
        else
            puts $opcion_invalida
            system "clear"
            main
        end
    end
end

# correr main
while true
    main
end