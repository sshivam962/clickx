# frozen_string_literal: true
require "prawn"

class AgencyAddendumPdfGenerator
  attr_reader :addendum

  def initialize(params)
    @addendum = params[:addendum]
  end

  def self.run(*args)
    new(*args).perform
  end

  def perform
    day = Time.current.day.ordinalize
    month = Time.current.strftime('%B')
    agency_name = addendum[:agency_name]
    signature = addendum[:signature]
    name = addendum[:name]
    title = addendum[:title]
    signed_date = Date.current.strftime('%B, %d %Y')
    pdf = Prawn::Document.new(page_size: 'EXECUTIVE')
    pdf.font_size 10
    pdf.text "Addendum A", style: :bold, align: :center
    pdf.move_down 20
    pdf.font_size 8
    pdf.text("This Addendum is issued pursuant to and incorporates the terms and conditions set forth in the White Label Agreement (“Agreement”) which was effective on #{day} day of #{month} #{Date.current.year}, entered into between Clickxposure LLC d/b/a Clickx (“Company”) and #{name}(“Label”).", inline_format: true)
    pdf.move_down 15
    pdf.text "This Addendum modifies only the terms below. All other terms of the Agreement remain in full force and effect."
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "9.7", styles: [:bold] },
      { text: "Video/Audio Recording.", styles: [:bold] }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.text "Label acknowledges and agrees to Company’s audio and/or video recording of conversations between the Parties to this Agreement. In the event Company desires to sue any such recording or portion thereof for marketing, publication, or other commercial use, Company shall seek Label’s express written consent. Label shall not be entitled to any royalty or other such compensation as a result of Company’s use of any recording."
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "10.3", styles: [:bold] }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.text "Company shall not be liable for the acts or omissions of any third party listed on Company’s website who Label hires for the provision of digital marketing services. For the avoidance of doubt, any third party who performs services for Label in connection with this Agreement is solely liable for its acts or omissions."
    pdf.move_down 15
    pdf.font_size 8
    pdf.formatted_text [
      { text: "IN WITNESS WHEREOF" },
      { text: ", he parties have executed this Addendum on the date set forth below." }
    ]
    pdf.move_down 15
    pdf.font_size 8
    pdf.table(
      [
        ['Name', 'Name'],
        ["<b>Solomon Thimothy</b>", "<b>#{name}</b>"],
        ["Representative, <b>Clickxposure LLC</b>", "Representative, <b>#{agency_name}</b>"],
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
    pdf.number_pages "Page <page> of <total>", { :start_count_at => 1, :page_filter => :all, :at => [pdf.bounds.right - 50, 0], :align => :right, :size => 8 }
    pdf
  end
end
