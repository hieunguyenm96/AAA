use DBI;
use DBD::mysql;

use Log::Log4perl;

Log::Log4perl::init_and_watch("log4perl.conf", 60);
my $logger = Log::Log4perl->get_logger();

$logger->info("Starting script");

# Specify the path to your .env file
my $env_file = './.env';

# Read the .env file and parse the environment variables
open(my $fh, '<', $env_file) or die "Could not open file '$env_file' $!";
while (my $line = <$fh>) {
    chomp $line;
    my ($key, $value) = split('=', $line, 2);
    $ENV{$key} = $value;
}
close($fh);

# Access the environment variables
my $K_DB = $ENV{'K_DB'};
my $K_USER = $ENV{'K_USER'};
my $K_PWD = $ENV{'K_PWD'};
my $K_HOST = $ENV{'K_HOST'};

$logger->info("K_DB: $K_DB");
$logger->info("K_USER: $K_USER");
$logger->info("K_PWD: $K_PWD");
$logger->info("K_HOST: $K_HOST\n");

# use constant K_DB         => 'kamailio';
# use constant K_USER       => 'kamailio';
# use constant K_PWD        => 'kamailiorw';
# use constant K_HOST       => 'localhost';

sub connect_to_cnxcc_db()
{
    $logger->info("Connecting to cnxcc database.\n");
	return connect_to_db($K_DB, $K_HOST, $K_USER, $K_PWD);
    # return connect_to_db(K_DB, K_HOST, K_USER, K_PWD);
}

sub connect_to_db($$$$)
{
	my ($db, $host, $user, $pwd) 	= @_;	
    my $dsn = "DBI:mysql:$db:$host";

    $logger->info("Dsn: $dsn\n");

    $dbh = DBI->connect($dsn, $user, $pwd) || die "Could not connect to database: $DBI::errstr";

    $logger->info("Connected to database.\n");

    return $dbh;
}

sub update_customer_credit($$$)
{
	my ($dbh, $customer, $duration)	= @_;

    # $logger->info("Charge for customer [$customer] with duration [$duration]\n");
	
	$dbh->do("UPDATE credit_card SET credit_money = credit_money - ($duration * cps) WHERE customer_id = '$customer'") or die("$!\n");
}

1;