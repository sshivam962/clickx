# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Admin User
fail if Rails.env.production?

User.reset_column_information
Business.reset_column_information
User.create(first_name: 'Admin',
            last_name: 'ClixkX',
            email: 'admin@clickx.io',
            password: 'admin1234',
            role: User::Admin,
            invitation_accepted_at: Time.now)

# Test Company Admin
User.create(first_name: 'Test',
            last_name: 'User',
            email: 'test@clickx.com',
            password: 'test1234',
            role: User::CompanyAdmin,
            invitation_accepted_at: Time.now)


Agency.create(name: "test")
Business.create(domain: "http://test.com", name: "test", agency: Agency.last)

MailTemplate::Types.each do |mail_type|
  MailTemplate.create(mail_type: mail_type,
                      subject: mail_type.titleize,
                      welcome_text: '<tr>\n\t<td style=\"color:#f7af30;font-size:28px;line-height:28px;font-weight:bold;padding:20px 0\">\n\t\tYou’re invited xyz,\n\t</td></tr>',
                      paragraph1: "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"><tbody><tr><td style=\"font-weight:bold;color:#646464;padding:10px 0\">Quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</td></tr><tr><td style=\"color:#646464;padding:10px 0\">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</td></tr></tbody></table>"
                     )
end
#Content Questionnaire
# group_bank = [{name: "About Your Company"},
#               {name: "Your Industry & Competition"},
#               {name: "Your Audience"},
#               {name: "Your Content"},
#               {name: "Your Blog"}]

group1 = Group.new(name: "About Your Company")
group1.questions.build([{question: 'Brief Company Overview', description: '', exp_ans_type: 'oneliner', is_published: false, is_mandatory: true, order: 1 },
                     {question: 'Website URL', description: '', exp_ans_type: 'oneliner', is_published: false, is_mandatory: true, order: 2 },
                     {question: 'Tag Lines', description: 'if any', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 3 },
                     {question: 'Desired Calls-to-Action', description: 'what action do you want people to take after reading your content/visiting your website - e.g. request a free consultation, request a quote, schedule an appointment, etc.', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 4 },
                     {question: 'Use of Calls-to-Action', description: 'are you looking for a very direct, strong use of calls-to-action or do you prefer a more subtle approach – e.g. Buy Now! vs. Browse our selection', exp_ans_type: 'oneliner',  is_published: false, is_mandatory: false, order: 5 },
                     {question: 'Your Current Content', description: 'are you happy with the current content on your website?(yes or no)', exp_ans_type: 'boolean_ans', is_published: false, is_mandatory: false, order: 6}])
group1.save

group2 = Group.new(name: "Your Industry & Competition")
group2.questions.build([{question: 'Competitors for Sample/Industry Content', description: 'provide at least three', exp_ans_type: 'paragraph', is_published: false, is_mandatory: false, order: 1 },
                        {question: 'Competitors Industry Content Likes/Dislikes ', description: 'for the above mentioned competitors, are there aspects you like or dislike about their content?', exp_ans_type: 'paragraph', is_published: false, is_mandatory: false, order: 2 },
                        {question: 'Other Resources', description: 'e.g. Industry websites / newsletters / forums, WebMD, Wikipedia pages, etc.', exp_ans_type: 'paragraph',is_published: false, is_mandatory: false, order: 3 }])
group2.save

group3 = Group.new(name: "Your Audience")
group3.questions.build([{question: 'Target Audience', description: 'who is reading your content – e.g. engineers, students, doctors, etc.', exp_ans_type: 'oneliner',  is_published: false, is_mandatory: false, order: 1 },
                        {question: 'Your Ideal Audience', description: 'if you have multiple audiences, are you trying to cater your content to one particular audience?', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 2},
                        {question: 'Addressing Your Audience', description: 'is there a particular way you prefer to address your audience – e.g. patients, members, clients, guests, etc.', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 3 },
                        {question: 'What’s Important for Your Target Audience', description: 'what resonates with your target audience – humor, industry insights, etc.', exp_ans_type: 'oneliner',  is_published: false, is_mandatory: false, order: 4 },
                        {question: 'Industry Lingo', description: 'are there industry-specific terms we should be aware of? If so, please list them to the best of your ability', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 5 }])
group3.save


group4 = Group.new(name: "Your Content")
group4.questions.build([{question: 'Primary Goal of Your Content', description: 'e.g. to educate, to sell, to entertain, etc.', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 1 },
                        {question: 'Tone of Writing', description: 'e.g. formal, technical, journalistic, whimsical, etc.', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 2 },
                        {question: 'Narrative', description: 'how should your content be written – first person, second person, neutral, etc.', exp_ans_type: 'oneliner',  is_published: false, is_mandatory: false, order: 3 },
                        {question: 'DON’Ts', description: 'any particular items we should avoid when writing content – e.g. imply it’s do it yourself, imply it’s suited for residential use, compare to competition, provide advice without a disclaimer, etc.', exp_ans_type: 'paragraph', is_published: false, is_mandatory: false, order: 4},
                        {question: 'DO’s', description: 'particular items we should emphasize when writing content – e.g. ease of use, benefits, low cost, etc.', exp_ans_type: 'paragraph',  is_published: false, is_mandatory: false, order: 5 },
                        {question: 'Other requests or considerations', description: '', exp_ans_type: 'paragraph', is_published: false, is_mandatory: false, order: 6 }])
