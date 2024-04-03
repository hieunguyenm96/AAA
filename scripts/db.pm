 #!/usr/local/bin/perl -l

use DBI;
use DBD::mysql;

use constant K_DB         => 'local';
use constant K_USER       => 'root';
use constant K_PWD        => 'ANSKk08aPEDbFjDO';
use constant K_HOST       => 'mysql.orb.local';

sub connect_to_cnxcc_db()
{
	return connect_to_db(K_DB, K_HOST, K_USER, K_PWD);
}

sub connect_to_db($$$$)
{
	my ($db, $host, $user, $pwd) 	= @_;	
    my $dsn = "DBI:mysql:$db:$host";

    return DBI->connect($dsn, $user, $pwd) || die "Could not connect to database: $DBI::errstr";
}

sub update_customer_credit($$$)
{
	my ($dbh, $customer, $duration)	= @_;
	
	$dbh->do("UPDATE credit_card SET credit_money = credit_money - ($duration * cps) WHERE customer_id = '$customer'") or die("$!\n");
}

1;