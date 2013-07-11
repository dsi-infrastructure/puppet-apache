# Definition
#

define apache::site($vhosts,$vapps,$status="desactivate") {
	include apache
	file { "/etc/apache2/sites-available/${vhosts}":
		path    => "/etc/apache2/sites-available/${vhosts}",
		ensure  => file,
		require => package['apache2'],
		content => template("apache/apache-vhost.erb"),
		notify  => service['apache2']
	}

	file { "/var/www/${vapps}":
		path    => "/var/www/${vapps}",
		ensure  => directory
	}

	case $status {
		'activate' : {
			exec { "/usr/sbin/a2ensite ${vhosts}":
				unless	=> "/bin/readlink -e /etc/apache2/sites-enabled/${vhosts}",
				notify	=> exec["reload-apache2"],
				require	=> package["apache2"],
			}
		}
		'desactivate': {
			exec { "/usr/sbin/a2dissite ${vhosts}":
				onlyif	=> "/bin/readlink -e /etc/apache2/sites-enabled/${vhosts}",
				notify	=> exec["reload-apache2"],
				require	=> package["apache2"],
			}
		}
		default: {
			err ("La valeur du parametre status est inconnu")
		}
	}

	exec { "reload-apache2":
		command => "/etc/init.d/apache2 reload",
		refreshonly => true,
	}
}
