class BaseJob

  # def perform
  #   raise NoMethodError.new('Inheritors must implement the perform method.', 'perform')
  # end

  def enqueue(job)
    Rails.logger.info logjob('ENQUEUE', job)
  end

  def before(job)
    Rails.logger.debug logjob('BEFORE', job)
  end

  def after(job)
    Rails.logger.debug logjob('AFTER', job)
  end

  def error(job, exception)
    Rails.logger.error("#{logjob('ERROR', job)}: #{exception}")
    ExceptionNotifier.notify_exception(exception)
  end

  def success(job)
    Rails.logger.info(logjob('SUCCESS', job))
    reschedule(job)
  end

  def failure(job)
    msg = logjob('FAILURE', job)
    Rails.logger.error(msg)
    ExceptionNotifier.notify_exception(RuntimeError.new(msg))
    reschedule(job)
  end

  def reschedule(job)
    self.class.jobs.each{|j| j.destroy unless j == job}
    Delayed::Job.enqueue self.class.new, run_at: 1.minute.from_now
  end

  def self.jobs
    Delayed::Job.where('failed_at IS NULL').where("(handler LIKE ?) OR (handler LIKE ?)", "--- !ruby/object:#{name} %", "--- !ruby/object:#{name}\n%")
  end

  def self.enqueue_now
    jobs.each{|j| j.destroy}
    Delayed::Job.enqueue self.new
  end

  protected

  def logjob(label, job)
    "#{Time.now.strftime('%FT%T%z')} #{label} #{job.name}(#{job.id}), attempts #{job.attempts}"
  end
end
