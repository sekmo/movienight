# ConnectionMapper takes a user and a list of users (returned e.g. from the search friends
# feature). Sending the "#connections" method it returns a list of connections that the user has
# with the users.

class ConnectionMapper
  attr_reader :base_user, :users

  def initialize(base_user, search_result_users)
    @base_user = base_user
    @users = search_result_users
  end

  def connections
    users.map do |user|
      connection = connection_with(user)
      type = connection[:type]
      detailed_connection = {
        full_name: user.full_name,
        user: user,
        type: type
      }
      detailed_connection[:friendship] = connection[:friendship] if type == :requester
      detailed_connection
    end
  end

  private

  def users_book
    @_users_book ||= {
      friends_ids: User.where(id: base_user.friends_ids).pluck(:id),
      friend_requesters_ids: User.where(id: base_user.friendship_requesters_ids).pluck(:id),
      friend_receivers_ids: User.where(id: base_user.friendship_receivers_ids).pluck(:id),
    }
  end

  def connection_with(user)
    if users_book[:friends_ids].include?(user.id)
      return { type: :friend }
    elsif users_book[:friend_requesters_ids].include?(user.id)
      friendship = Friendship.find_by!(receiver: base_user, sender_id: user.id)
      return { type: :requester, friendship: friendship }
    elsif users_book[:friend_receivers_ids].include?(user.id)
      return { type: :receiver }
    else
      return { type: :stranger }
    end
  end

end
