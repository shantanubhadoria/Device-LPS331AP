package Device::LPS331AP;

# PODNAME: Device::LPS331AP 
# ABSTRACT: I2C interface to LPS331AP Thermometer and Barometer using Device::SMBus
# COPYRIGHT
# VERSION

use 5.010;
use Moose;
use POSIX

# Dependencies
use Device::LPS331AP::Altimeter;

has 'I2CBusDevicePath' => (
    is => 'ro',
);

has Altimeter => (
    is => 'ro',
    isa => 'Device::LPS331AP::Altimeter',
    lazy_build => 1,
);

sub _build_Altimeter {
    my ($self) = @_;
    my $obj = Device::LPS331AP::Altimeter->new(
        I2CBusDevicePath => $self->I2CBusDevicePath;
    );
    return $obj;
}

1;
