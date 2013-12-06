#!/usr/bin/perl
use strict;
use warnings;

# genMasks();

# print genRandomAddress(),"\n";

my $add = genRandomAddress();
my $bits = int(rand(32));
my $hostbits = 32 - $bits;
my $mask = genmask($bits);
my $net = $add & $mask;
$net = $net .  "0" x (32-length($net));

print $bits," ",$mask," ",$add," ",$net," ",$hostbits,"\n";
print convBinAddress($mask)," ",convBinAddress($add)," ",convBinAddress($net),"\n";

exit;

sub genRandomAddress {
my $v;
for (my $i=0; $i<32; $i++) {
        $v .= (rand(10)>5) ? 0 : 1;
}
return $v;
}

sub genMasks {
for (my $i=0; $i<20; $i++) {
my $bits = int(rand(32));
my $cidr = convbitsCidr($bits);
print "\\$bits -> $cidr\n";
}
}

sub convbitsCidr {
my $bits = shift;
my $mask = genmask($bits);
my $cidr = convMaskCidr($mask);
return $cidr;
}

sub convBinAddress {
my $binary=shift;
my $byte1 = bin2dec(substr($binary,0,8));
my $byte2 = bin2dec(substr($binary,8,8));
my $byte3 = bin2dec(substr($binary,16,8));
my $byte4 = bin2dec(substr($binary,24,8));
return "$byte1.$byte2.$byte3.$byte4";
}

sub convMaskCidr {
my $mask=shift;
my $byte1 = bin2dec(substr($mask,0,8));
my $byte2 = bin2dec(substr($mask,8,8));
my $byte3 = bin2dec(substr($mask,16,8));
my $byte4 = bin2dec(substr($mask,24,8));
return "$byte1.$byte2.$byte3.$byte4";
}

sub genmask {
my $ones = shift;
my $zero = 32-$ones;
return "1" x $ones . "0" x $zero;
}

sub netmask2cidr {
    my ($mask, $network) = @_;
    my @octet = split (/\./, $mask);
    my @bits;
    my $binmask;
    my $binoct;
    my $bitcount=0;

    foreach (@octet) {
      $binoct = dec2bin($_);
      $binmask = $binmask . substr $binoct, -8;
    }

    # let's count the 1s
    @bits = split (//,$binmask);
    foreach (@bits) {
      if ($_ eq "1") {
        $bitcount++;
      }
    }

    my $cidr = $network . "/" . $bitcount;
    return $cidr;
}


sub genbin {
my $range = 255;
my $random_number = int(rand($range));
my $binary_number = dec2bin($random_number);
return pad($binary_number);
}

sub pad {
return sprintf '%.8d', shift;
}

sub pad32 {
return sprintf '%.32d',shift;
}

sub dec2bin {
my $str = unpack("B32", pack("N", shift));
$str =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
return $str;
}

sub bin2dec {
return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}
