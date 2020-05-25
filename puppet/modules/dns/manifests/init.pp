class dns inherits baseconfig {
  package { ['bind','bind-utils','bind-libs','bind-*']:
    ensure => present,
  }
  define dns::conf() {
    file { "/var/named/${name}":
      require => Package['bind'],
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => "puppet:///modules/dns/${name}",
      path    => "/var/named/${name}",
    }
  }
  dns::conf {['valkysoft.com.fwd','valkysoft.com.rev']:
  }
  
  file { '/etc/named.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['bind'],
    content => template('dns/named.conf'),
  }
  service{ "named":
    name    => 'named', 
    ensure  => running,
    enable  => true,
    require => File['/var/named/valkysoft.com.rev'],
    subscribe => File['/etc/named.conf'],
  }  

}
