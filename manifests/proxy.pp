# Class: apache::proxy
#
#
class apache::proxy($status = hiera('apache::proxy::status', '')) {
    package { 'libapache2-mod-proxy':
        ensure => installed,
    }
}