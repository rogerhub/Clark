class BlogController < ApplicationController
  before_filter :getuser,:settab
  def settab    
    @activetab = "blog"
    @pagetitle = "Blog &ndash; WalnutNHS".html_safe
    @pagedescription = "The official blog of WalnutNHS, with pictures and posts about our character, scholarship, leadership, and service to the community."
    @pagekeywords = "WalnutNHS, Walnut, National Honor Society, Walnut High, Walnut High School, blog"
  end
  def index
    @tumblrblogurl = $clarksettings[:tumblrurl] || ""
    redirect_to("http://#{@tumblrblogurl}/", :status => :moved_permanently)
  end
  def tumblrconnect    
    @announcements = $clarksettings[:announcements] || ""
    @aboutnhs = $clarksettings[:aboutnhs] || ""
    @submitguidelines = $clarksettings[:submitguidelines] || ""
    @taglist = $clarksettings[:taglist] || ""
    @tumblrblogurl = $clarksettings[:tumblrurl] || ""
    render :layout => false, :content_type => 'text/javascript'
  end
end
