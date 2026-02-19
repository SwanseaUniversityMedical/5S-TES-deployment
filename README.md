# DARE-TREFX-Environment
Demo Environment for DARE TRE-FX Project.
User and Developer Guides can be found in the [documentation](https://docs.federated-analytics.ac.uk/).


## 📁 Project Structure

```bash
.
├── AllInOne/      # Demonstration instance of the stack
├── ansible/       # Ansible script to install funnel
├── DemoStack/     # Demonstration instance of the stack (for dev and demonstration purposes)
├── Submission/    # Deploy an instance of the Submission Layer
├── TRE/           # Deploy an instance of the TRE Agent
├── Diagram/       # Architecture or system diagrams
└── README.md      # This is a readme file.

```
## DemoStack
A Simple Demonstrator instance of the complete stack, intended to be run locally, not intended to be a production deployment.
```bash
.
├── config/
│   ├── ldap-init/
│   │   └── init.ldif           # LDAP initialisation file
│   ├── realm-config/
│   │   ├── sub-layer.json      # Keycloak Submission realm config
│   │   ├── tre-layer.json      # Keycloak TRE realm config
│   │   └── egress-layer.json   # Keycloak Egress realm config
│   ├── vault-config/           # Vault configuration files
│   └── init.sql                # SQL script for DB initialisation
├── scripts/
│    ├── funnel.sh              # Script to automate funnel setup
│    └── setup.sh               # Script to automate demo stack setup
├── .env                        # Environment variables
├── starter.sh                  # Script to re-start the demo stack with updated vars
└──docker-compose.yml           # All-in-One demonstrator docker compose
```

### To add New Services to the DemoStack
1. Create a new docker compose file for the service in `ServiceStack/compose-manifests/`.
2. Add the new compose file to the `include` section of `DemoStack/docker-compose.yml`.
3. Add any necessary configuration files to `DemoStack/config/` and reference them in the compose file.
    - For pointing the service to the config files, use `CONFIG_PATH` environment variable in the compose file.

**The docker compose includes:**

Application Services:
- Submission UI & Submission API
- TRE Agent UI & TRE Agent API
- Egress UI & Egress API
- TRE Camunda (Credential Worker)

Shared Services:
- Keycloak: includes realms defined in realm-config/
- PostgreSQL | Adminer | RabbitMQ | Seq

Authentication & Security:
- OpenLDAP | phpLDAPadmin | LDAP Init | HashiCorp Vault

Storage Services:
- MinIO: Submission & TRE Agent
- Elasticsearch

Orchestration Services:
- Camunda (Zeebe + Operate + Tasklist)
- Camunda Connectors

## DeploymentStack/Submission

A deployable instance of the Submission Layer.

```bash
DeploymentStack/Submission/
.
├── config/
│   ├── init.sql                # SQL script for DB initialisation
│   └── realm-config/
│       └── sub-layer.json      # Keycloak Submission realm configuration
├── .env                        # Environment variables for Submission deployment
├── docker-compose.yml
```
The docker compose includes:
- Submission UI & Submission API
- Keycloak (Submission realm defined in `config/realm-config/sub-layer.json`)
- PostgreSQL | RabbitMQ | Seq | Nginx
- Submission MinIO

## TRE
```bash
DeploymentStack/TRE/
.
├── config/
│   ├── init.sql                 # SQL script for DB initialisation
│   ├── ldap-init/
│   │   └── init.ldif            # OpenLDAP initialisation file
│   └── realm-config/
│       ├── tre-layer.json       # Keycloak TRE realm configuration
│       └── egress-layer.json    # Keycloak Egress realm configuration
├── .env                         # Environment variables for TRE deployment
├── docker-compose.yml
```

The docker compose includes:
- TRE Agent UI & TRE Agent API
- Egress UI & Egress API
- Keycloak (TRE & Egress realms defined in `config/realm-config/`)
- PostgreSQL | RabbitMQ | Seq | Nginx
- TRE Agent MinIO
