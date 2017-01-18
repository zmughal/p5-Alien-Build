package Alien::Build::Interpolate;

use strict;
use warnings;

# ABSTRACT: Advanced interpolation engine for Alien builds
# VERSION

sub new
{
  my($class) = @_;
  my $self = bless {
    helper  => {},
    classes => {},
  }, $class;
  $self;
}

sub add_helper
{
  my $self = shift;
  my $name = shift;
  my $code = shift;
  
  if(defined $self->{helper}->{$name}->{code})
  {
    require Carp;
    Carp::croak "duplicate implementation for interpolated key $name";
  }
  
  while(@_)
  {
    my $module = shift;
    my $version = shift;
    $version ||= 0;
    $self->{helper}->{$name}->{require}->{$module} = $version;
  }
  
  $self->{helper}->{$name}->{code} = $code;
}

sub execute_helper
{
  my($self, $name) = @_;
  
  foreach my $module (keys %{ $self->{helper}->{$name}->{require} })
  {
    my $version = $self->{helper}->{$name}->{require}->{$module};

    # yeah we do have to eval every time in case $version is different
    # from the last load.
    eval qq{ use $module $version (); 1 };
    die $@ if $@;

    unless($self->{classes}->{$module})
    {
      if($module->can('alien_helper'))
      {
        my $helpers = $module->alien_helper;
        while(my($k,$v) = each %$helpers)
        {
          $self->{helper}->{$k}->{code} = $v;
        }
      }
      $self->{classes}->{$module} = 1;
    }
  }
  
  my $code = $self->{helper}->{$name}->{code};
  
  if(ref($code) ne 'CODE')
  {
    my $perl = $code;
    package Alien::Build::Interpolate::Helper;
    $code = sub {
      my $value = eval $perl;
      die $@ if $@;
      $value;
    };
  }
  
  $code->();
}

sub interpolate
{
  my($self, $string) = @_;
  $string =~ s{(?<!\%)\%\{([a-zA-Z_][a-zA-Z_0-9]+)\}}{$self->execute_helper($1)}eg;
  $string =~ s/\%(?=\%)//g;
  $string;
}

1;
