# Tutorial de manipulación de datos y gráficas en R
### Por Erick Cardenas Poire

---

# Tabla de contenidos

1. [Introducción y preparativos](#p1)
2. [Manipulación de datos con Tidiverse](#p2)
    1. [Selección de datos](#p2.1)
    2. [Reordenamiento de datos](#p2.2)
    3. [Seleccionar variables](#p2.3)
    4. [Creación de nuevas variables](#p2.4)
    5. [Condensación de variables](#p2.5)
    6. [Muestreo](#p2.6)
    7. [Conexión de funciones](#p2.7)
3. [Gráficas con ggplot2](#p3)
    1. [Concepto general](#p3.1)
    2. [Estratificando](#p3.2)
    3. [Temas de colores](#p3.3)
    4. [Paletas de colores](#p3.4)
    5. [Grabando gráficas](#p3.5)
    6. [Catálogo de visualizaciones](#p3.6)

## Introducción y preparativos <a name="p1"></a>


[Tidyverse](https://www.tidyverse.org/packages/) es un grupo de paquetes especializados en la manipulación de datos. Tienen una mentalidad, estructura, y gramatica comun. Los dos paquete del *tidyverse* que vamos a usar how con *dplyr* y *ggplot*.


 
````
setwd("E:/Libraries/Dropbox/tutorial/") # Este es mi directorio de trabajo, escoge el mas apropiado para tu trabajo
getwd()

library(dplyr)
library(ggplot2)

# Si es que las librerías no están instaladas usa este comando y reintenta cargar las librerías.
install.packages("tidyverse")

````

Cargamos el set que vamos a manipular
````
data(starwars) # cargamos el set requerido
# Set de Starwars
# 87 filas y 13 variables:
# name: Nombre del personaje
# height: Talla en cm
# mass: Peso en kg
# hair_color: Color de pelo
# skin_color: Color de piel
# birth_yea: Año de nacimiento (después de la Batalla de Yavin)
# gender: Genero con valores male, female, hermaphrodite, o none.
# homeworld: Nombre del mundo de nacimiento
# species: Nombre de la especie
# films: Lista de películas en las que aparece el personaje
# vehicles: Lista de vehiculos que el personaje piloteo
# starships: Lista de naves que el personaje piloteo
````

*Dplyr* provee una función por cada acción básica en la manipulación de datos:  
````
# filter()# Selección de datos
# arrange() # Reordenamiento de datos
# select() y rename() para seleccionar variables
# mutate() y transmute() para crear nuevas variables en funcion de variables pre-existentes
# summarise() # para condensar variables
# sample_n() y sample_frac() # Para tomar muestras al azar
````

## Selección de datos <a name="p2.1"></a>

Para seleccionar datos usamos el comando *filter()*

````
# Uso:
# filter(datos, Condicion1, Condicion2, ....)
humans = filter(starwars, species == "Human")
humans

small_droids = filter(starwars, species == "Droid", height <= 100)
small_droids
````

## Reordenamiento de datos <a name="p2.2"></a>

Para reordenar datos usamos el comando *arrange()*

````
# Uso:
# arrange(datos, Variable1, Variable2, ...) # Reordenamiento de datos
sw1 = arrange(starwars, height)
head(sw1)

sw2 = arrange(starwars, gender, height)
sw2
````

## Seleccionar variables <a name="p2.3"></a>

El comando *select()* seleccionar columas

````
# Uso:
# select(datos, ColumnaX, ColumnaY, ...)
# select(datos, ColumnaA:ColumnaD, ...) # De la columna "A" hasta la "D"
# select(datos, -ColumnaR, ...) # Todas las columnas menos la "R"

sw_tallas = select(starwars, name, height)
(sw_tallas)
````

Con *rename()* podemos renombrar el nombre de las columnas
````
# Uso
# rename(datos, NombreNuevo = Nombre_antiguo)
sw_tallas2 = rename(sw_tallas, Personaje = name, Talla = height)
sw_tallas2
````

## Creación de nuevas variables <a name="p2.4"></a>

Con *mutate()* creamos variables nuevas y la agregamos al set seleccionado, con *transmutate* solo creamos la nueva columna.

````
# Uso:
# mutate(datos nueva_variable1 = formula1)
# transmutate(datos nueva_variable2 = formula2)
SW_new = mutate(starwars, bmi = (mass / (height/100)^2))
````

## Condensación de variables <a name="p2.5"></a>

Usamos la función *summarize()* para crear una nueva table que resuma una o varias variables. Es útil cuando la usamos en combinación con la función *group_by()*

```
# Modificamos el objeto para después resumir los datos por la variable "homeworld" y "gender"
# Uso:
group_by(datos, Variable1, Variable2, ...)
mundos = group_by(starwars, homeworld, gender)
mundos

# Uso:
# summarise(datos, Nueva_variable = function(variable2))
promedios = summarise(mundos,
                      Talla_promedio = mean(height, na.rm = TRUE)
)
promedios
````

## Muestreo <a name="p2.6"></a>

Para tomar muestras de tamaño N usamos la función *sample_n()*, para tomar una fraccion del set usamos *sample_frac()*.

````
set.seed(191931)
sample_n(starwars, 10)

set.seed(191931)
sample_frac(starwars, 0.5)
````

## Conexión de funciones <a name="p2.7"></a>

Finalmente podemos utilizar el símbolo %>% como una tubería. Esta tubería toma los datos del lado izquierdo y se los pasa como input a la función de la derecha. De esta manera no generamos archivos intermedios

````
# Uso:
# nuevo_objeto = datos_originales %>% funcion1 %>% funcion2

gorditos  =
  starwars %>%
  filter(species != "Droid") %>%
  mutate(bmi = (mass / (height/100)^2)) %>%
  filter(bmi > 30) %>%
  arrange(-bmi) %>%
  select(name, species, bmi, gender, homeworld) 
gorditos  
````

## Graficas con ggplot2 <a name="p3"></a>

### Concepto general <a name="p3.1"></a>
Empezamos esta sección cargando un set de datos de EEUU donde para el la década de los 70s reporta información de población, ingreso per capita, tasa de analfabetismo, tasa de asesinatos, porcentaje de graduación de secundaria, area, dias frios, latitud, longitud, region, división, y abreviación. Los datos los puedes bajar de [acá](https://github.com/carden24/2018_Taller_Genomica_ambiental/raw/master/Visualizacion/statedata.csv) o buscalos en la carpeta "Visualizacion" del repositorio

En las siguientes gráficas demostramos como ggplot agrega capas secuencialmente

```
state = read.csv(file="statedata.csv")
summary(state)


# Capa1
plot1 = ggplot(state, 
       aes(x=HS.Grad, y=Income)) +
  geom_point()
plot1 

# Capa2
plot2 = ggplot(state, 
       aes(x=HS.Grad, y=Income)) +
  geom_point(aes(col=state.region))
plot2

# Capa3
plot3 = 
ggplot(state, 
       aes(x=HS.Grad, y=Income)) +
  geom_point(aes(col=state.region)) +
  ggtitle("Income as a function of High school graduation rates") +
  xlab("High school graduation rate") +
  ylab("Income")
plot3

# Capa4
plot4 = ggplot(state, 
       aes(x=HS.Grad, y=Income)) +
  geom_point(aes(col=state.region)) +
  ggtitle("Income as a function of high school graduation rates") +
  xlab("High school graduation rate") +
  ylab("Income ") +
  geom_text(aes(label=state.abb), nudge_x = 1, nudge_y = 1)
plot4

```

Las formas mas básicas de graficar con usando gráficas de puntos, lineas, y barras.

````
# Gráfica de puntos
ggplot(state, 
       aes(x=x, y=y, col=state.region)) + geom_point()
# Que forma tiene la grafica?       

# Gráfica de lineas
# Gráfica de densidad en funcion de la latitud geografica
state$Density = state$Population/ state$Area # Creo una nueva variable Densidad 
ggplot(state, 
       aes(x=x, y=Density)) + geom_line()

# Gráfica de barras
# Población por región
ggplot(state, 
       aes(x=state.region, y=Population, fill = state.region)) +
  geom_bar(stat="identity") # stat="identity" significa que sumamos los valores de todos los puntos de las categorias del eje x
````

### Estratificando <a name="p3.2"></a>
Para separar por grupos(o combinaciones) podemos usar *facet_wrap()* o *facet_grid()*


````
#Original Versión 1, algunos puntos estan superpuestos unos encima de otros
ggplot(state, 
       aes(x=state.region, y=Income, col=state.region)) +
  geom_point()  


# Versión 2
ggplot(state, 
       aes(x=state.region, y=Income, col=state.region)) +
  geom_jitter()  + # Esto hace que los puntos se muevan ligeramente para evitar sobrelapacion
  facet_wrap(~state.region,
             scale="free_x",
             nrow=2, ncol=2)

# Versión 3
ggplot(state, 
       aes(x=state.region, y=Income, col=state.region)) +
  geom_jitter()  + facet_wrap(~state.region,
                              scale="free", # Diferencia sutil?
                              nrow=2, ncol=2)
````


## Temas de colores <a name="p3.3"></a>

Uno puede controlar el tema de las gráficas con la opción *theme*

![Temas de ggplot2](http://r4ds.had.co.nz/images/visualization-themes.png)


````
plot4

plot4 + theme_bw()

plot4 + theme_minimal()
````


## Paletas de colores <a name="p3.4"></a>
La palea de colores para utilizar se puede escoger manualmente. El paquete **Colorbrewer** tiene muchas buenas opciones para esto.

> **Numero discreto de colores**  
> Color de relleno  : *scale_fill_brewer()*  
> Colores del borde : *scale_color_brewer()*  

> **Numero continuo de colores**  
> Color de relleno  : *scale_fill_distiller()*  
> Colores del borde : *scale_color_distiller()*  


Probando colores
````
install.packages("RColorBrewer")
library(RColorBrewer)

# Gráfica de puntos con tamaño proporcional a la población
mapa = ggplot(state, 
       aes(x=x, y=y, col=state.region, size=Population)) + geom_point() +
  theme_void()

# usamos una paleta cualitativa
mapa + scale_color_brewer(palette = "Set1")


# Gráfica de puntos con intensidad de color proporcionales a los ingresos per capita
mapa2 = 
  ggplot(state, 
         aes(x=x, y=y, col=Income)) + geom_point(size=5) +
  theme_void()

# usamos una paleta cuantitativa
mapa2 + scale_color_distiller(palette = "Blues", direction = 1)
````



## Grabando gráficas <a name="p3.5"></a>

El comando *ggsave()* es usado para guardar gráficas actuales o objetos de gráficas a archivos.
Se pueden grabar gráficas con formatos pdf, jpg, eps,svg, y png usando el commando *ggsave()*

````
ggsave("plot4.jpg")        # Graba plot actual como plot4.jpg
ggsave(filename = "plot1.jpg", plot = plot1, ) # Graba plot1 actual como plot1.jpg
ggsave(plot=plot2, filename = "plot2.jpg", width=6, height=4) # Graba plot2 actual como plot2.jpg usando dimensiones 6 x 4 in
````

## Catalogo de visualizaciones <a name="p3.6"></a>

En [esta página](http://shiny.stat.ubc.ca/r-graph-catalog/
) se pueden ver diferentes tipos de visualizaciones con su código en para ggplot2.

Acá hay buenas sugerencias para mejorar visualizaciones
http://stat545.com/block015_graph-dos-donts.html



