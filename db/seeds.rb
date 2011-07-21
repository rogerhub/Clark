# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
Setting.create([{:name => "currentsemester",:value=>"FALL 2011"},
                {:name => "tumblrurl",:value=>"walnutnhs.tumblr.com"},
                {:name => "volunteermotivation",:value=>"""<p class='motivation'>To render service is more than a chance to display good character. It is the means through which a well-rounded individual, accomplished in the fields of leadership and scholarship, with a passion driven by honorable character, can impact the community and give back to a world that has provided so much.</p> <p class='motivation'>Each member of NHS is expected to show the ability to render service to the community. NHS oraganizes group efforts for club members to volunteer in the community. Every semester, NHS contributes hundreds of hours of volunteer work for the benefit of the people around us. It represents the most effective vector of exhibiting good character. Here you will find information about volunteer opportunities and the expectations for NHS members.</p>"""},
                {:name => "volunteerpolicy",:value => """<p>In order to make sure that NHS members are active in service and volunteering, members are required to meet a number of requirements every semester in NHS.</p> <p><ol> <li>Each volunteer or donation event is given a point value and difficulty.</li> <li>Members must earn 25 points through volunteering and contributing donations per semester.</li> <li>Members must complete 2 Hard events, 2 Medium events, and 2 Easy events per semester.</li> <li>If a member does more than 2 Hard events, the excess Hard events can be used to fulfill the requirements for Medium and Easy events. If a member does more than 2 Medium events, the excess Medium events can be used to fulfill the requirements for Easy events. Events may not be bumped up to more difficult categories.</li> <li>After an event, points and difficulty level may be adjusted according to the performance and enthusiasm of a volunteer, or because of unexpected developments during an event. This is left to the chairperson's discretion.</li> <li>Each school year consists of a Fall and Spring semester. Deadlines for NHS point requirements will be announced many weeks in advance.</li> <li>If you feel that NHS's volunteer opportunities are too limited with your schedule, you may be able to earn points for volunteer service done outside of NHS events. You must fill out an outside event volunteering form, which is available in Frau Rovell's room in P7. The point value and difficulty will be determined by the officers. You must get a form approved before you begin the event.</li> <li>There are limits to the number of points that you can earn through outside events. Contact your group leader for more information.</li> <li>Finally, members are expected to uphold the qualities of character, leadership, scholarship, and service, whenever volunteering as a member of NHS.</li> </ol></p> <p>You can sign up for events both online and by emailing your group leader, although using the website is preferred. If you have any ideas or questions about NHS event volunteering, ask your group leader.</p>"""},
                {:name => "volunteerdonationticket",:value => """<p>In addition to volunteering in the community, cooperative donation drives through nonprofit organiziations like World Vision enable NHS members to impact fellow human beings around the world. In order to encourage participation and effort in donations, NHS members can receive points for donating items. We use event tickets to keep track of the various donations that are processed through NHS.</p> <p>Before you make a donation, print out an event ticket, fill it out, and attach it to the donation. A chairperson will sign the ticket and give you back a receipt. Points for donations are usually delayed for several weeks, but event tickets ensure that the points are correctly awarded.</p> <ul> <li><a href="">Event Ticket (21K PDF)</a></li> </ul> <p>If your points for donation events are delayed for at least 30 days, email your group leader. Typically, most donations do not get recorded until the last days of the semester.</p>"""},
                {:name => "peoplemotivation",:value=>"""<p class='motivation'>Each member of NHS is expected to show the ability to render service to the community. NHS oraganizes group efforts for club members to volunt2eer in the community. Every semester, NHS contributes hundreds of hours of volunteer work for the benefit of the people around us. It represents the most effective vector of exhibiting good character. Here you will find information about volunteer opportunities and the expectations for NHS members. Each member of NHS is expected to show the ability to render service to the community. NHS oraganizes group efforts for club members to volunteer in the community.</p>"""},
                {:name => "nhsemail",:value=>"noreply@walnutnhs.com"},
                {:name => "semesterlist",:value=>"FALL 2011\nSPRING 2012\nFALL 2012"},
                {:name => "announcements",:value=>"Announcement 1\nAnnouncement 2"},
                {:name => "aboutnhs",:value=>"<p>NHS is a volunteer organization at Walnut High School that promotes the qualities of leadership, scholarship, character, and service in its members.</p><p>Our club consists of: 230 Members, 145 Club Events, 2951 Points, and 1903 Signups</p>"},
                {:name => "taglist",:value=>"""Campus Beautification
Roger Chen
Trees
Tester
People
Walk
Lorem Ipsum
Summertime
Gardening"""},
                {:name => "submitguidelines",:value=>"""<p>Turn in pictures of NHS members volunteering at events to get easy points! You can submit pictures on the <a href='/submit'>submit page</a>.</p>"""}])