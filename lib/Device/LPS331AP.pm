package Device::LPS331AP;

# PODNAME: Device::LPS331AP 
# ABSTRACT: I2C interface to LPS331AP Thermometer and Barometer using Device::SMBus
# COPYRIGHT
# VERSION

use 5.010;
use Moose;
use POSIX;

# Dependencies
use Device::LPS331AP::Altimeter;

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

This is a object of L<Device::LPS331AP::Altimeter>

=cut

has Altimeter => (
    is => 'ro',
    isa => 'Device::LPS331AP::Altimeter',
    lazy_build => 1,
);

sub _build_Altimeter {
    my ($self) = @_;
    my $obj = Device::LPS331AP::Altimeter->new(
        I2CBusDevicePath => $self->I2CBusDevicePath
    );
    return $obj;
}

1;
