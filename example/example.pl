use FindBin qw($Bin);
use lib "$Bin/../lib";

use Device::LPS331AP::Altimeter;

my $a = Device::LPS331AP::Altimeter->new(I2CBusDevicePath => '/dev/i2c-1');
$a->enable();
use Data::Dumper;
while(){
    print 'Altimeter: ' . Dumper {$a->getRawReading()};
    print 'millibars: ' . Dumper {$a->getPressureMillibars()};
    print 'InchesHg: ' . Dumper {$a->getPressureInchesHg()};
    print 'Celsius: ' . Dumper {$a->getTemperatureCelsius()};
    print 'Farenheit: ' . Dumper {$a->getTemperatureFarenheit()};
}
