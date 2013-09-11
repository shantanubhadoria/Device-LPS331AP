use FindBin qw($Bin);
use lib "$Bin/../lib";
use v5.10;

use Device::LPS331AP::Altimeter;

my $a = Device::LPS331AP::Altimeter->new(I2CBusDevicePath => '/dev/i2c-1');
$a->enable();
use Data::Dumper;
while(){
    say 'millibars: ' . Dumper $a->getPressureMillibars();
    say 'InchesHg: ' . $a->getPressureInchesHg();
    say 'Celsius: ' . $a->getTemperatureCelsius();
    say 'Farenheit: ' . $a->getTemperatureFarenheit();
    say 'ALTITUDE: ' . $a->getPressureToAltitudeMeters($a->getPressureMillibars,1011);
}