group4.save

group5 = Group.new(name: "Your Blog")
group5.questions.build([{question: 'For ongoing copy writing  inspiration, please provide at least 10 blog topics/titles that you feel would be of interest to your target audience(s)', description: 'how should your content be written – first person, second person, neutral, etc.', exp_ans_type: 'paragraph', is_published: false, is_mandatory: false, order: 1 }])
group5.save

# question_bank = [{question: 'Brief Company Overview', description: '', exp_ans_type: 'oneliner', is_published: false, is_mandatory: true, order: 1 },
#                  {question: 'Website URL', description: '', exp_ans_type: 'oneliner', is_published: false, is_mandatory: true, order: 2 },
#                  {question: 'Tag Lines', description: 'if any', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 3 },
#                  {question: 'Desired Calls-to-Action', description: 'what action do you want people to take after reading your content/visiting your website - e.g. request a free consultation, request a quote, schedule an appointment, etc.', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 4 },
#                  {question: 'Use of Calls-to-Action', description: 'are you looking for a very direct, strong use of calls-to-action or do you prefer a more subtle approach – e.g. Buy Now! vs. Browse our selection', exp_ans_type: 'oneliner',  is_published: false, is_mandatory: false, order: 5 },
#                  {question: 'Your Current Content', description: 'are you happy with the current content on your website?(yes or no)', exp_ans_type: 'boolean_ans', is_published: false, is_mandatory: false, order: 6},
#                  {question: 'Competitors for Sample/Industry Content', description: 'provide at least three', exp_ans_type: 'paragraph', is_published: false, is_mandatory: false, order: 1 },
#                  {question: 'Competitors Industry Content Likes/Dislikes ', description: 'for the above mentioned competitors, are there aspects you like or dislike about their content?', exp_ans_type: 'paragraph', is_published: false, is_mandatory: false, order: 2 },
#                  {question: 'Other Resources', description: 'e.g. Industry websites / newsletters / forums, WebMD, Wikipedia pages, etc.', exp_ans_type: 'paragraph',is_published: false, is_mandatory: false, order: 3 },
#                  {question: 'Target Audience', description: 'who is reading your content – e.g. engineers, students, doctors, etc.', exp_ans_type: 'oneliner',  is_published: false, is_mandatory: false, order: 1 },
#                  {question: 'Your Ideal Audience', description: 'if you have multiple audiences, are you trying to cater your content to one particular audience?', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 2},
#                  {question: 'Addressing Your Audience', description: 'is there a particular way you prefer to address your audience – e.g. patients, members, clients, guests, etc.', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 3 },
#                  {question: 'What’s Important for Your Target Audience', description: 'what resonates with your target audience – humor, industry insights, etc.', exp_ans_type: 'oneliner',  is_published: false, is_mandatory: false, order: 4 },
#                  {question: 'Industry Lingo', description: 'are there industry-specific terms we should be aware of? If so, please list them to the best of your ability', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 5 },
#                  {question: 'Primary Goal of Your Content', description: 'e.g. to educate, to sell, to entertain, etc.', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 1 },
#                  {question: 'Tone of Writing', description: 'e.g. formal, technical, journalistic, whimsical, etc.', exp_ans_type: 'oneliner', is_published: false, is_mandatory: false, order: 2 },
#                  {question: 'Narrative', description: 'how should your content be written – first person, second person, neutral, etc.', exp_ans_type: 'oneliner',  is_published: false, is_mandatory: false, order: 3 },
#                  {question: 'DON’Ts', description: 'any particular items we should avoid when writing content – e.g. imply it’s do it yourself, imply it’s suited for residential use, compare to competition, provide advice without a disclaimer, etc.', exp_ans_type: 'paragraph', is_published: false, is_mandatory: false, order: 4},
#                  {question: 'DO’s', description: 'particular items we should emphasize when writing content – e.g. ease of use, benefits, low cost, etc.', exp_ans_type: 'paragraph',  is_published: false, is_mandatory: false, order: 5 },
#                  {question: 'Other requests or considerations', description: '', exp_ans_type: 'paragraph', is_published: false, is_mandatory: false, order: 6 },
#                  {question: 'For ongoing copy writing  inspiration, please provide at least 10 blog topics/titles that you feel would be of interest to your target audience(s)', description: 'how should your content be written – first person, second person, neutral, etc.', exp_ans_type: 'paragraph', is_published: false, is_mandatory: false, order: 1 }]

# question_bank.each do |ques|
#   Question.create(question: ques[:question],
#                   description: ques[:description],
#                   exp_ans_type: ques[:exp_ans_type],
#                   is_published: ques[:is_published],
#                   is_mandatory: ques[:is_mandatory],
#                   order: ques[:order])
# end

