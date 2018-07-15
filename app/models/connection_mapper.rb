# ConnectionMapper takes a profile and a list of profiles (returned e.g. from the search friends
# feature). Sending the "#connections" method it returns a list of connections that the profile has
# with every profile's associated user.

class ConnectionMapper
  attr_reader :profile_to_match, :profiles

  def initialize(profile_to_match, search_result_profiles)
    @profile_to_match = profile_to_match
    @profiles = search_result_profiles
  end

  def connections
    profiles.map do |profile|
      connection = connection_with(profile)
      type = connection[:type]
      detailed_connection = {
        full_name: profile.full_name,
        profile: profile,
        type: type
      }
      detailed_connection[:friendship] = connection[:friendship] if type == :requester
      detailed_connection
    end
  end

  private

  def profiles_book
    @_profiles_book ||= {
      friends_ids: Profile.where(user_id: profile_to_match.friends_ids).pluck(:id),
      friend_requesters_ids: Profile.where(user_id: profile_to_match.friendship_requesters_ids).pluck(:id),
      friend_receivers_ids: Profile.where(user_id: profile_to_match.friendship_receivers_ids).pluck(:id),
    }
  end

  def connection_with(profile)
    if profiles_book[:friends_ids].include?(profile.id)
      return { type: :friend }
    elsif profiles_book[:friend_requesters_ids].include?(profile.id)
      friendship = Friendship.find_by!(sender_id: profile.id, receiver: profile_to_match)
      return { type: :requester, friendship: friendship }
    elsif profiles_book[:friend_receivers_ids].include?(profile.id)
      return { type: :receiver }
    else
      return { type: :stranger }
    end
  end

end
