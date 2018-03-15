# Analisis de comunidades microbianas con *Phyloseq*
### Por Erick Cardenas Poire

---

# Tabla de contenidos
1. [Introducción](#introduction)
2. [Preparativos](#prelim)
3. [Importación de datos](#p3)
    1. [Sub paragraph](#p1.1)
4. [Preparacion de datos](#p4)
    1. [Filtracion de muestras](#4.1)
    2. [Filtracion de OTUs](#p4.2)
    3. [Normalizacion](#p4.3)
5. [Visualizacion de comunidades](#p5)
6. [Diversidad alfa](#p6)
7. [Ordenaciones no restringigas](#p7)
8. [PERMANOVA](#p8)
9. [Ordenaciones restringidas](#p9)
10. [Datos de la sesion](#p10)

## Introducción <a name="introduction"></a>
Este tutorial cubre el análisis de datos de comunidades microbianas usando el paquete *Phyloseq* en R. Los datos provienen del procesamiento de datos de Illumina Miseq on el programa *Mothur*. El tutorial esta basado parcialmente en el tutorial de *Phyloseq* por Michelle Berry disponible [acá](http://deneflab.github.io/MicrobeMiseq/demos/mothur_2_phyloseq.html).

*Phyloseq* es un paquete para R enfocado en el análisis de datos de censos de microbioma. El articulo original se encuentra en la carpeta *Recursos* de este repositorio. Para mas detalles ir a su página original [acá](http://joey711.github.io/phyloseq/).

La gran ventaja que provee *Phyloseq* es que crea un objeto que organiza y agrupa todos los datos relevantes de un experimento: tablas de OTUs, metadatos, la clasificación de los OTUs, y un árbol filogenético con todos los representantes de los OTUs. *Phyloseq* provee además funciones especializadas para la importación, exportacion, manipulación, y visualización de datos de microbioma.

**Esquema de un objeto de clase Phyloseq**  
![Imagen de objeto Phyloseq](https://carden24.github.com/images/Phyloseq.jpg)  



## Preparativos <a name="prelim"></a>

El primer paso recomendado es establecer el directorio o carpeta de trabajo. En este directorio R busca los archivos y es también ahí donde se guardan los resultados exportados. Es recomendado que en general la creación de una carpeta por cada análisis mayor e idealmente guardar ahí también el script de análisis.  

Abrir Rstudio y ahí crear un nuevo script en blanco con **Ctrl** + **Shift** + **N**. Es acá donde vamos a ir escribiendo los comandos y ejecutando cada linea con **Ctrl** + **R**. En R el símbolo **#** es usado para anotar la linea de código. Todo lo que viene después del "#" es ignorado por el programa pero es útil para saber la función de la linea o bloque de código.

````
setwd("E:/Libraries/Dropbox/tutorial/")
getwd() # Este comando reporta el directorio actual.

````

El segundo paso es cargar la librería *Phyloseq* para tener acceso a las funciones requeridas
````
library(phyloseq)
library(ggplot2) # Este paquete es requerido para graficar los resultados
library(vegan) # Este es un paquete para analisis de diversidad
````

Finalmente vamos a cargar unas funciones contenidas en el archivo "miseqR.R". Estas funciones provienen del tutorial original y son herramientas útiles. El archivo debe estar en el directorio de trabajo para que R lo pueda encontrar. Los archivos requeridos para este tutorial se encuentran en el folder "Archivos_Phyloseq" del [repositorio del taller](https://github.com/carden24/2018_Taller_Genomica_ambiental).


````
source("miseqR.R")
````


## Importación de datos <a name="p1"></a>

*Phyloseq* tiene una función para la importación de archivos de *Mothur*. Es necesario copia y pegar los archivos de la sesión anterior en la carpeta de trabajo y luego usar el siguiente código en R. Si no encuentras los archivos necesarios puedes acceder a ellos [acá](https://github.com/carden24/2018_Taller_Genomica_ambiental).

````
# Crear variables para los archivos que exportamos de *Mothur*
shared_file = "stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.opti_mcc.unique_list.shared"
tax_file = "stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.opti_mcc.unique_list.0.03.cons.taxonomy"
metadata_file = "mouse.dpw.metadata_file"
tree_file = "stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.phylip.tre"

# Import mothur data
mothur_data <- import_mothur(mothur_shared_file = sharedfile,
  mothur_constaxonomy_file = taxfile)

# Import sample metadata
map <- read.delim2(metadata_file, header=TRUE)

````

Una vez creados estos dos objetos podemos ver su contenido escribiendo el nombre del objeto o si es un objeto muy grande podemos usar el comando head()





### Segunda parte <a name="p1.1"></a>





## Datos de la sesion]<a name="p10"></a>

Lo ultimo que se recomienda es grabar los datos de la sesion, esto es util para poder recrear los datos completamente, especialmente si es que posteriormente se usan otras versiones de R o de alguno de los paquetes. Esta informacion se puede guardar al final del script.

```
sessionInfo()
```
 
Alternativamente se puede grabar todos objetos de la sesion usando 

````
save.image("Toda_la_session.RData") # Graba todos los objetos de la sesión a un archivo de extensión *.Rdata*
save(data, file="un_objeto.Rdata")  # Graba el objeto data a un archivo de extensión *.Rdata*

load("Toda_la_session.RData") # Carga todos los objetos contenidos en el archivo de extension *.Rdata*
load("un_objeto.Rdata") # Carga todos los objetos contenidos en el archivo de extension *.Rdata*

````









