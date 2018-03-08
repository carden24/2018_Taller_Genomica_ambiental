# Procesamiento de datos de microbioma usando *Mothur*
### Por Erick Cárdenas Poiré


---

# Tabla de contenidos
1. [Introducción](#p1)
2. [Preparativos](#p2)
    1. [Instalación de *Mothur*](#p2.1)
    2. [Archivos de referencia para *Mothur*](#p2.2)
    3. [Secuencias y archivos relacionados](#p2.3)
3. [Procesamiento inicial](#p3)
   1. [Concatenación de pares](#p3.1)
   2. [Remoción de secuencias anormales](#p3.2)
   3. [Dereplicación](#p3.3)
4. [Alineamiento](#p4)
5. [Eliminación de errores](#p5)
   1. [Reducción de ruido](#p5.1)
   2. [Remoción de quimeras](#p5.2)
   3. [Remoción de lineajes indeseados](#p5.3)
6. [Creación de tablas de OTUs](#p6)
7. [Creación de arboles filogenéticos](#p7)
8. [Exportación de datos](#p8)

## Introducción  <a name="p1"></a>
Este tutorial usa el programa *Mothur* para procesar archivos de secuenciación del gen de ARNr 16S. Este tutorial esta basado en el protocolo operativo estándar desarrollado por Patrick Schloss que se encuentra disponible [acá](http://www.mothur.org/wiki/MiSeq_SOP). 

**Requisitos:**
- Mothur instalado (ver abajo)
- Archivos de referencia de Mothur (en la carpeta MiSeq_SOP_files)
- Secuencias y archivos relacionados (en la carpeta MiSeq_SOP_files)

## Preparativos <a name="p2"></a>

Lo primero que hay que hacer es decidir donde poner todos los archivos para el tutorial. Lo ideal es crear un directorio de fácil acceso. Por ejemple podemos crear un directorio llamado *mothur* en el disco duro C.  

### Instalación de *Mothur* <a name="p2.1"></a>

La versión mas reciente de *Mothur* se encuentra [acá](https://github.com/mothur/mothur/releases/latest).  Para ejecutar este tutorial es necesario bajar el archivo y descomprimirlo dentro de la carpeta de trabajo. Esta versión de *Mothur* no tiene interfaz gráfica sino que se ejecuta tipeando comandos en el terminal de mothur. Luego de descomprimir el archivo haz click en el y se vera lo siguiente:

![Imagen de Mothur prompt](https://carden24.github.com/images/Mothur.jpg) 

Si es que esto no funciona se puede acceder a la terminal de windows directamente e iniciar *Mothur* desde ahí.

Para acceder al terminal desde windows apretar   **[Windows] + R**  
Luego tipear **cmd** y apretar **Enter**

Por predeterminado nos encontramos en el directorio del usuario actual ````c:\Users\erick````

Para movernos de directorio usamos el comando **cd**

````
cd ..             Cambiamos al directorio de arriba
cd c:\mothur      Cambiamos al directorio "mothur" en c:/

````

Cuando llegamos al directorio donde se encuentran los ejecutables de *Mothur* podemos iniciar el programa tipeando:
````
mothur.exe
````

En esta nueva terminal es que tenemos que tipear los comandos. *Mothur* mantiene una lista de los ultimos archivos creados asi que no es necesario muchas veces retipear el nombre del archivo sino solo reemplazar su nombre con "current". Para saber cuales son los archivos o parametros  que *Mothur* considera como los mas actuales se puede usar el comando *get.current()*. Para cambiar estos parametros se puede usar el comando *set.current*.

*Mothur* puede también recibir comandos directamente desde el terminal de Windows o ejecutar una serie de comandos escritos en un archivo de texto (un comando por linea). 


````
mothur "#fastq.info(fastq=test.fastq);get.current()"

mothur stability.batch
````

El archivo *stability.batch* contiene todos los comandos necesarios para el procesamiento estándar y se puede reutilizar para analizar otras muestras siempre y cuando se cambie el contenido del archivo *stability.files* que tiene la lista de archivos de secuencias.

### Archivos de referencia para *Mothur* <a name="p2.2"></a>

*Mothur* necesita archivos extras para poder funcionar. Los archivos se encuentran en la carpeta MiSeq_SOP_files. Es necesario bajarlos y descomprimirlos en la carpeta de trabajo. Estos son los archivos que vamos a usar para el tutorial:

- Alineamiento de referencia de *Silva* versión 102(Silva.bacteria.zip). Útil para tutorial, versiones mas recientes disponibles [acá](https://www.mothur.org/wiki/Silva_reference_files).
- Taxonomía del RDP formateado para *Mothur* (Trainset14_032015.pds.zip). Mothur mantiene la lista de taxonomías del RDP [acá](https://www.mothur.org/wiki/RDP_reference_files). *Mothur recomienda* usar la taxonomia de Greengenes. *Mothur* mantiene una lista de las  versiones mas recientes [acá](https://www.mothur.org/wiki/Greengenes-formatted_databases).


### Secuencias y archivos relacionados <a name="p2.3"></a>

Finalmente necesitamos bajar las secuencias de Miseq y archivos relacionados al experimento. El tutorial original usa 21 pares, esta usa 9 pares para hacer el tutorial mas corto.

- Secuencias en formato fastq (Miseq SOP.zip)
- Diseño experimental (mouse.time.design)
- Metadatos (mouse.dpw.metadata)
- stability.files (lista de archivos de secuencias)

## Procesamiento inicial <a name="p3"></a>

### Concatenación de pares <a name="p3.1"></a>

El comando *make.contigs* une el par de secuencias que provienen de la misma molécula. La región hipervariable V4 del gen de ARNr tiene en promedio 364 bases por lo que secuenciarla de ambos lados con secuencias de 250 bases crea un gran solapamiento. *Mothur* une las secuencias y usa los valores de calidad para asignar bases en la región que se sobrelapa.  


```
make.contigs(file=stability.files, processors=2)
```

Este comando también genera archivos que se necesitan después. 
:
  
- *stability.trim.contigs.fasta* : Nuevas secuencias unidas
- *stability.contigs.groups* : El grupo al cual pertenece cada secuencias
- *stability.contigs.report* : Reporte del proceso de concatenamiento
  
Para crear estadisdicas de las secuencias usamos el comando *summary.seqs*

 
 ```
 summary.seqs()
 ```
 
### Remoción de secuencias anormales <a name="p3.2"></a>

Usamos el comando *screen.seqs*  para remover secuencias de acuerdo a su tamaño y el numero de bases ambiguas en ellas (Ns). Este paso remueve secuencias erróneas y artefactos.

 
```
screen.seqs(fasta=stability.trim.contigs.fasta, group=stability.contigs.groups, maxambig=0, maxlength=275)
```

En este caso removemos secuencias con bases ambiguas y secuencias mas largas que 275 bp. Este numero depende del tamaño del la región definida por los primers.
 

### Dereplicación <a name="p3.3"></a>

En este paso removemos secuencias idénticas para reducir la carga en la computadora. *Mothur* se encarga de acordarse de que hizo esto. 
Este es un paso no cambia la calidad de las secuencias pero reduce la carga computacional (tiempo de procesamiento y memoria requerida).

```
unique.seqs(fasta=stability.trim.contigs.good.fasta)
``` 

El protocolo requiere que usemos *count.seqs* para crear una tabla que registra las secuencias repetidas.

```
count.seqs(name=stability.trim.contigs.good.names, group=stability.contigs.good.groups)
```

## Alineamiento <a name="p4"></a> 

En este paso alineamos nuestras secuencias con el alineamiento de referencia de SILVA, un alineamiento curado manualmente de gran calidad. Este es un archivo grande con casi 15000 secuencias y mas de 50000 posiciones. Para hacer nuestra trabajo mas fácil vamos a editar el alineamiento de Silva a las región que nos interesa (V4) y luego alinearemos nuestras secuencias con esta selección. Finalmente editaremos el alineamiento que incluye nuestras secuencias.  


El primer comando, *pcr.seqs*, edita el alineamiento de Silva a nuestra región de interés. Si es que no sabes las coordinadas de la región de interés, saltea el tutorial hasta el comando *align.seqs* y ahí usa la opción *reference=silva.bacteria.fasta*.

```
pcr.seqs(fasta=silva.bacteria.fasta, start=11894, end=25319, keepdots=F)
```

Ahora podemos renombrar el nuevo archivo creado con algo mas fácil de entender usando el comando *rename.file*. 

```
rename.file(input=silva.bacteria.pcr.fasta, new=silva.v4.fasta)
```

Ahora podemos alinear las secuencias al alineamiento maestro de Silva para la region V4. 


```
align.seqs(fasta=stability.trim.contigs.good.unique.fasta, reference=silva.v4.fasta)
```

Luego de alinear las secuencias podemos ejecutar *summary.seqs()* de nuevo  para ver estadísticas sobre distribución de las secuencias en el alineamiento. Al evaluar el alineamiento podemos ver que la mayoría de las secuencias empieza en la posición 1968 y termina en la posición 11550. Esto es útil detectar secuencias con muchas inserciones o con muchos homopolímeros ya que estas tienden a ser erróneas.  
Utilizamos entonces el comando *screen.seqs* para eliminar secuencias.
```
screen.seqs(fasta=stability.trim.contigs.good.unique.align, count=stability.trim.contigs.good.count_table, summary=stability.trim.contigs.good.unique.summary, start=1968, end=11550, maxhomop=8)
```

Ahora podemos editar el alineamiento al remover posiciones que solo tienen gaps ya que no contribuyen con datos. El comando *screen.seqs* también necesita saber cual es el carácter que el alineamiento usa para indicar que no hay datos (trump character). En nuestro caso el alineamiento de Silva usa ".".

```
filter.seqs(fasta=stability.trim.contigs.good.unique.good.align, vertical=T, trump=.)
```

Finalmente ejecutamos summary.seqs() y vemos que el alineamiento tiene muchas menos posiciones lo cual hace el calculo posterior mas fácil. 
````
summary.seqs()
````

**Opcional:**
También podemos ejecutar *unique.seqs* ya que algunas secuencias pueden ser idénticas luego del alineamiento. 

```
unique.seqs()
```

## Eliminación de errores <a name="p5"></a>

Estos pasos reducen mejoran la calidad de los datos al eliminar errores del secuenciador, secuencias provenientes del huésped, y algunos artefactos generados por la PCR.  

### Reducción de ruido <a name="p5.1"></a>

El primer paso es agrupar secuencias altamente similares con *pre.cluster*. Este comando primero agrupa secuencias que difieran en unas cuantas posiciones, este caso no mas de dos diferencias (1 por cada 100 bases). Si hay varias secuencias similar el algoritmo escoge a la secuencia mas abundante como la secuencias correcta y asume que las demás son diferentes debido a errores de secuenciación.

```
pre.cluster(fasta=current, count=current, diffs=2)
```

### Remoción de quimeras <a name="p5.2"></a>

Las quimeras son artefactos de la PCR creados cuando la secuencias de una especie se alinean con las de otra especies. El resultado de este encuentro casi amoroso es un artefacto que no representa la diversidad real de la comunidad.

El primer paso detecta las quimeras. El segundo las remueve. Deben ejecutarse uno después del otro   
```
chimera.vsearch(fasta=stability.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=stability.trim.contigs.good.unique.good.filter.unique.precluster.count_table, dereplicate=t)

remove.seqs(fasta=current, accnos=current)
```

### Remoción de lineajes indeseados <a name="p5.3"></a>

En algunos casos nuestra PCR puede amplificar secuencias de organelos del huésped (mitocondrias, cloroplastos), secuencias de arqueas o eucariotas (con menos especificidad y poca sensibilidad) y otros artefactos. Estas secuencias deben ser detectadas y removidas pues no representan a la comunidad microbiana.  
El primer paso es clasificar todas las secuencias de la comunidad con *classify.sequences* y luego remover los lineajes no deseados con *remove.lineajes*. El primer paso usa el método Bayesiano de clasificación, usando los archivos de referencia del RDP. 


```
classify.seqs(fasta=current, count=current, reference=trainset9_032012.pds.fasta, taxonomy=trainset9_032012.pds.tax, cutoff=80)

remove.lineage(fasta=current, count=current, taxonomy=current, taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota)
```

**Opcional:**
También se pueden remover muestras que de comunidades modelos utilizando el comando *remove.seqs*. El tutorial de Miseq original explica como utilizar comunidades modelos (con abundancias definidas) para calcular tasas de error.


```
remove.groups(count=current, fasta=current, taxonomy=current, groups=Mock)
```

## Creacion de tablas de OTUS <a name="p6"></a>

El siguiente objetivo es agrupar las secuencias en unidades taxonómicas operacionales (OTUs), grupos de secuencias definidos por la similitud entre ellas. La forma tradicional es primero crear una matriz de distancias con *dist.seqs* y luego crear grupos de secuencias con esta matriz con *cluster*. Este método es muy lento cuando se trabajan con miles de secuencias. 

````
No ejecutar estos comandos
dist.seqs(fasta=stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.fasta, cutoff=0.03)
cluster(column=stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.dist, count=stability.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.pick.count_table)

````

Una alternativa practica es usar *cluster.split*. Este método primero crea grupos basándose en la matriz de distancia o en la clasificación taxonómica de las secuencias y posteriormente aplica los métodos de agrupamientos sobre las selecciones individuales. Es este caso usaremos la clasificación taxonómica para separar los grupos a nivel de orden (nivel taxonómico), y luego aplicaremos el método algoritmo *opticlust* para crear OTUs. El comando *cluster.split* necesita una valor para saber hasta que porcentaje de similitud hay que crear las matrices de distancia. Para este algoritmo, cutoff=0.03 es suficiente, para el método *average neighbour* se recomiendan valores mas altos que el parametro final (usar 0.15 si es que se quiere trabajar a nivel de especies ).


```
cluster.split(fasta=current, count=current, taxonomy=current, splitmethod=classify, taxlevel=4, cutoff=0.15)
cluster.split(fasta=stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.fasta, count=stability.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.pick.count_table, taxonomy=stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.pick.taxonomy, splitmethod=classify, taxlevel=4, cutoff=0.03)
```

Ahora podemos usar las matrices de distancia para crear las tablas de OTUs. En este caso nos interesa trabajar a nivel de especie que es aproximadamente 3%.


```
make.shared(list=current, count=current, label=0.03)
```
La tabla que se genero es lo necesario para hacer los análisis de diversidad. 

El ultimo paso del protocolo es asignar una clasificación taxonómica a cada OTU. Para esto usaremos el comando *classify.otu* que genera para la clasificación de consenso para el OTU. 

```
classify.otu(list=current, count=current, taxonomy=current, label=0.03)
```

## Creación de arboles filogenético <a name="p7"></a>

Algunos métodos como Unifrac requieren saber la localizacion de cada otu en un arbol filogenetico del estudio. Este proceso se basa en el alineamiento y crea primero una matriz de distancias y luego usa esa matrix para crear un arbol basado en distancias (método Neighbour-joining.)

```
dist.seqs(fasta=stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.fasta, output=lt, processors=8)
clearcut(phylip=stability.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.phylip.dist)
```

## Exportación de datos <a name="p8"></a>

Mothur genera muchos archivos intermedios con nombres complicados. La forma mas fácil de transferir estos archivos a otros programas es convirtiéndolo a un objeto en formato biom. Para mas información de este formato ver [acá] http://biom-format.org/documentation/biom_format.html. 


````
make.biom(shared=final.tx.1.subsample.1.pick.shared, constaxonomy=final.tx.1.cons.taxonomy, metadata=metadata.txt)

````



