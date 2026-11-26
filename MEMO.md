# Mémo Ansible

## Les commandes

| Commande | À quoi ça sert |
| --- | --- |
| `ansible windows -m ansible.windows.win_ping` | Tester la connexion au serveur |
| `ansible windows -m ansible.windows.win_shell -a "hostname"` | Lancer une commande à distance |
| `ansible-playbook deploy_ad.yml` | Lancer un playbook |
| `ansible-playbook comptes.yml --syntax-check` | Vérifier la syntaxe sans rien lancer |
| `ansible-playbook comptes.yml --check` | Voir ce qui serait fait, sans rien modifier |
| `ansible-playbook comptes.yml -v` | Plus de détails (`-vvv` pour encore plus) |
| `ansible-doc microsoft.ad.user` | Lire la doc d'un module dans le terminal |
| `git pull` | Récupérer la dernière version des fichiers |

## Les résultats

- `ok` : déjà conforme, Ansible n'a rien changé
- `changed` : Ansible a modifié quelque chose
- `skipping` : tâche ignorée (condition `when` fausse)
- `failed` : erreur, lire le message en rouge

## Le YAML en 5 règles

1. L'indentation se fait **avec des espaces, jamais avec des tabulations**.
2. Toujours 2 espaces par niveau.
3. Un tiret `-` = un élément de liste.
4. Après les deux-points `:` il faut un espace.
5. Une valeur qui commence par `{{` doit être entre guillemets.

## Structure d'une tâche

```yaml
    - name: Ce que fait la tâche (en français)
      nom.du.module:
        parametre1: valeur
        parametre2: "{{ une_variable }}"
      loop: "{{ une_liste }}"
      loop_control:
        label: "{{ item.Identifiant }}"
```

- `item` = l'élément en cours dans la boucle
- `item.Nom`, `item.Service`... = les colonnes du fichier RH

## Les variables

- Définies dans `vars/ad.yml` ou calculées dans le playbook
- Utilisées avec `{{ nom_de_la_variable }}`
- Exemple : `"OU={{ item.Service }},{{ domaine_dn }}"` donne `OU=RH,DC=tp,DC=local`
