## site.pp ##

File { backup => false }

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}

node 'centos.epam.com'{
  include apache
}

node 'ubuntu-bionic.epam.com' {
  include apache
  class { '::mysql::server':
    root_password           => 'strongpassword',
    remove_default_accounts => true,
    }
  mysql::db { 'test_mdb': 
    user     => 'test_user',
    password => 'test_pass',
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE'],
  }
}
