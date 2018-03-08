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
Este tutorial cubre el análisis de datos de comunidades microbianas usando el paquete *Phyloseq* en R. Los datos provienen del procesamiento de datos de Illumina Miseq on el programa *Mothur*.

*Phyloseq* es un paquete para R enfocado en el analisis de datos de censos de microbioma. El articulo original se encuentra en la carpeta [Recursos](https://github.com/carden24/2018_Genomica_ambiental/tree/master/Recursos). Para mas detalles ir a su pagina original [acá](http://joey711.github.io/phyloseq/).

La gran ventaja que provee *Phyloseq* es que crea un objeto que organiza todos los datos relevantes a un experimento: tablas de OTUs, metadatos, la clasificación de los OTUs, y un árbol filogenético con todos los representantes de los OTUs. Phyloseq* provee funciones especializadas para la importacion, exportacion, manipulacion, y visualizacion de datos de microbioma.

![Imagen de objeto Phyloseq](https://carden24.github.com/images/Phyloseq.jpg)  
**Esquema de un objeto de clase Phyloseq**  


## Preparativos <a name="prelim"></a>

El primer paso recomendado es establecer el directorio o carpeta de trabajo. En este directorio R busca los archivos y es también ahí donde se guardan los resultados exportados. Una segunda recomendación es crear una carpeta por cada análisis mayor e idealmente guardar ahí el script de análisis.  

````
setwd("E:/Libraries/Dropbox/tutorial/")
getwd() # Este comando reporta el directorio actual.

````

El segundo paso es cargar la libreria *Phyloseq* para tener acceso a las funciones requeridas
````
library(phyloseq)
library(ggplot2) # Este paquete es requerido para graficar los resultados
````


## Importación de datos <a name="p1"></a>

Phyloseq tiene una funcion para la importacion de archivos de mothur. Necesitamos acceder 

### Segunda parte <a name="p1.1"></a>



````
library(Phyloseq)
````



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









