# 📦 Inventario App - Microservicio & Pipeline CI/CD en Kubernetes

Catálogo de inventario con interfaz web, base de datos local y API REST. Este proyecto cuenta con un entorno contenerizado en Docker, una canalización de Integración y Despliegue Continuos (CI/CD) completamente automatizada con GitHub Actions y un despliegue orquestado en Kubernetes (Minikube).

---

## 🛠️ Qué es y Tecnologías Utilizadas

Una aplicación en Node.js/Express con:
- **Interfaz web:** (`public/index.html`, `public/app.js`, `public/styles.css`): Tabla interactiva de productos con formularios para agregar y eliminar.
- **Base de datos local:** (`db.js`): Archivo JSON en `data/products.json` que persiste datos entre reinicios sin dependencias externas.
- **API REST:** Endpoints consumidos por la interfaz web y probes de Kubernetes.
- **Contenedores & Orquestación:** Docker, Kubernetes (`kubectl`), Minikube.
- **CI/CD & Registry:** GitHub Actions, GitHub Container Registry (GHCR).
- **Pruebas y Seguridad:** Jest/Supertest para pruebas unitarias y Trivy Vulnerability Scanner para análisis de imágenes.

---

## 📁 Estructura del Proyecto

```text
INVENTARIO-APP-MAIN/
├── .github/
│   └── workflows/
│       └── ci-cd.yaml        # Pipeline CI/CD de GitHub Actions
├── data/
│   └── .gitkeep              # Control de versiones para directorio de datos
├── k8s/
│   ├── blue-green/
│   │   ├── deployment-blue-green.yaml # Manifiesto para estrategia Blue-Green
│   │   └── service-blue-green.yaml    # Servicio para estrategia Blue-Green
│   ├── deployment.yaml       # Configuración de despliegue principal (Probes y Startup Delay)
│   ├── secret.yaml           # Creación de secretos (API_KEY)
│   └── service.yaml          # Exposición del servicio principal
├── public/                   # Frontend estático (HTML, CSS, JS)
├── db.js                     # Controlador de base de datos local
├── Dockerfile                # Imagen multi-stage optimizada y validada con npm test
├── package.json              # Gestión de dependencias y scripts
├── README.md                 # Documentación del proyecto
├── server.js                 # Servidor Express y lógica de la API
└── server.test.js            # Pruebas unitarias para CI