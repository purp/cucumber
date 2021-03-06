if defined?(ActiveRecord::Base)
  Cucumber::Rails::World.use_transactional_fixtures = true
  
  Before do
    @__cucumber_ar_connection = ActiveRecord::Base.connection
    if @__cucumber_ar_connection.respond_to?(:increment_open_transactions)
      @__cucumber_ar_connection.increment_open_transactions
    else
      ActiveRecord::Base.__send__(:increment_open_transactions)
    end
    @__cucumber_ar_connection.begin_db_transaction
    ActionMailer::Base.deliveries = [] if defined?(ActionMailer::Base)
  end
  
  After do
    @__cucumber_ar_connection.rollback_db_transaction
    if @__cucumber_ar_connection.respond_to?(:decrement_open_transactions)
      @__cucumber_ar_connection.decrement_open_transactions
    else
      ActiveRecord::Base.__send__(:decrement_open_transactions)
    end
  end
else
  module Cucumber::Rails
    def World.fixture_table_names; []; end # Workaround for projects that don't use ActiveRecord
  end
end
