# DARE-TREFX-Environment
Demo Environment for DARE TRE-FX Project.
User and Developer Guides can be found in the [documentation](https://docs.federated-analytics.ac.uk/).


## 📁 Project Structure

```bash
.
├── AllInOne/         # Demonstration instance of the stack
├── ansible/          # Ansible script to install funnel 
├── TRE-Keycloak/     # Deploy an instance of the TRE Agent
├── Submission-Keycloak/  # Deploy an instance of the Submission Layer
├── Diagram/          # Architecture or system diagrams
└── README.md         

```

## All In One
A Simple Demonstrator instance of the complete stack, intended to be run locally, not intended to be a production deployment.
```bash
.
├── realm-config/.     # Keycloak realms configuration files
    ├── sub-layer.json
    ├── tre-layer.json
    ├── egress-layer.json     
├── .env               # Environment variables
├── default.conf       # Proxy configuration
├── docker-compose.yml # All in One demonstrator docker compose
├── init.sql           # SQL script for the DB
```

The docker compose includes:   
- Submission UI & Submission API 
- TRE Agent UI & TRE Agent API
- Egress UI & Egress API
- Keycloak: includes realms defined in `realm-config/`
- PostgreSQL | RabbitMQ | Seq | Nginx
- MinIO: Submission & TRE Agent 

## Submission
```bash
.
├── realm-config/.     # Keycloak realm configuration file
    ├── sub-layer.json
├── .env               # Environment variables
├── default.conf       # Proxy configuration
├── docker-compose.yml # Submission docker compose
├── init.sql 
```
The docker compose includes:
- Submission UI & Submission API 
- Keycloak: submission realm defined in `realm-config/`
- PostgreSQL | RabbitMQ | Seq | Nginx
- Submission MinIO

## TRE
```bash
.
├── realm-config/.     # Keycloak realm configuration file
    ├── egress-layer.json
    ├── tre-layer.json
├── .env               # Environment variables
├── default.conf       # Proxy configuration
├── docker-compose.yml # TRE Agent & Egress docker compose
├── init.sql 
```

The docker compose includes:
- TRE Agent UI & TRE Agent API
- Egress UI & Egress API
- Keycloak: TRE & Egress realms defined in `realm-config/`
- PostgreSQL | RabbitMQ | Seq | Nginx
- TRE Agent MinIO
