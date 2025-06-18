# 📁 ProyectoIntegradorM1

## 📐 Estructura del Proyecto

La estructura general del repositorio es la siguiente:

```
📦ProyectoIntegradorM1/
│
├── 📁 data/                     # Conjunto de datos en formato .csv
│      └─ [archivos.csv]
│
├── 📁 sql/                      # Consultas y scripts SQL organizados
│      │
│      ├── 📁 query_progress/       # Consultas realizadas en distintos avances del proyecto
│      │      ├── avance_1.sql
│      │      └── avance_2.sql
│      │
│      └── 📁 load/                 # Scripts para carga y creación de estructuras
│             ├── carga_datos.sql
│             └── creacion_tablas.sql
│
├── 📁 reports/                   # Reportes escritos y en notebook
│      ├── reporte_avance_1.docx
│      ├── reporte_avance_2.docx
│      └── reporte_avance_3.ipynb
│
└── 📝 README.md                  # Documentación del proyecto
```

Cada carpeta está organizada para facilitar el desarrollo, la colaboración y el seguimiento del flujo de trabajo.

### 🔗 Enlaces útiles:
- [data/](./data/)
- [sql/query_progress/](./sql/query_progress/)
- [sql/load/](./sql/load/)
- [reports/](./reports/)

---

## 🎯 Objetivos

El objetivo principal de este proyecto es:

- Transformar, limpiar y optimizar datos provenientes de distintas fuentes, garantizando su calidad y disponibilidad para el analisis
- Aplicar SQL avanzado para realizar consultas eficientes y optimizadas
- Desarrollar habilidades de data wrangling con Python para transformar y limpiar datos.
- Aplicar tecnicas de feature engineering
- Gestionar versiones del proyecto con Git.
- Documentar resultados y generar reportes claros.

---

## 🛠️ Stack Tecnológico Usado

Este proyecto fue desarrollado utilizando las siguientes tecnologías y herramientas:

- **Lenguaje**: Python 3.13
- **Librerías principales**:
  - `pandas`
  - `matplotlib` / `seaborn`
  - `scikit-learn`
- **Entorno de desarrollo**:
  - Jupyter Notebook
  - Visual Studio Code
- **Base de datos**:
  - **MySQL** (motor de base de datos)
  - **MySQL Workbench** (herramienta de modelado y administración)
- **Control de versiones**:
  - Git + GitHub

---

## 💬 Conclusiones y Observaciones

- Se logro cargar el set de datos en una base de datos (MySQL) para su rapida visualizacion y descubrimiento
- Se logro cargar, visualizar y manipular el set de datos en un entorno de trabajo utilizando python como herramienta y pandas como libreria principal.
- Se logro diseñar graficos para ayudar a visualizar las metricas asociadas al dataset
- Se descubrieron irregularidades referidos a valores nulos.
- Se logro relacionar los distintos .csv mediante merge para manipularlos mediante el uso de dataframe
- Se logro incorporar herramientas para la optimizacion  y el uso de modelos de ML.
- Finalmente se logro responder a las preguntas solicitadas generando los informes pertinentes