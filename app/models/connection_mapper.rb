# ConnectionMapper takes a user and a list of profiles (returned e.g. from the search friends
# feature). Sending the "#connections" method it returns a list of connections that the user has
# with every profile's associated user.

class ConnectionMapper
  attr_reader :user, :profiles

  def initialize(user_to_match, search_result_profiles)
    @user = user_to_match
    @profiles = search_result_profiles
  end

  def connections
    profiles.map do |profile|
      connection = connection_with(profile)
      type = connection[:type]
      detailed_connection = {
        full_name: profile.full_name,
        user_id: profile.user_id,
        type: type
      }
      detailed_connection[:friendship] = connection[:friendship] if type == :requester
      detailed_connection
    end
  end

  private

  def profiles_book
    @_profiles_book ||= {
      friends_prof_ids: Profile.where(user_id: user.friends_ids).pluck(:id),
      friend_requesters_prof_ids: Profile.where(user_id: user.friendship_requesters_ids).pluck(:id),
      friend_receivers_prof_ids: Profile.where(user_id: user.friendship_receivers_ids).pluck(:id),
    }
  end

  def connection_with(profile)
    if profiles_book[:friends_prof_ids].include?(profile.id)
      return { type: :friend }
    elsif profiles_book[:friend_requesters_prof_ids].include?(profile.id)
      friendship = Friendship.find_by!(sender_id: profile.user_id, recipient: user)
      return { type: :requester, friendship: friendship }
    elsif profiles_book[:friend_receivers_prof_ids].include?(profile.id)
      return { type: :receiver }
    else
      return { type: :stranger }
    end
  end

end
