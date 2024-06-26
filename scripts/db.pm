use DBI;
use DBD::mysql;

use lib '/usr/local/lib64/kamailio/perl/';
use Kamailio qw ( log );
use Kamailio::Constants;
use Kamailio::Message;

# Specify the path to your .env file
# my $env_file = './.env';

# # Read the .env file and parse the environment variables
# open(my $fh, '<', $env_file) or die "Could not open file '$env_file' $!";
# while (my $line = <$fh>) {
#     chomp $line;
#     my ($key, $value) = split('=', $line, 2);
#     $ENV{$key} = $value;
# }
# close($fh);

# # Access the environment variables
# my $K_DB = $ENV{'K_DB'};
# my $K_USER = $ENV{'K_USER'};
# my $K_PWD = $ENV{'K_PWD'};
# my $K_HOST = $ENV{'K_HOST'};

# log(L_INFO, "K_DB: $K_DB\n");
# log(L_INFO, "K_USER: $K_USER\n");
# log(L_INFO, "K_PWD: $K_PWD\n");
# log(L_INFO, "K_HOST: $K_HOST\n");

use constant K_DB         => 'kamailio';
use constant K_USER       => 'kamailio';
use constant K_PWD        => 'kamailiorw';
use constant K_HOST       => 'localhost';

sub connect_to_cnxcc_db()
{
    log(L_INFO, "Connecting to database.\n");
	# return connect_to_db($K_DB, $K_HOST, $K_USER, $K_PWD);
    return connect_to_db(K_DB, K_HOST, K_USER, K_PWD);
}

sub connect_to_db($$$$)
{
	my ($db, $host, $user, $pwd) 	= @_;	
    my $dsn = "DBI:mysql:$db:$host";

    log(L_INFO, "DSN: $dsn\n");

    $dbh = DBI->connect($dsn, $user, $pwd) || die "Could not connect to database: $DBI::errstr";

    log(L_INFO, "Connected to database.\n");

    return $dbh;
}

sub update_customer_credit($$$)
{
	my ($dbh, $customer, $duration)	= @_;

    log(L_INFO, "Charge for customer [$customer] with duration [$duration]\n");
	
	$dbh->do("UPDATE credit_card SET credit_money = credit_money - ($duration * cps) / 2 WHERE customer_id = '$customer'") or die("$!\n");
}

1;