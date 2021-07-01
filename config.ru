require './config/environment'

begin
  fi_check_migration

  use Rack::MethodOverride
  run ApplicationController
  enable :sessions
rescue ActiveRecord::PendingMigrationError => err
  STDERR.puts err
  exit 1
end

run ApplicationController
use SongsController
use ArtistsController
use GenresController
