namespace :jobs do

  desc "Removes all guest users and the rooms they've created."
  task :guests_cleanup => :environment do
    GuestsCleanupJob.perform_later
  end

end