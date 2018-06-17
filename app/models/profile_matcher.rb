class ProfileMatcher
  def initialize(user)
    Rails.logger.debug("ProfileMatcher#initialize")
    @friends_profiles = user.friends.map(&:profile)
    @friendship_requesters = user.friendship_requesters.map(&:profile)
    @friendship_receivers = user.friendship_receivers.map(&:profile)
  end

  def match(profile)
    return { match_kind: :friend } if @friends_profiles.include?(profile)
    if @friendship_requesters.include?(profile)
      friendship = Friendship.find_by(sender: profile.user)
      return { match_kind: :requester, friendship: friendship }
    end
    return { match_kind: :receiver } if @friendship_receivers.include?(profile)
    return { match_kind: :no_match }
  end
end
