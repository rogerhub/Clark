class BlogController < ApplicationController
  before_filter :getuser,:settab
  def settab    
    @activetab = "blog"
    @pagetitle = "Blog &ndash; WalnutNHS".html_safe
    @pagedescription = "The official blog of WalnutNHS, with pictures and posts about our character, scholarship, leadership, and service to the community."
    @pagekeywords = "WalnutNHS, Walnut, National Honor Society, Walnut High, Walnut High School, blog"
  end
  def index
    @tumblrblogurl = Setting.find_by_name('tumblrurl').value || ""
    redirect_to("http://#{@tumblrblogurl}/")
  end
  def tumblrconnect    
    @announcements = Setting.find_by_name('announcements').value || ""
    @aboutnhs = Setting.find_by_name('aboutnhs').value || ""
    @submitguidelines = Setting.find_by_name('submitguidelines').value || ""
    @taglist = Setting.find_by_name('taglist').value || ""
    @tumblrblogurl = Setting.find_by_name('tumblrurl').value || ""
    render :layout => false, :content_type => 'text/javascript'
  end
end
