# frozen_string_literal: true

shared_context 'site audit report params' do
  let(:valid_title) do
    { "data" =>
       [{ "title" => "Collectible",
          "status" => "passed",
          "issue_type" => "title_presence" }] }
  end
  let(:valid_description) do
    { "data" =>
       [{ "status" => "passed",
          "issue_type" => "description_presence",
          "description" => "Wondering what to consider" }] }
  end
  let(:valid_htag) do
    { "data" =>
      [{ "status" => "passed",
         "h1_tags" => ["Ball-Jointed Dolls"],
         "issue_type" => "h1_tag_presence" }] }
  end
  let(:valid_image) do
    { "data" =>
      [{ "status" => "passed",
         "issue_type" => "images_count",
         "image_count" => 8 }] }
  end
  let(:valid_cta) do
    { "data" =>
      [{ "cta" => ["This Page does not contain any call-to-action"],
         "status" => "warning",
         "issue_type" => "cta_presence" }] }
  end
  let(:valid_pagelinks) do
    { "data" =>
      [{ "status" => "passed",
         "issue_type" => "internal_links_presence" }] }
  end
end
