#!/usr/bin/perl

use DBI;
use DBD::mysql;

use strict;

use constant K_DB         => 'local';
use constant K_USER       => 'root';
use constant K_PWD        => 'ANSKk08aPEDbFjDO';
use constant K_HOST       => '127.0.0.1';

my $driver = "mysql"; 
my $database = "local";
my $dsn = "DBI:$driver:database=$database";
my $userid = "root";
my $password = "ANSKk08aPEDbFjDO";

my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;

