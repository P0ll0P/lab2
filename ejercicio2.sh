#!/bin/bash

#Argumento

if [ "$#" -ne 1 ]; then
        echo "Argumento necesario: $0 <proceso>" >&2
        exit 1
fi

#Ejecutar proceso y registrar datos
archivo_log="registro_cpu_memoria.dat"
echo "# Tiempo CPU% memoria%" > $archivo_log

#Ejecutando con eval y obteniendo su PID
comando="$@"
eval "$proceso &"
datos_del_proceso=$!

#regitro continuo de procesos
while kill $datos_del_proceso 2> /dev/null; do
	echo "$(date +%s) $(ps -p $datos_del_proceso -o %cpu,%mem | tail -n +2)" >> "$archivo_log"
	sleep 1
done

#grafica con gnuplot
gnuplot <<EOF
set terminal qt
set output 'grafica.png'
set title "Consumo de CPU y Memoria"
set xlabel "timepo (segundos)"
set ylabel "uso (%)"
set grid 
set key outside
set xdata time
set timefmt "%s"
set format x "%H:%M:%S"
plot "$archivo_log" using 1:2 with lines title "CPU%" lc rgb "blue"\
"$archivo_log" using 1:3 with lines title "Memoria %" lc rgb "green" 
EOF
echo "grafica generada: grafica.png"
