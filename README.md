# Apache [![Build Status](https://travis-ci.org/sipf-infrastructure/apache.png?branch=master)](https://travis-ci.org/sipf-infrastructure/apache)

## Installation du module

```bash
$ mkdir apache
$ cd apache
$ git clone https://github.com/sipf-infrastructure/apache.git
```

## Utilisation

Dans le fichier '/etc/puppet/manifests/site.pp', on définit ce qui suit :
```ruby
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

## A faire

- Activer le mode SSL
