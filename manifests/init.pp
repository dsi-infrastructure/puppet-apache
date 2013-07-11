# Class apache
#
class apache($status="disabled", $apachemodules) {
	package { 'apache2':
		ensure => installed
	}

	package { $apachemodules:
		ensure => installed
	}

	service { "apache2":
		ensure 		=> running,
		hasstatus 	=> true,
		hasrestart	=> true,
		require		=> Package["apache2"],
	}

        exec { "reload-apache2":
                command => "/etc/init.d/apache2 reload",
                refreshonly => true,
        }

}
