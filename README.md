# TP Ansible : déployer Active Directory sur Windows Server

## Contenu du dossier

| Fichier | Rôle |
| --- | --- |
| `enable-winrm.ps1` | À lancer sur chaque Windows Server : active WinRM pour Ansible |
| `inventory.ini` | Liste des serveurs pilotés (mettre l'IP du serveur) |
| `group_vars/windows.yml` | Réglages de connexion WinRM (mettre le mot de passe administrateur) |
| `vars/ad.yml` | État voulu : domaine, services. **Le fichier que vous modifiez** |
| `deploy_ad.yml` | Le playbook qui crée le domaine, les unités d'organisation et les groupes |
| `ansible.cfg` | Indique à Ansible quel inventaire utiliser |
| `requirements.yml` | Collections Ansible à installer |
| `install.sh` | Installe Ansible et les collections sur la VM Ubuntu en une commande |

> Les deux VM doivent avoir accès à Internet pour les étapes 1 et 2.
> En réseau Host-Only, faites-les avant, ou ajoutez une seconde carte réseau en NAT.

## 1. Sur le Windows Server

Le serveur doit avoir une **adresse IP fixe** et un **mot de passe administrateur** défini.
Lancer PowerShell en administrateur, puis :

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/walidtwalid/tp-ansible-ad/main/enable-winrm.ps1" -OutFile enable-winrm.ps1
powershell -ExecutionPolicy Bypass -File .\enable-winrm.ps1
```

## 2. Sur la VM Ubuntu (Ubuntu 22.04)

```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/walidtwalid/tp-ansible-ad.git
cd tp-ansible-ad
bash install.sh
source ~/.bashrc
```

Si un fichier est corrigé pendant le TP, récupérez la nouvelle version avec `git pull`.

Puis compléter :
- `inventory.ini` : remplacer `<IP_DU_SERVEUR>` ;
- `group_vars/windows.yml` : remplacer `<MOT_DE_PASSE_ADMINISTRATEUR>` ;
- `vars/ad.yml` : remplacer `<MOT_DE_PASSE_DSRM>` (mot de passe complexe).

## 3. Premières commandes

```bash
ansible windows -m ansible.windows.win_ping                       # doit répondre "pong"
ansible windows -m ansible.windows.win_shell -a "hostname"        # commande à distance
ansible windows -m ansible.windows.win_shell -a "Get-Service WinRM"
```

## 4. Lancer le playbook

```bash
ansible-playbook deploy_ad.yml
```

Le serveur redémarre pendant la création du domaine : c'est normal, Ansible attend qu'il revienne.
Lisez le récapitulatif final (`ok`, `changed`, `failed`).

## 5. Tester l'idempotence

1. Relancez `ansible-playbook deploy_ad.yml` sans rien changer : tout doit être `ok`, rien `changed`.
2. Ajoutez un service dans `vars/ad.yml`, par exemple `- Comptabilite`.
3. Relancez : seules l'unité et le groupe du nouveau service passent en `changed`.
4. Vérifiez dans « Utilisateurs et ordinateurs Active Directory » sur le serveur.

## En cas de problème

- `win_ping` échoue : vérifier l'IP, le ping, le pare-feu, et que `enable-winrm.ps1` a bien été lancé.
- Erreur d'authentification : vérifier le nom `Administrateur` et le mot de passe.
- Erreur « couldn't resolve module » : relancer `ansible-galaxy collection install -r requirements.yml`.
