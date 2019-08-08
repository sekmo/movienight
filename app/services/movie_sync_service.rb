class MovieSyncService
  # The rate limit for the TMDB API is 40 reqs per 10 seconds
  TIME_WINDOW = 11 # one more second, looks 10 is not enough
  MAX_REQUESTS_IN_TIME_WINDOW = 40

  def self.sync_from_tmdb(force_update: false) #TODO change to false and schedule force update one time per month
    Rails.logger.info "XXX #{DateTime.now} MovieSyncService Started!"
    all_current_tmdb_ids = TMDB::Client.get_updated_movies_ids
    
    if force_update
      ids_to_create = all_current_tmdb_ids
    else
      persisted_tmdb_ids = Movie.all.pluck(:tmdb_code)
      ids_to_create = all_current_tmdb_ids - persisted_tmdb_ids
    end
    
    one_per_mille_amount_ids = ids_to_create.size / 1000
    amount_inserted = 0

    ids_to_create.each_slice(MAX_REQUESTS_IN_TIME_WINDOW) do |ids_to_create_grouped|
      time = Time.now
      ids_to_create_grouped.each do |tmdb_id|
        begin
          Movie.create_from_tmdb_id(tmdb_id, force_update: force_update)
        rescue TMDB::RequestError => e
          Rails.logger.info("XXX MovieSyncService Error with tmdb_id #{tmdb_id} - #{e.message}")
        end

        amount_inserted += 1

        if (amount_inserted % one_per_mille_amount_ids == 0)
          percentage = (amount_inserted/one_per_mille_amount_ids * 0.1).round(1)
          Rails.logger.info "XXX #{DateTime.now} MovieSyncService progress: #{percentage}%"
        end
      end

      # TODO: wrap it in a "throttle" method
      seconds_elapsed = Time.now - time
      Rails.logger.info("seconds_elapsed: #{seconds_elapsed}")
      if seconds_elapsed < TIME_WINDOW
        Rails.logger.info("sleeping for #{TIME_WINDOW - seconds_elapsed}")
        sleep(TIME_WINDOW - seconds_elapsed)
      end
    end

    Rails.logger.info "XXX #{DateTime.now} MovieSyncService Finished!"
  end
end
