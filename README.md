# Installation du module

```
$ mkdir apache
$ cd apache
$ git clone https://github.com/sipf-infrastructure/apache.git

```

# Utilisation

Dans le fichier '/etc/puppet/manifests/site.pp', on définit ce qui suit :
```
node test {
        class { 'apache':
                status          => enable,
                apachemodules   => ["libapache2-mod-php5"],
        }

        apache::site { 'wiki.srv.gov.pf':
                status          => enable,
                vhosts          => 'wiki.srv.gov.pf',
                vapps           => 'mediawiki',
                ssl             => enable,
        }
}
```
