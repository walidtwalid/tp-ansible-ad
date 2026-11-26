# Erreurs fréquentes

## Connexion

**`UNREACHABLE` / `connection refused` / `timed out`**
Le serveur ne répond pas sur WinRM. Vérifier l'IP dans `inventory.ini`, faire un `ping`, vérifier que `enable-winrm.ps1` a bien été lancé et que le pare-feu laisse passer le port 5985.

**`the specified credentials were rejected by the server`**
Mauvais mot de passe ou mauvais compte dans `group_vars/windows.yml`.

## YAML

**`mapping values are not allowed here`**
Presque toujours un problème d'indentation, ou un `:` en trop dans une valeur. Regarder la ligne indiquée et celle d'avant.

**`found character that cannot start any token`**
Une tabulation dans le fichier. Remplacer par des espaces.

**`did not find expected key`**
Une ligne n'est pas alignée avec les autres du même niveau.

**`template error while templating string`**
Une accolade `{{` ou `}}` oubliée, ou une valeur avec `{{` pas mise entre guillemets.

## Modules

**`couldn't resolve module/action 'microsoft.ad.user'`**
Collection pas installée : `ansible-galaxy collection install -r requirements.yml`.

**`Unsupported parameters for (microsoft.ad.user) module: ...`**
Un paramètre mal écrit. Comparer avec la doc : `ansible-doc microsoft.ad.user`.

**`'item' is undefined`**
La tâche utilise `item` mais n'a pas de `loop`.

## Active Directory

**`Failed to find the AD object`** ou erreur sur le `path`
L'OU n'existe pas. Vérifier son nom (accents compris) et relancer `deploy_ad.yml`.

**`The password does not meet the length, complexity, or history requirement`**
Le mot de passe initial ne respecte pas la politique du domaine.

**`Unable to contact the server` juste après la création du domaine**
Le serveur redémarre encore. Attendre une minute et relancer.
