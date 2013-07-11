# Definition
#

define apache::site($vhosts,$vapps,$status="desactivate",$php="disabled") {

	include apache

	file { "/etc/apache2/sites-available/${vhosts}":
		path    => "/etc/apache2/sites-available/${vhosts}",
		ensure  => file,
		require => Package['apache2'],
		content => template("apache/apache-vhost.erb"),
		notify  => Service['apache2']
	}

	file { "/var/www/${vapps}":
		path    => "/var/www/${vapps}",
		ensure  => directory,
		owner	=> www-data,
		group	=> www-data
	}

	case $status {
		'activate' : {
			exec { "/usr/sbin/a2ensite ${vhosts}":
				unless	=> "/bin/readlink -e /etc/apache2/sites-enabled/${vhosts}",
				notify	=> Exec["reload-apache2"],
				require	=> Package["apache2"],
			}
		}
		'desactivate': {
			exec { "/usr/sbin/a2dissite ${vhosts}":
				onlyif	=> "/bin/readlink -e /etc/apache2/sites-enabled/${vhosts}",
				notify	=> Exec["reload-apache2"],
				require	=> Package["apache2"],
			}
		}
		default: {
			err ("La valeur du parametre status est inconnue.")
		}
	}

	case $php {
		'enable' : {
		        package { 'libapache2-mod-php5':
				ensure => installed,
				notify	=> Exec["reload-apache2"]
			}
		}
		'disabled' : {
		        package { 'libapache2-mod-php5':
				ensure => purged,
				notify	=> Exec["reload-apache2"]
			}
		}
		default: {
			err ("La valeur du parametre php est inconnue.")
		}		
	}

	exec { "reload-apache2":
		command => "/etc/init.d/apache2 reload",
		refreshonly => true,
	}
}
