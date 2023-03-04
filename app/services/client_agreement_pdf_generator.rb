# frozen_string_literal: true
require 'prawn'

class ClientAgreementPdfGenerator
  attr_reader :agreement

  def initialize(params)
    @agreement = params[:agreement]
  end

  def self.run(*args)
    new(*args).perform
  end

  def perform
    legal_name = agreement[:legal_name]
    signature = agreement[:signature]
    name = agreement[:name]
    title = agreement[:title]
    signed_date = Date.current.strftime('%B, %d %Y')
    pdf = Prawn::Document.new(page_size: 'EXECUTIVE')
    pdf.move_down 20
    pdf.font_size 8
    pdf.text("This Digital Services and Consulting Agreement (“Agreement”), is entered by and between #{legal_name} (hereinafter referred to as “Client”), and CLICKX, INC., 222 W. Merchandise Mart Plaza, Suite 1212, Chicago, IL 60654 (hereinafter referred to as “Clickx”).  Client and Clickx may be collectively referred to in this Agreement as the “Parties.”", inline_format: true, style: :bold)
    pdf.move_down 15
    pdf.formatted_text [
      { text: 'WHEREAS, ', styles: [:bold]},
      { text: 'Client requests that Clickx, as the digital marketing firm, perform website development, digital marketing services, and/or consulting services for its brand (“Project”).', size: 8 }
    ]
    pdf.move_down 15
    pdf.formatted_text [
      { text: 'WHEREAS, ', styles: [:bold]},
      { text: 'Client and Clickx desire to enter into an agreement, which will define respective rights and duties as to all services to be performed.', size: 8 }
    ]
    pdf.move_down 15
    pdf.formatted_text [
      { text: 'WHEREAS, ', styles: [:bold]},
      { text: 'Client and Clickx affirm that both understand all of the provisions contained in this Agreement, and in the case that either party requires clarification as to one or more of the provisions contained herein, it has requested clarification or otherwise sought legal guidance.', size: 8 }
    ]
    pdf.move_down 15
    pdf.formatted_text [
      { text: 'NOW, THEREFORE, ', styles: [:bold]},
      { text: 'in consideration of the covenants and agreements contained herein, the parties hereto agree as follows:' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'ARTICLE 1.  AGREEMENT DOCUMENTS', style: :bold
    pdf.move_down 15
    pdf.formatted_text [
      { text: '1.1 ', styles: [:bold], size: 8 },
      { text: 'This Agreement, and the correlating Proposal, as well as any accompanying appendices, addendums, attachments, duplicates, or copies, constitutes the entire agreement between the Parties with respect to the subject matter of this Agreement, and supersedes all prior negotiations, agreements, representations, and understandings of any kind, whether written or oral, between the Parties, preceding the date of this Agreement.', size: 8 }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 2.  CLIENT REPRESENTATIONS AND WARRANTIES.', style: :bold
    pdf.text 'For the duration of this Agreement as set forth in Article 6.1 below, Client makes the following representations and warranties.', size: 8
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '2.1 ', styles: [:bold] },
      { text: 'That it is fully authorized and empowered to enter into this Agreement, and that its performance of the obligations under this Agreement will not violate any agreement between Client and any other person, firm or organization or any law or governmental regulation.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '2.2 ', styles: [:bold] },
      { text: 'That it shall be solely responsible for providing Clickx with all necessary instructions and information concerning the Project.  Client’s knowledge and commercial information regarding the Project is vital and Clickx is not responsible for any shortcomings with respect to such information.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '2.3 ', styles: [:bold] },
      { text: 'That it owns, or has express permission to use, any element of text, graphics, photos, designs, trademarks, or other work it furnishes to Clickx for the Project.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '2.4 ', styles: [:bold] },
      { text: 'That any material submitted to publication by Clickx will not contain anything leading to an abusive or unethical use of Web Hosting services, the Host Server, or Clickx. Abusive and unethical materials and uses include but are not limited to pornography; obscenity; violations of privacy; computer viruses; harassment; illegal activity or advocacy thereof; spamming; or information which may be used by another party to harm another. ' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 3.  CLICKX DUTIES, REPRESENTATIONS AND WARRANTIES. ', style: :bold
    pdf.text 'For the duration of this Agreement, as set forth in Article 6.1 below, Clickx makes the following representations and warranties.', size: 8
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '3.1 ', styles: [:bold] },
      { text: 'That it is fully authorized and empowered to enter into this Agreement, and that its performance of the obligations under this Agreement will not violate any agreement between Client and any other person, firm or organization or any law or governmental regulation.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '3.2 ', styles: [:bold] },
      { text: 'Clickx may provide the following primary services to Client, as specifically set forth in the Proposal:' }
    ]
    pdf.indent 15, 0 do
      pdf.text 'a) Design and develop a responsive website to showcase Client’s business.', :align => :justify
      pdf.text 'b) Recommend SEO and Paid Search best practices to promote the site and generate additional sales leads.', :align => :justify
      pdf.text 'c) Create a digital marketing strategy includes organic owned, earned, and paid content management, content scheduling, follower interactions and engagements, and generate analytic reports.', align: :justify
      pdf.text 'd) Website updates as needed', align: :justify
      pdf.text 'e) Digital marketing consulting', align: :justify
    end
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '3.3 ', styles: [:bold] },
      { text: 'Clickx shall have the right to engage contractors and subcontractors on Client’s behalf and Client authorizes Clickx to do so.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 4.  DISCLAIMER OF WARRANTY.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '4.1 ', styles: [:bold] },
      { text: 'The warranties contained herein are the only warranties made by the Parties hereunder.  Each party makes no other warranty, whether express or implied, and expressly excludes and disclaims all other warranties and representations of any kind, including any warranties of non-infringement.  Clickx does not provide any warranty that operation of any services hereunder will be uninterrupted or error-free.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '4.2 ', styles: [:bold] },
      { text: 'CLICKX DOES NOT WARRANT THAT SERVICES WILL MEET CLIENT’S EXPECTATIONS OR REQUIREMENTS. CLIENT ASSUMES THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SERVICES HEREUNDER. EXCEPT AS OTHERWISE SPECIFIED IN THIS AGREEMENT, CLICKX PROVIDES ITS SERVICES “AS IS” AND WITHOUT WARRANTY OF ANY KIND. CLICKX DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, RELATING TO ANY CONTENT FROM CLIENT OR A THIRD PARTY, AND EACH PARTY’S COMPUTING AND DISTRIBUTION SYSTEM.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 5.  RELATIONSHIP OF PARTIES.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '5.1 ', styles: [:bold] },
      { text: 'Clickx is an independent contractor of Client. Nothing contained in this Agreement shall be construed to create the relationship of employer and employee, principal and agent, partnership or joint venture, or any other fiduciary relationship.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 6.  CONTRACT TERM AND SCOPE, DELIVERABLES, AND PROJECT CHANGES.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '6.1 ', styles: [:bold] },
      { text: 'The term of the Agreement is six (6) months from the Effective Date and shall automatically renew for successive six (6) month terms unless terminated in accordance with the terms herein. Alternatively, if the Proposal states as much, then this Agreement shall conclude with the completion of the Project.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '6.2 ', styles: [:bold] },
      { text: 'Clickx may provide the following Services and Deliverables to Client as set forth below and, in the Proposal, with the Proposal controlling: ' }
    ]
    pdf.indent 15, 0 do
      pdf.text 'a) Domain Registration: Clickx will secure a domain name for Client at Client’s request. Clickx will register domain name in Client’s name and it shall become Client’s property after final payment of the Project has been received by Clickx. If Client has an existing domain name, Clickx will coordinate redirecting the address to the new host. Negotiations for a domain name owned by another party shall be Client’s responsibility.', :align => :justify
      pdf.move_down 5
      pdf.text 'b) Scanning: Clickx agrees to scan up to twenty (20) images for Client. Additional charges to Client shall be assessed if additional scanning is requested.', :align => :justify
      pdf.move_down 10
      pdf.text 'c) Installation: Clickx will upload the completed site to Client’s hosting company, whether it is Clickx or a third party.', align: :justify
      pdf.move_down 10
      pdf.text 'd) Cross Browser Compatibility: Clickx will create a website viewable by both Firefox and Microsoft Internet Explorer. Compatibility is defined as all critical elements of each page of the website being viewable in both browsers. Client understands and agrees that some advanced techniques on the internet may require a more recent browser version and brand or plug-in. Client understands and agrees that new browsers are constantly being developed and the new browser versions may not be compatible to the website that Clickx has developed. Absent a Maintenance Agreement between the Parties, any time spent by Clickx to redesign a site for compatibility due to the introduction of a new browser version shall be separately negotiated and compensated. Said costs and fees are separate and not included in this Agreement.', align: :justify
      pdf.move_down 10
      pdf.text 'e) Website: the standard site is fifteen (15) pages or less and requires approximately ninety (90) days to complete. Additional pages will require additional time and cost, which shall be assessed to Client as set forth in the Proposal. Client must provide any text for use on Client’s site in a .doc or .txt format via disk or email attachment. There shall be additional charges to Client in the event Clickx has to typeset or create text. Photos and other miscellaneous graphics shall be supplied by Client. ', align: :justify
      pdf.move_down 10
      pdf.text 'f) Search Engine Optimization Research: keyword research & competitor analysis to identify appropriate keywords and phrases. The number of keywords will be specified in the Proposal. Additional keyword research will require an additional Work Order or Project Change Notice, at additional cost to Client, which will be incorporated into this Agreement and subject to the terms herein.', align: :justify
      pdf.move_down 10
      pdf.text 'g) Edit various HTML tags and page text as necessary prior to submission to selected Search Engines.', align: :justify
      pdf.move_down 10
      pdf.text 'h) Create, as needed, additional web pages for the purpose of “catching” keyword/phrase searches.', align: :justify
      pdf.move_down 10
      pdf.text 'i) Hand submit Client’s website to any of the following Search Engines: About, All the Web, Alta Vista, AOL, Excite, Google, Hot Bot, Looksmart, Lycos, BING, Netscape, and Yahoo.', align: :justify
      pdf.move_down 10
      pdf.text 'j) Create positioning reports for Client’s website and any associated pages showing rankings and under which keywords in the applicable Search Engines.', align: :justify
      pdf.move_down 10
      pdf.text 'k) Establish advertising of certain Client materials on websites owned and operated by Clickx for the purpose of delivering leads to Client and/or traffic to Client’s website. Advertising includes any of the following: sponsored listings, images, maps, videos, definitions and suggested search refinements found within search engines.', align: :justify
    end
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '6.3 ', styles: [:bold] },
      { text: 'Website hosting is not included in this Agreement unless specified in the Proposal. The Parties shall expressly agree upon hosting services. Client agrees to select a hosting service that allows Clickx full access to Client’s account via FTP and telnet. If the web host’s operating system is not a UNIX system, standard CGI software may not work and providing a substitute may cause Client to incur additional charges, which Client agrees to pay. At the request of Client, Clickx can assist Client in securing hosting. In the event Client desires Clickx to host Client’s website, Client shall be billed on a monthly basis at the rate specified in the Proposal. Fees and costs associated with hosting are separate and are not included in this Agreement.  Client shall be responsible for all billing associated with hosting.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '6.4 ', styles: [:bold] },
      { text: 'Domain registrations, SSL certificates, Merchant Accounts, and any other third-party setup costs and/or monthly fees are separate and are not included in this Agreement.  Client shall provide Clickx with a form of payment to authorize related charges. Renewal of such services shall be the sole responsibility of Client.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '6.5 ', styles: [:bold] },
      { text: 'Project management, communication and tracking will be handled primarily by email, text, phone.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '6.6 ', styles: [:bold] },
      { text: 'If the Parties require a change to this Agreement, Clickx shall submit a Project Change form to Client for review.  The Project Change form must include a description of the proposed change, the reason for such proposed change, and any and all additional fees to Client.  In order for the proposed change to take effect, the Parties must execute the Project Change form as an addendum to this Agreement.  If no such addendum is executed, Clickx shall not commence work outside the scope of this Agreement.  Client will be billed for additional fees in accordance with the terms herein or as set forth in the Project Change form.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 7.  CLIENT DUTIES, COST AND PAYMENTS.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.1 ', styles: [:bold] },
      { text: 'In consideration for the services to be performed by Clickx in connection with the Project, Client shall pay Clickx the total Project cost as set forth in the Proposal. The breakdown of the total Project costs is as set forth in the Proposal.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.2 ', styles: [:bold] },
      { text: 'Prior to the commencement of any work on the Project, and upon execution of this Agreement, Client shall pay Clickx an initial payment, as set forth in the Proposal. Upon completion of the Project, and before the release of the completed Project to Client, Client shall pay Clickx the balance of any and all amounts owed to Clickx by Client.  Clickx reserves the right to ask for an increase or additional retention deposit at its sole discretion, from time to time, on an as needed basis. If a Deposit is required by the Proposal, the Deposit is non-refundable as it is used to secure the time and resources of Clickx in order to deliver the Project to Client in a reasonable timeframe.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.3 ', styles: [:bold] },
      { text: 'Clickx will issue to Client a monthly invoice to reflect Client’s account. Payment by credit card is required if Client is on a monthly payment schedule. Clickx accepts VISA, MasterCard, Discover, and American Express. If Clickx permits, Client may pay invoices by ACH transfer or credit card. Monthly plans will be automatically charged to Client’s credit card at the start of each new billing cycle (each billing cycle is one calendar month). All other payment of invoices shall be paid within five (5) days of receipt of invoice.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.4 ', styles: [:bold] },
      { text: 'In the event that payment of any Project costs is not made within the terms set forth in this Agreement, Clickx shall have the right, at its option and without prejudicing any other right, to cease work on the Project and withhold or cause to withhold the release of any documents or work product prepared by Clickx for which Clickx was not paid.  Clickx may also delay or cancel the release of any deliverable created on behalf of Client for the Project for which Clickx has not been paid.  All payments received will be applied to the earliest outstanding amounts due.  Payments due and unpaid shall bear interest from and after the date payment is due at a rate of nine percent (9%) per annum. In any event, accounts more than ninety (90) days overdue will automatically be cancelled and ongoing services will be restricted until payment is received in full. In the event that Clickx initiates legal action to collect fees due it under this Agreement, Clickx shall be entitled to recover from Client its reasonable attorneys’ fees, costs and expenses incurred in any such action.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.5 ', styles: [:bold] },
      { text: 'Client agrees to reimburse Clickx for any and all expenses necessary for the completion of the Project, which are requested by Client or approved in writing by Client.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.6 ', styles: [:bold] },
      { text: 'If Client reasonably determines that a Deliverable fails in any material respect to meet the specifications and/or other acceptance criteria mutually agreed upon by the Parties, Client shall (a) promptly, after the delivery by Clickx of such Deliverable, notify Clickx in writing of such failure, and (b) specify in reasonable detail the nature and extent of such failure. Upon receipt of such notice, Clickx shall, in its discretion, make such adjustments, modifications, or revisions as are necessary to cause such Deliverable to so meet the specifications and/or other acceptance criteria mutually agreed upon by the Parties as set forth in the Proposal, and resubmit such Deliverable to Client for Client’s review. In any case, each Deliverable shall be deemed accepted by Client unless rejected in writing, in accordance with the above terms, within seven (7) calendar days of the delivery by Clickx of such Deliverable. Notwithstanding the rejection of any Deliverable by Client, use of any Deliverable shall be deemed to constitute acceptance thereof.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 8.  CONFIDENTIAL INFORMATION AND INTELLECTUAL PROPERTY.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '8.1 ', styles: [:bold] },
      { text: 'The Parties acknowledge that they will have access to information that is treated as confidential and proprietary by the other Party, including, without limitation, ideas and concepts arising during the Project (whether implemented or not), any trade secrets or other information whether of a technical, business, or other nature (including, without limitation, any information relating to the other Party’s technology, software, products, services, designs, methodologies, business plans, finances, marketing plans, customers, products, or other affairs), in each case whether spoken, written, printed, electronic or in any other form or medium (collectively, the "Confidential Information"). The Parties agree to treat all Confidential Information as strictly confidential, not to disclose Confidential Information or permit it to be disclosed, in whole or part, to any third party without the prior written consent of the other Party in each instance, and not to use any Confidential Information for any purpose except as required by this Agreement. Each Party shall notify the other Party immediately in the event it becomes aware of any loss or disclosure of any Confidential Information.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '8.2 ', styles: [:bold] },
      { text: 'All final deliverables developed by Clickx, or jointly with Client, pursuant to this Agreement, are assigned in all worldwide right, title, and interest to Client upon final delivery of same. This includes but may not be limited to Client’s website and content. Clickx shall retain ownership of content that it owned or developed prior to the Project. Specifically, this content includes, but is not limited to, database interfaces, market products, financial and economy information, Request for Proposal programs used on the server to process forms, applications, or any other item of stock content used by Clickx to develop or create Client’s website and/or content (“Prior Materials”). To the extent any final deliverables incorporate Prior Materials, Clickx retains ownership of said Prior Materials and hereby grants Client a perpetual, unlimited, non-exclusive license to reproduce, distribute, display, and otherwise use such Prior Materials to the extent and only as they are incorporated into the deliverables.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '8.3 ', styles: [:bold] },
      { text: 'Any materials developed by Client making use of the aforementioned content remains the sole property of Clickx subject to all applicable laws and/or statutes.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '8.4 ', styles: [:bold] },
      { text: 'Client expressly authorizes Clickx to use all of Client’s logos, trademarks, images, etc. for use in creating informational pages, and any other uses Clickx deems necessary.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '8.5 ', styles: [:bold] },
      { text: 'The Parties expressly permit the other Party to use their name and logo for promotional and marketing purposes.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 9.  LIABILITY.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '9.1 ', styles: [:bold] },
      { text: 'Any delays, cancellations or changes in pricing as a result of Client’s failure to make timely payment shall be the sole responsibility of Client. Further, Clickx shall not be liable for any delay or default in performing this Agreement if such delay or default is caused by conditions beyond its control (force majeure conditions).' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '9.2 ', styles: [:bold] },
      { text: 'Clickx makes no representations or warranties and does not guarantee any content provided by Client in furtherance of the Project.  Client is solely responsible for the accuracy and safeguarding of its content.  Clickx does not have control of, does not insure, and is not liable for the content provided by Client, and as such, is not liable for any improper use of content which Client is legally prohibited from using.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '9.3 ', styles: [:bold] },
      { text: 'No responsibility or liability is assumed by Clickx for delays due to the failure of service or the acts or omissions of outside service providers, such as third-party servers which host Client’s digital content. In the event Client or a third party make edits or modifications to Client’s website, Clickx shall not be liable for any result, consequence, or damage related to those edits or modifications.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '9.4 ', styles: [:bold] },
      { text: 'Events that might delay final delivery or individual milestone delivery of the Project, for which Clickx shall not be liable, include delays in receiving Client approvals, delays in receiving Client content and images, delays in receiving Client feedback and revision notes, delays in receiving partial payments to initiate the Project or individual completed phases, and/or delays in providing information or access to third party accounts.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '9.5 ', styles: [:bold] },
      { text: 'Natural Law Search Engine Optimization. Client understands and accepts that there are limitations relating to Natural Law SEO and agrees that Clickx shall not be liable for any limitations related thereto or resulting therefrom. Clickx has no control over the policies of Search Engines with respect to the type of sites and/or content that they accept currently or in the future. Client’s site may be excluded from any directory at any time at the sole discretion of the Search Engine. Due to the competitiveness of some keywords and phrases, ongoing changes in Search Engine ranking algorithms and other competitive factors, Clickx cannot guarantee top or any other position or consistent top ten (10) positions for any particular keyword, phrase or term. Client accepts that some Search Engines may take as long as two (2) to four (4) months, and in some cases longer, after submissions to list its website. Client understands and accepts that some Search Engines stop accepting submissions for an indefinite period of time or drop listings for no reason and with no advanced warning.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '9.6 ', styles: [:bold] },
      { text: 'NOTWITHSTANDING ANY OTHER PROVISION OF THIS AGREEMENT, IN NO EVENT WILL CLICKX OR ITS AFFILIATES BE LIABLE TO CLIENT OR ITS AFFILIATES FOR ANY SPECIAL, INDIRECT, INCIDENTAL, CONSEQUENTIAL, OR EXEMPLARY DAMAGES OF ANY NATURE ARISING OUT OF OR RELATING TO THIS AGREEMENT, INCLUDING BUT NOT LIMITED TO LOSS OF BUSINESS, LOSS OF PROFITS, LOSS OF REVENUE, OR REPUTATIONAL HARM, EVEN IF CLIENT WILL HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. THE FOREGOING WILL APPLY REGARDLESS OF WHETHER SUCH LIABILITY ARISES IN CONTRACT, NEGLIGENCE, TORT, STRICT LIABILITY, OR ANY OTHER THEORY OF LIABILITY. CLIENT AGREES THAT THE MAXIMUM AMOUNT OF DAMAGES IT IS ENTITLED TO IN ANY CLAIM ARE NOT TO EXCEED THE TOTAL AMOUNT PAID UNDER THIS AGREEMENT, OR THE AMOUNT PAID BY CLIENT IN THE SIX (6) MONTHS PRECEDING THE RELEVANT CLAIM BY CLIENT, WHICHEVER IS THE LESSOR OF THE TWO.' }
    ]

    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 10.  NON-SOLICITATION OF CLICKX EMPLOYEES.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '10.1 ', styles: [:bold] },
      { text: 'During the term of this Agreement as defined above in Section 6.1 and for a period of six (6) months commencing on the date by which this Agreement is terminated (the "Restricted Period"), Client shall not, and shall not permit any of its Affiliates to, directly or indirectly, hire or solicit any employee or contractor of Clickx or encourage any such employee or contractor to leave such employment or hire any such employee or contractor who has left such employment, except pursuant to a general solicitation which is not directed specifically to any such employees or contractors; provided, that nothing in this Section 10 shall prevent Client or any of its Affiliates from hiring (i) any employee whose employment has been terminated by Clickx; or (ii) after 180 days from the date of termination of employment, any employee whose employment has been terminated by the employee.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '10.2 ', styles: [:bold] },
      { text: 'Client acknowledges that a breach or threatened breach of this Section 10 would give rise to irreparable harm to Clickx, for which monetary damages would not be an adequate remedy, and hereby agrees that in the event of a breach or a threatened breach by Client of any such obligations, Clickx shall, in addition to any and all other rights and remedies that may be available to it in respect of such breach, be entitled to equitable relief, including a temporary restraining order, an injunction, specific performance and any other relief that may be available from a court of competent jurisdiction (without any requirement to post bond).' }
    ]

    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 11.  INDEMNIFICATION.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '11.1 ', styles: [:bold] },
      { text: 'Client (“Indemnifying Party”) agrees to indemnify, defend and hold harmless Clickx, its Affiliates and their respective officers, directors, employees, agents, representatives, successors, and assigns (“Indemnified Parties”), from and against any and all Third Party claims, damages, losses, suits, actions, demands, proceedings, expenses, and/or liabilities of any kind (including but not limited to reasonable attorneys’ fees incurred and/or those necessary to successfully establish the right to indemnification), threatened, asserted or filed (collectively, “Claims”), against Client, to the extent that such Claims arise out of or relate to: (a) Client’s breach or alleged breach of any warranty, representation or covenant made under this Agreement; (b) infringement or misappropriation or alleged infringement or misappropriation of an Intellectual Property Right of a Third Party by Client; (c) violation of Applicable Law by Client; and (d) Claims by government regulators or agencies for fines, penalties, sanctions, underpayments or other remedies to the extent such fines, penalties, sanctions, underpayments or other remedies relate to Client’s failure to perform its responsibilities under this Agreement.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '11.2 ', styles: [:bold] },
      { text: 'Clickx will have the right to approve the counsel selected by Client for defense of the Claims.  Clickx will provide Client reasonably prompt written notice of any such Claims and provide reasonable information and assistance, at Client’s expense, to help defend such Claims. Client will not have any right, without Clickx’s written consent, to settle any such claim if such settlement arises from or is part of any criminal action, suit or proceeding or contains a stipulation to or admission or acknowledgment of, any liability or wrongdoing (whether in contract, tort or otherwise) on the part of Clickx or its Affiliates or otherwise requires Clickx or its Affiliates to take or refrain from taking any material action.' }
    ]

    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 12.  DISPUTE RESOLUTION – ARBITRATION.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '12.1 ', styles: [:bold] },
      { text: 'Arbitration. As a material part of this Agreement, the Parties agree that any and all disputes, claims, or controversies arising out of or relating to this Agreement shall be determined by confidential, final, and binding arbitration in Chicago, Illinois, by one arbitrator in accordance with the then-existing rules for commercial arbitration of the American Arbitration Association. The demand for arbitration shall be made within a reasonable time after notice of the dispute, claim, or controversy has arisen, and in no event shall it be made after two (2) years from when the aggrieved party knew or should have known of the dispute, claim, or controversy. If the Parties are not able to agree upon the selection of an arbitrator, within twenty (20) days of the commencement of an arbitration proceeding by service of a demand for arbitration, the arbitrator shall be selected by the American Arbitration Association. The arbitrator shall have no authority to award punitive, consequential, special, or indirect damages. Each Party agrees to pay its own expenses associated with any arbitration, subject to Sections 7.4 and 11.1 of this Agreement. Any judgment on an award rendered may be entered in any state or federal court having jurisdiction. Except as may be required by law, neither party nor its representatives may disclose the existence, content, or results of any arbitration hereunder without the prior written consent of all Parties.' }
    ]

    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 13.  TERMINATION.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '13.1 ', styles: [:bold] },
      { text: 'Either party may terminate this Agreement for any reason upon seven (7) days written notice to the other party.  The termination of this Agreement shall be effective as of seven (7) days from the delivery of the notice.  In the event of termination, all design time and operating time related to the Project which is unpaid shall be billed and due at the rates and times set forth herein.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: 'Clickx may immediately terminate this Agreement in the event of a breach by Client, including, but not limited to, the inclusion or involvement of offensive materials on Client’s website. Offensive materials include but are not limited to spam; pornographic material; material which is illegal in the State of Illinois; racially, sexually, faith-based, or gender insensitive; politically or otherwise inflammatory; or that which Clickx determines in good faith is in poor taste. In the event that Clickx terminates this Agreement as a result of a breach by Client, Clickx reserves the right to not provide deliverables to Client.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '13.2 ', styles: [:bold] },
      { text: 'If the Project is cancelled or terminated by Client after services have been rendered, Client agrees to pay Clickx all costs incurred and amounts owing.  Clickx will bill Client for all unpaid design and operating time related to the Project up until the day work was stopped.  The entire Deposit will be forfeited to Clickx and realized as a cancellation fee. If Client terminates an automatically renewing monthly service, Client will be billed and shall be liable for a prorated amount for the month in which Client cancelled services.' }
    ]

    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 14.  MISCELLANEOUS.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '14.1 ', styles: [:bold] },
      { text: 'This Agreement shall take effect immediately upon execution by the Parties and shall remain fully enforceable and effective for the term of this Agreement or until terminated pursuant to Section 13 of this Agreement.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '14.2 ', styles: [:bold] },
      { text: 'This Agreement may be amended only by written agreement duly executed by an authorized representative of each party.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '14.3 ', styles: [:bold] },
      { text: 'If any provision or provisions of this Agreement shall be held unenforceable for any reason, then such provision shall be modified to reflect the parties’ intention. All remaining provisions of this Agreement shall remain fully enforceable and effective for the duration of this Agreement.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '14.4 ', styles: [:bold] },
      { text: 'This Agreement shall not be assigned by either party without the express written consent of the other party.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '14.5 ', styles: [:bold] },
      { text: 'The Parties agree that any provisions of this Agreement, that due to their nature, extend beyond termination of this Agreement, including but not limited to Articles 8, 10 and 11, shall survive any termination of this Agreement.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '14.6 ', styles: [:bold] },
      { text: 'This Agreement may be signed in multiple counterparts, each of which is considered an original and all of which together will constitute a whole. This Agreement may be executed by digital signature of the Parties.' }
    ]

    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 15.  GOVERNING LAW AND JURISDICTION.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '15.1 ', styles: [:bold] },
      { text: 'All matters arising out of or relating to this Agreement shall be governed by and construed in accordance with the internal laws of the State of Illinois without giving effect to any choice or conflict of law provision or rule (whether of the State of Illinois or any other jurisdiction).' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '15.2 ', styles: [:bold] },
      { text: 'Any legal suit, action, or proceeding arising out of or relating to this Agreement which may be brought shall be instituted in any United States federal court or state court located in the state of Illinois in the City of Chicago and County of Cook, and each Party irrevocably submits to the exclusive jurisdiction of such courts in any such suit, action, or proceeding. The Parties irrevocably and unconditionally waive any objection to the laying of venue of any suit, action, or proceeding in such courts and irrevocably waive and agree not to plead or claim in any such court that any such suit, action, or proceeding brought in any such court has been brought in an inconvenient forum.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text 'Article 16.  WAIVER OF RIGHTS.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '16.1 ', styles: [:bold] },
      { text: 'A failure or delay in exercising any right, power or privilege in respect of this Agreement will not be presumed to operate as a waiver, and a single or partial exercise of any right, power or privilege will not be presumed to preclude any subsequent or further exercise of that right, power or privilege or the exercise of any other right, power or privilege.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: 'IN WITNESS WHEREOF', styles: [:bold] },
      { text: ', the Parties, intending to be legally bound, have each executed this agreement as of the Effective Date.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.table(
      [
        ['Name', 'Name'],
        ["<b>Solomon Thimothy</b>", "<b>#{name}</b>"],
        ["Representative, <b>Clickxposure LLC</b>", "Representative, <b>#{legal_name}</b>"],
        ['Title', 'Title'],
        ["<b>CEO</b>", "<b>#{title}</b>"],
        ['Signature', 'Signature'],
        [{image: 'app/assets/images/solomon_signature.jpg', fit: [200, 70]}, {image: open(signature), fit: [200, 70]}],
        ['Date', 'Date'],
        ["<b>#{signed_date}</b>", "<b>#{signed_date}</b>"]
      ],
      cell_style: {border_width: 0, inline_format: true},
      width: pdf.bounds.width
    )
    pdf
  end
end
