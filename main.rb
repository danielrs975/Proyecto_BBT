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

$jugadas =
"
1- Piedra
2- Papel
3- Tijera
4- Lagarto
5- Spock
6- Terminar

Introduzca una jugada: "

$opcion_invalida = "La opcion marcada no es valida"

# Metodo que devuelve una jugada en String 
def seleccionar_una_jugada()
    print $jugadas 
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
        system "clear"
        return Pensar.new()
    when 2
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
        system "clear"
        puts "Copiar"
    else
        puts $opcion_invalida
        system "clear"
        return menu_secundario
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
            puts estrategia_pc
        when 2
            system "clear"
            puts "opcion 2"
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
main