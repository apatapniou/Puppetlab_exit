# Class: apache
# ===========================

class apache {

  if $::osfamily == 'RedHat' {
    $server_name = 'httpd'
    $vhost_conf = '/etc/httpd/conf.d/server.conf'
	}
  elsif $facts['os']['name'] =~ /^(Debian|Ubuntu)$/ {
    $server_name = 'apache2'
    $vhost_conf = '/etc/apache2/sites-available/server.conf'
	}

  package { $server_name:
    ensure => installed, 
	}
  service { $server_name:
    ensure => running,  
	}
  file { '/var/www/html':
    ensure  => directory,
    recurse => true,
  }

  file { "/var/www/html/index.html":
    ensure  => file,
    content => template('apache/index.html.epp'),
    notify  => Service[$server_name],
  }

  $apache_hash = {
    'server_name' => $server_name,
  }
  file { $vhost_conf:
    content => epp('apache/server.conf.epp', $apache_hash),
    require => Package[$server_name],
    notify  => Service[$server_name],
  }

}
