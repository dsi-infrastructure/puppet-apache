# Class
#
class apache {
	package { 'apache2':
		ensure => installed
	}

	service { "apache2":
  	ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => Package["apache2"],
  }

}
