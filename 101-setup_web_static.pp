# Puppet script that sets up web servers for the deployment of web_static.

include stdlib

exec { 'update':
  command => '/usr/bin/apt-get update',
}

package { 'nginx':
  ensure  => installed,
  name    => 'nginx',
  require => Exec['update'],
}

file { [ '/data/', '/data/web_static/', '/data/web_static/releases/',
          '/data/web_static/releases/test/' ]:
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

file { '/data/web_static/shared':
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

exec { 'Creates fake index.html':
  path    => ['/usr/bin', '/usr/sbin', '/bin'],
  command => 'echo "Hello Nginx!" > /data/web_static/releases/test/index.html',
}

exec { 'Change user:group owner of index.html':
  path    => ['/usr/bin', '/usr/sbin', '/bin'],
  command => 'chown -hR ubuntu:ubuntu /data/web_static/releases/test/index.html',
}

file { '/data/web_static/current':
  ensure => 'link',
  owner  => 'ubuntu',
  group  => 'ubuntu',
  target => '/data/web_static/releases/test'
}

$to_add = '
        location /hbnb_static/ {
		                alias /data/web_static/current/;
        }'

file_line { 'location /hbnb_static/':
  ensure  => 'present',
  path    => '/etc/nginx/sites-available/default',
  after   => 'server_name _;',
  line    => $to_add,
  require => Package['nginx'],
}

service { 'nginx':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  require    => Package['nginx'],
}
