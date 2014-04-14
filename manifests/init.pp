# Class: apache
#
#
class apache(
    $modules        = hiera(apache::modules, []),
    $ssl            = hiera(apache::ssl, 'disabled'),
    $status         = hiera(apache::status, 'disabled')) {

    package { 'apache2':
        ensure => installed,
    }

    package { $modules:
        ensure => installed,
    }

#    file { "${name}-cert":
#        ensure  => file,
#        path    => "/etc/ssl/certs/${fqdn}.crt",
#        source  => "puppet:///certs/${fqdn}.crt",
#        notify  => Service['apache2'],
#    }

#   file { "${name}-key":
#        ensure  => file,
#        path    => "/etc/ssl/private/${fqdn}.key",
#        source  => "puppet:///certs/${fqdn}.key",
#        notify  => Service['apache2'],
#    }

    $enabled_mod = '/etc/apache2/mods-enabled'
    case $ssl {
        'enable': {
            exec { "${name}-ssl-enable":
                command => '/usr/sbin/a2enmod ssl',
                unless  => "/bin/readlink -e $enabled_mod/ssl.conf",
                notify  => Exec['reload-apache2'],
                require => Package['apache2'],
            }
        }
        'disabled': {
            exec { "${name}-ssl-disabled":
                command => '/usr/sbin/a2dismod ssl',
                onlyif  => "/bin/readlink -e $enabled_mod/ssl.conf",
                notify  => Exec['reload-apache2'],
                require => Package['apache2'],
            }
        }
        default: {
            err (
                "La valeur du parametre ssl doit etre enable ou disabled.
                 Actuellement, cette variable est '$ssl'"
            )
        }
    }

    if $status == "disabled" {
        $initiate = 'stopped'
    } else {
        $initiate = 'running'
    }
    service { 'apache2':
        ensure      => $initiate,
        hasstatus   => true,
        hasrestart  => true,
        require     => Package['apache2'],
    }

    exec { 'reload-apache2':
        command     => '/etc/init.d/apache2 reload',
        refreshonly => true,
    }

    $vhosts = hiera(apache::vhost, {})
    create_resources(apache::site, $vhosts)

}
