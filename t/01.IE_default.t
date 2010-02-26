#
# Win32::Watir - test.
#

use Test::More 'no_plan';
BEGIN { use_ok('Win32::Watir') };

#########################

use Win32::Watir;

my $codepage = undef;
   $codepage = 'utf8' if (exists($ENV{CYGWIN}));
my $ie = Win32::Watir->new(
	visible => 1,
	maximize => 1,
	warnings => 1,
	codepage => $codepage,
);

## clear cookie and cache.
ok  ($ie->delete_cookie() >= 0, 'delete_cookie() method.');
ok  ($ie->delete_cache()  >= 0, 'delete_cookie() method.');

## WinActivate
sleep 5;
$ie->bring_to_front;
sleep 1;

## Google
$ie->goto('http://www.google.co.jp/');
is  ($ie->URL, 'http://www.google.co.jp/', 'goto www.google.co.jp');

$ie->text_field('name:', 'q')->SetValue('Perl Win32::Watir');
$ie->button('index:', 1)->click;
ok  ($ie->URL =~ /search?/i, 'google search');

my $i = 1;
foreach my $link ( $ie->getAllLinks() ){
	if ($link->class eq 'l'){
		print "# ($i) [text:".$link->text."] [href:".$link->href."]\n";
		$i++;
	}
}
ok  ($i > 1, 'parse google search result');

## Yahoo
$ie->goto('http://search.yahoo.co.jp/');
ok  ($ie->URL =~ /search.yahoo.co.jp/, 'goto search.yahoo.co.jp');
$ie->text_field('name:', 'p')->SetValue('Perl Win32::Watir');
$ie->button('index:', 1)->click;
$i = 1;
foreach my $link ( $ie->getAllLinks() ){
	if ($link->class eq 'yschttl'){
		print "# ($i) [text:".$link->text."] [href:".$link->href."]\n";
		$i++;
	}
}
ok  ($i > 1, 'parse yahoo search result');

## Bing
#$ie->goto('http://www.bing.com/');
#ok  ($ie->URL =~ /www.bing.com/, 'goto www.bing.com');
#$ie->text_field('name:', 'q')->SetValue('Perl Win32::Watir');
#$ie->button('index:', 1)->click;
#$i = 1;
#foreach my $link ( $ie->getAllLinks() ){
#	if ($link->class eq 'sb_tlst'){
#		print "# ($i) [text:".$link->text."] [href:".$link->href."]\n";
#		$i++;
#	}
#}
#ok  ($i > 1, 'parse bing search result');

END {
	$ie->close() if (ref($ie) eq 'Win32::Watir');
}
