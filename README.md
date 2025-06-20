# Kubernetes Node Sample

A simple Node.js Express application demonstrating deployment to k3s with Traefik ingress routing.

## Features

- Express.js HTTP server with JSON responses
- Docker containerization
- Kubernetes deployment manifests
- Traefik IngressRoute configuration
- Health check endpoints
- Automated deployment script

## Prerequisites

- Node.js 18+ (for local development)
- Docker
- k3s cluster with Traefik enabled
- kubectl configured for your k3s cluster

## Local Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Or start production server
npm start
```

The app will be available at `http://localhost:3000`

## API Endpoints

- `GET /` - Returns hello world message with hostname and timestamp
- `GET /health` - Health check endpoint

## Deployment to k3s

### Quick Deploy

Use the provided deployment script:

```bash
# Make script executable and run
chmod +x deploy.sh
./deploy.sh
```

### Manual Deployment

1. **Build Docker image:**
   ```bash
   docker build -t node-sample-app:latest .
   ```

2. **Import image to k3s:**
   ```bash
   k3s ctr images import <(docker save node-sample-app:latest)
   ```

3. **Deploy to Kubernetes:**
   ```bash
   kubectl apply -f k8s/
   ```

4. **Verify deployment:**
   ```bash
   kubectl get pods -l app=node-sample-app
   kubectl get svc node-sample-service
   kubectl get ingressroute node-sample-ingress
   ```

## Access the Application

Once deployed, the application will be available at:
- **http://hallo.fritz.box**

Make sure your DNS or `/etc/hosts` file resolves `hallo.fritz.box` to your k3s cluster IP.

## Configuration

### Traefik Routing

The application uses Traefik IngressRoute to route traffic from `hallo.fritz.box` to the service. The configuration is in `k8s/ingressroute.yaml`.

### Resource Limits

The deployment includes resource requests and limits:
- CPU: 50m request, 100m limit
- Memory: 64Mi request, 128Mi limit

### Health Checks

- **Liveness Probe:** Checks `/health` every 10 seconds
- **Readiness Probe:** Checks `/health` every 5 seconds

## Troubleshooting

### Check pod status:
```bash
kubectl get pods -l app=node-sample-app
kubectl logs -l app=node-sample-app
```

### Check service and ingress:
```bash
kubectl describe svc node-sample-service
kubectl describe ingressroute node-sample-ingress
```

### Verify Traefik is routing correctly:
```bash
kubectl get ingressroute -A
```

## Cleanup

To remove the deployment:

```bash
kubectl delete -f k8s/
```