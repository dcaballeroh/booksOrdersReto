# Automatización CRUD y Autenticación - Simple Books API

Proyecto de pruebas automatizadas de API utilizando **Karate DSL** y **Gradle**. El flujo valida de extremo a extremo (E2E) las operaciones CRUD, la generación dinámica de tokens de autenticación y la validación de esquemas JSON sobre la **Simple Books API**.

## 🚀 Flujo de pruebas automatizado

El escenario principal ejecuta secuencialmente los siguientes pasos:

1. **Health Check (`GET /status`):** Verifica que la API esté activa y respondiendo correctamente (`200 OK`).
2. **Consulta de libros (`GET /books`):** Filtra libros disponibles mediante parámetros de consulta (`type=fiction`, `limit=5`), valida el esquema de respuesta y selecciona dinámicamente el ID de un libro disponible.
3. **Autenticación dinámica (`POST /api-clients`):** Registra un cliente único utilizando `System.currentTimeMillis()` para evitar conflictos (`409 Conflict`) y extrae el `Bearer Token`.
4. **Creación de orden (`POST /orders`):** Genera una nueva orden autenticada asociando el `bookId` obtenido previamente y captura el `orderId`.
5. **Consulta de orden (`GET /orders/{orderId}`):** Valida que la orden creada cumpla con el esquema definido (`orderSchema`) y que los datos coincidan.
6. **Actualización (`PATCH /orders/{orderId}`):** Modifica el nombre del cliente de la orden (`204 No Content`).
7. **Verificación de actualización (`GET /orders/{orderId}`):** Confirma que el cambio en el nombre del cliente se haya persistido.
8. **Eliminación (`DELETE /orders/{orderId}`):** Elimina la orden creada (`204 No Content`).
9. **Confirmación de borrado (`GET /orders/{orderId}`):** Verifica que la orden ya no exista devolviendo un código `404 Not Found`.

## 🛠️ Tecnologías utilizadas

* [Karate DSL](https://github.com) - Framework de automatización de pruebas de API y validación de esquemas.
* [Gradle](https://gradle.org) - Herramienta de construcción y gestión de dependencias.
* [Java](https://java.com) - Lenguaje base del proyecto.

## 📋 Prerrequisitos

* **Java JDK** (versión 11 o superior)
* **Gradle** (o utilizar el wrapper `./gradlew` incluido en el proyecto)
* Conexión a internet para consumir la Simple Books API

## 🔧 Instalación

1. **Clona el repositorio:**
   ```bash
   git clone https://github.com/dcaballeroh/booksOrdersReto.git
   ```

2. **Ingresa al directorio del proyecto:**
   ```bash
   cd reto-karate-api
   ```

## 💻 Ejecución de las pruebas

Para limpiar compilaciones anteriores y ejecutar toda la suite de pruebas, corre el siguiente comando en la raíz del proyecto:

```bash
gradle clean test
```

*(Si utilizas el wrapper de Gradle en Linux/macOS, ejecuta `./gradlew clean test`, o `gradlew.bat clean test` en Windows).*

## 📊 Reportes

Al finalizar la ejecución, Karate genera automáticamente un reporte detallado en HTML. Puedes abrirlo en tu navegador desde la siguiente ruta:

```text
build/karate-reports/karate-summary.html
```

## ✍️ Autor

* **David Caballero**