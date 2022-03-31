# load sinatra
require 'sinatra'
# require 'stripe'
# require 'sidekiq'
# load dotenv
require 'dotenv/load'
# load activesupport
require 'active_support/all'

# load autoloader
require 'require_all'

# init logging
require 'logger'
logger = Logger.new($stdout)
logger.level = Logger::DEBUG
set :logger, logger

# init database
require 'sequel'
Sequel.extension :pg_array, :pg_json, :pg_json_ops, :pg_inet
Sequel::Model.plugin(:json_serializer)
Sequel::Model.plugin(:validation_helpers)
Sequel::Model.raise_on_save_failure = true # Do not throw exceptions on failure
DB = Sequel.connect(ENV['DB']) # read from docker-compose file
DB.loggers << logger
Sequel::Model.db.extension(:pagination)
Sequel::Model.strict_param_setting = false
DB.extension :pg_array, :pg_json, :connection_validator
DB.extension :auto_literal_strings
DB.pool.connection_validation_timeout = -1
Sequel.extension :migration, :core_extensions
require_all 'models'

# sequel extensions
require 'sequel/extensions/seed'
Sequel.extension :seed
Sequel::Seeder.apply(DB, 'db/seeds')


# load helpers
require_all './lib'

# load main app
require './app'

# load controllers
# require_all 'controllers'