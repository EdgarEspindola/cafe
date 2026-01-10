# 📄 README – Proyecto Rails + JasperReports (Docker)

Este proyecto es una aplicación **Ruby on Rails 5.0.5** que utiliza **PostgreSQL** y genera **PDFs mediante JasperReports (Java)**.
El entorno está **dockerizado** para evitar problemas de versiones y dependencias.

> ⚠️ **Nota importante**: este proyecto usa **tecnología legacy** (Rails 5, Devise 4.3.0, Jasper vía Java).
> **NO actualizar versiones sin validar compatibilidad**.

---

## 🧩 Stack técnico

* **Ruby**: 2.4.x
* **Rails**: 5.0.5
* **Devise**: 4.3.0
* **DB**: PostgreSQL
* **PDFs**: JasperReports (Java)
* **Java**: Temurin / OpenJDK 8 (instalado manualmente)
* **Contenedores**: Docker + Docker Compose

---

## 📁 Estructura relevante

```
.
├── app/
├── lib/
│   └── jasper-bridge/
│       └── jasper-reports/
│           ├── bin/        # InterfaceJasperXML.class
│           └── lib/        # JARs de JasperReports
├── reports/               # PDFs generados (.pdf, .jasper, .jrxml)
├── Dockerfile
├── docker-compose.yml
├── Gemfile
├── Gemfile.lock
└── README.md
```

---

### 1️⃣ **NO usar `bash -l` (login shell)**

Este proyecto **requiere Java en PATH** para ejecutar JasperReports.

❌ **NO usar**:

```bash
bash -lc
```

✅ **USAR**:

```bash
bash -c
```

👉 El login shell (`-l`) **resetea el PATH** y rompe Java (`java: not found`).

Esto ya está corregido en:

* `Dockerfile`
* `docker-compose.yml`

⚠️ **NO CAMBIAR ESTO**.

---

### 2️⃣ Java NO se instala con `apt`

Java se instala **manualmente** (Temurin JRE 8) porque:

* `openjdk` vía `apt` falla en imágenes Debian viejas
* `ca-certificates-java` rompe el build

La ruta válida de Java es:

```bash
/opt/java/bin/java
```

---

## 🚀 Cómo levantar el proyecto (paso a paso)

### 1️⃣ Requisitos

* Docker
* Docker Compose

---

### 2️⃣ Construir la imagen

```bash
docker compose build --no-cache
```

---

### 3️⃣ Levantar la aplicación

```bash
docker compose up
```

La app queda disponible en:

```
http://localhost:3000
```

---

## 🗄️ Base de datos

### Crear y migrar la DB (solo la primera vez)

```bash
docker compose run --rm web bin/rails db:setup
```

O, si ya existe:

```bash
docker compose run --rm web bin/rails db:migrate
```

---

## 🧑‍💻 Acceso a consola Rails

👉 **NO es necesario detener la app**.

```bash
docker compose run --rm web bin/rails console
```

Ejemplo para crear un usuario:

```ruby
User.create!(
  email: "admin@example.com",
  password: "password123",
  password_confirmation: "password123"
)
```

---

## 📄 Generación de PDFs (JasperReports)

### Flujo

1. Rails renderiza un XML (`.xml.builder`)
2. Ruby ejecuta Java (`InterfaceJasperXML.class`)
3. Jasper genera el PDF en:

```
/app/reports/*.pdf
```

### Verificación rápida

Si el PDF no se genera, **lo primero que hay que validar** es:

```bash
docker exec -it cafe-web-1 sh -c 'which java; java -version'
```

Debe mostrar Java **sin error**.

---

## 🧪 Comprobaciones útiles

### Ver Java dentro del contenedor activo

```bash
docker exec -it cafe-web-1 sh -c 'java -version'
```

### Ver archivos Jasper

```bash
docker exec -it cafe-web-1 ls -la /app/lib/jasper-bridge/jasper-reports/bin
docker exec -it cafe-web-1 ls -la /app/lib/jasper-bridge/jasper-reports/lib
```

---

## 🧨 Errores comunes y solución

### ❌ `sh: java: not found`

✔ Java no está en PATH
✔ Se usó `bash -l`
✔ Contenedor viejo sin recrear

👉 Solución:

```bash
docker compose down
docker compose up --build --force-recreate
```

---

### ❌ `ActionController::MissingFile (Cannot read file entradas.pdf)`

✔ Jasper no corrió
✔ Java no se ejecutó

👉 Revisar **Java primero**, no Rails.

---

## 🧠 Notas finales

* Este proyecto **funciona**, pero es **legacy**
* NO actualizar Ruby, Rails o Devise “por probar”
* El código de Jasper **no se toca** si ya genera PDFs
* Si algo falla, **primero revisar Docker / PATH / Java**
* Infraestructura > código (en este proyecto)
