class ProfileMatcher
  attr_reader :matched_user

  def initialize(matched_user)
    @matched_user = matched_user
    @friends_profiles = Profile.where(user_id: matched_user.friends_ids)
    @friendship_requesters = Profile.where(user_id: matched_user.friendship_requesters_ids)
    @friendship_receivers = Profile.where(user_id: matched_user.friendship_receivers_ids)
  end

  def match(profile)
    return { match_kind: :friend } if @friends_profiles.include?(profile)
    if @friendship_requesters.include?(profile)
      friendship = Friendship.find_by(sender: profile.user, recipient: @matched_user)
      return { match_kind: :requester, friendship: friendship }
    end
    return { match_kind: :receiver } if @friendship_receivers.include?(profile)
    return { match_kind: :stranger }
  end
end
