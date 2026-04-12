# pve-core — platform tier

Identity + secrets + object store + source-of-truth, running as a NixOS VM
on `pve0-nic0` (R730xd).

This host is the trust anchor for the whole homelab. If it is down,
you cannot log in, cannot issue tokens, cannot push code, cannot see
metrics, cannot pull backups. Treat it accordingly:

- ZFS-backed virtio disks on the Proxmox host's `vmpool-ssd` and `bulkpool`
  (host ZFS handles integrity, encryption, and snapshots)
- Auto-unseal via transit seal from `sealvault` on the weak laptop
  (Pattern B — see `hosts/sealvault/`)
- All runtime secrets come from Vault on this host
- Wildcard TLS `*.internal.wassp.dev` via Let's Encrypt DNS-01 against
  Cloudflare (see `caddy.nix` — pending port)

## Services

Currently represented in this directory:

| File | Service | Status |
|---|---|---|
| `default.nix` | host basics, networking, boot | ✅ first cut |
| `disko-fs.nix` | three virtio disks, btrfs subvolumes | ✅ first cut |
| `tailscale.nix` | per-VM Tailscale identity, `tag:platform` | ✅ first cut |
| `kanidm.nix` | Kanidm OIDC IdP | ✅ first cut |
| `vault.nix` | HashiCorp Vault (Raft + transit seal) | ✅ first cut |

Pending — to be ported from `hosts/idols-aquamarine/` or written fresh
in draft #2:

| File | Service | Source |
|---|---|---|
| `caddy.nix` | edge reverse proxy + LE DNS-01 | port from `idols-aquamarine` |
| `gitea.nix` | Gitea + Actions runners **enabled** | port, drop physical-disk bits |
| `postgresql.nix` | shared Postgres + pgvector | port |
| `minio.nix` | object store (models, backups, TF state) | port, expand bucket list |
| `monitoring/` | Prometheus/VM, Grafana, Loki, Alertmanager | port as-is |
| `exporters/` | node-exporter, pve-exporter, smartctl-exporter | port, add pve-exporter |
| `restic.nix` | backups to B2 | port, change remote |
| `journald.nix` | centralized log forwarding to Loki | port |

Deliberately **not** ported:
- `sftpgo.nix`, `transmission.nix` — not platform-tier
- `disko-fs.nix` from aquamarine — it uses LUKS on a physical WD disk,
  incompatible with a VM. Our disko config is virtio + btrfs, no LUKS
  (host ZFS handles encryption).
- `modules/nixos/server/kubevirt-hardware-configuration.nix` — we're on
  Proxmox QEMU, not KubeVirt. We import `qemu-guest.nix` instead.

## Registration

This host needs an entry at
`outputs/x86_64-linux/src/pve-core.nix` (pending, see draft #2).
Unlike the `idols-*` hosts, **we do not build a KubeVirt package output**:
the VM is provisioned via Terraform in `ha-k8s-proxmox` and installed
via `nixos-anywhere`.

## Networking

- LAN: `192.168.5.120` on `enp2s0` (add to `vars/networking.nix` under
  `hostsAddr.pve-core`).
- Tailscale: joins the tailnet with `tag:platform`, identity
  `pve-core`. Primary reachability for `tag:admin` from ThinkPad Qubes.
- DNS names (all `*.internal.wassp.dev`, served by pfSense Unbound
  and pushed via Tailscale Split DNS):
  - `kanidm.internal.wassp.dev`
  - `vault.internal.wassp.dev`
  - `gitea.internal.wassp.dev`
  - `minio.internal.wassp.dev`, `s3.internal.wassp.dev`
  - `grafana.internal.wassp.dev`
  - `pve-core.internal.wassp.dev` (host itself)

## Secrets

Two categories, clearly separated:

**Build-time (agenix)** — needed before Vault is reachable. Required
for this host to boot and reach steady state:
- `tailscale-authkey` — ephemeral Tailscale auth key (one-shot)
- `vault-sealvault-token` — token used by Vault to talk to `sealvault`
  for transit seal operations
- `kanidm-admin-password` — bootstrap admin account, used once during
  the ceremony then rotated
- `cloudflare-api-token` — for LE DNS-01 wildcard renewal (Caddy)
- `sealvault-ca` — CA cert of the sealvault's TLS (for Vault to trust it)

**Runtime (Vault)** — fetched after Vault is up, via vault-agent or
operator-injected env files:
- Gitea: mailer password, OIDC client secret
- MinIO: root creds (bootstrap only), OIDC client secret
- Postgres: root creds, per-app dynamic creds via Vault DB engine
- Grafana: admin password, OIDC client secret
- Kanidm OIDC client secrets for everything above

## Bootstrap order

See `docs/bootstrap.md` (pending). Summary:

1. Terraform creates this VM using a one-time bootstrap Proxmox token
2. `nixos-anywhere` installs NixOS from this flake's `pve-core` output
3. First boot: agenix unlocks secrets from the build-time list above
4. Tailscale joins the tailnet via the auth key
5. Vault comes up, initialized with Shamir (shares to physical safe)
6. Kanidm comes up, bootstrap admin enrolls `you@admin` with Yubikey WebAuthn
7. Vault OIDC auth method wired to Kanidm; seal migrated from Shamir to
   transit (sealvault must be up first)
8. Engines enabled: Proxmox / SSH CA / PKI / KV v2 / DB / Transit /
   Gitea tokens
9. Bootstrap Proxmox token revoked
10. Remaining services (Gitea, MinIO, Postgres, observability) come up
    with runtime secrets from Vault
