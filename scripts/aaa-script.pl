require './db.pm';

use strict;
use warnings;

use constant AAA_INTERNAL_ERROR => -2;

sub bill_call {
	my ($input) = @_;

    my ($duration, $customer) = split(',', $input);

	return do_billing($duration, $customer);
}

sub do_billing {
	my ($duration, $customer) = @_;
	my $dbh	= connect_to_cnxcc_db();

	if (!defined $dbh) {
		return AAA_INTERNAL_ERROR;
	}

    update_customer_credit($dbh, $customer, $duration);

	return 1;
}

sub compare_float_with_operator {
    my ($input) = @_;

    my ($num1_str, $num2_str, $operator) = split(',', $input);
    
    my $num1 = 0 + $num1_str;  # Convert string to floating-point number
    my $num2 = 0 + $num2_str;  # Convert string to floating-point number
    
    # Perform the comparison based on the specified operator
    if ($operator eq '==') {
        return $num1 == $num2;
    } elsif ($operator eq '!=') {
        return $num1 != $num2;
    } elsif ($operator eq '<') {
        return $num1 < $num2;
    } elsif ($operator eq '>') {
        return $num1 > $num2;
    } elsif ($operator eq '<=') {
        return $num1 <= $num2;
    } elsif ($operator eq '>=') {
        return $num1 >= $num2;
    } else {
        die "Unsupported operator: $operator";
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