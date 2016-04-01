use Encode;

$NAME = 'queer';
$VERSION = '0.1';

%IRSSI = (
	name		=> $NAME,
	version		=> $VERSION,
	author		=> 'Miranda Kastemaa',
	contact		=> 'miranda@foldplop.com',
	description	=> 'Creates rainbow text using the extended IRC color palette',
	license		=> 'CC0'
);

sub colorize {
    my ($brightness, $offset, $text) = @_;
    
    $brightness = $brightness % 6;
    $offset = $offset % 12;
    
    my @chars = split(//, $text);
    
    my @colorized_chars = ();
    my $i = $offset;
    foreach $char (@chars) {
        my $color = 16 + $brightness * 12 + $i;
        push @colorized_chars, "\x03$color$char";
        
        $i = ($i + 1) % 12;
    }
    
    return join('', @colorized_chars);
}

sub queer {
    my ($data, $server, $witem) = @_;
    
    # TODO: parse -brightness x and -offset y args from $data
    my $brightness = 3;
    my $offset = 0;
        
    if(defined $witem && $data) {
        my $text = Encode::decode_utf8($data) unless Encode::is_utf8($data, 1);        
        my $colorized_text = colorize($brightness, $offset, $text);
    
        # TODO: ensure irssi's line splitting doesn't break colors
        $witem->command("MSG " . $witem->{name} . " $colorized_text");
    }    
}

Irssi::command_bind($NAME, \&queer);
