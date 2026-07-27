# inventario-app

Catálogo de inventario con interfaz web y base de datos local. Este repositorio es el **punto de partida** de la tarea de CI/CD — no incluye `Dockerfile`, workflow de GitHub Actions ni manifiestos de Kubernetes: esos tres se construyen como parte del trabajo asignado.

## Qué es

Una app Node.js/Express con:

- **Interfaz web** (`public/index.html`, `public/app.js`, `public/styles.css`): una tabla de productos con formulario para agregar y botón para eliminar.
- **Base de datos local** (`db.js`): un archivo JSON en `data/products.json` que persiste los productos entre reinicios del proceso — sin motor de base de datos externo ni dependencias nativas.
- **API REST** consumida por la interfaz.

## Ejecutar en local

```bash
npm install
npm start
# abrir http://localhost:3000
```

## Pruebas

```bash
npm test
```

## Endpoints

| Método y ruta | Qué hace |
|---|---|
| `GET /health` | Estado de salud: `200` si el proceso y el archivo de base de datos son accesibles, `500` si no (o si `SIMULATE_FAILURE=true`). |
| `GET /version` | Devuelve `version`, `color` y `hostname` — configurables por variables de entorno `APP_VERSION` / `APP_COLOR`. |
| `GET /api/products` | Lista todos los productos. |
| `GET /api/products/:id` | Devuelve un producto por id. |
| `POST /api/products` | Crea un producto (`name`, `sku`, `stock`, `price`). |
| `PATCH /api/products/:id` | Actualiza campos de un producto. |
| `DELETE /api/products/:id` | Elimina un producto. |
| `GET /` | Sirve la interfaz web. |

## Variables de entorno

| Variable | Por defecto | Para qué |
|---|---|---|
| `PORT` | `3000` | Puerto del servidor. |
| `APP_VERSION` | `v1` | Se muestra en `/version` y en el encabezado de la interfaz. |
| `APP_COLOR` | `blue` | Color del encabezado — útil para distinguir versiones en un despliegue. |
| `SIMULATE_FAILURE` | `false` | Si es `true`, `/health` responde siempre `500`. |
| `DB_PATH` | `./data/products.json` | Ruta del archivo de base de datos local. |


# 📦 Inventario App - Microservicio & Pipeline CI/CD en Kubernetes

Catálogo de inventario con interfaz web, base de datos local y API REST. Este proyecto cuenta con un entorno contenerizado en Docker, una canalización de Integración y Despliegue Continuos (CI/CD) completamente automatizada con GitHub Actions y un despliegue orquestado en Kubernetes (Minikube).

---

## 🛠️ Qué es y Tecnologías Utilizadas

Una aplicación en Node.js/Express con:

* **Interfaz web:** (`public/index.html`, `public/app.js`, `public/styles.css`): Tabla interactiva de productos con formularios para agregar y eliminar.
* **Base de datos local:** (`db.js`): Archivo JSON en `data/products.json` que persiste datos entre reinicios sin dependencias externas.
* **API REST:** Endpoints consumidos por la interfaz web y probes de Kubernetes.
* **Contenedores & Orquestación:** Docker, Kubernetes (`kubectl`), Minikube.
* **CI/CD & Registry:** GitHub Actions, GitHub Container Registry (GHCR).
* **Pruebas y Seguridad:** Jest/Supertest para pruebas unitarias y Trivy Vulnerability Scanner para análisis de imágenes.

---

## 📁 Estructura del Proyecto

```text
INVENTARIO-APP/
├── .github/
│   └── workflows/
│       └── ci-cd.yml         # Pipeline CI/CD de GitHub Actions
├── k8s/
│   ├── deployment.yaml       # Configuración de réplicas, estrategia RollingUpdate y Probes
│   ├── secret.yaml           # Secretos y variables de entorno codificadas
│   └── service.yaml          # Exposición del servicio mediante NodePort
├── public/                   # Frontend estático (HTML, CSS, JS)
├── data/                     # Persistencia de datos local (JSON)
├── db.js                     # Controlador de base de datos
├── server.js                 # Servidor Express y lógica de la API
├── server.test.js            # Pruebas unitarias para CI
├── Dockerfile                # Imagen multicapa optimizada para la app
└── package.json              # Gestión de dependencias y scripts

# 1. Iniciar el clúster local de Minikube
minikube start

# 2. Aplicar el manifiesto de Secretos (Variables de entorno)
kubectl apply -f k8s/secret.yaml

# 3. Aplicar el Deployment (Pods, Réplicas y Probes)
kubectl apply -f k8s/deployment.yaml

# 4. Aplicar el Servicio (NodePort)
kubectl apply -f k8s/service.yaml

# 5. Obtener la URL de acceso e iniciar el túnel hacia la app
minikube service inventario-service

# Verificar que los pods estén en estado Running y READY (1/1)
kubectl get pods

# Consultar el estado del servicio y puertos asignados
kubectl get services

# Simular una actualización/reinicio sin caída del servicio
kubectl rollout restart deployment/inventario-deployment

# Monitorear la sustitución progresiva de Pods en tiempo real
kubectl get pods -w

# Revisar el historial de despliegues (Rollout History)
kubectl rollout history deployment/inventario-deployment

