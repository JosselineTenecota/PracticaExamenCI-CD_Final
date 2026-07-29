# Inventario App - Microservicio y Pipeline CI/CD en Kubernetes

Catálogo de inventario con interfaz web, base de datos local y API REST. Este proyecto cuenta con un entorno contenerizado en Docker, una canalización de Integración y Despliegue Continuos (CI/CD) automatizada con GitHub Actions y un despliegue orquestado en Kubernetes mediante Minikube.

---

# Tecnologías Utilizadas

- Node.js
- Express
- Docker
- Kubernetes
- Minikube
- GitHub Actions
- GitHub Container Registry (GHCR)
- Jest
- Supertest
- Trivy

---

# Descripción del Proyecto

La aplicación está compuesta por los siguientes elementos:

- **Interfaz web**
  - `public/index.html`
  - `public/app.js`
  - `public/styles.css`

  Permite visualizar, agregar y eliminar productos mediante una tabla interactiva.

- **Base de datos local**
  - `db.js`
  - `data/products.json`

  Almacena la información de los productos en formato JSON sin utilizar un motor de base de datos externo.

- **API REST**

  Proporciona los servicios consumidos por la interfaz web y por las verificaciones (probes) de Kubernetes.

- **Contenedores y Orquestación**

  Utiliza Docker para la creación de imágenes y Kubernetes (Minikube) para el despliegue.

- **Integración y Despliegue Continuo (CI/CD)**

  Implementado mediante GitHub Actions y publicación automática de imágenes en GitHub Container Registry (GHCR).

- **Pruebas y Seguridad**

  - Jest y Supertest para pruebas unitarias.
  - Trivy para análisis automático de vulnerabilidades de la imagen Docker.

---

# Estructura del Proyecto

```text
INVENTARIO-APP-MAIN/
├── .github/
│   └── workflows/
│       └── ci-cd.yaml
├── data/
│   └── .gitkeep
├── k8s/
│   ├── blue-green/
│   │   ├── deployment-blue-green.yaml
│   │   └── service-blue-green.yaml
│   ├── deployment.yaml
│   ├── secret.yaml
│   └── service.yaml
├── public/
├── db.js
├── Dockerfile
├── package.json
├── README.md
├── server.js
└── server.test.js
```

---

# Ejecución del Proyecto

## 1. Iniciar Minikube

```sh
minikube start
```

**Salida esperada**

```text
minikube started
```

---

## 2. Crear el Secret de Kubernetes

```sh
kubectl apply -f k8s/secret.yaml
```

**Salida esperada**

```text
secret/inventario-secrets created
```

---

## 3. Desplegar la aplicación

```sh
kubectl apply -f k8s/deployment.yaml
```

**Salida esperada**

```text
deployment.apps/inventario-deployment configured
```

---

## 4. Crear el servicio

```sh
kubectl apply -f k8s/service.yaml
```

**Salida esperada**

```text
service/inventario-service created
```

---

# Reproducción y Verificación de Componentes

## Componente 1: Gestión de Secretos en Kubernetes

### Objetivo

Demostrar la inyección segura de credenciales mediante `secretKeyRef` utilizando el Secret `inventario-secrets`, evitando almacenar información sensible en texto plano.

### Verificar que el Secret exista

```sh
kubectl get secrets
```

### Verificar la variable de entorno dentro del contenedor

```sh
kubectl exec -it deployment/inventario-deployment -- printenv API_KEY
```

---

## Componente 2: Escaneo Automático de Seguridad con Trivy

### Objetivo

Demostrar la integración de Trivy dentro del pipeline de GitHub Actions para detectar vulnerabilidades críticas y detener el flujo de CI/CD si existen problemas de seguridad.

### Evidencia esperada

```text
Run aquasecurity/trivy-action@master
...
Total: 0 (CRITICAL: 0, HIGH: 0)

[SECURITY] Vulnerability scan completed successfully with exit-code configured for strict policy enforcement.
```

---

## Componente 3: Readiness Probe con Arranque Lento

### Objetivo

Demostrar el uso de un tiempo de espera mediante `STARTUP_DELAY_SECONDS` y una configuración robusta de Readiness Probe para evitar reinicios innecesarios durante el arranque de la aplicación.

### Reiniciar el Deployment

```sh
kubectl rollout restart deployment/inventario-deployment
```

### Monitorear los Pods

```sh
kubectl get pods
```

### Salida esperada

```text
NAME                                     READY   STATUS    RESTARTS   AGE
inventario-deployment-7754884586-44nq7   1/1     Running   0          28s
inventario-deployment-7754884586-vv9x9   1/1     Running   0          27s
```

---

# Endpoints de la API

| Método | Endpoint | Descripción |
|---------|----------|-------------|
| GET | `/health` | Estado de salud de la aplicación. |
| GET | `/version` | Devuelve versión, color y hostname. |
| GET | `/api/products` | Lista todos los productos. |
| GET | `/api/products/:id` | Obtiene un producto por ID. |
| POST | `/api/products` | Crea un nuevo producto. |
| PATCH | `/api/products/:id` | Actualiza un producto existente. |
| DELETE | `/api/products/:id` | Elimina un producto. |
| GET | `/` | Muestra la interfaz web. |

---

# Variables de Entorno

| Variable | Valor por defecto | Descripción |
|-----------|-------------------|-------------|
| `PORT` | `3000` | Puerto del servidor. |
| `APP_VERSION` | `v1` | Versión mostrada en `/version`. |
| `APP_COLOR` | `blue` | Color del encabezado de la interfaz. |
| `STARTUP_DELAY_SECONDS` | `0` | Retardo inicial utilizado para pruebas de arranque lento. |
| `SIMULATE_FAILURE` | `false` | Si es `true`, el endpoint `/health` responde con error 500. |