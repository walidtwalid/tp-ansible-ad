#!/usr/bin/env bash
# install.sh : installe tout le nécessaire sur la machine Linux (Debian ou Ubuntu).
# Utilisation, depuis le dossier tp-ansible-ad :
#   bash install.sh
set -e

echo "==> Mise à jour des paquets et installation de pip"
sudo apt update
sudo apt install -y python3-pip

echo "==> Installation d'Ansible et de pywinrm (pour piloter Windows)"
# Les versions récentes de Debian et d'Ubuntu (Ubuntu 23.04 et plus, Debian 12)
# bloquent pip par défaut : on réessaie alors avec l'option qui l'autorise.
if ! python3 -m pip install --user ansible pywinrm; then
    python3 -m pip install --user --break-system-packages ansible pywinrm
fi

# Rend les commandes ansible accessibles, maintenant et aux prochaines sessions
export PATH="$HOME/.local/bin:$PATH"
if ! grep -q 'HOME/.local/bin' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

echo "==> Installation des collections Ansible pour Windows et Active Directory"
ansible-galaxy collection install -r requirements.yml

echo
echo "==> Installation terminée"
ansible --version | head -1
echo
echo "Étapes suivantes :"
echo "  1. source ~/.bashrc"
echo "  2. Compléter inventory.ini, group_vars/windows.yml et vars/ad.yml"
echo "  3. Tester : ansible windows -m ansible.windows.win_ping"
