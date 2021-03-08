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
