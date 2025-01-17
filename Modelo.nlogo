globals[
  upper  ;;the upper edge of exit
  lower  ;;the lower edge of exit


             upper1  ;;the upper edge of bloque   MODIFICACIÓN POR CALEB
             lower1  ;;the lower edge of bloque   MODIFICACIÓN POR CALEB
             upper2  ;;the upper edge of bloque   MODIFICACIÓN POR CALEB
             lower2  ;;the lower edge of bloque   MODIFICACIÓN POR CALEB


  move-speed ;;how many patches did people move in last tick on average. max = 1 patch/tick
  alist  ;;used in calculating the shortest distance to exits
  the-row         ;;used in export-data. it is the row being written
]
turtles-own[
  moved? ;;if it moved in this tick
]
patches-own[
  exit  ;;1 if it is an exit, 0 if it is not
  elelist ;;a list of elevations to the exits
  elevation  ;;elevation at this point is equal to shortest distance to exits
  path  ;;how many times it has been chosen as a path
]
to setup
 ca
 reset-ticks
 file-close
 draw-gridlines
 ;;set up the bounding wall
 ask patches [set pcolor white set path 0]
 ask patches with [pxcor = 20 or pxcor = -20][set pcolor black]
 ask patches with [pycor = 20 or pycor = -20][set pcolor black]


             set upper1 round (Bloque / 2)                                                                                  ;;MODIFICACIÓN POR CALEB
             set lower1 0 - (Bloque - upper1)                                                                               ;;MODIFICACIÓN POR CALEB
             ask patches with [pxcor = 18 and pycor < upper1 and pycor >= lower1 ][set pcolor black]                        ;;MODIFICACIÓN POR CALEB
             set upper2 round (Salida_opcional / 2)                                                                         ;;MODIFICACIÓN POR CALEB
             set lower2 0 - (Salida_opcional - upper2)                                                                      ;;MODIFICACIÓN POR CALEB


 set upper round (Tamaño_de_salida / 2)
 set lower 0 - (Tamaño_de_salida - upper)
 ask patches with [pxcor = 20 and pycor < upper and pycor >= lower ][set pcolor white set exit 1]


             ask patches with [pxcor = -20 and pycor < upper2 and pycor >= lower2 ][set pcolor white set exit 1]            ;;MODIFICACIÓN POR CALEB


 ;;set up elevation
 ask patches [
   set alist []
   ask patches with [exit = 1][
     set alist lput distance myself alist]
   set elevation min alist]
 ask patches with [pcolor = black] [set elevation 999999999]
 ;;create people


             ask n-of peatones patches with [pcolor = white and pxcor != 20][sprout 1 [set color red set shape "person"]]   ;;MODIFICACIÓN POR CALEB


 ;;to show different colors in different areas
 ;ask turtles with [xcor < -5 and ycor > 5][set color yellow]
 ;ask turtles with [xcor < -5 and ycor < -5][set color green]
 ;ask turtles with [xcor >= -5][set color blue]
end
to go
  if count turtles > 0 [set move-speed count turtles with [moved? = true] / count turtles]
  if count turtles = 0 [stop]
  ask patches with [exit = 1] [ask turtles-here[die]]
  ask turtles [
    set moved? false
    let target min-one-of neighbors [ elevation + ( count turtles-here * 9999999) ]
    if [elevation + (count turtles-here * 9999999)] of target < [elevation] of patch-here
    [ face target
      move-to target
      set moved? true
      ask target [set path path + 1]]
  ]
  if Mostrar_grafica [ask patches with [pcolor != black][let thecolor (9.9 - (path * 0.15)) if thecolor < 0.001 [set thecolor 0.001] set pcolor thecolor]]
  tick
end
to move-right
  set heading 90
  fd 1
end
to move-down
  set heading 180
  fd 1
end
to move-up
  set heading 0
  fd 1
end
to draw-gridlines
let x min-pxcor
repeat world-width - 1 [
  crt 1 [
    set ycor min-pycor
    set xcor x + 0.5
    set color 0
    set heading 0
    pd
    fd world-height - 1
    die]
      set x x + 1]
set x min-pycor
repeat world-height - 1[
  crt 1[
    set xcor min-pxcor
    set ycor x + 0.5
    set color 0
    set heading 90
    pd
    fd world-width - 1
    die
  ] set x x + 1]
end
to show_elevation
  let min-e min [elevation] of patches with [pcolor != black and exit != 1]
  let max-e max [elevation] of patches with [pcolor != black and exit != 1]
  print min-e
  print max-e
  ask patches with [pcolor != black][set pcolor scale-color blue elevation (max-e + 1) min-e]
