package Device::LPS331AP::Altimeter;

# PODNAME: Device::LPS331AP::Altimeter 
# ABSTRACT: I2C interface to LPS331AP Altimeter using Device::SMBus
# COPYRIGHT
# VERSION

use 5.010;
use Moose;
use POSIX;
use Math::BigFloat;

# Registers for the Altimeter 
use constant {
    CTRL_REG1 => 0x20,
};

# X, Y and Z Axis magnetic Field Data value in 2's complement
use constant {
    PRESS_OUT_H  => 0x2a,
    PRESS_OUT_L  => 0x29,
    PRESS_OUT_XL => 0x28,

    TEMP_OUT_H => 0x2c,
    TEMP_OUT_L => 0x2b,
};

use integer; # Use arithmetic right shift instead of unsigned binary right shift with >> 4

extends 'Device::SMBus';

has '+I2CDeviceAddress' => (
    is      => 'ro',
    default => 0x5d,
);

=method enable 

    $self->enable()

Initializes the device, Call this before you start using the device. This function sets up the appropriate default registers.
The Device will not work properly unless you call this function

CTRL_REG1
power: {0:off,1:on}
ODR2:output data rate
ODR1
ODR0
DIFF_EN: Interrupt generation{0:disabled,1:enabled}
BDU: Block Data Update{0:continuous update, 1: output registers not updated until MSB and LSB reading}
DELTA_EN: (1: delta pressure registers enabled. 0: disable)
SIM: SPI Serial Interface Mode selection (0: 4-wire interface; 1: 3-wire interface)
default = 1 111 0 1 1 0
=cut

sub enable {
    my ($self) = @_;
    $self->writeByteData(CTRL_REG1,0b11100000);
}

=method getRawReading

    $self->getRawReading()

Return raw readings from accelerometer registers

=cut

sub getRawReading {
    my ($self) = @_;

    return (
        pressure => (
            ( $self->_typecast_int_to_int32( $self->readByteData(PRESS_OUT_H) ) << 16)
            | ( $self->_typecast_int_to_int16( $self->readByteData(PRESS_OUT_L) ) << 8)
            | ($self->readByteData(PRESS_OUT_XL) )
        ),
        temperature => ( $self->_typecast_int_to_int16( ($self->readByteData(TEMP_OUT_H) << 8) | $self->readByteData(TEMP_OUT_L) ) ) ,
    );
}

sub getPressureMillibars{
    my ($self) = @_;

    my $pressure_raw = ( $self->_typecast_int_to_int32( $self->readByteData(PRESS_OUT_H) ) << 16)
            | ( $self->_typecast_int_to_int16( $self->readByteData(PRESS_OUT_L) ) << 8)
            | ($self->readByteData(PRESS_OUT_XL) )
    ;
    return Math::BigFloat->new( ( $self->_typecast_int_to_int32( $self->readByteData(PRESS_OUT_H) ) << 16)
            | ( $self->_typecast_int_to_int16( $self->readByteData(PRESS_OUT_L) ) << 8)
            | ($self->readByteData(PRESS_OUT_XL) ) )/4096;
}

sub getPressureInchesHg{
    my ($self) = @_;
    return Math::BigFloat->new(
            ( $self->_typecast_int_to_int32( $self->readByteData(PRESS_OUT_H) ) << 16)
            | ( $self->_typecast_int_to_int16( $self->readByteData(PRESS_OUT_L) ) << 8)
            | ($self->readByteData(PRESS_OUT_XL) )
    ) / 138706.5;
}

sub getTemperatureCelsius{
    my ($self) = @_;
    
    return 42.5 + (Math::BigFloat->new( $self->_typecast_int_to_int16( ($self->readByteData(TEMP_OUT_H) << 8) | $self->readByteData(TEMP_OUT_L) ) ) / 480);
}

sub getTemperatureFarenheit{
    my ($self) = @_;
    
    return 108.5 + (Math::BigFloat->new( $self->_typecast_int_to_int16( ($self->readByteData(TEMP_OUT_H) << 8) | $self->readByteData(TEMP_OUT_L) ) ) / 480 * 1.8);
}

sub _typecast_int_to_int16 {
    return  unpack 's' => pack 'S' => $_[1];
}

sub _typecast_int_to_int32 {
    return  unpack 'ss' => pack 'SS' => $_[1];
}

sub calibrate {
    my ($self) =@_;

}

1;
