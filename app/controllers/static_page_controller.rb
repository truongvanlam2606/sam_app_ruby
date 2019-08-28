class StaticPageController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.paginate(page: params[:page],
      per_page: Settings.per_page_feed).sort_by_created_at
  end

  def help; end

  def about; end

  def contact; end
end
