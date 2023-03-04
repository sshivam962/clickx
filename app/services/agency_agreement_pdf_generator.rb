# frozen_string_literal: true
require "prawn"

class AgencyAgreementPdfGenerator
  attr_reader :agreement

  def initialize(params)
    @agreement = params[:agreement]
  end

  def self.run(*args)
    new(*args).perform
  end

  def perform
    day = Time.current.day.ordinalize
    month = Time.current.strftime('%B')
    legal_name = agreement[:legal_name]
    signature = agreement[:signature]
    name = agreement[:name]
    title = agreement[:title]
    signed_date = Date.current.strftime('%B, %d %Y')
    location = agreement[:location]
    pdf = Prawn::Document.new(page_size: 'EXECUTIVE')
    pdf.font_size 12
    pdf.text "CLICKX PARTNER PROGRAM AGREEMENT", style: :bold, align: :center
    pdf.move_down 20
    pdf.font_size 8
    pdf.text("This Partner Program Agreement (“Agreement”), made this <b>#{day}</b> day of <b>#{month}</b>, #{Date.current.year} between, Clickxposure LLC d/b/a Clickx, an Illinois limited liability company located at 3301 Bonita Beach Rd SW, Suite 100, Bonita Springs, FL 34134 (“Company”), and <b>#{legal_name}</b>(“Label”) located at <b>#{location}</b>. Company and Label may be collectively referred to as the 'Parties.'", inline_format: true)
    pdf.move_down 15
    pdf.text "WHEREAS, Company, as a digital marketing company, agrees to perform digital marketing services to Agency and Agency’s third-party clients (“Customer(s)”), on behalf of Agency and performed under Agency’s name and brand"
    pdf.move_down 15
    pdf.text "WHEREAS, Company, as a digital marketing company, agrees to perform digital marketing services to Agency and Agency’s third-party clients (“Customer(s)”), on behalf of Agency and performed under Agency’s name and brand"
    pdf.move_down 15
    pdf.text "WHEREAS Agency has purchased a Plan or multiple Plans from Company’s website and they Parties desire the terms set forth herein to govern their relationship"
    pdf.move_down 15
    pdf.text "NOW, THEREFORE, in consideration of the covenants and agreements contained herein, the Parties hereto agree as follows."
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 1.  AGREEMENT DOCUMENTS AND DEFINITIONS", style: :bold
    pdf.move_down 15
    pdf.formatted_text [
      { text: "1.1 ", styles: [:bold], size: 8 },
      { text: "This Agreement, and any accompanying appendices, addendums, attachments, Plans, duplicates, or copies, constitutes the entire Agreement between the Parties with respect to the subject matter of this Agreement, and supersedes all prior negotiations, agreements, representations, and understandings of any kind, whether written or oral, between the Parties, preceding the date of this Agreement.", size: 8 }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "1.2 ", styles: [:bold] },
      { text: "Definitions." }
    ]
    pdf.move_down 15
    pdf.text "“Customer” – any person(s) or entity(ies) engaging Agency to provide digital marketing services."
    pdf.move_down 15
    pdf.text "“Services” – means the products and/or work ordered by Agency or provided to Agency by Company, to be preformed for Customer on behalf of Agency."
    pdf.move_down 15
    pdf.text "“Plan” – refers to the service and product package(s) selected and purchased by Agency on the Clickx website."
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 2.  WHITE LABEL BRANDING", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "2.1 ", styles: [:bold] },
      { text: "All Services provided by Company to Customer on behalf of Agency shall be branded under Agency’s name and brand. Company’s name, trademarks, trade name, trade dress, designs, and logo shall not appear on the final product of any Services. Company does not grant any license, express or implied, to Agency for any Company names, logos, or any other intellectual property." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 3.  LABEL REPRESENTATIONS AND WARRANTIES", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.text "For the duration of this Agreement, Agency makes the following representations and warranties."
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "3.1 ", styles: [:bold] },
      { text: "That it is fully authorized and empowered to enter into this Agreement, and that its performance of the obligations under this Agreement will not violate any agreement between Agency and any other person, firm or organization or any law or governmental regulation." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "3.2 ", styles: [:bold] },
      { text: "That it has notified Customer of Agency’s right and intent to engage Company to perform services on its behalf to Customer." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "3.3 ", styles: [:bold] },
      { text: "That it shall be responsible for providing Company with all the necessary information concerning the Services." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "3.4 ", styles: [:bold] },
      { text: "That is has obtained and shall maintain for the duration of this Agreement liability insurance policies from financially sound and reputable insurance companies in such amounts, with such deductibles and covering such risks as are customarily carried by entities engaged in similar businesses. Agency shall add Company as an additional insured on all such policies and shall provide proof of insurance from time to time as demanded by Company." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 4.  COMPANY REPRESENTATIONS AND WARRANTIES.", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.text "For the duration of this Agreement, Company makes the following representations and warranties."
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "4.1 ", styles: [:bold] },
      { text: "That it is fully authorized and empowered to enter into this Agreement, and that its performance of the obligations under this Agreement will not violate any agreement between Company and any other person, firm or organization or any law or governmental regulation." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 5.  DISCLAIMER OF WARRANTY", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "5.1 ", styles: [:bold] },
      { text: "The warranties contained herein are the only warranties made by the Parties hereunder. Each Party makes no other warranty, whether express or implied, and expressly excludes and disclaims all other warranties and representations of any kind." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "5.2 ", styles: [:bold] },
      { text: "COMPANY DOES NOT WARRANT THAT SERVICES WILL MEET CUSTOMER’S EXPECTATIONS OR REQUIREMENTS. AGNECY AND CUSTOMER SOLELY ASSUME THE RISK AS TO QUALITY AND PERFORMANCE UNDER THIS AGREEMENT. EXCEPT AS OTHERWISE PROVIDED IN THIS AGREEMENT, COMPANY PROVIDES ITS SERVICES “AS IS” AND WITHOUT WARRANTY OF ANY KIND. COMPANY DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, RELATING TO THIS AGREEMENT, PERFORMANCE OR INABILITY TO PERFORM UNDER THIS AGREEMENT, THE CONTENT, AND EACH PARTY’S COMPUTING AND DISTRIBUTION SYSTEM." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 6.  RELATIONSHIP OF PARTIES", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "6.1 ", styles: [:bold] },
      { text: "Company is an independent contractor of Agency. Nothing contained in this Agreement shall be construed to create the relationship of employer and employee, principal and agent, partnership or joint venture, or any other fiduciary relationship." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 7.  TERM, SERVICES AND COST", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "7.1 ", styles: [:bold] },
      { text: "This Agreement shall commence on the date executed by the Parties (the “Effective Date”) for a term of one (1) month (the “Term”). This Agreement shall automatically renew for subsequent month for additional one-month terms unless terminated by the Parties." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "7.2 ", styles: [:bold] },
      { text: "Beginning on the Effective Date, and remaining in effect for the term of this Agreement, Company shall provide the services mutually agreed upon and described in the Plan purchased by Agency from the Clickx website, which is incorporated into this Agreement by this reference. All services to be provided by Company hereunder are referred to as “Services.” The Parties may use this Agreement for multiple Plans." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "7.3 ", styles: [:bold] },
      { text: "Some of Company’s expenses, including operation and equipment expenses, may be eligible for reimbursement by Agency, as set forth in the applicable Plan. The work performed by Company shall be performed at the rate(s) set forth in the applicable Plan." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 8. AGENCY DUTIES AND PAYMENT", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "8.1 ", styles: [:bold] },
      { text: "Prior to the commencement of any of the Services, and upon execution of this Agreement, Agency shall pay Company the sum total is set forth in the applicable Plan. This shall be the case for each Plan purchased by Agency, whether at once or if purchased at separate times. In the event the payment remitted by Agency does not ultimately pay for all of the Services performed by Company, Company reserves the right to ask for additional payment at its sole discretion, from time to time, on an as need basis." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "8.2 ", styles: [:bold] },
      { text: "Third Party Costs and Expenses. Domain registrations, SSL certificates, Merchant Accounts, website hosting, and any other third-party setup costs and/or monthly fees are separate and are not included in this Agreement. Agency is solely responsible for third-party costs." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "8.3 ", styles: [:bold] },
      { text: "Payment may be made by credit card or ACH payment to Clickx." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "8.4 ", styles: [:bold] },
      { text: "In the event that payment of any for any of the Services is not made within the terms set forth in this Agreement, Company shall have the right, at its option and without prejudicing any other right, to cease work on the Services and withhold or cause to withhold the release of any documents or work product prepared by Company for which Company was not paid. Company may also delay or cancel the release of any deliverable created on behalf of Customer in furtherance of the Services for which Company has not been paid. Payments due and unpaid shall bear interest from and after the date of payment is due at a rate of nine percent (9%) per annum or the maximum amount permitted under applicable law, whichever is greater. In the event that Company initiates legal action to collect fees due it under this Agreement, Company shall be entitled to recover from Agency its reasonable attorneys’ fees, costs, and expenses incurred in any such action." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "8.5 ", styles: [:bold] },
      { text: "Agency’s obligation to pay shall not be conditioned on Customer’s payment to Agency. In the event Customer fails or refuses to pay Agency for services related to this Agreement, Agency shall remain obligated to pay Company pursuant to the applicable Plan, and Company shall not be obligated to refund any payment remitted by Agency." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "8.6 ", styles: [:bold] },
      { text: "In no event shall Company be obligated to refund any or all of monies paid to it under this Agreement." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "8.7 Agency Referrals.", styles: [:bold] },
      { text: "In the event Agency refers a prospective client to Company for use of the Company’s services, and the prospective client enters into an agreement with Company such that it becomes a Agency client to Company (“Referred Client”), Agency will be entitled to a referral fee equal to five percent (5%) of the total fee paid by the Referred Client to Company during the first six (6) months of the relationship between Referred Client and Company (“Referral Fee”). The Referred Client must use Agency’s personal link, provided by Company in Agency’s portal, to sign up with Company in order for Agency to qualify for the Referral Fee. For the avoidance of doubt, parties already known to, being recruited by, or engaged in discussions with Company cannot be Referred Clients. Qualification for and payment of the Referral Fee shall have no bearing on Agency’s duty to pay fees under this Agreement. Agency is not entitled to any Referral Fee after Referred Client terminates its relationship with Company, even where Referred Client subsequently enters a new agreement with Company." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "8.8 Promotions and Offers.", styles: [:bold] },
      { text: "From time to time, at the sole discretion of Company, Company shall have the right, but not the obligation, to offer promotions affecting the pricing and offerings of goods and services of Company. Agency should regularly consult its Company portal for these promotions." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "8.9 Revenue Guarantee.", styles: [:bold] },
      { text: "Agency understands and agrees that it is bound by the terms and conditions set forth in the Revenue Guarantee incorporated herein, and that any noncompliance shall result in Agency’s ineligibility for the Company’s revenue guarantee." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "8.10 Chargebacks.", styles: [:bold] },
      { text: "In the event Agency initiates a credit card chargeback or other dispute for funds paid pursuant to this Agreement (a “Chargeback”), any such Chargeback shall constitute a breach of this Agreement and entitle Company to immediate relief, including, but not limited to, immediate cessation of work for and with Agency, termination of this Agreement, and an immediate right to receive from Agency all funds affected by any such Chargeback, including the cost of restoration of funds to Company’s account(s) and any and all attorneys’ fees and costs incurred in relation to any such Chargeback." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 9. CONFIDENTIAL INFORMATION AND INTELLECTUAL PROPERTY", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "9.1 ", styles: [:bold] },
      { text: "Agency acknowledges that it will have access to information that is treated as confidential and proprietary by Company including, without limitation, all ideas and design concepts arising during the Services (whether implemented or not), in each case whether spoken, written, printed, electronic or in any other form or medium (collectively, the “Confidential Information”). Agency agrees to treat all Confidential Information as strictly confidential, not to disclose Confidential Information or permit it to be disclosed, in whole or part, to any third party without the prior written consent of Company in each instance, and not to use any Confidential Information for any purpose except as required by this Agreement. Agency shall notify Company immediately in the event it becomes aware of any loss or disclosure of any Confidential Information." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "9.2 ", styles: [:bold] },
      { text: "Agency agrees that all content provided by Company to Agency, or to Customer on behalf of Agency in furtherance of the Services described hereunder, including, without limitation, copyrights, design rights, moral rights, and all other intellectual property rights recognized anywhere in the world in the work performed by Company, including work related to the Services rendered pursuant to this Agreement, (including specifications, designs, dashboards, wireframes, source code, object code, drawings, illustrations, texts, scores, photographs, prototypes, objects, models and mock-ups, whether stored or displayed physically or electronically and in whatever medium), is owned solely and legally by Company unless stated otherwise in writing by Company. Any final deliverable created by Company and delivered to Customer shall be owned by Customer upon delivery, but the underlying components shall remain owned by Company." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "9.3 Company Software.", styles: [:bold] },
      { text: "Company has developed its own software (“Clickx Software”) for use in furtherance of the Services. While Agency and/or Customer may have access to Clickx Software during the term of this Agreement, Company shall remain the sole owner of and retain all rights in Clickx Software. In no circumstance shall any act or inaction of Company be construed as transferring, relinquishing, or forfeiting its rights and ownership of the Clickx Software. For the term of this Agreement, and as permitted by Company, Agency may have a non-exclusive, worldwide, non-transferable, non-sublicensable license for the use of Clickx Software as needed in furtherance of this Agreement. Company reserves the right to revoke Agency and/or Customer’s access to Clickx Software at any time for any reason." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "9.4 Company Case Studies.", styles: [:bold] },
      { text: "Company may grant Agency access to and use of Company Case Studies during the Term of this Agreement. Agency acknowledges that all Company Case Studies are owned solely and legally by Company, and Agency’s access to and use of Company Case Studies is at the sole discretion of Company. Agency’s access to and use of Company Case Studies is conditioned upon Agency having an active account, in good standing, with Company. Upon expiration or Termination of this Agreement, Agency shall cease all access to and use of Company Case Studies for any reason, and upon request by Company, Agency shall certify removal of Company Case Studies from all Agency materials and destruction of all copies of same. In any event, Agency agrees that it will immediately remove any and all Company content, including, but not limited to, Company Case Studies, from Agency materials upon request by Company." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "9.5 ", styles: [:bold] },
      { text: "Agency shall comply with all federal, state, and local laws, rules, regulations and ordinances with respect to the performance of any of its obligations under this Agreement. Agency shall not: (a) modify, copy or create derivative works based on Services or any part thereof, (b) reverse engineer, disassemble, or decompile any of our Services or any part of Clickx Software to try and find our source code; (c) use or launch any automated system, including, “robots”, “crawlers”, “spiders”, or “offline readers”; (d) use the Services in any manner that damages, disables, overburdens, or impairs any of Company’s websites or interferes with any other party’s use of the Services; (e) attempt to gain unauthorized access to the Services; or (f) access the Services other than through Company’s interface. Any violation of this provision shall be deemed to be a material breach of this Agreement and, in such event, Company shall have the right, in addition to retaining all monies paid hereunder and pursuing all other remedies available at law or in equity, to refuse or terminate Customer’s access to services. The restrictions contained in this Section shall expressly survive the termination or expiration of this Agreement." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "9.6 ", styles: [:bold] },
      { text: "Agency shall request Customer’s authorization for Company’s use of Customer’s name and logo for use in marketing and promotional materials. Company agrees not to disclose to any non-affiliate third party any Customer personal or financial information without Customer’s written consent. Agency authorizes Company to use Agency’s name and logo in marketing and promotional materials." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "9.7 Video/Audio Recording.", styles: [:bold] },
      { text: "Agency acknowledges and agrees to Company’s audio and/or video recording of conversations between the Parties to this Agreement. In the event Company desires to sue any such recording or portion thereof for marketing, publication, or other commercial use, Company shall seek Agency’s express written consent. Agency shall not be entitled to any royalty or other such compensation as a result of Company’s use of any recording." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 10. LIABILITY", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "10.1 ", styles: [:bold] },
      { text: "Company shall not be liable for any delay or default in performing this Agreement if such delay or default is caused by conditions beyond its reasonable control (force majeure conditions). Any delays, cancellations, or changes in pricing as a result of Agency’s failure to make timely payment or timely correspondence and/or feedback shall be the sole responsibility of Agency." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "10.2 ", styles: [:bold] },
      { text: "Company makes no representations or warranties and does not guarantee any content provided by Customer or Agency in furtherance of the Services. Company shall have no responsibility for the accuracy and safeguarding of Customer’s content. Company does not have control of, does not insure, and is not liable for the content provided by Customer or Agency, and as such, shall not be liable for any improper use of content which Customer or Agency is legally prohibited from using." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "10.3 ", styles: [:bold] },
      { text: "Company shall not be liable for delays due to the failure of service or the acts or omissions of outside service providers, such as third-party servers which host Customer’s digital content. Company shall not be liable for the acts or omissions of any third party listed on Company’s website who Agency hires for the provision of digital marketing services. For the avoidance of doubt, any third party who performs services for Agency in connection with this Agreement is solely liable for its acts or omissions" }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "10.4 ", styles: [:bold] },
      { text: "Company shall have no obligation to retain Customer’s data after the expiration or termination of this Agreement. Company shall have no obligation to make data, Clickx Software, or any services available to Customer or Agency after the expiration or termination of this Agreement. As a courtesy to Agency, Company may agree, but is not obligated, to hold Customer data for a period of thirty (30) days after the expiration or termination of this Agreement. If Customer or Agency desires to export Customer’s data, they should do so within the thirty-day (30) period." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "10.5 ", styles: [:bold] },
      { text: "Events that might delay final delivery or individual aspects of delivery of the Services, for which Company shall not be liable, include delays in receiving Customer approvals, delays in receiving Customer content and images, delays in receiving Customer feedback and revision notes, delays in receiving payment from Agency, and/or delays in providing information or access to third party accounts." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "10.6 ", styles: [:bold] },
      { text: "Company works closely with its Affiliate, OneIMS, Inc., which is an Illinois corporation that provides resources such as personnel and equipment to Company which enables Company to provide the Services. Agency understands and agrees that in no event shall OneIMS, Inc., or its officers or directors, be liable for any claim arising out of or relating to this Agreement." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "10.7 ", styles: [:bold] },
      { text: "Company shall have the right to utilize subcontractors, third party vendors, and/or independent contractors in furtherance of this Agreement. Company shall not be liable for the acts or omissions of any such third parties." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "10.8 ", styles: [:bold] },
      { text: "NOTWITHSTANDING ANY OTHER PROVISION OF THIS AGREEMENT, IN NO EVENT WILL COMPANY OR ITS AFFILIATES BE LIABLE TO AGENCY OR ITS AFFILIATES FOR ANY SPECIAL, INDIRECT, INCIDENTAL, CONSEQUENTIAL OR EXEMPLARY DAMAGES OF ANY NATURE ARISING OUT OF OR RELATING TO THIS AGREEMENT, INCLUDING BUT NOT LIMITED LOSS OF BUSINESS, LOSS OF PROFITS, OR REPUTATIONAL HARM, EVEN IF AGENCY WILL HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. THE FOREGOING WILL APPLY REGARDLESS OF WHETHER SUCH LIABILITY ARISES IN CONTRACT, NEGLIGENCE, TORT, STRICT LIABILITY, OR ANY OTHER THEORY OF LIABILITY. AGENCY AGREES THAT THE MAXIMUM AMOUNT OF DAMAGES IT IS ENTITLED TO IN ANY CLAIM ARE NOT TO EXCEED THE TOTAL AMOUNT PAID BY AGENCY UNDER THIS AGREEMENT, OR THE AMOUNT PAID BY AGENCY IN THE THREE MONTHS PRECEDING RELEVANT CLAIM BY AGENCY, WHICHEVER IS THE LESSOR OF THE TWO." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "10.2 ", styles: [:bold] },
      { text: "" }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 11. AGREEMENT NOT TO SOLICIT", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "11.1 ", styles: [:bold] },
      { text: "During the Term of this Agreement as defined above in Section 7.1, and for a period of twelve (12) months commencing on the date by which this Agreement is terminated, Agency shall not, and shall not permit any of its Affiliates to, directly or indirectly, hire or solicit any employee or contractor of Company or OneIMS, Inc. or encourage any such employee or contractor to leave such employment" }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "11.2 ", styles: [:bold] },
      { text: "During the Term of this Agreement and for a period of twenty-four (24) months thereafter, Agency shall not, directly or indirectly, without prior written consent of Company, solicit or otherwise seek to obtain for Agency’s benefit (or assist any other person or entity in which Agency or its directors, officers, or employees has an interest or by which Agency is affiliated) any business from any person, firm, or other entity that is or was a client or customer of Company or OneIMS, Inc., which would be directly or indirectly competitive with the business of Company or any of its Affiliates or contact such client or customer for any purpose directly or indirectly relating to the services that Company or OneIMS, Inc. currently provides." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "11.3 ", styles: [:bold] },
      { text: "Agency acknowledges that a breach of threatened breach of this Section 11 would give rise to irreparable harm to Company, for which monetary damages would not be an adequate remedy, and hereby agrees that in the event of a breach or a threatened breach by Agency of any such obligations, Company shall, in addition to any and all other rights and remedies that may be available to it in respect of such breach, be entitled to equitable relief, including a temporary restraining order, an injunction, specific performance, and any other relief that may be available from a court of competent jurisdiction (without any requirement to post bond). If Company prevails in an action for a breach of this Section 11, Company shall be entitled to its reasonable attorneys’ fees, costs, and expenses incurred in any such action" }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 12. INDEMNIFICATION", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "12.1 ", styles: [:bold] },
      { text: "Agency (“Indemnifying Party”) agrees to indemnify, defend, and hold harmless Company, its Affiliates and their respective officers, directors, employees, agents, representatives, successors, and assigns (“Indemnified Parties”), from and against any and all Third Party claims, damages, losses, suits, actions, demands, proceedings, expenses, and/or liabilities of any kind (including but not limited to reasonable attorneys’ fees and costs incurred and/or those necessary to successfully establish the right to indemnification), threatened, asserted, or filed (collectively, “Claims”), against Company and/or its Affiliates, to the extent that such Claims arise out of or relate to: (a) Agency’s breach or alleged breach of any warranty, representation, or covenant made under this Agreement; (b) infringement or misappropriation or alleged infringement or misappropriation of an Intellectual Property Right of a Third Party by Agency or Customer; (c) violation of Applicable Law by Agency; and (d) Claims by government regulators or agencies for fines, penalties, sanctions, underpayments, or other remedies to the extent such fines, penalties, sanctions, underpayments, or other remedies relate to Agency’s failure to perform its responsibilities under this Agreement." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "12.2 ", styles: [:bold] },
      { text: "Company will have the right to approve the counsel selected by Agency for defense of the Claims. Company will provide Agency reasonably prompt notice of any such Claims and provide reasonable information and assistance, at Agency’s expense, to help defend such Claims. Agency will not have any right, without Company’s written consent, to settle any such Claim if such settlement arises from or is part of any criminal action, suit, or proceeding or contains a stipulation to or admission or acknowledgement of, any liability or wrongdoing (whether in contract, tort, or otherwise) on the part of Company or its Affiliates or otherwise requires Company or its Affiliates to take or refrain from taking any material action." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 13. DISPUTE RESOLUTION", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "13.1 ", styles: [:bold] },
      { text: "The Parties agree that any and all disputes, claims, or controversies arising out of or relating to this Agreement shall be determined by confidential, final, and binding arbitration in Chicago, Illinois, by one arbitrator in accordance with the then-existing rules for commercial arbitration of the American Arbitration Association. The demand for arbitration shall be made within a reasonable time after notice of the dispute, claim, or controversy has arisen, and in no event shall it be made after two (2) years from when the aggrieved party knew or should have known of the dispute, claim, or controversy. If the Parties are not able to agree upon the selection of an arbitrator, within twenty (20) days of the commencement of an arbitration proceeding by service of a demand for arbitration, the arbitrator shall be selected by the American Arbitration Association. The arbitrator shall have no authority to award punitive, consequential, special, or indirect damages. Each Party agrees to pay its own expenses associated with any arbitration, subject to Sections 8.4, 11.3, and 12.1 of this Agreement. Any judgment on an award rendered may be entered in any state or federal court having jurisdiction. Except as may be required by law, neither party nor its representatives may disclose the existence, content, or results of any arbitration hereunder without the prior written consent of all Parties." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 14. TERMINATION", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "14.1 ", styles: [:bold] },
      { text: "Agency may terminate this Agreement for any reason upon thirty (30) days written notice to Company, sent via electronic mail (email) to support@clickx.io . The termination of this Agreement shall be effective as of thirty (30) days from the delivery of the notice. Company may terminate this Agreement for any reason upon seven (7) days’ notice to Agency. If Company terminates this Agreement, the termination of this Agreement shall be effective as of seven (7) days from the delivery of notice to Agency. In the event that Company terminates this Agreement, Company reserves the right to not provide Services to Customer or Agency. Either Party may terminate this Agreement for cause, if after written notice of the breach to the breaching party the breaching party has failed to cure the breach within five (5) days. Termination for cause is effective immediately after the five-day notice period." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "14.2 ", styles: [:bold] },
      { text: "If the Agreement or any part thereof is cancelled or terminated by either Party after services have been rendered, Agency agrees to pay Company any amounts still owing. In the event Agency terminates this Agreement, during the thirty (30) day notice period, after proper notice has been served and before termination is effective, Company shall perform the Services under this Agreement and Agency shall pay all fees for each month up until the effective date of termination. In the event Agency or Customer declines services by Company during the thirty (30) day notice period, Agency shall remain obligated to pay all monthly fees up until the date of termination, and Company shall have no obligation to refund any monies paid by Agency. If the effective date of termination falls on any date after the first (1st) of a month, all fees for that month shall be due and paid by Agency to Company. Upon expiration or termination of this Agreement for any reason, Agency’s right to use or acquire Services shall cease and Company shall have no further obligation to make the Services available to Agency or Customer and all rights and licenses granted to Agency shall cease." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "14.3 ", styles: [:bold] },
      { text: "In the event Company proposes to sell its business operated pursuant to this Agreement, whether by sale of the assets thereof, or otherwise, either Party shall have the option to terminate this Agreement upon the consummation of such sale or at any time thereafter, upon written notice to Company or the buyer of Company’s business." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 15. GOVERNING LAW AND JURISDICTION", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "15.1 ", styles: [:bold] },
      { text: "All matters arising out of or relating to this Agreement shall be governed by and construed in accordance with the internal laws of the State of Illinois without giving effect to any choice or conflict of law provision or rule (whether of the State of Illinois or any other jurisdiction)." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "15.2 ", styles: [:bold] },
      { text: "The Parties hereto agree that all actions or proceedings arising out of or relating to this Agreement shall be arbitrated exclusively in the City of Chicago, County of Cook, in the State of Illinois. Each Party hereby waives any right it may have to assert the doctrine of forum non conveniens or similar doctrine or to object to venue with respect to any proceeding brought in accordance with this provision. Each Party hereby authorizes and accepts service of process sufficient for personal jurisdiction in any action against it as contemplated by this Section 15 by registered or certified mail, return receipt requested, to its known business address." }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "ARTICLE 16. MISCELLANEOUS", style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "16.1 ", styles: [:bold] },
      { text: "If any provision or provisions of this Agreement shall be held unenforceable for any reason, then such provision shall be modified to reflect the Parties’ intention. All remaining provisions of this Agreement shall remain fully enforceable and effective for the duration of this Agreement." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "16.2 ", styles: [:bold] },
      { text: "This Agreement shall not be assigned by Agency without the express written consent of Company." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "16.3 ", styles: [:bold] },
      { text: "The Parties agree that any provision of this Agreement that due to their nature extend beyond termination of this Agreement, including by not limited to Articles 9, 11, and 12, shall survive any termination of this Agreement." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "16.4 ", styles: [:bold] },
      { text: "This Agreement may be executed in counterparts, each of which shall be deemed to be an original, but all of which, taken together, shall constitute one and the same agreement. This Agreement may be executed by digital signature." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "16.5 ", styles: [:bold] },
      { text: "A failure or delay in exercising any right, power, or privilege in respect of this Agreement will not be presumed to operate as a waiver, and a single or partial exercise of any right, power, or privilege will not be presumed to preclude any subsequent or further exercise of that right, power, or privilege or the exercise of any other right, power, or privilege." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "IN WITNESS WHEREOF", styles: [:bold] },
      { text: ", the Parties, intending to be legally bound, have each executed this agreement as of the Effective Date." }
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


    pdf.start_new_page
    pdf.font_size 12
    pdf.text "Exhibit A: $10K In Revenue Guarantee", style: :bold, align: :center
    pdf.move_down 20
    pdf.font_size 8
    pdf.text("Our money back guarantee is a credit program: we guarantee that if you follow our process you will earn $10,000 in revenue or we will give you a full credit for your advance payment which can be used to purchase any of our subscription options then-available.  In order to qualify for our money back guarantee, you must provide proof of strict compliance with our process as outlined in our academy. You are ineligible for the money back guarantee if you fail to pay for the program in advance. If we make special payment arrangements with you, including but not limited to, partial payments, a payment plan, or even financing, you are ineligible for the money back.", inline_format: true)

    pdf.move_down 15
    pdf.font_size 8
    pdf.text "PART 1: Fill in the knowledge gap.", style: :bold
    pdf.move_down 15
    pdf.text "We require you to consume 95% of the specified course content and submit your exercises to a coach."

    pdf.move_down 15
    pdf.font_size 8
    pdf.text "PART 2: Work On The Business", style: :bold
    pdf.move_down 15
    pdf.text "We require a minimum of 2 hours of time invested each day in order to get your business new customers and generate revenue. Depending on your speed and technical abilities, you may require additional time.  Each week (a “documented week”), you are required to submit a timesheet which sets forth an itemization of the time you invested each day of the prior week and the activities you worked on during that time. Each timesheet must be submitted no later than Wednesday of the week after the documented week (i.e., five calendar days after the documented week ends). If you fail to timely submit detailed timesheets, or fail to meet the 2-hour minimum daily time-spend requirement, you will be ineligible for the money back guarantee."

    pdf.move_down 15
    pdf.font_size 8
    pdf.text "PART 3: Live Coaching Calls", style: :bold
    pdf.move_down 15
    pdf.text "We require you attend a minimum of 2 coaching calls per week. We offer coaching calls on Lead Generation and Sales. Our coaches dedicate their time in training, answering questions, and getting you any help LIVE during the call. If you cannot attend a call, you must provide 24-hour notice in advance of the call. You are permitted to miss a total of 2 of the scheduled calls in the 90-day timeframe.  Failure to give proper notice of your intended absence, or absence from more than 2 calls will make you ineligible for the money back guarantee."

    pdf.move_down 15
    pdf.font_size 8
    pdf.text "PART 4: Lead Generation Activities:", style: :bold
    pdf.move_down 15
    pdf.text "In order to generate 3 sales meetings a day, you must reach out to leads provided by Clickx as well as personally researched leads.  Our research and experience tells us that if you want 1 booked meeting per day, you must reach out to 100 businesses via Call, Text, Facebook Page, and submit a form on their website. In order to get to 2 booked meetings per day, you have to reach out to 200 businesses."
    pdf.move_down 15
    pdf.text "Use this methodology to increase the number of booked appointments. While outbound prospecting is not difficult, it is time-consuming. Typical appointment setters make 300 outbound dials per day.   The higher the number of calls per day, the higher the likelihood of you getting a sale. You may wish to hire a virtual assistant to do this on your behalf. You must submit a detailed activity log showing all outbound prospecting activities to confirm compliance with our process."
    pdf.move_down 15
    pdf.text "You may alternatively run YouTube Ads or Facebook Ads to increase the awareness of your agency. Ads budget is not included in any of our programs you are responsible for the ad spend yourself. In addition to verified email addresses that Clickx provides, we also include a Business Facebook profile for many of the businesses. To be eligible for the money back guarantee, you must reach out to a minimum of 100 Facebook business pages per day."

    pdf.move_down 15
    pdf.font_size 8
    pdf.text "PART 5: KPI Sheet", style: :bold
    pdf.move_down 15
    pdf.text "We will provide a KPI sheet which lists a set of specific activities. This Google doc created for you must be the form you turn in with your tracked activities. You are strictly prohibited from creating duplicates or copies. You must fill out the form contemporaneously with each day’s activities in order to ensure compliance. Failure to complete the form each day as required will make you ineligible for the money back guarantee."

    pdf.move_down 15
    pdf.font_size 8
    pdf.text "PART 6: Organic Social/Inbound Marketing", style: :bold
    pdf.move_down 15
    pdf.text "In order to generate a brand for your agency, we require you to create one piece of content that is image, text, or video on one of your profiles of choice. This could be on Facebook, YouTube, TikTok, etc. You must paste the link to your post in our Slack Engagement Group so that others may like, comment, and give you additional exposure for your agency. Ensure that you create one piece of content per day, ensure you post on the slack channel daily Monday through Friday on a consistent basis."

    pdf.move_down 15
    pdf.font_size 8
    pdf.text "PART 7: Chat Support", style: :bold
    pdf.move_down 15
    pdf.text "We provide a Slack channel with other Partners who are in the program on which you have the ability to ask us questions. We may have our coaches answer you, or other Partners will answer. If you do not engage in the slack channel, we will assume that you have no questions which means you are well on your way to booking 2 or 3 meetings per day!"

    pdf.move_down 15
    pdf.font_size 8
    pdf.text "No Extension of Time", style: :bold
    pdf.move_down 15
    pdf.text "The program is a strict 90-day timeline, and the 90-days must be contiguous 90-days without any pauses, extensions or modifications for any reason. The money back guarantee will be applied in the form of credit you can use towards our software subscription. You will be able to apply the credit to any of the agency subscriptions available.  If you wish to continue partnering with us, and for some reason are unable to complete the 90-day program without interruption, you will need to purchase one of our agency subscription plans."

    pdf.number_pages "Page <page> of <total>", { :start_count_at => 1, :page_filter => :all, :at => [pdf.bounds.right - 50, 0], :align => :right, :size => 8 }
    pdf
  end
end
