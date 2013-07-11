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
	apache::site { 'Config du premier site':
		vhosts 	=> "test.srv.gov.pf",
		vapps  	=> "tutu",
		status  => "activate",
	}
}

```
