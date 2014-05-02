# Define: apache::site
# Parameters:
#   $name : nom de domaine du virtualhost
#   $vapps : nom de l'application
#   $status : permet d'activer (ou pas) le site
#   $ssl : permet d'activer le protocole HTTPS pour ce site
# arguments
#
define apache::site (
    $vapps,
    $status = 'disabled',
    $ssl = 'disabled') {

    include apache

    $enabled_site = '/etc/apache2/sites-enabled'
    $available_site = '/etc/apache2/sites-available'

    file { "/var/www/${vapps}":
        ensure  => directory,
        path    => "/var/www/${vapps}",
        owner   => www-data,
        group   => www-data
    }

    case $status {
        'enable' : {
            if $ssl == 'disabled' or $::apache::ssl == 'disabled' {
                $vhost_template = 'apache-vhost-default.erb'

                file { "${name}-disabled-443":
                    ensure  => absent,
                    path    => "${available_site}/${name}-ssl",
                    notify  => Exec['reload-apache2'],
                }
            } else {
                $vhost_template = 'apache-vhost-ssl80.erb'

                file { "${name}-enable-443":
                    ensure  => file,
                    path    => "${available_site}/${name}-ssl",
                    require => Package['apache2'],
                    content => template("apache/apache-vhost-ssl443.erb"),
                    notify  => Service['apache2'],
                }
            }

            file { "${name}-enable":
                ensure  => file,
                path    => "${available_site}/${name}",
                require => Package['apache2'],
                content => template("apache/${vhost_template}"),
                notify  => Service['apache2'],
            }

            exec { "/usr/sbin/a2ensite ${name}":
                unless  => "/bin/readlink -e ${enabled_site}/${name}",
                notify  => Exec['reload-apache2'],
                require => Package['apache2'],
            }
            
            File["${name}-enable"] ->
            Exec["/usr/sbin/a2ensite ${name}"]
        }
        'disabled': {
            if $ssl == 'enable' {
                err ("Merci de mettre le parametre ssl a disabled.")
            }

            file { "${name}-disabled-443":
                ensure  => absent,
                path    => "${available_site}/${name}-ssl",
                notify  => Exec['reload-apache2'],
            }

            file { "${name}-disabled":
                ensure  => absent,
                path    => "${available_site}/${name}",
            }

            exec { "/usr/sbin/a2dissite ${name}":
                onlyif  => "/bin/readlink -e ${enabled_site}/${name}",
                notify  => Exec['reload-apache2'],
                require => Package['apache2'],
            }

            Exec["/usr/sbin/a2dissite ${name}"] ->
            File["${name}-disabled"] ->
            File["${name}-disabled-443"]
        }
        default: {
            err (
                "La valeur du parametre status doit etre enable ou disabled.
                 Actuellement, cette variable est '$status'"
            )
        }
    }
}
