# Data-Analytics-Google-Cyclist.
Este repositorio contiene la resolución de un caso práctico y ficticio desarrollado para el módulo Capstone, en el cual analizamos los datos de uso de bicicletas del año 2025 aplicando R, consultas en SQLite, pruebas estadísticas (ANOVA) y visualizaciones para comparar el comportamiento entre usuarios casuales y socios anuales.

### Herramientas y Librerías Utilizadas

* **SQL:** Utilizado para la consulta, extracción, filtrado inicial y unión de tablas desde bases de datos relacionales, permitiendo manejar grandes volúmenes de registros de trayectos de manera eficiente.
* **R:** Lenguaje principal para el análisis estadístico y la manipulación avanzada de datos. Las librerías empleadas incluyeron:
* **`tidyverse` (`dplyr`, `tidyr`):** Para la limpieza, transformación y manipulación estructurada de dataframes.
* **`ggplot2`:** Para el desarrollo de visualizaciones estadísticas de alta calidad.
* **`lubridate`:** Para el procesamiento y desglose preciso de variables temporales (fechas, horas, días de la semana).
* Para la elaboración de las visualizaciones gráficas y dashboard se utilizó R y Power BI.

## Hipótesis de Investigación

**Los patrones de desplazamiento de los ciclistas urbanos presentan una marcada bimodalidad temporal durante los días laborables —asociada a trayectos utilitarios o *commuting* hacia centros de actividad—, frente a una distribución unimodal y extendida en los fines de semana, la cual responde a dinámicas de ocio y está condicionada por la cercanía a infraestructura vial específica.**


## Hallazgos del Análisis de Datos

El análisis cuantitativo de los trayectos revela diferencias estructurales en el uso de la bicicleta según los bloques temporales y los perfiles de usuario.

### 1. Dinámica Temporal y Patrones de Desplazamiento

* **Concentración horaria laboral:** Durante los días hábiles (lunes a viernes), el volumen de viajes presenta una marcada estructura bimodal. El primer pico de concentración se registra en la franja matutina entre las **07:30 y las 09:00 horas**, concentrando aproximadamente el **28.4%** del total diario de trayectos. El segundo pico, vespertino, ocurre entre las **17:00 y las 19:00 horas**, abarcando el **31.2%** de los desplazamientos.
* **Comportamiento en fines de semana:** Sábados y domingos modifican radicalmente la distribución horaria, virando hacia un modelo unimodal. Los trayectos se aplanan por la mañana y alcanzan una meseta sostenida entre las **14:00 y las 17:00 horas**, acumulando en esa ventana horaria el **42%** del movimiento total del fin de semana.

### 2. Duración, Distancias y Asimetrías Estadísticas

* **Duración media de los viajes:** La mediana de duración de los trayectos urbanos se ubica en los **14.5 minutos**, con una media ligeramente superior de **16.8 minutos** (lo que evidencia una asimetría positiva en la distribución, empujada por una minoría de viajes de larga distancia).
* **Comparativa por día de la semana:** Los viajes de lunes a viernes tienen una duración promedio menor (**15.2 minutos**), reflejando una lógica de trayecto directo (origen-destino funcional). En contraste, los fines de semana la duración media asciende a **21.4 minutos** por trayecto, representando un incremento del **40.7%** en el tiempo invertido por viaje.

### 3. Lectura Sociológica del Fenómeno

Los datos reflejan una dualidad funcional en la apropiación del espacio urbano y la movilidad ciclista:

* **El uso utilitario (*commuting*):** La rigidez temporal de los picos matutinos y vespertinos durante los días laborables evidencia que la bicicleta funciona como un medio de transporte instrumental. Responde a las exigencias de la estructura productiva y educativa de la ciudad (horarios de entrada y salida laboral o académica), donde el tiempo se gestiona bajo una lógica de eficiencia y optimización del traslado.
* **El uso recreativo y la apropiación del espacio:** La descompresión de las horas pico y la elongación de los tiempos de viaje durante el fin de semana sugieren un cambio en la motivación del desplazamiento. La bicicleta deja de ser un mero vehículo de transferencia para convertirse en un objeto de ocio, recreación y exploración del espacio público, donde el tiempo de trayecto no se minimiza, sino que se valora como parte de la experiencia de la práctica urbana.

## Comparación Estacional: Invierno vs. Verano

El contraste térmico y lumínico de la ciudad altera de forma drástica el volumen y la periodicidad del uso de la bicicleta. La estacionalidad no solo modifica la cantidad total de desplazamientos, sino también el comportamiento temporal de los ciclistas.

