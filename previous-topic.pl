use strict;
use vars qw($VERSION %IRSSI);

use Irssi;

$VERSION = '1.00';
%IRSSI = (
    authors     => 'Miranda Kastemaa',
    contact     => 'miranda@foldplop.com',
    name        => 'previous-topic',
    description => 'Displays the previous topic when the topic is changed. Inspired by Pascal Hakim\'s topic-diff.',
    license     => 'CC0'
);

my %topics;

sub save_topic {
    my ($server, $channel, $topic) = @_;
    $topics{$server}{$channel} = $topic;
}

sub retrieve_topic {
    my ($server, $channel) = @_;
    return $topics{$server}{$channel};
}

sub channel_joined {
    my ($channel) = @_;
    save_topic($channel->{server}->{tag}, $channel->{name}, $channel->{topic});
}

sub topic_changed {
    my ($server, $channel, $topic, $username, $realname) = @_;
    
    my $previous_topic = retrieve_topic($server->{tag}, $channel);
    
    if(defined $previous_topic) {
        $server->print($channel, "Previous topic: " . $previous_topic);
    } else {
        $server->print($channel, "No previous topic");
    }
    
    save_topic($server->{tag}, $channel, $topic);
}

foreach my $channel (Irssi::channels()) {
    channel_joined($channel);
}

Irssi::signal_add 'message topic' => \& topic_changed;
Irssi::signal_add 'channel joined' => \& channel_joined;
