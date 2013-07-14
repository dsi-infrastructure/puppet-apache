# Definition
#
define apache::site($vhosts,$vapps,$status="disabled",$ssl="disabled") {

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
		'enable' : {
			exec { "/usr/sbin/a2ensite ${vhosts}":
				unless	=> "/bin/readlink -e /etc/apache2/sites-enabled/${vhosts}",
				notify	=> Exec["reload-apache2"],
				require	=> Package["apache2"],
			}
		}
    
    'disabled': {
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

}
