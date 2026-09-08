# --- 1. INSTALACIÓN DE PAQUETES (Ejecutar solo si falta alguno) ---
install.packages(c("tidyverse", "lubridate", "DBI", "RSQLite", "dplyr", "ggplot2"), dependencies = TRUE)

# --- 2. CARGA DE LIBRERÍAS ---
library(tidyverse)
library(dplyr)
library(ggplot2)
library(lubridate)
library(DBI)
library(RSQLite)

# --- 3. CONFIGURAR LA UBICACIÓN EXACTA DE LOS ARCHIVOS ---
ruta_archivos <- "C:/Users/Usuario/Desktop/R Studio Projects/ech/Caso de estudio Bicicletas/bases/Ciclistas"
setwd(ruta_archivos)

# --- 4. CONFIGURACIÓN DE LA BASE DE DATOS ---
nombre_db <- "ciclistas_2025.db"
con <- dbConnect(SQLite(), dbname = nombre_db)

# Generamos los nombres exactos de los 12 archivos de 2025
archivos_2025 <- sprintf("2025%02d-divvy-tripdata.csv", 1:12)

# --- 5. PROCESAMIENTO MES A MES (OPTIMIZADO PARA LA PC) ---
cat("Comenzando la importación y limpieza mes a mes...\n")

for (archivo in archivos_2025) {
  if (file.exists(archivo)) {
    cat(paste("Procesando:", archivo, "...\n"))
    
    # Leemos el archivo
    df_mes <- read_csv(archivo, col_types = cols(.default = "c"), show_col_types = FALSE)
    
    # Limpieza y transformación
    df_limpio <- df_mes %>%
      mutate(
        started_at = ymd_hms(started_at),
        ended_at = ymd_hms(ended_at)
      ) %>%
      filter(!is.na(started_at) & !is.na(ended_at)) %>%
      mutate(
        duracion_minutos = as.numeric(difftime(ended_at, started_at, units = "mins")),
        mes = format(started_at, "%Y-%m")
      ) %>%
      filter(duracion_minutos > 0)
    
    # Guardamos los datos limpios en la base de datos (se apilan mes a mes)
    dbWriteTable(con, "uso_bicicleta", df_limpio, append = TRUE, row.names = FALSE)
    
    # Liberamos la memoria RAM
    rm(df_mes, df_limpio)
    gc()
    
  } else {
    cat(paste("ATENCIÓN: El archivo no se encuentra ->", archivo, "\n"))
  }
}

cat("¡Proceso finalizado! Base de datos guardada correctamente en la carpeta Ciclistas.\n")

# --- 6. PRUEBA DE CONSULTA SQL ---
resumen_prueba <- dbGetQuery(con, "
  SELECT 
    member_casual, 
    COUNT(*) AS total_viajes,
    ROUND(AVG(duracion_minutos), 2) AS promedio_duracion_min
  FROM uso_bicicleta
  GROUP BY member_casual
")

print("Resumen obtenido directamente de la base de datos SQLite:")
print(resumen_prueba)

# Desconexión de seguridad
dbDisconnect(con)


library(DBI)
library(RSQLite)
library(tidyverse)

# 1. Nos conectamos a la base de datos existente
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# 2. Consultamos los datos resumidos directamente desde SQL
datos_grafico <- dbGetQuery(con, "
  SELECT 
    mes,
    member_casual,
    COUNT(*) AS total_viajes
  FROM uso_bicicleta
  GROUP BY mes, member_casual
  ORDER BY mes ASC
")

# Cerramos la conexión
dbDisconnect(con)

# 3. Creamos la gráfica de barras con ggplot2
ggplot(datos_grafico, aes(x = mes, y = total_viajes, fill = member_casual)) +
  # Usamos position = "dodge" para que las barras de 'casual' y 'member' estén lado a lado por mes
  geom_bar(stat = "identity", position = "dodge") +
  # Personalizamos etiquetas y títulos
  labs(
    title = "Total de Viajes por Mes y Tipo de Usuario (2025)",
    subtitle = "Comparativa entre Socios Anuales (member) y Usuarios Casuales (casual)",
    x = "Mes",
    y = "Cantidad de Viajes",
    fill = "Tipo de Usuario"
  ) +
  # Mejoramos el diseño visual y rotamos los meses abajo para que se lean perfectamente
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 10),
    plot.title = element_text(face = "bold", size = 14)
  ) +
  # Opcional: formatea los números del eje Y con separadores de miles
  scale_y_continuous(labels = scales::comma)


library(DBI)
library(RSQLite)
library(tidyverse)

