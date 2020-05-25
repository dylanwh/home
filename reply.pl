use 5.28.0;
use lib 'lib';
use experimental 'signatures';
use Env qw($HOME @PATH);
use Data::Printer { escape_chars => 'nonascii', print_escapes => 1, indent => 2, deparse => 1, max_depth => 1 };
use Mojo::File qw(path);
use Graph;