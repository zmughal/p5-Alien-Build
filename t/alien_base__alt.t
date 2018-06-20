use Test2::V0 -no_srand => 1;
use Test::Alien;
use Alien::Base;
use lib 'corpus/lib';
use Alien::libfoo3;

subtest 'test a share install' => sub {

  alien_ok 'Alien::libfoo3';

  subtest 'default' => sub {
    like( Alien::libfoo3->cflags,        qr{-I.*Alien-libfoo3/include -DFOO=1} );
    like( Alien::libfoo3->libs,          qr{-L.*Alien-libfoo3/lib -lfoo} );
    like( Alien::libfoo3->cflags_static, qr{-I.*Alien-libfoo3/include -DFOO=1 -DFOO_STATIC=1} );
    like( Alien::libfoo3->libs_static,   qr{-L.*Alien-libfoo3/lib -lfoo -lbar -lbaz} );
    is( Alien::libfoo3->version,         '2.3.4' );
    is( Alien::libfoo3->runtime_prop->{arbitrary}, 'two');
  };
  
  subtest 'foo1' => sub {
  
    my $alien = Alien::libfoo3->alt('foo1');
    
    isa_ok $alien, 'Alien::Base';
    isa_ok $alien, 'Alien::libfoo3';

    like( $alien->cflags,        qr{-I.*Alien-libfoo3/include -DFOO=1} );
    like( $alien->libs,          qr{-L.*Alien-libfoo3/lib -lfoo} );
    like( $alien->cflags_static, qr{-I.*Alien-libfoo3/include -DFOO=1 -DFOO_STATIC=1} );
    like( $alien->libs_static,   qr{-L.*Alien-libfoo3/lib -lfoo -lbar -lbaz} );
    is( $alien->version,         '2.3.4' );
    is( $alien->runtime_prop->{arbitrary}, 'two');
  
  };
  
  subtest 'foo2' => sub {

    my $alien = Alien::libfoo3->alt('foo2');
    
    isa_ok $alien, 'Alien::Base';
    isa_ok $alien, 'Alien::libfoo3';

    like( $alien->cflags,        qr{-I.*Alien-libfoo3/include -DFOO=2} );
    like( $alien->libs,          qr{-L.*Alien-libfoo3/lib -lfoo1} );
    like( $alien->cflags_static, qr{-I.*Alien-libfoo3/include -DFOO=2 -DFOO_STATIC=2} );
    like( $alien->libs_static,   qr{-L.*Alien-libfoo3/lib -lfoo1 -lbar -lbaz} );
    is( $alien->version,         '2.3.5' );
    is( $alien->runtime_prop->{arbitrary}, 'four');

  };
  
  subtest 'foo3' => sub {
  
    my $alien = Alien::libfoo3->alt('foo3');
    
    isa_ok $alien, 'Alien::Base';
    isa_ok $alien, 'Alien::libfoo3';

    like( $alien->cflags,        qr{-I.*Alien-libfoo3/include -DFOO=1} );
    like( $alien->libs,          qr{-L.*Alien-libfoo3/lib -lfoo} );
    like( $alien->cflags_static, qr{-I.*Alien-libfoo3/include -DFOO=1 -DFOO_STATIC=1} );
    like( $alien->libs_static,   qr{-L.*Alien-libfoo3/lib -lfoo -lbar -lbaz} );
    is( $alien->version,         '2.3.4' );
    is( $alien->runtime_prop->{arbitrary}, 'five');
  
  };
  
  subtest 'foo4' => sub {
  
    eval { Alien::libfoo3->alt('foo4') };
    like $@, qr/no such alt: foo4/;
  
  };
  
  subtest 'default -> foo2 -> foo1' => sub {
  
    my $alien = Alien::libfoo3->alt('foo2')->alt('foo1');
  
    isa_ok $alien, 'Alien::Base';
    isa_ok $alien, 'Alien::libfoo3';

    like( $alien->cflags,        qr{-I.*Alien-libfoo3/include -DFOO=1} );
    like( $alien->libs,          qr{-L.*Alien-libfoo3/lib -lfoo} );
    like( $alien->cflags_static, qr{-I.*Alien-libfoo3/include -DFOO=1 -DFOO_STATIC=1} );
    like( $alien->libs_static,   qr{-L.*Alien-libfoo3/lib -lfoo -lbar -lbaz} );
    is( $alien->version,         '2.3.4' );
    is( $alien->runtime_prop->{arbitrary}, 'two');

  };
  
};

done_testing
