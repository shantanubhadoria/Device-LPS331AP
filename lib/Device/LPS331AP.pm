package Device::LPS331AP;

# PODNAME: Device::LPS331AP 
# ABSTRACT: I2C interface to LPS331AP Thermometer and Barometer using Device::SMBus
# COPYRIGHT
# VERSION

# Dependencies
use 5.010;
use Moose;
use POSIX;

use Device::Altimeter::LPS331AP;

=attr I2CBusDevicePath

this is the device file path for your I2CBus that the LPS331AP is connected on e.g. /dev/i2c-1
This must be provided during object creation.

=cut

has 'I2CBusDevicePath' => (
    is => 'ro',
);

=attr Altimeter

    $self->Altimeter->enable();
    $self->Altimeter->getReading();

This is a object of L<Device::Altimeter::LPS331AP>

=cut

has Altimeter => (
    is => 'ro',
    isa => 'Device::Altimeter::LPS331AP',
    lazy_build => 1,
);

sub _build_Altimeter {
    my ($self) = @_;
    my $obj = Device::Altimeter::LPS331AP->new(
        I2CBusDevicePath => $self->I2CBusDevicePath
    );
    return $obj;
}

1;
