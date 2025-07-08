# Ansible for Funnel Provisions

```
ansible-playbook provision-funnel.yml -i ./inventory/live
```

You'll be prompted for two inputs - these are the minio key and secret
These are marked as secure, so you won't see an input in the terminal

You will need to add target ips to ./inventory/live/hosts
