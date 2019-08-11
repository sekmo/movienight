class MovieSyncService
  # The rate limit for the TMDB API is 40 reqs per 10 seconds
  TIME_WINDOW = 11 # one more second, looks 10 is not enough
  MAX_REQUESTS_IN_TIME_WINDOW = 40

  def self.sync_from_tmdb(force_update: false, start_from_tmdb_code:) #TODO change to false and schedule force update one time per month
    Rails.logger.info "XXX #{DateTime.now} MovieSyncService Started!"
    all_current_tmdb_ids = TMDB::Client.get_updated_movies_ids
    
    if force_update
      ids_to_create = all_current_tmdb_ids
    else
      persisted_tmdb_ids = Movie.all.pluck(:tmdb_code)
      ids_to_create = all_current_tmdb_ids - persisted_tmdb_ids
    end

    if start_from_tmdb_code
      index = ids_to_create.index(start_from_tmdb_code)
      puts "XXX index: #{index}"
      ids_to_create = ids_to_create[index + 1 .. -1]
      puts "XXX ids_to_create[0]: #{ids_to_create[0]}"
      puts "XXX ids_to_create[-1]: #{ids_to_create[-1]}"
    end

    one_per_mille_amount_ids = ids_to_create.size / 1000
    amount_inserted = 0

    ids_to_create.each_slice(MAX_REQUESTS_IN_TIME_WINDOW) do |ids_to_create_grouped|
      time = Time.now
      ids_to_create_grouped.each do |tmdb_id|
        begin
          Movie.create_from_tmdb_id(tmdb_id, force_update: force_update)
        rescue TMDB::RequestError => e
          Rails.logger.info("XXX MovieSyncService Error with status #{e.code} - tmdb_id: #{tmdb_id}")
          Rails.logger.info("XXX Message: #{e.message}")
        end

        amount_inserted += 1

        if (amount_inserted % one_per_mille_amount_ids == 0)
          percentage = (amount_inserted/one_per_mille_amount_ids * 0.1).round(1)
          Rails.logger.info "XXX #{DateTime.now} MovieSyncService progress: #{percentage}%"
        end
      end

      # TODO: wrap it in a "throttle" method
      seconds_elapsed = Time.now - time
      if seconds_elapsed < TIME_WINDOW
        seconds_to_sleep = TIME_WINDOW - seconds_elapsed
        Rails.logger.info("XXX MovieSyncService sleeping for #{seconds_to_sleep} seconds")
        sleep(seconds_to_sleep)
      end
    end

    Rails.logger.info "XXX #{DateTime.now} MovieSyncService Finished!"
  end
end
