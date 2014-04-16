## Utilisation du module

* Ce module utilise les "hiera", veuillez créer un répertoire "apache" dans le dossier hieradata.
* Dans ce nouveau répertoire veuillez créer un fichier portant le nom suivant : srv1.dev.yaml
* Ce fichier doit contenir ce qui suit :

```
---
apache::modules:
    - 'libapache2-mod-php5'
    - 'php5-mysql'
apache::status: 'enable'
apache::ssl: 'disabled'
apache::vhost:
    'example.com':
        vapps: 'apps'
        status: 'enable'
        ssl: 'disabled'
```

