namespace :cleanup do

  desc "Removes all guest users and the rooms they've created."
  task :guests => :environment do
    GuestsCleanupJob.perform_later
  end

  desc "Removes all expired sharing codes."
  task :codes => :environment do
    ExpiredCodesCleanupJob.perform_later
  end

end