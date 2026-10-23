# PHP-sandbox-lab
This should be proof of concecpt for PHP sandboxing
all credits go to Gemini of Google, which is not closely that dangerous like the none stop privileges escalation and critical slop of copilot today ! 🤬 
# Cloud Drift Mitigation & Exploit Hardening for PHP on GCP

This repository provides a hardened, production-ready reference implementation for running PHP workloads on Google Cloud Platform (GCP). It is specifically engineered to mitigate unauthenticated pre-application remote code execution vulnerabilities (**CVE-2026-109618** and **CVE-2026-109619**), prevent denial-of-service (DoS) and privilege escalation, and continuously enforce infrastructure compliance against **cloud drift**.

---

## 🏛️ Architecture & GCP Mappings

| Security Layer | GCP Native Service / Control | Purpose |
| :--- | :--- | :--- |
| **Edge Filtering & WAF** | **Google Cloud Armor** | Rate limiting, virtual patching, and request body size enforcement. |
| **Ingress & Ingress Routing** | **Global External Application Load Balancer** | Single entry point preventing direct origin IP bypass. |
| **Network Isolation** | **VPC & Firewall Rules** | Restricts backend communication exclusively to the Load Balancer proxy range. |
| **Drift Detection & Audit** | **Terraform State & Cloud Audit Logs** | Continuously verifies live GCP resources against the version-controlled baseline. |

---

## 🔒 Verified PHP Fix Baseline

The official PHP advisories identify the fixed minimum releases as:
* **PHP 8.5:** `8.5.12` or later
* **PHP 8.4:** `8.4.27` or later
* **PHP 8.3:** `8.3.36` or later
* **PHP 8.2:** `8.2.35` or later

> ⚠️ **Important:** PHP 8.1 and earlier are End-of-Life (EOL) and should be migrated immediately. WAF rules and configuration workarounds are temporary mitigation layers—**patching the PHP runtime is mandatory**.

---

## 🚀 Key Defense Pillars

1. **Patch First:** Pin container runtimes to fixed, patched PHP releases in CI/CD.
2. **Worker Recycling:** Restart all PHP-FPM workers immediately after configuration updates or patches to clear stale global state.
3. **Strict Resource Bounds:** Enforce `memory_limit`, strict `post_max_size`, and container-level cgroups to contain OOM exhaustion.
4. **Least Privilege Execution:** Run PHP-FPM as an unprivileged user (`www-data`) with a read-only root filesystem and restricted write paths.
5. **Drift Detection:** Automated daily checks ensure live infrastructure matches the approved Terraform configuration.

---

## 📂 Repository Layout

* `terraform/` — GCP infrastructure (VPC, Load Balancer, Cloud Armor WAF).
* `configs/` — Hardened runtime settings (`php.ini` & `www.conf`).
* `docker/` — Multi-stage, non-root hardened container definition.
* `.github/workflows/` — CI/CD security scans and scheduled cloud drift detection.
* `policies/` — Compliance validation baselines (Checkov).

---

## 🔗 References
* [GHSA-w8hw-w9fx-j79w (CVE-2026-109618)](https://github.com/php/php-src/security/advisories/GHSA-w8hw-w9fx-j79w)
* [GHSA-6wmf-4rv5-p3rp (CVE-2026-109619)](https://github.com/php/php-src/security/advisories/GHSA-6wmf-4rv5-p3rp)
* [PHP Official Advisories](https://www.php.net/archive/2026.php)
