namespace :recurring do
  desc 'Queue up recurring social media fetchers'
  task init: :environment do
    InstagramJob.enqueue_now
    FacebookJob.enqueue_now
    TwitterJob.enqueue_now
  end
end
