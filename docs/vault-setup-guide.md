## Initializing the Vault HA Cluster

This guide describes how to initialize and configure a three-node HashiCorp Vault HA cluster using Integrated Storage (Raft).

> **Important**
>
> - Initialize **only** `vault-0`.
> - Never run `vault operator init` on `vault-1` or `vault-2`.
> - Store the unseal keys and root token securely.

---

## Step 1: Initialize `vault-0`

Run the following command:

```bash
kubectl exec -it vault-0 -n vault -- vault operator init
```

Example output:

```text
Unseal Key 1: abc
Unseal Key 2: def
Unseal Key 3: ghi
Unseal Key 4: jkl
Unseal Key 5: mno

Initial Root Token: 
```

Save the following securely:

- Unseal Key 1
- Unseal Key 2
- Unseal Key 3
- Initial Root Token

> **Do not run** `vault operator init` on:
>
> - `vault-1`
> - `vault-2`

---

## Step 2: Unseal `vault-0`

Apply the first unseal key:

```bash
kubectl exec -it vault-0 -n vault -- vault operator unseal
```

Paste **Unseal Key 1**.

Apply the second key:

```bash
kubectl exec -it vault-0 -n vault -- vault operator unseal
```

Paste **Unseal Key 2**.

Apply the third key:

```bash
kubectl exec -it vault-0 -n vault -- vault operator unseal
```

Paste **Unseal Key 3**.

Verify the Vault status:

```bash
kubectl exec -it vault-0 -n vault -- vault status
```

Expected output:

```text
Initialized     true
Sealed          false
HA Mode         active
```

---

## Step 3: Log in to `vault-0`

Open a shell inside the pod:

```bash
kubectl exec -it vault-0 -n vault -- sh
```

Configure the Vault address:

```bash
export VAULT_ADDR=http://127.0.0.1:8200
```

Authenticate using the root token:

```bash
vault login <ROOT_TOKEN>
```

Example:

```bash
vault login 
```

Verify the Raft cluster:

```bash
vault operator raft list-peers
```

Expected output:

```text
No peers found
```

At this stage, only `vault-0` is part of the Raft cluster.

---

## Step 4: Join `vault-1` to the Cluster

Run:

```bash
kubectl exec -it vault-1 -n vault -- \
vault operator raft join http://vault-0.vault-internal:8200
```

Expected output:

```text
Joined raft cluster successfully
```

---

## Step 5: Unseal `vault-1`

Use the same three unseal keys generated during initialization.

Apply the first key:

```bash
kubectl exec -it vault-1 -n vault -- vault operator unseal
```

Apply the second key:

```bash
kubectl exec -it vault-1 -n vault -- vault operator unseal
```

Apply the third key:

```bash
kubectl exec -it vault-1 -n vault -- vault operator unseal
```

Verify the status:

```bash
kubectl exec -it vault-1 -n vault -- vault status
```

Expected output:

```text
Initialized     true
Sealed          false
HA Mode         standby
```

---

## Step 6: Join `vault-2` to the Cluster

Run:

```bash
kubectl exec -it vault-2 -n vault -- \
vault operator raft join http://vault-0.vault-internal:8200
```

Expected output:

```text
Joined raft cluster successfully
```

---

## Step 7: Unseal `vault-2`

Use the same three unseal keys.

Apply the first key:

```bash
kubectl exec -it vault-2 -n vault -- vault operator unseal
```

Apply the second key:

```bash
kubectl exec -it vault-2 -n vault -- vault operator unseal
```

Apply the third key:

```bash
kubectl exec -it vault-2 -n vault -- vault operator unseal
```

Verify the status:

```bash
kubectl exec -it vault-2 -n vault -- vault status
```

Expected output:

```text
Initialized     true
Sealed          false
HA Mode         standby
```

---

## Step 8: Verify the Raft Cluster

Log in to `vault-0`:

```bash
kubectl exec -it vault-0 -n vault -- sh

export VAULT_ADDR=http://127.0.0.1:8200

vault login <ROOT_TOKEN>
```

List the cluster peers:

```bash
vault operator raft list-peers
```

Expected output:

```text
Node                         State
----                         -----
vault-0.vault-internal       leader
vault-1.vault-internal       follower
vault-2.vault-internal       follower
```

---

## Step 9: Verify Vault Pods

```bash
kubectl get pods -n vault
```

Expected output:

```text
NAME      READY   STATUS
vault-0   1/1     Running
vault-1   1/1     Running
vault-2   1/1     Running
```

---

## Step 10: Verify the Active Service

Check the active Vault service:

```bash
kubectl get endpoints -n vault vault-active
```

Expected output:

```text
NAME            ENDPOINTS
vault-active    10.x.x.x:8200
```

Only the active Vault leader should be listed in the `vault-active` endpoint.