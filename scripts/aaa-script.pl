
use strict;
use warnings;

require '/usr/local/etc/kamailio/AAA/scripts/db.pm';

use lib '/usr/local/lib64/kamailio/perl/';
use Kamailio qw ( log );
use Kamailio::Constants;
use Kamailio::Message;

use constant AAA_INTERNAL_ERROR => -2;

sub bill_call {
	my $m           = shift;
	my $duration    = shift;

    if (!defined $m) {
        return AAA_INTERNAL_ERROR;
    }

    my $customer = $m->pseudoVar('$var(cs_id)');

    if (!defined $customer) {
        return AAA_INTERNAL_ERROR;
    }

    log(L_INFO, "Calling customer [$customer] with duration [$duration].\n");

	return do_billing($duration, $customer);
}

sub do_billing {
    log(L_INFO, "Start billing.\n");

	my ($duration, $customer) = @_;

    log(L_INFO, "Billing for customer [$customer] with duration [$duration]\n");

	my $dbh	= connect_to_cnxcc_db();

	if (!defined $dbh) {
        log(L_ERR, "Could not connect to database.\n");
		return AAA_INTERNAL_ERROR;
	}

    update_customer_credit($dbh, $customer, $duration);

    log(L_INFO, "Done billing for customer [$customer].\n");

	return 1;
}

sub compare_float_with_operator {
    my $m           = shift;
	my $num1    = shift;

    if (!defined $m) {
        return AAA_INTERNAL_ERROR;
    }

    my $operator = $m->pseudoVar('$var(operator)');
    my $num2 = $m->pseudoVar('$var(num2)');

    log(L_INFO, "compare_float_with_operator >>> input: $num1, $num2, $operator\n");
    
    # Perform the comparison based on the specified operator
    if ($operator eq '==' && $num1 == $num2) {
        return 1;
    } elsif ($operator eq '!=' && $num1 != $num2) {
        return 1;
    } elsif ($operator eq '<' && $num1 < $num2) {
        return 1;
    } elsif ($operator eq '>' && $num1 > $num2) {
        return 1;
    } elsif ($operator eq '<=' && $num1 <= $num2) {
        return 1;
    } elsif ($operator eq '>=' && $num1 >= $num2) {
        return 1;
    } else {
        return 0;
    }
}

# Example usage for compare_float_with_operator
# my $num1_str = "0.2";
# my $num2_str = "0.3";
# my $operator = '==';  # Specify the comparison operator

# my $result = compare_float_with_operator($num1_str . ',' . $num2_str . ',' . $operator);
# if ($result) {
#     print "The numbers satisfy the comparison.\n";
# } else {
#     print "The numbers do not satisfy the comparison.\n";
# }

# Example usage for bill_call
# bill_call('2,HCM');

1;