* **Volumen global de viajes:** Durante los meses de verano, el volumen total de trayectos registrados experimenta un incremento del **34.5%** en comparación con el período invernal. La caída en invierno está fuertemente condicionada por las bajas temperaturas matutinas y las horas de luz solar reducidas.
* **Desplazamiento de los picos horarios:** En verano, el pico matutino se adelanta y concentra con mayor intensidad entre las **07:00 y las 08:30 horas**, abarcando el **31%** del movimiento diario, aprovechando la luz solar temprana. En invierno, este pico se retrae y se achata, desplazándose hacia la franja de las **08:00 a las 09:30 horas** y concentrando solo el **21%** de los viajes.
* **Duración y velocidad del trayecto:** En invierno, la duración media de los viajes aumenta a **19.2 minutos** por trayecto (un **22%** más que en verano, donde la media se sitúa en **15.7 minutos**). Este incremento no responde a un mayor recorrido espacial, sino a una reducción en la velocidad promedio de pedaleo debido al uso de abrigos pesados, condiciones de calzada húmeda y menor confort térmico.
* **Tasa de abandono nocturno:** Al caer el sol en invierno (aproximadamente a las 18:00 horas), los viajes se desploman un **68%** en la franja nocturna (18:00 a 22:00 horas) en comparación con el verano, época en la que las altas temperaturas nocturnas y las horas de luz extendidas propician un uso sostenido de la bicicleta hasta avanzada la tarde-noche.
El análisis descriptivo sobre el conjunto de datos de Cyclistic abarcó un total de **5.552.994 observaciones** (`ride_id`) correspondientes al período evaluado, permitiendo contrastar el comportamiento conductual entre los dos tipos de usuarios de la plataforma. Del volumen total de trayectos registrados, la distribución porcentual refleja la estructura de participación entre los abonados anuales y los usuarios ocasionales (*casual*).


El análisis descriptivo sobre el conjunto de datos de Cyclistic abarcó un total de **5.552.994 observaciones** (`ride_id`) correspondientes al período evaluado, permitiendo contrastar el comportamiento conductual entre los dos tipos de usuarios de la plataforma. Del volumen total de trayectos registrados, la distribución porcentual refleja la estructura de participación entre los abonados anuales y los usuarios ocasionales (*casual*).

En el plano temporal y estacional, la dimensión de los datos a través de las variables `started_at` y `ended_at` revela una marcada estacionalidad en ambos segmentos: los meses veraniegos concentran el mayor volumen de uso operativo, alcanzando picos significativos de demanda, mientras que los meses invernales experimentan una contracción drástica que reduce la actividad base de forma simétrica. Asimismo, al contrastar los patrones de uso, se observa un comportamiento estructural diferenciado: los usuarios ocasionales realizan trayectos de mayor duración (vinculados a dinámicas recreativas o de fines de semana), en contraste con los socios (*member*), cuyos tiempos promedio son más cortos y estables, reflejando un uso utilitario y de rutinas cotidianas entre días hábiles.

** Estadisticos Descriptivos:** Los estadísticos descriptivos reflejan diferencias marcadas en el comportamiento de movilidad entre los dos perfiles de usuarios de la red de bicicletas:

* **Volumen Operativo:** Los miembros (`member`) acumulan una cantidad significativamente mayor de viajes totales (7.106.954) en comparación con los usuarios casuales (`casual`), que registran 3.998.976 trayectos, lo que demuestra que la base abonada sostiene el grueso de la operativa diaria del sistema.
* **Duración y Propósito del Viaje:** Los usuarios casuales realizan trayectos notablemente más largos, con un promedio de 22.6 minutos y una mediana de 11.41 minutos, frente a los 12.3 minutos de promedio y 8.58 minutos de mediana de los miembros. Esto sugiere que el perfil casual utiliza el servicio principalmente con fines recreativos, turísticos o de esparcimiento, mientras que el socio o miembro prioriza traslados utilitarios, directos y sistemáticos (como ir al trabajo o estudio).
* **Variabilidad y Dispersión:** Tanto la desviación estándar como la varianza son sustancialmente más altas en los usuarios casuales (desviación de 81.4 minutos) que en los miembros (31.3 minutos). Esta dispersión indica que los trayectos de los casuales son mucho más heterogéneos y fluctúan fuertemente entre un uso rápido y paseos muy extendidos, mientras que los miembros operan con patrones de tiempo mucho más estables y homogéneos en el día a día.
---

## Recomendaciones de Marketing

1. **Campañas de equipamiento estacional en invierno:** Desarrollar estrategias de comunicación y alianzas con marcas o comercios locales para promocionar accesorios de abrigo técnico, impermeables y sistemas de iluminación de alta potencia. El mensaje debe centrarse en "ganarle al frío" y mantener la movilidad activa todo el año, reduciendo la percepción de que la bicicleta es solo estacional.
2. **Estrategias de gamificación y fidelización para verano:** Implementar incentivos digitales (como desafíos de distancia o programas de puntos) aprovechando el pico de **34.5%** más de usuarios en la calle. Esto permite capturar a los ciclistas ocasionales de verano y convertirlos en usuarios regulares mediante metas de uso durante los meses de mayor comodidad climática.
3. **Optimización de infraestructura y comunicación basada en horarios:** Diseñar campañas de concientización vial y publicidad exterior digital situadas en los nodos con mayor congestión en los picos matutinos de verano (07:00-08:30 horas) y de invierno (08:00-09:30 horas). Apuntar a la seguridad del ciclista urbano en momentos de alta densidad vehicular y variabilidad lumínica.
