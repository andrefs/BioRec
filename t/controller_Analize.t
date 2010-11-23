use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Bipi::App' }
BEGIN { use_ok 'Bipi::App::Controller::Analize' }

ok( request('/analize')->is_success, 'Request should succeed' );
done_testing();
