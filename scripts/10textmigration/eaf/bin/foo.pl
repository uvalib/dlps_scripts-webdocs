#!/usr/bin/perl

while (<>){
    if (/<orig[^>]*>[^<]*<\/orig><lb\/>/){
	$buffer=$_;
        until (/<orig>[^<]*<\/orig>/) {
	    $buffer.=$_;
            $_=<>;
        }
        $buffer.=$_;
        $buffer=~s/\n//g;
        $buffer=~s/<orig reg="([^"]*)">([^<]*)<\/orig><lb\/>(.*?)<orig>([^<]*)<\/orig>/<orig reg="$1">$2-$4<\/orig>$3/;
        print "$buffer\n";
    } else {
      print "$_";
    }
}