end
to export_data
  file-close
  if file-exists? "data/result.asc" [ file-delete "data/result.asc"]
  file-open "data/result.asc"
  file-print "ncols         41   \r\n"
  file-print "nrows         41   \r\n"
  file-print "xllcorner     -122.26638888878   \r\n"
  file-print "yllcorner     42.855833333   \r\n"
  file-print  "cellsize      0.0011111111111859   \r\n"
  file-print  "NODATA_value  -9999   \r\n"
  let y 20
  while [y >= -20]
    [let x -20
      while [x <= 20][
        ask patch x y [file-write path]
        set x x + 1]
      file-print " "
      set y y - 1]
  file-close
end
@#$#@#$#@
GRAPHICS-WINDOW
146
10
629
494
-1
-1
11.6
1
10
1
1
1
0
0
0
1
-20
20
-20
20
0
0
1
ticks
30.0

BUTTON
1
10
141
43
Configuración inicial
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1
43
72
76
Iniciar
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1
144
141
177
Tamaño_de_salida
Tamaño_de_salida
1
41
10.0
1
1
NIL
HORIZONTAL

SLIDER
1
177
141
210
Peatones
Peatones
0
1000
500.0
1
1
NIL
HORIZONTAL

BUTTON
72
43
141
76
Iniciar
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
1
210
141
243
Mostrar_grafica
Mostrar_grafica
1
1
-1000

BUTTON
1
76
141
109
Gráfica de elevación
show_elevation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
633
10
1012
197
Número de personas restantes atrapadas
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

TEXTBOX
7
113
157
143
Mientras más oscuro, mayor es la \"elevación\"
12
0.0
1

PLOT
633
198
1012
359
Velocidad promedio
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot move-speed"

BUTTON
633
359
776
392
Exportar gráfica de camino
export_data
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

TEXTBOX
636
395
766
440
Exporta la frecuencia del camino a un archivo con formato asc.
12
0.0
1

SLIDER
1
243
141
276
Bloque
Bloque
0
10
0.0
1
1
NIL
HORIZONTAL

SLIDER
1
276
141
309
Salida_opcional
Salida_opcional
0
41
1.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## ¿Qué es esto?
Este es un modelo de peatones que tratan de salir de una habitación a través de una salida del lado derecho de la habitación. El modelo además graba la frecuencia en que cada parche es escogido como camino del peaton y dibuja el resultado en una gráfica de camino, que puede ser exportada al formato GIS para análisis futuros.

A continuación se muestra una gráfica de camino:

![Picture not found](file:data/path_frequency.jpg)

## ¿Cómo funciona?

Cada parche tiene una variable llamada elevación, la cual es determinada por la distancia más corta hacia la salida. Si hay más de un parche de salida, la elevación es igual a la distancia más corta cercana a uno de los parches de salida.
Los peatones usan el modelo de gravedad (el flujo es hacia la elevación menor si el espacio lo permite) para moverse hacia la salida.

## ¿Cómo usarlo?

1. Utilice los deslizadores para ajustar el ancho de la salida, el número de personas y si quiere generar un bloque cerca de la puerta.
2. Presione Configuración inicial para construir el espacio, la salida y una cantidad aleatoriamente distribuida de peatones en el espacio.
3. Ponga encendido en Mostrar_grafica para mostrar la gráfica de  frecuencia de camino.
4. Presione iniciar para que los peatones se muevan 1 celda en cada tick, si el camino lo permite.
5. Use la función de Exportar gráfica de camino para generar un archivo GIS de la gráfica de frecuencia.

## Extendiendo el modelo
¿Podrías agregar obstaculos en medio de la habitación? ¿Qué pasaría si hubiera más de una salida?

## Características de Netlogo
Para calcular la "elevación" cada parche calcula la distancia hacia cada parche de salida y establece la menor distancia posible como la elevación. Cuando corre el modelo, los peatones siempre se tratan de mover hacia la menor elevación. Éste algoritmo también puede ser usado para construir un modelo de lluvia para analizar el movimiento de las gotas de lluvia en el suelo.

## Modelos relacionados
Un modelo de lluvia previo: https://github.com/YangZhouCSS/Rainfall_Model

Los modelos de Grand Canyon en la librería de modelos.

## Modificación
Modelo modificado por: Caleb Aguilar Camargo
Fecha de modificación: 12 de junio de 2019
Modificaciones:
-Se agrega una salida opcional de lado izquierdo que puede llegar a ser del mismo tamaño que la original.
-Se agrega un bloque próximo a la salida para ver la interacción que genera con los peatones.
-Los botones ahora están en español.
-En el código las modificaciones están en medio de 2 párrafos de espacios para localizarlas fácilmente.
Créditos a Yang Zhou por crear el modelo, el link de descarga es: https://github.com/YangZhouCSS/Pedestrian_model
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
