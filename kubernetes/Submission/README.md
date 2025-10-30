# Kubernetes - Submission Layer

This installs the Submission layer and all its dependencies into a local Kind cluster.
It is based on the Submission docker-compose and includes:
- ArgoCD
- Submission UI & Submission API 
- Keycloak: submission realm defined in `realm-config/`
- PostgreSQL | RabbitMQ | Seq | Nginx
- Submission MinIO

When the installation script has finished running, you should be able to access services on your machine at the following endpoints:
- http://argocd.localtest.me
- http://keycloak.localtest.me
- http://submission.localtest.me
- http://minio.localtest.me

## Pre-requisites

Before you run the installation scripts, you need to have Docker, Helm, kubectl, and [Kind](https://kind.sigs.k8s.io/) installed on your machine. Instructions for installing the former are out of scope here -- the internet has far better instructions than we could recreate here. 

### Installing Kind

We recommend that you install Kind with a package manager as it is the simplest and quickest way to get started.
On macOS,
`brew install kind`

On Windows,
`choco install kind`


On Linux, you'll need to install from a pre-built release binary
```
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64
# For ARM64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

### Installing FreeLens

If you are new to Kubernetes or prefer a GUI, we highly recommend installing either [Lens](https://k8slens.dev/) or [FreeLens](https://freelensapp.github.io/). FreeLens has a more flexible license so this is likely to be a better choice.


## Installing the Submission Layer
When you have fulfilled all of the pre-reqs, you are ready to create a new Kind cluster and deploy the Submission Layer in one-shot deployment mode.

To do this, make the installation script runnable: `chmod +x ./submission-layer.sh` and then run it `./submission-layer.sh`.
The script will carry out the following steps:
1. Create a Kind cluster, binding ports 80 and 443 in the cluster to those ports on the host. This is very important to ensure the ingresses work.
2. Install an ingress controller to the Kind cluster, ensuring the config works with our port bindings.
3. Make necessary changes to CoreDNS within the cluster so pods can still use internal communication.
4. Install ArgoCD and configure the Helm chart repo and Submission Layer Argo project.
5. Deploy the Argo app which controls and deploys the Submission Stack helm chart.
6. Add the Keycloak config with the pre-defined submission realm.
7. Print the ArgoCD admin password to the command line so you can log into ArgoCD and check the status.

## Post-installation
After the `submission-layer.sh` script has finished running, you should be able to log into the ArgoCD UI to check on the sync status.

In your browser, go to http://argocd.localtest.me and log in using the username `admin` and the password from step 7 of the installation. You can also find this password in the k8s secret called `argocd-initial-admin-secret` in the `argocd` namespace.

You can now see the sync status of all components of the Submission Layer. 
**If anything is in an 'error' state, just click on the Refresh button in Argo UI to force a hard refresh**.


You can also see all the pods in the cluster with 
`kubectl get pods -n dare-control-submission`

When all pods are up and ready, you can test that the endpoints are working.
In your browser, go to `http://keycloak.localtest.me`. Log in with the username `admin` and get the Keycloak admin password with the command
`kubectl get secret keycloak-admin-secret -n dare-control-submission -o jsonpath='{.data}'` .

Now you can go to the Dare-Control realm and add users or change the passwords for existing users.

In your browser, go to `http://submission.localtest.me`. Log in with the user you either just created or set the password for in Keycloak.

In your browser, go to `http://minio.localtest.me`. Log in with the user you either just created or set the password for in Keycloak.

If all of the above was successful, congratulations. You have deployed the Submission Layer on a Kind cluster running locally!


### Installing for Submission stack Helm chart development

If you are installing this so you can test local development work for the Submission stack Helm chart, you need to use the `chart-dev-setup.sh` script instead. In this pattern we then assume that the Submission Stack chart would be installed from the `DARE-Control/charts` path with the command 
```
helm upgrade --install submission-stack submission-stack -n dare-control-submission --create-namespace -f submission-stack/values-dev.yaml 
```

