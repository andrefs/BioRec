use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Bipi::App' }
BEGIN { use_ok 'Bipi::App::Controller::Upload' }

ok( request('/upload')->is_success, 'Request should succeed' );
done_testing();
