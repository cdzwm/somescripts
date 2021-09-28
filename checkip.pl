use utf8;
use Modern::Perl;
use Net::Ping;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTPS;
use Email::Simple::Creator;
use Try::Tiny;

my @check_ports = qw(80 443);

my @hosts = qw(202.99.166.4);

my $ping = Net::Ping->new('tcp', 2);

while(1){
	for (@hosts){
		for my $port (@check_ports) {
			$ping->port_number($port);
			if( my $result = $ping->ping($_)){
				&notify(scalar localtime . ' : ' .  "Host $_, Port: $port");
				last;
			}
		}
	}
	sleep 60;
}

sub notify{
	my $text = shift;
	my $transport = Email::Sender::Transport::SMTPS->new(
		host => 'smtp.qq.com',
		ssl  => 'ssl',
		port => 465,
		sasl_username => '2084944805@qq.com',
		sasl_password => 'password',
		debug => 0
	);

	my $message = Email::Simple->create(
		header => [
			From    => '11111111@qq.com',
			To      => '22222222@qq.com',
			Subject => 'Please note the host is online',
		],
		body => $text,
	);
	try {
		sendmail($message, { transport => $transport });
	} catch {
		die "Error sending email: $_";
	};
}
