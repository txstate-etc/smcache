namespace :recurring do
  task init: :environment do
    InstagramJob.enqueue_now
    TwitterJob.enqueue_now
  end
end