# 1. Conexión a la base de datos
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# 2. Extracción de datos resumidos
datos_grafico <- dbGetQuery(con, "
  SELECT 
    mes,
    member_casual,
    COUNT(*) AS total_viajes
  FROM uso_bicicleta
  GROUP BY mes, member_casual
  ORDER BY mes ASC
")

dbDisconnect(con)

# 3. Gráfica de barras con colores personalizados (Naranja y Violeta)
ggplot(datos_grafico, aes(x = mes, y = total_viajes, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  # Asignamos colores personalizados a cada tipo de usuario
  scale_fill_manual(
    values = c("casual" = "#FF7F0E", "member" = "#8E44AD"),
    labels = c("casual" = "Casual", "member" = "Socio Anual")
  ) +
  labs(
    title = "Total de Viajes por Mes y Tipo de Usuario (2025)",
    subtitle = "Comparativa de uso mensual",
    x = "Mes",
    y = "Cantidad de Viajes",
    fill = "Tipo de Usuario"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 10),
    plot.title = element_text(face = "bold", size = 14)
  ) +
  scale_y_continuous(labels = scales::comma)


library(DBI)
library(RSQLite)
library(tidyverse)

# 1. Conexión a la base de datos SQLite
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# --- ANÁLISIS 1: Cantidad de viajes por mes y tipo de usuario ---
cat("--- 1. VIAJES POR MES Y TIPO DE USUARIO ---\n")
viajes_mes <- dbGetQuery(con, "
  SELECT 
    mes,
    member_casual,
    COUNT(*) AS total_viajes
  FROM uso_bicicleta
  GROUP BY mes, member_casual
  ORDER BY mes ASC, member_casual ASC
")
print(viajes_mes)
cat("\n\n")


# --- ANÁLISIS 2: Viajes en fin de semana vs días de semana (% comparativo) ---
# En SQL SQLite, strftime('%w', started_at) devuelve 0 para domingo y 6 para sábado.
cat("--- 2. FIN DE SEMANA VS DÍAS DE SEMANA (%) ---\n")
analisis_semana <- dbGetQuery(con, "
  WITH clasificacion_dias AS (
    SELECT 
      member_casual,
      CASE 
        WHEN strftime('%w', started_at) IN ('0', '6') THEN 'Fin de semana'
        ELSE 'Dia de semana'
      END AS tipo_dia
    FROM uso_bicicleta
  )
  SELECT 
    member_casual,
    tipo_dia,
    COUNT(*) AS cantidad
  FROM clasificacion_dias
  GROUP BY member_casual, tipo_dia
")

# Calculamos los porcentajes relativos para cada tipo de usuario en R
analisis_semana_pct <- analisis_semana %>%
  group_by(member_casual) %>%
  mutate(
    total_usuario = sum(cantidad),
    porcentaje = round((cantidad / total_usuario) * 100, 2)
  )

print(analisis_semana_pct)
cat("\n\n")


# --- ANÁLISIS 3 y 4: Tiempo de uso, Varianza y Desviación Estándar ---
cat("--- 3 Y 4. ESTADÍSTICOS DE TIEMPO DE USO (Promedio, Mediana, Varianza) ---\n")
# Como SQLite no tiene una función nativa directa de varianza (VAR), 
# traemos los datos de duración a R para calcular la varianza exacta y hacer el ANOVA.
datos_duracion <- dbGetQuery(con, "
  SELECT member_casual, duracion_minutos 
  FROM uso_bicicleta
")

resumen_estadistico <- datos_duracion %>%
  group_by(member_casual) %>%
  summarise(
    total_viajes = n(),
    promedio_min = mean(duracion_minutos, na.rm = TRUE),
    mediana_min = median(duracion_minutos, na.rm = TRUE),
    varianza_min = var(duracion_minutos, na.rm = TRUE),
    desviacion_std = sd(duracion_minutos, na.rm = TRUE)
  )

print(resumen_estadistico)
cat("\n\n")


# --- ANÁLISIS 5: Prueba ANOVA (Análisis de Varianza) ---
cat("--- 5. PRUEBA ANOVA (Diferencia de medias de duración por tipo de usuario) ---\n")
# Evaluamos si el tiempo de uso difiere estadísticamente entre 'casual' y 'member'
modelo_anova <- aov(duracion_minutos ~ member_casual, data = datos_duracion)
print(summary(modelo_anova))

# Desconexión de seguridad de la base de datos
dbDisconnect(con)




library(DBI)
library(RSQLite)
library(tidyverse)

# 1. Conexión a la base de datos
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# 2. Consulta SQL para obtener la evolución mensual de viajes por tipo de usuario
datos_linea <- dbGetQuery(con, "
  SELECT 
    mes,
    member_casual,
    COUNT(*) AS total_viajes
  FROM uso_bicicleta
  GROUP BY mes, member_casual
  ORDER BY mes ASC
")

dbDisconnect(con)

# 3. Generación del gráfico de líneas temporal
ggplot(datos_linea, aes(x = mes, y = total_viajes, group = member_casual, color = member_casual)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  scale_color_manual(
    values = c("casual" = "#FF7F0E", "member" = "#8E44AD"),
    labels = c("casual" = "Casual", "member" = "Socio Anual")
  ) +
  labs(
    title = "Evolución Histórica Mensual de Viajes (2025)",
    subtitle = "Tendencia anual comparativa entre usuarios casuales y socios anuales",
    x = "Mes",
    y = "Cantidad de Viajes",
    color = "Tipo de Usuario"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10, face = "bold"),
    legend.position = "right"
  ) +
  scale_y_continuous(labels = scales::comma)

library(DBI)
library(RSQLite)
library(tidyverse)

# 1. Conexión a la base de datos
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# 2. Consulta SQL para obtener la tabla cruzada de viajes por mes y tipo de usuario
tabla_usos_mes <- dbGetQuery(con, "
  SELECT 
    mes,
    SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS socios_anuales,
    SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casuales,
    COUNT(*) AS total_general
  FROM uso_bicicleta
  GROUP BY mes
  ORDER BY mes ASC
")

dbDisconnect(con)

# 3. Mostrar la tabla resultante en la consola
print("Tabla de volumen de usos por mes y tipo de usuario:")
print(tabla_usos_mes)


library(DBI)
library(RSQLite)

# 1. Conexión a la base de datos
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# 2. Consulta SQL para calcular la frecuencia absoluta y relativa por tipo de usuario
frecuencia_tipos <- dbGetQuery(con, "
  SELECT 
    member_casual AS tipo_usuario,
    COUNT(*) AS frecuencia_absoluta,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM uso_bicicleta), 2) AS frecuencia_relativa_porcentaje
  FROM uso_bicicleta
  GROUP BY member_casual
")

dbDisconnect(con)

# 3. Mostrar la tabla de frecuencias
print("Frecuencia de viajes por tipo de usuario:")
print(frecuencia_tipos)


library(DBI)
library(RSQLite)

# 1. Conexión a la base de datos
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# 2. Consulta SQL para calcular la frecuencia absoluta y relativa por tipo de usuario
frecuencia_tipos <- dbGetQuery(con, "
  SELECT 
    member_casual AS tipo_usuario,
    COUNT(*) AS frecuencia_absoluta,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM uso_bicicleta), 2) AS frecuencia_relativa_porcentaje
  FROM uso_bicicleta
  GROUP BY member_casual
")

dbDisconnect(con)

# 3. Mostrar la tabla de frecuencias
print("Frecuencia de viajes por tipo de usuario:")
print(frecuencia_tipos)



library(DBI)
library(RSQLite)
library(tidyverse)

# 1. Conexión a la base de datos
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# 2. Tabla de frecuencia por mes y tipo de usuario
tabla_frecuencia_mes <- dbGetQuery(con, "
  SELECT 
    mes,
    member_casual AS tipo_usuario,
    COUNT(*) AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY mes), 2) AS porcentaje_mensual
  FROM uso_bicicleta
  GROUP BY mes, member_casual
  ORDER BY mes ASC, tipo_usuario DESC
")

print("--- Tabla de Frecuencia por Mes y Tipo de Usuario ---")
print(tabla_frecuencia_mes)

# 3. Extracción de datos para el modelo de regresión lineal
datos_modelo <- dbGetQuery(con, "
  SELECT ride_length, member_casual, mes 
  FROM uso_bicicleta
")

dbDisconnect(con)

# 4. Preparación de variables categóricas y ajuste del modelo de regresión
# Evaluamos cómo la duración del viaje (ride_length) se explica por el tipo de usuario y el mes
datos_modelo$member_casual <- as.factor(datos_modelo$member_casual)
datos_modelo$mes <- as.factor(datos_modelo$mes)

modelo_regresion <- lm(ride_length ~ member_casual + mes, data = datos_modelo)

print("--- Resumen del Modelo de Regresión ---")
print(summary(modelo_regresion))


library(DBI)
library(RSQLite)
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")
print(dbListFields(con, "uso_bicicleta"))
dbDisconnect(con)


library(DBI)
library(RSQLite)
library(tidyverse)

con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# 1. Tabla de frecuencia por mes y tipo de usuario
tabla_frecuencia_mes <- dbGetQuery(con, "
  SELECT 
    mes,
    member_casual AS tipo_usuario,
    COUNT(*) AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY mes), 2) AS porcentaje_mensual
  FROM uso_bicicleta
  GROUP BY mes, member_casual
  ORDER BY mes ASC, tipo_usuario DESC
")

print("--- Tabla de Frecuencia por Mes y Tipo de Usuario ---")
print(tabla_frecuencia_mes)

# 2. Extracción calculando la duración del viaje (asumiendo started_at y ended_at)
datos_modelo <- dbGetQuery(con, "
  SELECT 
    (julianday(ended_at) - julianday(started_at)) * 86400 AS ride_length, 
    member_casual, 
    mes 
  FROM uso_bicicleta
")

dbDisconnect(con)

# 3. Ajuste del modelo de regresión
datos_modelo$member_casual <- as.factor(datos_modelo$member_casual)
datos_modelo$mes <- as.factor(datos_modelo$mes)

modelo_regresion <- lm(ride_length ~ member_casual + mes, data = datos_modelo)

print("--- Resumen del Modelo de Regresión ---")
print(summary(modelo_regresion))



library(DBI)
library(RSQLite)

con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

datos_modelo <- dbGetQuery(con, "
  SELECT duracion_minutos, member_casual, mes 
  FROM uso_bicicleta
")

dbDisconnect(con)

datos_modelo$member_casual <- as.factor(datos_modelo$member_casual)
datos_modelo$mes <- as.factor(datos_modelo$mes)

modelo_regresion <- lm(duracion_minutos ~ member_casual + mes, data = datos_modelo)

print(summary(modelo_regresion))




library(DBI)
library(RSQLite)
library(tidyverse)

# 1. Conexión a la base de datos
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# 2. Tabla de frecuencia por mes y tipo de usuario
tabla_frecuencia_mes <- dbGetQuery(con, "
  SELECT 
    mes,
    member_casual AS tipo_usuario,
    COUNT(*) AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY mes), 2) AS porcentaje_mensual
  FROM uso_bicicleta
  GROUP BY mes, member_casual
  ORDER BY mes ASC, tipo_usuario DESC
")

print("--- Tabla de Frecuencia por Mes y Tipo de Usuario ---")
print(tabla_frecuencia_mes)

# 3. Extracción de datos para el modelo de regresión
datos_modelo <- dbGetQuery(con, "
  SELECT duracion_minutos, member_casual, mes 
  FROM uso_bicicleta
")

dbDisconnect(con)

# 4. Ajuste del modelo de regresión lineal
datos_modelo$member_casual <- as.factor(datos_modelo$member_casual)
datos_modelo$mes <- as.factor(datos_modelo$mes)

modelo_regresion <- lm(duracion_minutos ~ member_casual + mes, data = datos_modelo)

print("--- Resumen del Modelo de Regresión ---")
print(summary(modelo_regresion))


# 1. Guardar objetos específicos (por ejemplo, el modelo de regresión y la tabla de frecuencias)
save(modelo_regresion, tabla_frecuencia_mes, file = "resultados_cyclistic.RData")

# O si prefieres guardar solamente el modelo en un archivo individual:
saveRDS(modelo_regresion, file = "modelo_regresion_cyclistic.rds")


library(DBI)
library(RSQLite)
library(tidyverse)

# 1. Conexión a la base de datos
con <- dbConnect(SQLite(), dbname = "ciclistas_2025.db")

# 2. Análisis de patrones por día de la semana y hora de inicio (si tienes las columnas de fecha/hora originales)
# Esto extrae el día de la semana y la hora para comparar comportamientos de rutina vs recreación
patrones_horarios <- dbGetQuery(con, "
  SELECT 
    member_casual,
    strftime('%w', started_at) AS dia_semana_num, -- 0=Domingo, 1=Lunes, etc.
    strftime('%H', started_at) AS hora_dia,
    COUNT(*) AS total_viajes
  FROM uso_bicicleta
  GROUP BY member_casual, dia_semana_num, hora_dia
")

print("--- Resumen de Patrones Horarios y Días de la Semana ---")
print(head(patrones_horarios, 10))

# 3. Extracción de datos para un Modelo de Regresión Avanzado con Interacción
# Evaluamos si el efecto del tipo de usuario sobre la duración cambia dependiendo del mes
datos_interaccion <- dbGetQuery(con, "
  SELECT duracion_minutos, member_casual, mes 
  FROM uso_bicicleta
")

dbDisconnect(con)

# 4. Preparación de factores y modelo con interacción (member_casual * mes)
datos_interaccion$member_casual <- as.factor(datos_interaccion$member_casual)
datos_interaccion$mes <- as.factor(datos_interaccion$mes)

modelo_interaccion <- lm(duracion_minutos ~ member_casual * mes, data = datos_interaccion)

print("--- Resumen del Modelo de Regresión con Interacción ---")
print(summary(modelo_interaccion))

