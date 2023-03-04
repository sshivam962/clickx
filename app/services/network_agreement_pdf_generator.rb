# frozen_string_literal: true
require 'prawn'

class NetworkAgreementPdfGenerator
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
    pdf.font_size 12
    pdf.text "INDEPENDENT CONTRACTOR AGREEMENT", style: :bold, align: :center
    pdf.move_down 20
    pdf.font_size 8
    pdf.text("This Independent Contractor Agreement (“Agreement”) is entered by and between #{legal_name} (hereinafter referred to as the “Contractor”), and Clickxposure, LLC. an Illinois company (hereinafter referred to as the “Company”). Company and Contractor may be collectively referred to in this Agreement as the “Parties.”", inline_format: true, style: :bold)
    pdf.move_down 15
    pdf.formatted_text [
      { text: 'WHEREAS, ', styles: [:bold]},
      { text: 'Contractor requests that Company list Contractor as an available vendor for services to Company’s customers (“Company Customers”) on Company’s website; and', size: 8 }
    ]
    pdf.move_down 15
    pdf.formatted_text [
      { text: 'WHEREAS, ', styles: [:bold]},
      { text: 'Company and Contractor desire to enter into an agreement, which will define respective rights and duties as to all services to be performed,', size: 8 }
    ]
    pdf.move_down 15
    pdf.formatted_text [
      { text: 'WHEREAS, ', styles: [:bold]},
      { text: 'Contractor and Company affirm that both understand all of the provisions contained in this Agreement, and in the case that either party requires clarification as to one or more of the provisions contained herein, it has requested clarification or otherwise sought legal guidance,', size: 8 }
    ]
    pdf.move_down 15
    pdf.formatted_text [
      { text: 'NOW, THEREFORE, ', styles: [:bold]},
      { text: 'in consideration of the covenants and agreements contained herein, the parties hereto agree as follows:' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '1.  Services.', style: :bold
    pdf.move_down 15
    pdf.formatted_text [
      { text: 'Beginning on the Effective Date and remaining in effect for the term of this Agreement, Contractor shall provide Company with the following services listed in Appendix A, without limitation.', size: 8 }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '2.  Contractor Representations and Warranties.', style: :bold
    pdf.text 'Beginning on the Effective Date and remaining in effect for the term of this Agreement, Contractor makes the following representations and warranties.', size: 8
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '2.1 ', styles: [:bold] },
      { text: 'That Contractor is fully authorized and empowered to enter into this Agreement, and that Contractor’s performance of the obligations under this Agreement will not violate any agreement between Contractor and any other person, firm or organization or any law or governmental regulation.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '2.2 ', styles: [:bold] },
      { text: 'That Contractor will notify Company of any change(s) to Contractor’s schedule that could adversely affect the availability of Contractor, whether known or unknown at the time of this Agreement, no later than six (6) weeks prior to such change(s). If Contractor becomes aware of such change(s) within the six (6) week period, Contractor shall promptly notify Company of such change(s) within a reasonable amount of time. If Contractor is not in compliance with the Section 2.2, Company may in its sole discretion terminate this Agreement without any further obligation to Contractor.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '2.3 ', styles: [:bold] },
      { text: 'That Contractor will bear all expenses incurred in the performance of this Agreement, including but not limited to operation expenses, mail and phone communication expenses, travel expenses, and equipment expenses. Modifications to this provision may be made by the parties by mutual agreement in writing.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '3.  Company Representations and Warranties.', style: :bold
    pdf.text 'Beginning on the Effective Date and remaining in effect for the term of this Agreement, Company makes the following representations and warranties.', size: 8
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '3.1 ', styles: [:bold] },
      { text: 'That Company is fully authorized and empowered to enter into this Agreement, and that its performance of the obligations under this Agreement will not violate any agreement between Contractor and any other person, firm or organization or any law or governmental regulation.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '3.2 ', styles: [:bold] },
      { text: 'That Company is in full compliance with any and all laws and/or statutes applicable to the services described hereunder.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '4.  Compensation.', style: :bold
    pdf.text 'The work performed by Contractor shall be performed at the rate set forth in Appendix A.', size: 8
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '5.  Independent Contractor Status.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '5.1 ', styles: [:bold] },
      { text: 'Contractor is an independent contractor of Company. Nothing contained in this Agreement shall be construed to create the relationship of employer and employee, principal and agent, partnership or joint venture, or any other fiduciary relationship.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '5.2 ', styles: [:bold] },
      { text: 'Contractor shall have no authority to act as agent for, or on behalf of Company, or to represent Company, or bind Company in any manner without written consent from Company.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '5.3 ', styles: [:bold] },
      { text: 'Contractor shall not be entitled to worker"s compensation, retirement, insurance or other benefits afforded to employees of Company.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '6.  Agreement Not to Solicit.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '6.1 Non-solicitation of Clients.', styles: [:bold] },
      { text: 'During the term of this Agreement and for a period of twelve (12) months thereafter (the “Non-solicitation Term”) if this Agreement is terminated for any reason, with or without cause, Contractor shall not, directly or indirectly, solicit or otherwise seek to obtain for Contractor’s benefit (or assist any other person or entity in which Contractor or any member of his or her family has an interest or by which Contractor is affiliated) any business from any person, firm, or other entity that is or was, on the Termination Date, a client or customer of Company, which would be directly or indirectly competitive with the business of Company or any of its affiliates or contact such client or customer for any purpose directly or indirectly relating to the service that Company currently provides. Services which were specifically listed as available services under Contractor’s listing on Company’s website are expressly excluded from this provision.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '6.2 Non-solicitation of Employees or Contractors of Company.', styles: [:bold] },
      { text: 'During the Non-solicitation Term, Contractor shall not solicit or attempt to induce any employee or independent contractor of Company to terminate his or her employment or relationship with Company or otherwise interfere with the employment or relationship between Company and its other employees or contractors by soliciting any of such individuals to participate in independent business ventures.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '7.  Confidential Information and Non-Disclosure Agreement.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.1 ', styles: [:bold] },
      { text: 'Contractor and its employees shall not, during the time of rendering services to Company or thereafter, disclose to anyone other than authorized employees of Company (or persons designated by such duly authorized employees of Company) or use for the benefit of Contractor and its employees or for any entity other than Company, any information of a confidential nature, including but not limited to, information relating to: any and all non-public or proprietary information with respect to business plans, marketing plans, operations, assets, properties, financial condition, financial information, information pertaining to customers and vendors, customer lists, business records, projections, product information, business designs, business processes, technical processes, website designs, website processes, prototypes, programs, source codes, object codes, algorithms and related documentation, dashboards, wireframes, software designs, patent applications, scripts, writings, storyboards, film and television pitches, and any other information which gives the Company an advantage over its competition, together with all reports, summaries, studies, checklists, compilations and other documentation, and any other information not publicly available and disclosed by the Company to Party (hereinafter, the “Confidential Information”).' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.2 ', styles: [:bold] },
      { text: 'Nothing contained in this Agreement shall be deemed or construed to grant or confer any rights by license or otherwise to Contractor for the use of the Confidential information outside of the scope of performing Contractor’s services described in Appendix A to this Agreement.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.3 ', styles: [:bold] },
      { text: 'Upon the expiration or termination of this Agreement, Contractor shall return to the Company all Confidential Information, and any derivations thereof, then in its possession or in the possession of any of its representatives without retaining any copy thereof, and will promptly destroy all copies of any analyses, compilations, studies or other documents, records or data prepared by it or any of its representatives, which contain or otherwise reflect or are generated from the Confidential Information, and a duly authorized individual will certify in writing, under the penalty of perjury, to the Company that such destruction has been accomplished.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.4 ', styles: [:bold] },
      { text: 'In the event that Contractor or any of its respective representatives is requested or required (by deposition, interrogatory, request for documents, subpoena, civil investigative demand or similar legal, judicial or regulatory process or as otherwise required by applicable law or regulation) to disclose any of the Confidential Information, Contractor shall (a) provide Company with prompt prior written notice of such request or requirement, and (b) cooperate with Company so that Company may seek a protective order or other appropriate remedy. In the event that such protective order or other remedy is not obtained, or Company waives compliance with the terms and provisions of Section 7 to this Agreement, Contractor and its representatives may disclose only that portion of the Confidential Information that the receiving party is advised by legal counsel in writing is legally required to be disclosed.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '7.5 ', styles: [:bold] },
      { text: 'Contractor acknowledges and agrees that any breach of this Section will cause injury to Company for which money damages would be an inadequate remedy and that, in addition to remedies at law, Company is entitled to equitable relief as a remedy for any such breach, including, without limitation, injunctive relief (including, without limitation, the right to obtain a temporary or permanent injunction) and specific performance (without being required to obtain a bond or post other security or prove actual damages). All the rights and remedies of Company hereunder shall be cumulative. Contractor shall be liable to Company for all reasonable attorneys’ fees and costs should Company prevail in any legal action initiated by Company pursuant to Section 7 of this Agreement.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '8.  Intellectual Property.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '8.1 ', styles: [:bold] },
      { text: 'Company represents that all content provided by Company to Contractor, in furtherance of Contractor’s services described hereunder, including, without limitation, images, videos and text, including any intellectual property, such as copyrights, assumed names or trademarks (the “Company Content”), is owned solely and legally by Company' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '8.2 ', styles: [:bold] },
      { text: 'Company grants Contractor a non-exclusive, transferable sub-licensable, royalty-free, worldwide license to use Company Content, which is created by Contractor in connection with Contractor’s services described hereunder, in Contractor’s portfolio provided Contractor credit Company. This license may be freely revoked by Company at any time for any reason.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '8.3 ', styles: [:bold] },
      { text: 'Any materials developed by Company, making use of Content, remains the sole property of Company subject to all applicable laws and/or statutes' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '8.4 ', styles: [:bold] },
      { text: 'During the course of performing under this Agreement, Contractor and its directors, officers, employees, or other representatives may, independently or in conjunction with Company, develop information, produce work product, or achieve other results for Company in connection with the services it performs for Company under this Agreement. Contractor agrees that any such information, work product, and other results, systems and information developed by Contractor and/or Company in connection with such services (hereinafter referred to collectively as the "Work Product") shall, to the extent permitted by law, be a "work made for hire" within the definition of Section 101 of the Copyright Act (17 U.S.C. § 101) and shall remain the sole and exclusive property of Company.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '9.  Liability.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '9.1 ', styles: [:bold] },
      { text: 'Company shall not be responsible for any costs incurred by Contractor, including, without limitation, any and all fees and expenses, such as those described in Section 2.3 above. Modifications to this provision may be made by the parties by mutual agreement in writing.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '9.2 ', styles: [:bold] },
      { text: 'Company shall not be liable for the services or deliverables performed by Contractor as a result of being listed on Company’s website. This is the case regardless of whether Company performs services for any such customer. For the avoidance of doubt, Contractor shall be solely liable for its performance (or nonperformance) of services and delivery of deliverables.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '9.3 ', styles: [:bold] },
      { text: 'NOTWITHSTANDING ANY OTHER PROVISION OF THIS AGREEMENT, IN NO EVENT WILL COMPANY OR ITS AFFILIATES BE LIABLE TO CONTRACTOR OR ITS AFFILIATES FOR ANY SPECIAL, INDIRECT, INCIDENTAL, CONSEQUENTIAL OR EXEMPLARY DAMAGES OF ANY NATURE ARISING OUT OF OR RELATED TO THIS AGREEMENT, EVEN IF CONTRACTOR WILL HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. THE FOREGOING WILL APPLY REGARDLESS OF THE NEGLIGENCE OR OTHER FAILURE OF COMPANY AND REGARDLESS OF WHETHER SUCH LIABILITY ARISES IN CONTRACT, NEGLIGENCE, TORT, STRICT LIABILITY OR ANY OTHER THEORY OF LIABILITY. NOTWITHSTANDING ANYTHING TO THE CONTRARY IN THIS AGREEMENT OR OTHERWISE, IN NO EVENT WILL COMPANY BE LIABLE TO CONTRACTOR FOR ANY IMPAIRMENT OR LOSS OF GOODWILL. SUCH EXCLUDED DAMAGES INCLUDE, WITHOUT LIMITATION, LOSS OF DATA, LOSS OF OPPORTUNITY, LOSS OF PROFITS, AND/OR LOSS OF SAVINGS OR REVENUE.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '10.  Disclaimer of Warranty.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '10.1 ', styles: [:bold] },
      { text: 'THE WARRANTIES CONTAINED HEREIN ARE THE ONLY WARRANTIES MADE BY THE PARTIES HEREUNDER. EACH PARTY MAKES NO OTHER WARRANTY, WHETHER EXPRESS OR IMPLIED, AND EXPRESSLY EXCLUDES AND DISCLAIMS ALL OTHER WARRANTIES AND REPRESENTATIONS OF ANY KIND, INCLUDING ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT. COMPANY DOES NOT PROVIDE ANY WARRANTY THAT OPERATION OF ANY SERVICES HEREUNDER WILL BE UNINTERRUPTED OR ERROR-FREE.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '11.  Indemnification.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '11.1 ', styles: [:bold] },
      { text: 'Contractor (“Indemnifying Party”) agrees to indemnify, defend and hold harmless Company, its Affiliates and their respective officers, directors, employees, agents, representatives, successors, and assigns (“Indemnified Parties”), from and against any and all Third Party claims, damages, losses, suits, actions, demands, proceedings, expenses, and/or liabilities of any kind (including but not limited to reasonable attorneys’ fees incurred and/or those necessary to successfully establish the right to indemnification) threatened, asserted or filed (collectively, “Claims”), against Company, to the extent that such Claims arise out of or relate to: (a) Contractor’s breach or alleged breach of any warranty, representation, or covenant made under this Agreement; (b) infringement or misappropriation or alleged infringement or misappropriation of an Intellectual Property Right of a Third Party by the Contractor’s services or deliverables; (c) violation of Applicable Law by Contractor; and (d) Claims by government regulators or agencies for fines, penalties, sanctions, underpayments or other remedies to the extent such fines, penalties, sanctions, underpayments or other remedies relate to Contractor’s failure to perform its responsibilities under this Agreement.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '11.2 ', styles: [:bold] },
      { text: 'Company will have the right to approve the counsel selected by Contractor for defense of the Claims. Company will provide Contractor reasonably prompt written notice of any such Claims and provide reasonable information and assistance, at Contractor’s expense, to help defend such Claims. Contractor will not have any right, without Company’s written consent, to settle any such claim if such settlement arises from or is part of any criminal action, suit or proceeding or contains a stipulation to or admission or acknowledgment of, any liability or wrongdoing (whether in contract, tort or otherwise) on the part of Company or its Affiliates or otherwise requires Company or its Affiliates to take or refrain from taking any material action (such as the payment of fees).' }
    ]

    pdf.move_down 15
    pdf.font_size 12
    pdf.text '12.  Miscellaneous.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '12.1 ', styles: [:bold] },
      { text: 'This Agreement shall take effect immediately and shall remain fully enforceable and effective until terminated pursuant to the terms of this Agreement.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '12.2 ', styles: [:bold] },
      { text: 'Contractor may terminate this Agreement for any reason upon ninety (90) days’ written notice to Company. Company may terminate this Agreement for any reason upon written notice to Contractor. Either party may terminate this Agreement for cause immediately upon written notice to the breaching party.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '12.3 ', styles: [:bold] },
      { text: 'In the event Company proposes to sell its business operated pursuant to this Agreement, whether by sale of the assets thereof, or otherwise, Contractor shall have the option in its sole discretion to terminate this Agreement upon the consummation of such sale or at any time thereafter, upon written notice to Company or the buyer of Company’s business.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '12.4 ', styles: [:bold] },
      { text: 'This Agreement, and any accompanying appendices, duplicates, or copies, constitutes the entire agreement between the Parties with respect to the subject matter of this Agreement, and supersedes all prior negotiations, agreements, representations, and understandings of any kind, whether written or oral, between the Parties, preceding the date of this Agreement.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '12.5 ', styles: [:bold] },
      { text: 'This Agreement may be amended only by written agreement duly executed by an authorized representative of each party.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '12.6 ', styles: [:bold] },
      { text: 'If any provision or provisions of this Agreement shall be held unenforceable for any reason, then such provision shall be modified to reflect the parties’ intention. All remaining provisions of this Agreement shall remain fully enforceable and effective for the duration of this Agreement.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '12.7 ', styles: [:bold] },
      { text: 'This Agreement shall not be assigned by Contractor without Company’s express written consent.' }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '12.8 ', styles: [:bold] },
      { text: 'Contractor shall be liable to Company for all reasonable attorneys’ fees and costs should Company prevail in any legal action initiated by Company arising out of or relating to this Agreement.' }
    ]

    pdf.move_down 15
    pdf.font_size 12
    pdf.text '13.  Governing Law and Jurisdiction.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '13.1 ', styles: [:bold] },
      { text: 'This Agreement shall be governed by and construed in accordance with the laws of the State of Illinois without reference to any principles of conflicts of laws, which might cause the application of the laws of another state. Any action instituted by either party arising out of this Agreement shall only be brought, tried and resolved in the applicable federal or state courts having jurisdiction in the State of Illinois. EACH PARTY HEREBY CONSENTS TO THE EXCLUSIVE PERSONAL JURISDICTION AND VENUE OF THE COURTS, STATE AND FEDERAL, HAVING JURISDICTION IN THE STATE OF ILLINOIS.' }
    ]
    pdf.move_down 15
    pdf.font_size 12
    pdf.text '14.  Waiver of Rights.', style: :bold
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: '14.1 ', styles: [:bold] },
      { text: 'A failure or delay in exercising any right, power or privilege in respect of this Agreement will not be presumed to operate as a waiver, and a single or partial exercise of any right, power or privilege will not be presumed to preclude any subsequent or further exercise, of that right, power or privilege or the exercise of any other right, power or privilege.' }
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
        ['Title', ''],
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
    pdf.text "APPENDIX A", style: :bold, align: :center
    pdf.move_down 20
    pdf.text "CONTRACTOR’S SERVICES", style: :bold, align: :center
    pdf.move_down 20
    pdf.font_size 8
    pdf.formatted_text [
      { text: 'Contractor’s Services', styles: [:bold] },
      { text: ' include but are not limited to:' }
    ]
    pdf.move_down 8
    pdf.text("The provision of digital marketing services to Company Customers, as requested by Company Customers and approved by Company (in each case, a “Company Customer Project”")
    pdf.move_down 8
    pdf.text("The Parties may add additional Services by mutual agreement in writing.")
    pdf.move_down 15
    pdf.font_size 8
    pdf.text 'Term of Agreement:', style: :bold
    pdf.move_down 8
    pdf.text("The term of this Agreement commences on #{signed_date}, and shall continue until this Agreement is terminated by the Parties pursuant to Section 12 of this Agreement. The Term may be extended at the sole discretion of Company.")
    pdf.move_down 15
    pdf.font_size 12
    pdf.text "COMPENSATION GUIDELINES", style: :bold, align: :center
    pdf.move_down 20
    pdf.font_size 8
    pdf.formatted_text [
      { text: 'Contractor’s Compensation:', styles: [:bold] }
    ]
    pdf.move_down 8
    pdf.text("Company will add twenty percent (20%) to Contractor’s bid (the “Platform Fee”) for each Company Customer Project and Company Customer will be charged the total amount (Contractor’s bid plus the Platform Fee). Upon receipt of payment from Company Customer, Company shall pay Contractor the bid price for each Company Customer Project and retain the Platform Fee. Company shall process all payments for every Company Customer Project. Company shall not be obligated to pay Contractor in the event a Company Customer fails or refuses to pay Company. Company will have the right, without prejudicing or waiving any other right hereunder, to withhold the Platform Fee from any amounts due and owing to Contractor. In the event any payment for a Company Customer Project is not processed through Company, and Contractor receives any amount of that payment, Contractor shall pay to Company the Platform Fee due and owing within two (2) days of receipt of payment, even if the payment received by Contractor is not complete or where the Platform Fee exceeds the amount of any such payment.")
    pdf.text("Company does not guarantee Contractor any amount of work in any given timeframe.")
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: 'Contractor’s Withholdings:', styles: [:bold] }
    ]
    pdf.move_down 8
    pdf.text("Company shall not be responsible for federal, state and local taxes derived from the Contractor's net income, or for the withholding and/or payment of any federal, state and local income and other payroll taxes, workers' compensation, disability benefits or other legal requirements applicable to the Contractor.")
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: 'Nonpayment by Company Customer', styles: [:bold] }
    ]
    pdf.move_down 8
    pdf.text("In the event a Company Customer does not pay amounts owed, Company shall have the right but not obligation to initiate legal action against any such Company Customer. In the event Company waives its option to do so, or if Contractor elects to initiate its own legal proceedings against any nonpaying Company Customer, Company shall be entitled to its Platform Fee from whatever settlement or judgment obtained by Contractor. In the event the original outstanding Platform Fee exceeds the amount of any settlement or award paid to Contractor, Contractor shall pay Company a prorated fee which is equal to twenty percent (20%) of the gross settlement or award within seven (7) days of receipt of payment.")
    pdf
  end
end
