# frozen_string_literal: true

namespace :categories do
  desc 'add system users to existing companies'
  task add_categories: :environment do
    category_array = [
      {
        category: "3d printing service"
      },
      {
        category: "abarth dealer"
      },
      {
        category: "abbey"
      },
      {
        category: "aboriginal and torres strait islander organisation"
      },
      {
        category: "aboriginal art gallery"
      },
      {
        category: "abortion clinic"
      },
      {
        category: "abrasives supplier"
      },
      {
        category: "abundant life church"
      },
      {
        category: "academy"
      },
      {
        category: "acaraje restaurant"
      },
      {
        category: "accountant"
      },
      {
        category: "accounting"
      },
      {
        category: "accounting firm"
      },
      {
        category: "accounting school"
      },
      {
        category: "accounting software company"
      },
      {
        category: "acoustical consultant"
      },
      {
        category: "acrobatic diving pool"
      },
      {
        category: "acrylic shop"
      },
      {
        category: "acrylic store"
      },
      {
        category: "acupuncture clinic"
      },
      {
        category: "acupuncture school"
      },
      {
        category: "acupuncturist"
      },
      {
        category: "acura dealer"
      },
      {
        category: "addiction rehabilitation centre"
      },
      {
        category: "addiction treatment center"
      },
      {
        category: "adhesives and glue supplier"
      },
      {
        category: "administrative attorney"
      },
      {
        category: "adoption agency"
      },
      {
        category: "adult day care center"
      },
      {
        category: "adult dvd shop"
      },
      {
        category: "adult dvd store"
      },
      {
        category: "adult education centre"
      },
      {
        category: "adult education school"
      },
      {
        category: "adult entertainment"
      },
      {
        category: "adult entertainment club"
      },
      {
        category: "adult entertainment store"
      },
      {
        category: "adult foster care service"
      },
      {
        category: "adventure sports"
      },
      {
        category: "adventure sports center"
      },
      {
        category: "adventure sports centre"
      },
      {
        category: "advertising"
      },
      {
        category: "advertising agency"
      },
      {
        category: "advertising service"
      },
      {
        category: "aerated drinks supplier"
      },
      {
        category: "aerial photographer"
      },
      {
        category: "aerial sports center"
      },
      {
        category: "aero dance class"
      },
      {
        category: "aerobics instructor"
      },
      {
        category: "aeroclub"
      },
      {
        category: "aeromodel shop"
      },
      {
        category: "aeronautical engineer"
      },
      {
        category: "aeroplane"
      },
      {
        category: "aerospace company"
      },
      {
        category: "afghani restaurant"
      },
      {
        category: "african goods shop"
      },
      {
        category: "african goods store"
      },
      {
        category: "african restaurant"
      },
      {
        category: "after school program"
      },
      {
        category: "after-school programme"
      },
      {
        category: "aged care"
      },
      {
        category: "agent"
      },
      {
        category: "agenzia entrate"
      },
      {
        category: "aggregate supplier"
      },
      {
        category: "agistment service"
      },
      {
        category: "agricultural"
      },
      {
        category: "agricultural association"
      },
      {
        category: "agricultural cooperative"
      },
      {
        category: "agricultural engineer"
      },
      {
        category: "agricultural high school"
      },
      {
        category: "agricultural loan agency"
      },
      {
        category: "agricultural machinery manufacturer"
      },
      {
        category: "agricultural organisation"
      },
      {
        category: "agricultural organization"
      },
      {
        category: "agricultural product wholesaler"
      },
      {
        category: "agricultural production"
      },
      {
        category: "agricultural service"
      },
      {
        category: "agricultural service supply agency"
      },
      {
        category: "agriculture"
      },
      {
        category: "agriculture cooperative"
      },
      {
        category: "agriculture machines supplier"
      },
      {
        category: "agrochemicals supplier"
      },
      {
        category: "aikido club"
      },
      {
        category: "aikido school"
      },
      {
        category: "air compressor repair service"
      },
      {
        category: "air compressor supplier"
      },
      {
        category: "air conditioning contractor"
      },
      {
        category: "air conditioning repair service"
      },
      {
        category: "air conditioning repair shop"
      },
      {
        category: "air conditioning store"
      },
      {
        category: "air conditioning system supplier"
      },
      {
        category: "air duct cleaning service"
      },
      {
        category: "air filter supplier"
      },
      {
        category: "air force base"
      },
      {
        category: "air pump"
      },
      {
        category: "air taxi"
      },
      {
        category: "air traffic control tower"
      },
      {
        category: "airbrushing service"
      },
      {
        category: "airbrushing supply shop"
      },
      {
        category: "airbrushing supply store"
      },
      {
        category: "aircraft dealer"
      },
      {
        category: "aircraft maintenance company"
      },
      {
        category: "aircraft manufacturer"
      },
      {
        category: "aircraft rental service"
      },
      {
        category: "aircraft supply shop"
      },
      {
        category: "aircraft supply store"
      },
      {
        category: "airline"
      },
      {
        category: "airline ticket agency"
      },
      {
        category: "airplane"
      },
      {
        category: "airport"
      },
      {
        category: "airport car park"
      },
      {
        category: "airport gate"
      },
      {
        category: "airport limousine"
      },
      {
        category: "airport parking lot"
      },
      {
        category: "airport security checkpoint"
      },
      {
        category: "airport shuttle service"
      },
      {
        category: "airport terminal"
      },
      {
        category: "airsoft supply shop"
      },
      {
        category: "airsoft supply store"
      },
      {
        category: "airstrip"
      },
      {
        category: "alcohol manufacturer"
      },
      {
        category: "alcohol retail monopoly"
      },
      {
        category: "alcoholic beverage wholesaler"
      },
      {
        category: "alcoholism treatment program"
      },
      {
        category: "alcoholism treatment programme"
      },
      {
        category: "alfa romeo dealer"
      },
      {
        category: "allergist"
      },
      {
        category: "alliance church"
      },
      {
        category: "alsace restaurant"
      },
      {
        category: "alternative fuel station"
      },
      {
        category: "alternative medicine"
      },
      {
        category: "alternative medicine clinic"
      },
      {
        category: "alternative medicine practitioner"
      },
      {
        category: "alternative petrol station"
      },
      {
        category: "alternator supplier"
      },
      {
        category: "aluminium frames supplier"
      },
      {
        category: "aluminium supplier"
      },
      {
        category: "aluminium window"
      },
      {
        category: "aluminum frames supplier"
      },
      {
        category: "aluminum supplier"
      },
      {
        category: "aluminum welder"
      },
      {
        category: "aluminum window"
      },
      {
        category: "alumni association"
      },
      {
        category: "amateur theater"
      },
      {
        category: "ambulance service"
      },
      {
        category: "american football field"
      },
      {
        category: "american grocery store"
      },
      {
        category: "american restaurant"
      },
      {
        category: "amish furniture shop"
      },
      {
        category: "amish furniture store"
      },
      {
        category: "ammunition supplier"
      },
      {
        category: "amphitheater"
      },
      {
        category: "amphitheatre"
      },
      {
        category: "amusement center"
      },
      {
        category: "amusement centre"
      },
      {
        category: "amusement machine supplier"
      },
      {
        category: "amusement park"
      },
      {
        category: "amusement park ride"
      },
      {
        category: "amusement ride supplier"
      },
      {
        category: "anaesthetist"
      },
      {
        category: "anago restaurant"
      },
      {
        category: "andalusian restaurant"
      },
      {
        category: "anesthesiologist"
      },
      {
        category: "angler fish restaurant"
      },
      {
        category: "anglican church"
      },
      {
        category: "anhui restaurant"
      },
      {
        category: "animal control and welfare service"
      },
      {
        category: "animal control service"
      },
      {
        category: "animal feed shop"
      },
      {
        category: "animal feed store"
      },
      {
        category: "animal hospital"
      },
      {
        category: "animal park"
      },
      {
        category: "animal protection organisation"
      },
      {
        category: "animal protection organization"
      },
      {
        category: "animal rescue service"
      },
      {
        category: "animal shelter"
      },
      {
        category: "animal watering hole"
      },
      {
        category: "animals"
      },
      {
        category: "animation studio"
      },
      {
        category: "anime club"
      },
      {
        category: "anodizer"
      },
      {
        category: "antenna service"
      },
      {
        category: "antique furniture restoration service"
      },
      {
        category: "antique furniture shop"
      },
      {
        category: "antique furniture store"
      },
      {
        category: "antique shop"
      },
      {
        category: "antique store"
      },
      {
        category: "apartment building"
      },
      {
        category: "apartment complex"
      },
      {
        category: "apartment letting agency"
      },
      {
        category: "apartment rental agency"
      },
      {
        category: "apartments"
      },
      {
        category: "apostolic church"
      },
      {
        category: "apparel company"
      },
      {
        category: "appliance parts supplier"
      },
      {
        category: "appliance rental service"
      },
      {
        category: "appliance repair service"
      },
      {
        category: "appliance shop"
      },
      {
        category: "appliance store"
      },
      {
        category: "appliances"
      },
      {
        category: "appliances customer service"
      },
      {
        category: "appraiser"
      },
      {
        category: "apprenticeship center"
      },
      {
        category: "aquaculture farm"
      },
      {
        category: "aquarium"
      },
      {
        category: "aquarium shop"
      },
      {
        category: "aquatic centre"
      },
      {
        category: "aqueduct"
      },
      {
        category: "arboretum"
      },
      {
        category: "arborist and tree surgeon"
      },
      {
        category: "archaeological museum"
      },
      {
        category: "archaeological site"
      },
      {
        category: "archery club"
      },
      {
        category: "archery event"
      },
      {
        category: "archery hall"
      },
      {
        category: "archery range"
      },
      {
        category: "archery shop"
      },
      {
        category: "archery store"
      },
      {
        category: "archipelago"
      },
      {
        category: "architect"
      },
      {
        category: "architects association"
      },
      {
        category: "architectural and engineering model maker"
      },
      {
        category: "architectural designer"
      },
      {
        category: "architectural element"
      },
      {
        category: "architectural salvage shop"
      },
      {
        category: "architectural salvage store"
      },
      {
        category: "architecture"
      },
      {
        category: "architecture firm"
      },
      {
        category: "architecture school"
      },
      {
        category: "archive"
      },
      {
        category: "area"
      },
      {
        category: "arena"
      },
      {
        category: "argentinian restaurant"
      },
      {
        category: "armed forces association"
      },
      {
        category: "armenian church"
      },
      {
        category: "armenian restaurant"
      },
      {
        category: "army"
      },
      {
        category: "army & navy surplus shop"
      },
      {
        category: "army barracks"
      },
      {
        category: "army facility"
      },
      {
        category: "army museum"
      },
      {
        category: "aromatherapy class"
      },
      {
        category: "aromatherapy service"
      },
      {
        category: "aromatherapy supply shop"
      },
      {
        category: "aromatherapy supply store"
      },
      {
        category: "art"
      },
      {
        category: "art cafe"
      },
      {
        category: "art center"
      },
      {
        category: "art centre"
      },
      {
        category: "art dealer"
      },
      {
        category: "art gallery"
      },
      {
        category: "art handcraft"
      },
      {
        category: "art museum"
      },
      {
        category: "art restoration service"
      },
      {
        category: "art school"
      },
      {
        category: "art studio"
      },
      {
        category: "art supply shop"
      },
      {
        category: "art supply store"
      },
      {
        category: "artificial plant supplier"
      },
      {
        category: "artist"
      },
      {
        category: "arts and crafts"
      },
      {
        category: "arts and crafts sales outlet"
      },
      {
        category: "arts and crafts shop"
      },
      {
        category: "arts organisation"
      },
      {
        category: "arts organization"
      },
      {
        category: "asbestos testing service"
      },
      {
        category: "ashram"
      },
      {
        category: "asian fusion restaurant"
      },
      {
        category: "asian grocery shop"
      },
      {
        category: "asian grocery store"
      },
      {
        category: "asian household goods shop"
      },
      {
        category: "asian household goods store"
      },
      {
        category: "asian restaurant"
      },
      {
        category: "asphalt"
      },
      {
        category: "asphalt contractor"
      },
      {
        category: "asphalt mixing plant"
      },
      {
        category: "assemblies of god church"
      },
      {
        category: "assembly hall"
      },
      {
        category: "assembly room"
      },
      {
        category: "assistante maternelle"
      },
      {
        category: "assisted living facility"
      },
      {
        category: "assisted living residence"
      },
      {
        category: "association of people with disabilities"
      },
      {
        category: "association or organisation"
      },
      {
        category: "association or organization"
      },
      {
        category: "aston martin dealer"
      },
      {
        category: "astrologer"
      },
      {
        category: "asturian restaurant"
      },
      {
        category: "athletic club"
      },
      {
        category: "athletic field"
      },
      {
        category: "athletic park"
      },
      {
        category: "athletic track"
      },
      {
        category: "athletics"
      },
      {
        category: "athletics field"
      },
      {
        category: "atm"
      },
      {
        category: "atrium"
      },
      {
        category: "attorney"
      },
      {
        category: "attorney referral service"
      },
      {
        category: "attraction"
      },
      {
        category: "attractions"
      },
      {
        category: "atv dealer"
      },
      {
        category: "atv rental service"
      },
      {
        category: "atv repair shop"
      },
      {
        category: "auction house"
      },
      {
        category: "audi dealer"
      },
      {
        category: "audio visual consultant"
      },
      {
        category: "audio visual equipment hire service"
      },
      {
        category: "audio visual equipment rental service"
      },
      {
        category: "audio visual equipment repair service"
      },
      {
        category: "audio visual equipment supplier"
      },
      {
        category: "audio-visual equipment supplier"
      },
      {
        category: "audiologist"
      },
      {
        category: "auditor"
      },
      {
        category: "auditorium"
      },
      {
        category: "australian goods shop"
      },
      {
        category: "australian goods store"
      },
      {
        category: "australian restaurant"
      },
      {
        category: "austrian restaurant"
      },
      {
        category: "authentic japanese restaurant"
      },
      {
        category: "auto accessories wholesaler"
      },
      {
        category: "auto air conditioning service"
      },
      {
        category: "auto auction"
      },
      {
        category: "auto body parts supplier"
      },
      {
        category: "auto body shop"
      },
      {
        category: "auto bodywork mechanic"
      },
      {
        category: "auto broker"
      },
      {
        category: "auto chemistry shop"
      },
      {
        category: "auto dent removal service"
      },
      {
        category: "auto electrical service"
      },
      {
        category: "auto glass shop"
      },
      {
        category: "auto insurance agency"
      },
      {
        category: "auto machine shop"
      },
      {
        category: "auto market"
      },
      {
        category: "auto painting"
      },
      {
        category: "auto part and accessory manufacturer"
      },
      {
        category: "auto parts manufacturer"
      },
      {
        category: "auto parts market"
      },
      {
        category: "auto parts store"
      },
      {
        category: "auto radiator repair service"
      },
      {
        category: "auto repair shop"
      },
      {
        category: "auto restoration service"
      },
      {
        category: "auto spring shop"
      },
      {
        category: "auto sunroof shop"
      },
      {
        category: "auto tag agency"
      },
      {
        category: "auto tune up service"
      },
      {
        category: "auto upholsterer"
      },
      {
        category: "auto window tinting service"
      },
      {
        category: "auto wrecker"
      },
      {
        category: "automated external defibrillator"
      },
      {
        category: "automation company"
      },
      {
        category: "automation equipment"
      },
      {
        category: "automative"
      },
      {
        category: "automobile storage facility"
      },
      {
        category: "automotive"
      },
      {
        category: "aviation"
      },
      {
        category: "aviation consultant"
      },
      {
        category: "aviation training institute"
      },
      {
        category: "awning supplier"
      },
      {
        category: "ayurvedic clinic"
      },
      {
        category: "açaí shop"
      },
      {
        category: "baby clothing shop"
      },
      {
        category: "baby clothing store"
      },
      {
        category: "baby shop"
      },
      {
        category: "baby store"
      },
      {
        category: "baby swimming school"
      },
      {
        category: "back office"
      },
      {
        category: "baden restaurant"
      },
      {
        category: "badminton club"
      },
      {
        category: "badminton complex"
      },
      {
        category: "badminton court"
      },
      {
        category: "bag shop"
      },
      {
        category: "bagel shop"
      },
      {
        category: "baggage claim"
      },
      {
        category: "bahá’í house of worship"
      },
      {
        category: "bail bonds service"
      },
      {
        category: "bailiff"
      },
      {
        category: "bait & tackle shop"
      },
      {
        category: "bait shop"
      },
      {
        category: "bakery"
      },
      {
        category: "bakery equipment"
      },
      {
        category: "baking supply shop"
      },
      {
        category: "baking supply store"
      },
      {
        category: "bakso restaurant"
      },
      {
        category: "balinese restaurant"
      },
      {
        category: "ballet school"
      },
      {
        category: "ballet theater"
      },
      {
        category: "balloon artist"
      },
      {
        category: "balloon ride tour agency"
      },
      {
        category: "balloon shop"
      },
      {
        category: "balloon store"
      },
      {
        category: "ballot drop box"
      },
      {
        category: "ballroom"
      },
      {
        category: "ballroom dance instructor"
      },
      {
        category: "band"
      },
      {
        category: "bangladeshi restaurant"
      },
      {
        category: "bangle shop"
      },
      {
        category: "bank"
      },
      {
        category: "bank or atm"
      },
      {
        category: "banking and finance"
      },
      {
        category: "bankruptcy attorney"
      },
      {
        category: "bankruptcy lawyer"
      },
      {
        category: "bankruptcy service"
      },
      {
        category: "banner printing service"
      },
      {
        category: "banner shop"
      },
      {
        category: "banner store"
      },
      {
        category: "banquet hall"
      },
      {
        category: "baptist church"
      },
      {
        category: "bar"
      },
      {
        category: "bar & grill"
      },
      {
        category: "bar pmu"
      },
      {
        category: "bar restaurant furniture shop"
      },
      {
        category: "bar restaurant furniture store"
      },
      {
        category: "bar stool supplier"
      },
      {
        category: "bar tabac"
      },
      {
        category: "barbecue area"
      },
      {
        category: "barbecue restaurant"
      },
      {
        category: "barbecue shop"
      },
      {
        category: "barber school"
      },
      {
        category: "barber shop"
      },
      {
        category: "barber supply shop"
      },
      {
        category: "barber supply store"
      },
      {
        category: "barbers school"
      },
      {
        category: "bariatric surgeon"
      },
      {
        category: "bark supplier"
      },
      {
        category: "barn"
      },
      {
        category: "barrel supplier"
      },
      {
        category: "barrister"
      },
      {
        category: "bartending school"
      },
      {
        category: "baseball"
      },
      {
        category: "baseball club"
      },
      {
        category: "baseball field"
      },
      {
        category: "baseball goods shop"
      },
      {
        category: "baseball goods store"
      },
      {
        category: "basilica"
      },
      {
        category: "basket supplier"
      },
      {
        category: "basketball"
      },
      {
        category: "basketball club"
      },
      {
        category: "basketball court"
      },
      {
        category: "basketball court contractor"
      },
      {
        category: "basque restaurant"
      },
      {
        category: "batak restaurant"
      },
      {
        category: "bathroom remodeler"
      },
      {
        category: "bathroom renovator"
      },
      {
        category: "bathroom supply shop"
      },
      {
        category: "bathroom supply store"
      },
      {
        category: "batik clothing store"
      },
      {
        category: "battery manufacturer"
      },
      {
        category: "battery shop"
      },
      {
        category: "battery store"
      },
      {
        category: "battery wholesaler"
      },
      {
        category: "batting cage center"
      },
      {
        category: "battle site"
      },
      {
        category: "bavarian restaurant"
      },
      {
        category: "bay"
      },
      {
        category: "bazar"
      },
      {
        category: "bbq area"
      },
      {
        category: "beach"
      },
      {
        category: "beach cleaning service"
      },
      {
        category: "beach clothing shop"
      },
      {
        category: "beach clothing store"
      },
      {
        category: "beach entertainment shop"
      },
      {
        category: "beach pavillion"
      },
      {
        category: "beach volleyball club"
      },
      {
        category: "beach volleyball court"
      },
      {
        category: "bead shop"
      },
      {
        category: "bead store"
      },
      {
        category: "bead wholesaler"
      },
      {
        category: "bearing supplier"
      },
      {
        category: "beautician"
      },
      {
        category: "beauty"
      },
      {
        category: "beauty product supplier"
      },
      {
        category: "beauty products vending machine"
      },
      {
        category: "beauty products wholesaler"
      },
      {
        category: "beauty salon"
      },
      {
        category: "beauty school"
      },
      {
        category: "beauty supply store"
      },
      {
        category: "beauty therapy college"
      },
      {
        category: "bed & breakfast"
      },
      {
        category: "bed shop"
      },
      {
        category: "bedding shop"
      },
      {
        category: "bedding store"
      },
      {
        category: "bedroom furniture store"
      },
      {
        category: "beds"
      },
      {
        category: "beekeeping"
      },
      {
        category: "beer company"
      },
      {
        category: "beer distributor"
      },
      {
        category: "beer garden"
      },
      {
        category: "beer hall"
      },
      {
        category: "beer shop"
      },
      {
        category: "beer store"
      },
      {
        category: "belgian restaurant"
      },
      {
        category: "belt shop"
      },
      {
        category: "bentley dealer"
      },
      {
        category: "berry restaurant"
      },
      {
        category: "bespoke tailor"
      },
      {
        category: "betting agency"
      },
      {
        category: "beverage distributor"
      },
      {
        category: "beverage supplier"
      },
      {
        category: "beverages"
      },
      {
        category: "bicycle club"
      },
      {
        category: "bicycle hire shop"
      },
      {
        category: "bicycle rack"
      },
      {
        category: "bicycle rental service"
      },
      {
        category: "bicycle repair shop"
      },
      {
        category: "bicycle shop"
      },
      {
        category: "bicycle wholesale"
      },
      {
        category: "bicycles"
      },
      {
        category: "bight"
      },
      {
        category: "bike sharing station"
      },
      {
        category: "bike wash"
      },
      {
        category: "biking trail"
      },
      {
        category: "bikram yoga studio"
      },
      {
        category: "bilingual school"
      },
      {
        category: "billiards supply shop"
      },
      {
        category: "billiards supply store"
      },
      {
        category: "bingo hall"
      },
      {
        category: "biochemical supplier"
      },
      {
        category: "biochemistry lab"
      },
      {
        category: "biofeedback therapist"
      },
      {
        category: "biotechnology company"
      },
      {
        category: "biotechnology engineer"
      },
      {
        category: "bird control service"
      },
      {
        category: "bird shop"
      },
      {
        category: "bird watching area"
      },
      {
        category: "birth center"
      },
      {
        category: "birth certificate service"
      },
      {
        category: "birth control center"
      },
      {
        category: "biryani restaurant"
      },
      {
        category: "biscuit shop"
      },
      {
        category: "bistro"
      },
      {
        category: "blacksmith"
      },
      {
        category: "blast cleaning service"
      },
      {
        category: "blind school"
      },
      {
        category: "blind supplier"
      },
      {
        category: "blinds shop"
      },
      {
        category: "blood bank"
      },
      {
        category: "blood donation center"
      },
      {
        category: "blood donation centre"
      },
      {
        category: "blood testing service"
      },
      {
        category: "blueprint service"
      },
      {
        category: "blues club"
      },
      {
        category: "bmw dealer"
      },
      {
        category: "bmw motorcycle dealer"
      },
      {
        category: "bmx club"
      },
      {
        category: "bmx park"
      },
      {
        category: "bmx track"
      },
      {
        category: "board game club"
      },
      {
        category: "board of education"
      },
      {
        category: "board of trade"
      },
      {
        category: "boarding house"
      },
      {
        category: "boarding school"
      },
      {
        category: "boat accessories supplier"
      },
      {
        category: "boat builders"
      },
      {
        category: "boat club"
      },
      {
        category: "boat cover supplier"
      },
      {
        category: "boat dealer"
      },
      {
        category: "boat hire service"
      },
      {
        category: "boat maintenance"
      },
      {
        category: "boat ramp"
      },
      {
        category: "boat rental service"
      },
      {
        category: "boat repair shop"
      },
      {
        category: "boat storage facility"
      },
      {
        category: "boat tour agency"
      },
      {
        category: "boat trailer dealer"
      },
      {
        category: "boating club"
      },
      {
        category: "boating instructor"
      },
      {
        category: "bocce ball court"
      },
      {
        category: "bodega"
      },
      {
        category: "body arts"
      },
      {
        category: "body piercing shop"
      },
      {
        category: "body shaping class"
      },
      {
        category: "boiler manufacturer"
      },
      {
        category: "boiler supplier"
      },
      {
        category: "boilers"
      },
      {
        category: "bonesetting house"
      },
      {
        category: "bonsai plant supplier"
      },
      {
        category: "book publisher"
      },
      {
        category: "book shop"
      },
      {
        category: "book store"
      },
      {
        category: "bookbinder"
      },
      {
        category: "bookkeeping service"
      },
      {
        category: "bookmaker"
      },
      {
        category: "books"
      },
      {
        category: "books wholesaler"
      },
      {
        category: "boot camp"
      },
      {
        category: "boot repair shop"
      },
      {
        category: "boot shop"
      },
      {
        category: "boot store"
      },
      {
        category: "border crossing station"
      },
      {
        category: "border guard"
      },
      {
        category: "botanical garden"
      },
      {
        category: "bottle & can redemption center"
      },
      {
        category: "bottle & can redemption centre"
      },
      {
        category: "bottled water supplier"
      },
      {
        category: "bouncy castle hire"
      },
      {
        category: "boutique"
      },
      {
        category: "bowling alley"
      },
      {
        category: "bowling club"
      },
      {
        category: "bowling supply shop"
      },
      {
        category: "box lunch supplier"
      },
      {
        category: "boxing club"
      },
      {
        category: "boxing gym"
      },
      {
        category: "boxing ring"
      },
      {
        category: "boys’ high school"
      },
      {
        category: "boys’ secondary school"
      },
      {
        category: "bpo company"
      },
      {
        category: "bpo placement agency"
      },
      {
        category: "brake shop"
      },
      {
        category: "brasserie"
      },
      {
        category: "brazilian pastelaria"
      },
      {
        category: "brazilian restaurant"
      },
      {
        category: "breakfast restaurant"
      },
      {
        category: "brewery"
      },
      {
        category: "brewing supply shop"
      },
      {
        category: "brewing supply store"
      },
      {
        category: "brewpub"
      },
      {
        category: "brick manufacturer"
      },
      {
        category: "bricklayer"
      },
      {
        category: "bridal shop"
      },
      {
        category: "bridge"
      },
      {
        category: "bridge club"
      },
      {
        category: "british restaurant"
      },
      {
        category: "brunch restaurant"
      },
      {
        category: "bubble tea store"
      },
      {
        category: "buddhist supplies shop"
      },
      {
        category: "buddhist supplies store"
      },
      {
        category: "buddhist temple"
      },
      {
        category: "budget japanese inn"
      },
      {
        category: "buffet restaurant"
      },
      {
        category: "bugatti dealer"
      },
      {
        category: "buick dealer"
      },
      {
        category: "builder"
      },
      {
        category: "building"
      },
      {
        category: "building consultant"
      },
      {
        category: "building design company"
      },
      {
        category: "building designer"
      },
      {
        category: "building equipment hire service"
      },
      {
        category: "building firm"
      },
      {
        category: "building inspector"
      },
      {
        category: "building lots sales agency"
      },
      {
        category: "building materials market"
      },
      {
        category: "building materials store"
      },
      {
        category: "building materials supplier"
      },
      {
        category: "building restoration service"
      },
      {
        category: "building society"
      },
      {
        category: "bulgarian restaurant"
      },
      {
        category: "bullring"
      },
      {
        category: "bungee jumping center"
      },
      {
        category: "burglar alarm shop"
      },
      {
        category: "burglar alarm store"
      },
      {
        category: "burmese restaurant"
      },
      {
        category: "burrito restaurant"
      },
      {
        category: "bus and coach company"
      },
      {
        category: "bus and coach station"
      },
      {
        category: "bus charter"
      },
      {
        category: "bus company"
      },
      {
        category: "bus depot"
      },
      {
        category: "bus station"
      },
      {
        category: "bus stop"
      },
      {
        category: "bus ticket agency"
      },
      {
        category: "bus tour agency"
      },
      {
        category: "buses"
      },
      {
        category: "business administration service"
      },
      {
        category: "business banking service"
      },
      {
        category: "business broker"
      },
      {
        category: "business card design and printing service"
      },
      {
        category: "business center"
      },
      {
        category: "business centre"
      },
      {
        category: "business development service"
      },
      {
        category: "business management consultant"
      },
      {
        category: "business management consulting firm"
      },
      {
        category: "business networking company"
      },
      {
        category: "business park"
      },
      {
        category: "business related"
      },
      {
        category: "business school"
      },
      {
        category: "business to business service"
      },
      {
        category: "business-to-business service"
      },
      {
        category: "butane gas supplier"
      },
      {
        category: "butcher shop"
      },
      {
        category: "butcher shop deli"
      },
      {
        category: "butcher shop restaurant"
      },
      {
        category: "butchers"
      },
      {
        category: "butsudan store"
      },
      {
        category: "cabaret club"
      },
      {
        category: "cabin rental agency"
      },
      {
        category: "cabinet maker"
      },
      {
        category: "cabinet shop"
      },
      {
        category: "cabinet store"
      },
      {
        category: "cable car operation service"
      },
      {
        category: "cable car station"
      },
      {
        category: "cable company"
      },
      {
        category: "cable provider"
      },
      {
        category: "cadillac dealer"
      },
      {
        category: "cafe"
      },
      {
        category: "cafeteria"
      },
      {
        category: "cajun restaurant"
      },
      {
        category: "cake decorating equipment shop"
      },
      {
        category: "cake shop"
      },
      {
        category: "californian restaurant"
      },
      {
        category: "call center"
      },
      {
        category: "call centre"
      },
      {
        category: "call shop"
      },
      {
        category: "calligraphy lesson"
      },
      {
        category: "calvary chapel church"
      },
      {
        category: "cambodian restaurant"
      },
      {
        category: "camera repair shop"
      },
      {
        category: "camera shop"
      },
      {
        category: "camera store"
      },
      {
        category: "camp"
      },
      {
        category: "camper shell supplier"
      },
      {
        category: "campervan and caravan rental agency"
      },
      {
        category: "campground"
      },
      {
        category: "camping cabin"
      },
      {
        category: "camping farm"
      },
      {
        category: "camping shop"
      },
      {
        category: "camping store"
      },
      {
        category: "campsite"
      },
      {
        category: "canadian restaurant"
      },
      {
        category: "canal"
      },
      {
        category: "cancer treatment center"
      },
      {
        category: "cancer treatment centre"
      },
      {
        category: "candle shop"
      },
      {
        category: "candle store"
      },
      {
        category: "candy store"
      },
      {
        category: "cane furniture shop"
      },
      {
        category: "cane furniture store"
      },
      {
        category: "cannabis shop"
      },
      {
        category: "cannabis store"
      },
      {
        category: "cannery"
      },
      {
        category: "canoe & kayak rental service"
      },
      {
        category: "canoe & kayak shop"
      },
      {
        category: "canoe & kayak store"
      },
      {
        category: "canoe & kayak tour agency"
      },
      {
        category: "canoe and kayak club"
      },
      {
        category: "canoeing area"
      },
      {
        category: "canopy"
      },
      {
        category: "cantabrian restaurant"
      },
      {
        category: "canteen"
      },
      {
        category: "cantonese restaurant"
      },
      {
        category: "cape verdean restaurant"
      },
      {
        category: "capoeira school"
      },
      {
        category: "capsule hotel"
      },
      {
        category: "car accessories shop"
      },
      {
        category: "car accessories store"
      },
      {
        category: "car alarm supplier"
      },
      {
        category: "car and motor insurance agency"
      },
      {
        category: "car auction"
      },
      {
        category: "car battery shop"
      },
      {
        category: "car battery store"
      },
      {
        category: "car body parts supplier"
      },
      {
        category: "car body shop"
      },
      {
        category: "car bodywork mechanic"
      },
      {
        category: "car breaker"
      },
      {
        category: "car broker"
      },
      {
        category: "car club"
      },
      {
        category: "car dealer"
      },
      {
        category: "car detailing service"
      },
      {
        category: "car factory"
      },
      {
        category: "car finance and loan company"
      },
      {
        category: "car inspection station"
      },
      {
        category: "car leasing service"
      },
      {
        category: "car manufacturer"
      },
      {
        category: "car painting"
      },
      {
        category: "car park"
      },
      {
        category: "car parts manufacturer"
      },
      {
        category: "car parts wholesaler"
      },
      {
        category: "car polishing service"
      },
      {
        category: "car racing track"
      },
      {
        category: "car radiator repair service"
      },
      {
        category: "car rental"
      },
      {
        category: "car rental agency"
      },
      {
        category: "car rental company"
      },
      {
        category: "car rental service"
      },
      {
        category: "car repair and maintenance"
      },
      {
        category: "car restoration service"
      },
      {
        category: "car security system installer"
      },
      {
        category: "car service"
      },
      {
        category: "car sharing location"
      },
      {
        category: "car stereo shop"
      },
      {
        category: "car stereo store"
      },
      {
        category: "car wash"
      },
      {
        category: "carabinieri police"
      },
      {
        category: "caravan dealer"
      },
      {
        category: "caravan park"
      },
      {
        category: "caravan repair shop"
      },
      {
        category: "caravan storage facility"
      },
      {
        category: "caravan supply shop"
      },
      {
        category: "cardiologist"
      },
      {
        category: "cardiovascular and thoracic surgeon"
      },
      {
        category: "care services"
      },
      {
        category: "career guidance service"
      },
      {
        category: "caribbean restaurant"
      },
      {
        category: "carnival club"
      },
      {
        category: "carpenter"
      },
      {
        category: "carpet cleaning service"
      },
      {
        category: "carpet fitter"
      },
      {
        category: "carpet installer"
      },
      {
        category: "carpet manufacturer"
      },
      {
        category: "carpet retail shop"
      },
      {
        category: "carpet store"
      },
      {
        category: "carpet wholesaler"
      },
      {
        category: "carpool"
      },
      {
        category: "carport and pergola builder"
      },
      {
        category: "carriage ride service"
      },
      {
        category: "cars"
      },
      {
        category: "carvery"
      },
      {
        category: "cash & carry"
      },
      {
        category: "cash and carry wholesaler"
      },
      {
        category: "cashpoint"
      },
      {
        category: "casino"
      },
      {
        category: "casket service"
      },
      {
        category: "castilian restaurant"
      },
      {
        category: "castle"
      },
      {
        category: "casual clothing store"
      },
      {
        category: "cat boarding service"
      },
      {
        category: "cat breeder"
      },
      {
        category: "cat hostel"
      },
      {
        category: "cat trainer"
      },
      {
        category: "catalonian restaurant"
      },
      {
        category: "caterer"
      },
      {
        category: "catering"
      },
      {
        category: "catering food and drink supplier"
      },
      {
        category: "catering supplier"
      },
      {
        category: "cathedral"
      },
      {
        category: "catholic cathedral"
      },
      {
        category: "catholic church"
      },
      {
        category: "catholic school"
      },
      {
        category: "cattery"
      },
      {
        category: "cattle farm"
      },
      {
        category: "cattle market"
      },
      {
        category: "cave"
      },
      {
        category: "cbse school"
      },
      {
        category: "cd shop"
      },
      {
        category: "cd store"
      },
      {
        category: "ceiling supplier"
      },
      {
        category: "cell phone accessory store"
      },
      {
        category: "cell phone charging station"
      },
      {
        category: "cell phone store"
      },
      {
        category: "cell phone vending machine"
      },
      {
        category: "cell tower"
      },
      {
        category: "cement manufacturer"
      },
      {
        category: "cement supplier"
      },
      {
        category: "cemetery"
      },
      {
        category: "central american restaurant"
      },
      {
        category: "central authority"
      },
      {
        category: "central bank"
      },
      {
        category: "central heating service"
      },
      {
        category: "central javanese restaurant"
      },
      {
        category: "ceramic manufacturer"
      },
      {
        category: "ceramics"
      },
      {
        category: "ceramics contractor"
      },
      {
        category: "ceramics wholesaler"
      },
      {
        category: "certification agency"
      },
      {
        category: "certified public accountant"
      },
      {
        category: "chalet"
      },
      {
        category: "chamber of agriculture"
      },
      {
        category: "chamber of commerce"
      },
      {
        category: "chamber of handicrafts"
      },
      {
        category: "champon noodle restaurant"
      },
      {
        category: "chanko restaurant"
      },
      {
        category: "channel"
      },
      {
        category: "chapel"
      },
      {
        category: "charcuterie"
      },
      {
        category: "charity"
      },
      {
        category: "charity shop"
      },
      {
        category: "charter school"
      },
      {
        category: "chartered accountant"
      },
      {
        category: "chartered surveyor"
      },
      {
        category: "chauffeur service"
      },
      {
        category: "check cashing service"
      },
      {
        category: "cheese manufacturer"
      },
      {
        category: "cheese shop"
      },
      {
        category: "cheesesteak restaurant"
      },
      {
        category: "chemical engineer"
      },
      {
        category: "chemical exporter"
      },
      {
        category: "chemical industry"
      },
      {
        category: "chemical manufacturer"
      },
      {
        category: "chemical plant"
      },
      {
        category: "chemical recycling and disposal"
      },
      {
        category: "chemical wholesaler"
      },
      {
        category: "chemicals"
      },
      {
        category: "chemist"
      },
      {
        category: "chemistry faculty"
      },
      {
        category: "chemistry lab"
      },
      {
        category: "cheque cashing service"
      },
      {
        category: "chesapeake restaurant"
      },
      {
        category: "chess and card club"
      },
      {
        category: "chess club"
      },
      {
        category: "chess instructor"
      },
      {
        category: "chettinad restaurant"
      },
      {
        category: "chevrolet dealer"
      },
      {
        category: "chicken hatchery"
      },
      {
        category: "chicken restaurant"
      },
      {
        category: "chicken shop"
      },
      {
        category: "chicken wings restaurant"
      },
      {
        category: "chief of police department"
      },
      {
        category: "child care agency"
      },
      {
        category: "child center"
      },
      {
        category: "child health care centre"
      },
      {
        category: "child psychiatrist"
      },
      {
        category: "child psychologist"
      },
      {
        category: "childbirth class"
      },
      {
        category: "childcare agency"
      },
      {
        category: "childminder"
      },
      {
        category: "children hall"
      },
      {
        category: "children policlinic"
      },
      {
        category: "children’s amusement center"
      },
      {
        category: "children’s amusement centre"
      },
      {
        category: "children’s clothes shop"
      },
      {
        category: "children’s clothing store"
      },
      {
        category: "children’s furniture shop"
      },
      {
        category: "children’s furniture store"
      },
      {
        category: "children’s health service"
      },
      {
        category: "children’s hospital"
      },
      {
        category: "children’s museum"
      },
      {
        category: "children’s party service"
      },
      {
        category: "childrens book shop"
      },
      {
        category: "childrens book store"
      },
      {
        category: "childrens cafe"
      },
      {
        category: "childrens club"
      },
      {
        category: "childrens farm"
      },
      {
        category: "childrens home"
      },
      {
        category: "childrens library"
      },
      {
        category: "childrens party buffet"
      },
      {
        category: "childrens shop"
      },
      {
        category: "childrens store"
      },
      {
        category: "childrens theater"
      },
      {
        category: "childrens theatre"
      },
      {
        category: "chilean restaurant"
      },
      {
        category: "chimney services"
      },
      {
        category: "chimney sweep"
      },
      {
        category: "chinaware shop"
      },
      {
        category: "chinaware store"
      },
      {
        category: "chinese bakery"
      },
      {
        category: "chinese language instructor"
      },
      {
        category: "chinese language school"
      },
      {
        category: "chinese medicine"
      },
      {
        category: "chinese medicine clinic"
      },
      {
        category: "chinese medicine shop"
      },
      {
        category: "chinese medicine store"
      },
      {
        category: "chinese noodle restaurant"
      },
      {
        category: "chinese restaurant"
      },
      {
        category: "chinese supermarket"
      },
      {
        category: "chinese takeaway"
      },
      {
        category: "chinese tea house"
      },
      {
        category: "chiropodist"
      },
      {
        category: "chiropractor"
      },
      {
        category: "chocolate"
      },
      {
        category: "chocolate artisan"
      },
      {
        category: "chocolate cafe"
      },
      {
        category: "chocolate factory"
      },
      {
        category: "chocolate shop"
      },
      {
        category: "choir"
      },
      {
        category: "chophouse restaurant"
      },
      {
        category: "christian book shop"
      },
      {
        category: "christian book store"
      },
      {
        category: "christian church"
      },
      {
        category: "christian college"
      },
      {
        category: "christmas market"
      },
      {
        category: "christmas shop"
      },
      {
        category: "christmas store"
      },
      {
        category: "christmas tree farm"
      },
      {
        category: "christmas-tree farm"
      },
      {
        category: "chrysler dealer"
      },
      {
        category: "church"
      },
      {
        category: "church of christ"
      },
      {
        category: "church of england church"
      },
      {
        category: "church of jesus christ of latter-day saints"
      },
      {
        category: "church of jesus christ of latter-day saints (mormon)"
      },
      {
        category: "church of the nazarene"
      },
      {
        category: "church office"
      },
      {
        category: "church supply shop"
      },
      {
        category: "church supply store"
      },
      {
        category: "churreria"
      },
      {
        category: "cider bar"
      },
      {
        category: "cider mill"
      },
      {
        category: "cigar shop"
      },
      {
        category: "cigarette vending machine"
      },
      {
        category: "cinema"
      },
      {
        category: "cinema equipment supplier"
      },
      {
        category: "circular distribution service"
      },
      {
        category: "circus"
      },
      {
        category: "citizen information bureau"
      },
      {
        category: "citizens advice bureau"
      },
      {
        category: "citroen dealer"
      },
      {
        category: "city administration"
      },
      {
        category: "city clerk’s office"
      },
      {
        category: "city courthouse"
      },
      {
        category: "city department of environment"
      },
      {
        category: "city department of public safety"
      },
      {
        category: "city department of transportation"
      },
      {
        category: "city district office"
      },
      {
        category: "city employment department"
      },
      {
        category: "city government office"
      },
      {
        category: "city hall"
      },
      {
        category: "city or town hall"
      },
      {
        category: "city park"
      },
      {
        category: "city pillar shrine"
      },
      {
        category: "city tax office"
      },
      {
        category: "civic center"
      },
      {
        category: "civic centre"
      },
      {
        category: "civil defense"
      },
      {
        category: "civil engineer"
      },
      {
        category: "civil engineering"
      },
      {
        category: "civil engineering company"
      },
      {
        category: "civil engineering construction company"
      },
      {
        category: "civil examinations academy"
      },
      {
        category: "civil law attorney"
      },
      {
        category: "civil police"
      },
      {
        category: "civil registry"
      },
      {
        category: "cladding contractor"
      },
      {
        category: "clairvoyant"
      },
      {
        category: "class"
      },
      {
        category: "classified ads newspaper publisher"
      },
      {
        category: "cleaners"
      },
      {
        category: "cleaning products supplier"
      },
      {
        category: "cleaning service"
      },
      {
        category: "clergyman"
      },
      {
        category: "cliff"
      },
      {
        category: "clinic"
      },
      {
        category: "clock repair service"
      },
      {
        category: "clock tower"
      },
      {
        category: "clock watch maker"
      },
      {
        category: "closed circuit television"
      },
      {
        category: "clothes and fabric manufacturer"
      },
      {
        category: "clothes and fabric wholesaler"
      },
      {
        category: "clothes market"
      },
      {
        category: "clothing"
      },
      {
        category: "clothing alteration service"
      },
      {
        category: "clothing manufacturer"
      },
      {
        category: "clothing shop"
      },
      {
        category: "clothing store"
      },
      {
        category: "clothing supplier"
      },
      {
        category: "clothing wholesale market place"
      },
      {
        category: "clothing wholesaler"
      },
      {
        category: "club"
      },
      {
        category: "cng fittment center"
      },
      {
        category: "co-ed school"
      },
      {
        category: "co-working space"
      },
      {
        category: "coach and minibus hire"
      },
      {
        category: "coach service"
      },
      {
        category: "coaching"
      },
      {
        category: "coaching center"
      },
      {
        category: "coal exporter"
      },
      {
        category: "coal supplier"
      },
      {
        category: "coalfield"
      },
      {
        category: "coast guard station"
      },
      {
        category: "coat wholesaler"
      },
      {
        category: "coatroom"
      },
      {
        category: "cocktail bar"
      },
      {
        category: "cocktailbar"
      },
      {
        category: "coffee"
      },
      {
        category: "coffee machine supplier"
      },
      {
        category: "coffee roasters"
      },
      {
        category: "coffee shop"
      },
      {
        category: "coffee stand"
      },
      {
        category: "coffee store"
      },
      {
        category: "coffee vending machine"
      },
      {
        category: "coffee wholesaler"
      },
      {
        category: "coffin supplier"
      },
      {
        category: "coin cashing machine"
      },
      {
        category: "coin dealer"
      },
      {
        category: "coin operated laundry equipment supplier"
      },
      {
        category: "coin operated locker"
      },
      {
        category: "cold cut store"
      },
      {
        category: "cold noodle restaurant"
      },
      {
        category: "cold storage facility"
      },
      {
        category: "collectibles shop"
      },
      {
        category: "collectibles store"
      },
      {
        category: "college"
      },
      {
        category: "college of agriculture"
      },
      {
        category: "college of technology"
      },
      {
        category: "colombian restaurant"
      },
      {
        category: "colorectal surgeon"
      },
      {
        category: "comedy club"
      },
      {
        category: "comic book shop"
      },
      {
        category: "comic book store"
      },
      {
        category: "comic cafe"
      },
      {
        category: "commercial agent"
      },
      {
        category: "commercial cleaning service"
      },
      {
        category: "commercial photographer"
      },
      {
        category: "commercial printer"
      },
      {
        category: "commercial property estate agent"
      },
      {
        category: "commercial property inspector"
      },
      {
        category: "commercial real estate agency"
      },
      {
        category: "commercial real estate inspector"
      },
      {
        category: "commercial refrigeration"
      },
      {
        category: "commercial refrigerator supplier"
      },
      {
        category: "commissioner for oaths"
      },
      {
        category: "communications central"
      },
      {
        category: "community center"
      },
      {
        category: "community centre"
      },
      {
        category: "community college"
      },
      {
        category: "community garden"
      },
      {
        category: "community health centre"
      },
      {
        category: "community school"
      },
      {
        category: "community service"
      },
      {
        category: "company"
      },
      {
        category: "company health service"
      },
      {
        category: "company registry"
      },
      {
        category: "compressed natural gas station"
      },
      {
        category: "computer accessories shop"
      },
      {
        category: "computer accessories store"
      },
      {
        category: "computer club"
      },
      {
        category: "computer consultant"
      },
      {
        category: "computer desk store"
      },
      {
        category: "computer hardware manufacturer"
      },
      {
        category: "computer networking center"
      },
      {
        category: "computer rental agency"
      },
      {
        category: "computer repair service"
      },
      {
        category: "computer security service"
      },
      {
        category: "computer service"
      },
      {
        category: "computer shop"
      },
      {
        category: "computer software shop"
      },
      {
        category: "computer software store"
      },
      {
        category: "computer store"
      },
      {
        category: "computer support and services"
      },
      {
        category: "computer training school"
      },
      {
        category: "computer wholesaler"
      },
      {
        category: "computers"
      },
      {
        category: "concert hall"
      },
      {
        category: "concierge desk"
      },
      {
        category: "concrete contractor"
      },
      {
        category: "concrete factory"
      },
      {
        category: "concrete metal framework supplier"
      },
      {
        category: "concrete product supplier"
      },
      {
        category: "condiments supplier"
      },
      {
        category: "condominium complex"
      },
      {
        category: "condominium rental agency"
      },
      {
        category: "confectionery"
      },
      {
        category: "confectionery wholesaler"
      },
      {
        category: "conference center"
      },
      {
        category: "conference centre"
      },
      {
        category: "congregation"
      },
      {
        category: "conscription office"
      },
      {
        category: "conservation department"
      },
      {
        category: "conservative club"
      },
      {
        category: "conservative synagogue"
      },
      {
        category: "conservatory construction contractor"
      },
      {
        category: "conservatory contractor"
      },
      {
        category: "conservatory of music"
      },
      {
        category: "conservatory supply & installation"
      },
      {
        category: "consignment shop"
      },
      {
        category: "construction"
      },
      {
        category: "construction and maintenance office"
      },
      {
        category: "construction company"
      },
      {
        category: "construction engineering"
      },
      {
        category: "construction equipment supplier"
      },
      {
        category: "construction machine dealer"
      },
      {
        category: "construction machine rental service"
      },
      {
        category: "construction material wholesaler"
      },
      {
        category: "consultant"
      },
      {
        category: "consumer advice center"
      },
      {
        category: "consumer advice centre"
      },
      {
        category: "contact lenses supplier"
      },
      {
        category: "container manufacturer"
      },
      {
        category: "container service"
      },
      {
        category: "container supplier"
      },
      {
        category: "container terminal"
      },
      {
        category: "containers supplier"
      },
      {
        category: "contemporary louisiana restaurant"
      },
      {
        category: "continental restaurant"
      },
      {
        category: "continuing education institute"
      },
      {
        category: "contractor"
      },
      {
        category: "convenience store"
      },
      {
        category: "convenience stores organisation"
      },
      {
        category: "convenience stores organization"
      },
      {
        category: "convent"
      },
      {
        category: "convention center"
      },
      {
        category: "convention centre"
      },
      {
        category: "convention information bureau"
      },
      {
        category: "conveyancer"
      },
      {
        category: "conveyor belt sushi restaurant"
      },
      {
        category: "cookery school"
      },
      {
        category: "cookie shop"
      },
      {
        category: "cooking class"
      },
      {
        category: "cooking school"
      },
      {
        category: "cooling plant"
      },
      {
        category: "cooperative"
      },
      {
        category: "cooperative bank"
      },
      {
        category: "copier repair service"
      },
      {
        category: "copper supplier"
      },
      {
        category: "coppersmith"
      },
      {
        category: "copy shop"
      },
      {
        category: "copying supply shop"
      },
      {
        category: "copying supply store"
      },
      {
        category: "corporate campus"
      },
      {
        category: "corporate entertainment service"
      },
      {
        category: "corporate gift supplier"
      },
      {
        category: "corporate office"
      },
      {
        category: "correctional services department"
      },
      {
        category: "corridor"
      },
      {
        category: "cosmetic dentist"
      },
      {
        category: "cosmetic products manufacturer"
      },
      {
        category: "cosmetic surgeon"
      },
      {
        category: "cosmetics"
      },
      {
        category: "cosmetics and perfumes supplier"
      },
      {
        category: "cosmetics industry"
      },
      {
        category: "cosmetics shop"
      },
      {
        category: "cosmetics store"
      },
      {
        category: "cosmetics wholesaler"
      },
      {
        category: "cosplay cafe"
      },
      {
        category: "costa rican restaurant"
      },
      {
        category: "costume hire service"
      },
      {
        category: "costume jewellery shop"
      },
      {
        category: "costume jewelry shop"
      },
      {
        category: "costume rental service"
      },
      {
        category: "costume shop"
      },
      {
        category: "costume store"
      },
      {
        category: "cottage"
      },
      {
        category: "cottage rental"
      },
      {
        category: "cottage village"
      },
      {
        category: "cotton exporter"
      },
      {
        category: "cotton mill"
      },
      {
        category: "cotton supplier"
      },
      {
        category: "council"
      },
      {
        category: "counsellor"
      },
      {
        category: "counselor"
      },
      {
        category: "countertop contractor"
      },
      {
        category: "countertop store"
      },
      {
        category: "country club"
      },
      {
        category: "country food restaurant"
      },
      {
        category: "country house"
      },
      {
        category: "country park"
      },
      {
        category: "county court"
      },
      {
        category: "county government office"
      },
      {
        category: "county governors office"
      },
      {
        category: "county office"
      },
      {
        category: "courier & shipping services"
      },
      {
        category: "courier service"
      },
      {
        category: "course center"
      },
      {
        category: "court executive officer"
      },
      {
        category: "court of appeal"
      },
      {
        category: "court of arbitration"
      },
      {
        category: "court reporter"
      },
      {
        category: "courthouse"
      },
      {
        category: "couscous restaurant"
      },
      {
        category: "couture"
      },
      {
        category: "couture store"
      },
      {
        category: "coworking space"
      },
      {
        category: "crab house"
      },
      {
        category: "crab restaurant"
      },
      {
        category: "craft shop"
      },
      {
        category: "craft store"
      },
      {
        category: "cramming school"
      },
      {
        category: "crane dealer"
      },
      {
        category: "crane rental agency"
      },
      {
        category: "crane service"
      },
      {
        category: "craniosacral therapy"
      },
      {
        category: "crater"
      },
      {
        category: "creche"
      },
      {
        category: "credit counseling service"
      },
      {
        category: "credit counselling service"
      },
      {
        category: "credit reporting agency"
      },
      {
        category: "credit union"
      },
      {
        category: "cremation service"
      },
      {
        category: "creole restaurant"
      },
      {
        category: "cricket club"
      },
      {
        category: "cricket ground"
      },
      {
        category: "cricket shop"
      },
      {
        category: "crime victim service"
      },
      {
        category: "crime victims service"
      },
      {
        category: "criminal court"
      },
      {
        category: "criminal defence lawyer"
      },
      {
        category: "criminal justice attorney"
      },
      {
        category: "crisis center"
      },
      {
        category: "croatian restaurant"
      },
      {
        category: "crop grower"
      },
      {
        category: "croquet club"
      },
      {
        category: "crossroads"
      },
      {
        category: "crown court"
      },
      {
        category: "cruise agency"
      },
      {
        category: "cruise line company"
      },
      {
        category: "cruise terminal"
      },
      {
        category: "crushed stone supplier"
      },
      {
        category: "crêperie"
      },
      {
        category: "cuban restaurant"
      },
      {
        category: "culinary school"
      },
      {
        category: "cultural association"
      },
      {
        category: "cultural center"
      },
      {
        category: "cultural centre"
      },
      {
        category: "cultural landmark"
      },
      {
        category: "culture"
      },
      {
        category: "cupcake shop"
      },
      {
        category: "cured ham bar"
      },
      {
        category: "cured ham store"
      },
      {
        category: "cured ham warehouse"
      },
      {
        category: "curling club"
      },
      {
        category: "curling hall"
      },
      {
        category: "currency exchange service"
      },
      {
        category: "curtain and upholstery cleaning service"
      },
      {
        category: "curtain maker and retailer"
      },
      {
        category: "curtain shop"
      },
      {
        category: "curtain store"
      },
      {
        category: "curtain supplier and maker"
      },
      {
        category: "custom confiscated goods store"
      },
      {
        category: "custom home builder"
      },
      {
        category: "custom label printer"
      },
      {
        category: "custom t-shirt shop"
      },
      {
        category: "custom t-shirt store"
      },
      {
        category: "custom tailor"
      },
      {
        category: "customs broker"
      },
      {
        category: "customs consultant"
      },
      {
        category: "customs department"
      },
      {
        category: "customs office"
      },
      {
        category: "customs warehouse"
      },
      {
        category: "cutlery shop"
      },
      {
        category: "cutlery store"
      },
      {
        category: "cv service"
      },
      {
        category: "cycle trail"
      },
      {
        category: "cycling association"
      },
      {
        category: "cycling club"
      },
      {
        category: "cycling park"
      },
      {
        category: "czech restaurant"
      },
      {
        category: "dacia dealer"
      },
      {
        category: "dairy"
      },
      {
        category: "dairy farm"
      },
      {
        category: "dairy farm equipment supplier"
      },
      {
        category: "dairy products shop"
      },
      {
        category: "dairy store"
      },
      {
        category: "dairy supplier"
      },
      {
        category: "dam"
      },
      {
        category: "dan dan noodle restaurant"
      },
      {
        category: "dance club"
      },
      {
        category: "dance company"
      },
      {
        category: "dance conservatory"
      },
      {
        category: "dance hall"
      },
      {
        category: "dance pavillion"
      },
      {
        category: "dance restaurant"
      },
      {
        category: "dance school"
      },
      {
        category: "dance shop"
      },
      {
        category: "dance store"
      },
      {
        category: "dancing"
      },
      {
        category: "danish restaurant"
      },
      {
        category: "dart bar"
      },
      {
        category: "dart supply shop"
      },
      {
        category: "dart supply store"
      },
      {
        category: "data entry service"
      },
      {
        category: "data recovery service"
      },
      {
        category: "database management company"
      },
      {
        category: "dating service"
      },
      {
        category: "day care center"
      },
      {
        category: "day spa"
      },
      {
        category: "deaf church"
      },
      {
        category: "deaf school"
      },
      {
        category: "deaf service"
      },
      {
        category: "debris removal service"
      },
      {
        category: "debt collecting"
      },
      {
        category: "debt collection agency"
      },
      {
        category: "decal supplier"
      },
      {
        category: "deck builder"
      },
      {
        category: "defence company"
      },
      {
        category: "defence museum"
      },
      {
        category: "delegated driver service"
      },
      {
        category: "deli"
      },
      {
        category: "deli shop"
      },
      {
        category: "delicatessen"
      },
      {
        category: "delivery and mailing"
      },
      {
        category: "delivery chinese restaurant"
      },
      {
        category: "delivery company"
      },
      {
        category: "delivery restaurant"
      },
      {
        category: "delivery service"
      },
      {
        category: "demolition contractor"
      },
      {
        category: "dental"
      },
      {
        category: "dental clinic"
      },
      {
        category: "dental hygienist"
      },
      {
        category: "dental implants periodontist"
      },
      {
        category: "dental implants provider"
      },
      {
        category: "dental insurance agency"
      },
      {
        category: "dental laboratory"
      },
      {
        category: "dental radiology"
      },
      {
        category: "dental school"
      },
      {
        category: "dental supply shop"
      },
      {
        category: "dental supply store"
      },
      {
        category: "dentist"
      },
      {
        category: "denture care center"
      },
      {
        category: "denture care centre"
      },
      {
        category: "department for regional development"
      },
      {
        category: "department of education"
      },
      {
        category: "department of finance"
      },
      {
        category: "department of housing"
      },
      {
        category: "department of motor vehicles"
      },
      {
        category: "department of public safety"
      },
      {
        category: "department of social services"
      },
      {
        category: "department of transportation"
      },
      {
        category: "department store"
      },
      {
        category: "dept of city treasure"
      },
      {
        category: "dept of state treasure"
      },
      {
        category: "dermatologist"
      },
      {
        category: "desalination plant"
      },
      {
        category: "desert"
      },
      {
        category: "design"
      },
      {
        category: "design agency"
      },
      {
        category: "design consultant"
      },
      {
        category: "design engineer"
      },
      {
        category: "design institute"
      },
      {
        category: "designer"
      },
      {
        category: "designer clothing shop"
      },
      {
        category: "designer clothing store"
      },
      {
        category: "desktop publishing service"
      },
      {
        category: "dessert restaurant"
      },
      {
        category: "dessert shop"
      },
      {
        category: "detective"
      },
      {
        category: "detention center"
      },
      {
        category: "diabetes center"
      },
      {
        category: "diabetes centre"
      },
      {
        category: "diabetes equipment supplier"
      },
      {
        category: "diabetologist"
      },
      {
        category: "diagnostic center"
      },
      {
        category: "diagnostic centre"
      },
      {
        category: "dialysis center"
      },
      {
        category: "dialysis centre"
      },
      {
        category: "diamond buyer"
      },
      {
        category: "diamond dealer"
      },
      {
        category: "diaper service"
      },
      {
        category: "diesel engine dealer"
      },
      {
        category: "diesel engine repair service"
      },
      {
        category: "diesel fuel supplier"
      },
      {
        category: "dietitian"
      },
      {
        category: "digital media"
      },
      {
        category: "digital printer"
      },
      {
        category: "digital printing service"
      },
      {
        category: "dim sum restaurant"
      },
      {
        category: "diner"
      },
      {
        category: "dinner theater"
      },
      {
        category: "dinner theatre"
      },
      {
        category: "direct mail advertising"
      },
      {
        category: "dirt supplier"
      },
      {
        category: "disability equipment supplier"
      },
      {
        category: "disability services & support organisation"
      },
      {
        category: "disability transportation service"
      },
      {
        category: "disabled sports center"
      },
      {
        category: "disc golf course"
      },
      {
        category: "disciples of christ church"
      },
      {
        category: "disco club"
      },
      {
        category: "discount shop"
      },
      {
        category: "discount store"
      },
      {
        category: "discount supermarket"
      },
      {
        category: "display home centre"
      },
      {
        category: "display stand manufacturer"
      },
      {
        category: "disposable items shop"
      },
      {
        category: "disposable tableware supplier"
      },
      {
        category: "distance learning center"
      },
      {
        category: "distance learning centre"
      },
      {
        category: "distillery"
      },
      {
        category: "distributary"
      },
      {
        category: "distribution service"
      },
      {
        category: "distributors"
      },
      {
        category: "district attorney"
      },
      {
        category: "district council"
      },
      {
        category: "district court"
      },
      {
        category: "district government office"
      },
      {
        category: "district justice"
      },
      {
        category: "district office"
      },
      {
        category: "dive club"
      },
      {
        category: "dive shop"
      },
      {
        category: "diving center"
      },
      {
        category: "diving centre"
      },
      {
        category: "diving club"
      },
      {
        category: "diving contractor"
      },
      {
        category: "divorce lawyer"
      },
      {
        category: "divorce service"
      },
      {
        category: "diy store"
      },
      {
        category: "dj"
      },
      {
        category: "dj service"
      },
      {
        category: "dj supply shop"
      },
      {
        category: "dj supply store"
      },
      {
        category: "do-it-yourself shop"
      },
      {
        category: "dock builder"
      },
      {
        category: "doctor"
      },
      {
        category: "doctor referral service"
      },
      {
        category: "dodge dealer"
      },
      {
        category: "dog breeder"
      },
      {
        category: "dog cafe"
      },
      {
        category: "dog care"
      },
      {
        category: "dog day care center"
      },
      {
        category: "dog day care centre"
      },
      {
        category: "dog hostel"
      },
      {
        category: "dog park"
      },
      {
        category: "dog trainer"
      },
      {
        category: "dog walker"
      },
      {
        category: "dogsled ride service"
      },
      {
        category: "dojo restaurant"
      },
      {
        category: "doll restoration service"
      },
      {
        category: "doll shop"
      },
      {
        category: "doll store"
      },
      {
        category: "dollar store"
      },
      {
        category: "domestic abuse treatment center"
      },
      {
        category: "domestic abuse treatment centre"
      },
      {
        category: "domestic airport"
      },
      {
        category: "domestic services"
      },
      {
        category: "dominican restaurant"
      },
      {
        category: "donations center"
      },
      {
        category: "donut shop"
      },
      {
        category: "door and window store"
      },
      {
        category: "door manufacturer"
      },
      {
        category: "door shop"
      },
      {
        category: "door supplier"
      },
      {
        category: "door warehouse"
      },
      {
        category: "double glazing installer"
      },
      {
        category: "double glazing supplier"
      },
      {
        category: "doughnut shop"
      },
      {
        category: "doula"
      },
      {
        category: "down home cooking restaurant"
      },
      {
        category: "drafting equipment supplier"
      },
      {
        category: "drafting service"
      },
      {
        category: "drafting services"
      },
      {
        category: "drainage service"
      },
      {
        category: "drama school"
      },
      {
        category: "drama theater"
      },
      {
        category: "drawing lessons"
      },
      {
        category: "dress and tuxedo rental service"
      },
      {
        category: "dress shop"
      },
      {
        category: "dress store"
      },
      {
        category: "dressmaker"
      },
      {
        category: "dried flower shop"
      },
      {
        category: "dried seafood shop"
      },
      {
        category: "dried seafood store"
      },
      {
        category: "drilling contractor"
      },
      {
        category: "drilling equipment supplier"
      },
      {
        category: "drinking water"
      },
      {
        category: "drinking water dispenser"
      },
      {
        category: "drinking water fountain"
      },
      {
        category: "drinking-water fountain"
      },
      {
        category: "drive-in cinema"
      },
      {
        category: "drive-in movie theater"
      },
      {
        category: "driver and vehicle licensing agency"
      },
      {
        category: "driver’s licence office"
      },
      {
        category: "driver’s license office"
      },
      {
        category: "drivers license training school"
      },
      {
        category: "driveshaft shop"
      },
      {
        category: "driving licence training school"
      },
      {
        category: "driving school"
      },
      {
        category: "driving test centre"
      },
      {
        category: "drone shop"
      },
      {
        category: "drug store"
      },
      {
        category: "drug testing service"
      },
      {
        category: "drum school"
      },
      {
        category: "drum shop"
      },
      {
        category: "drum store"
      },
      {
        category: "dry cleaner"
      },
      {
        category: "dry fruit shop"
      },
      {
        category: "dry fruit store"
      },
      {
        category: "dry ice supplier"
      },
      {
        category: "dry wall contractor"
      },
      {
        category: "dry wall supply shop"
      },
      {
        category: "dry wall supply store"
      },
      {
        category: "ds automobiles dealer"
      },
      {
        category: "ducati dealer"
      },
      {
        category: "dude ranch"
      },
      {
        category: "dump truck dealer"
      },
      {
        category: "dumpling restaurant"
      },
      {
        category: "dune"
      },
      {
        category: "dutch restaurant"
      },
      {
        category: "duty free shop"
      },
      {
        category: "duty free store"
      },
      {
        category: "dvd shop"
      },
      {
        category: "dvd store"
      },
      {
        category: "dye store"
      },
      {
        category: "dyeworks"
      },
      {
        category: "dynamometer supplier"
      },
      {
        category: "e commerce agency"
      },
      {
        category: "e-commerce service"
      },
      {
        category: "ear piercing service"
      },
      {
        category: "ear-piercing service"
      },
      {
        category: "earth works company"
      },
      {
        category: "east african restaurant"
      },
      {
        category: "east javanese restaurant"
      },
      {
        category: "eastern european restaurant"
      },
      {
        category: "eastern orthodox church"
      },
      {
        category: "eatery"
      },
      {
        category: "eating disorder treatment center"
      },
      {
        category: "eating disorder treatment centre"
      },
      {
        category: "eclectic restaurant"
      },
      {
        category: "ecological park"
      },
      {
        category: "ecologists association"
      },
      {
        category: "economic consultant"
      },
      {
        category: "economic development agency"
      },
      {
        category: "ecuadorian restaurant"
      },
      {
        category: "education"
      },
      {
        category: "education and culture"
      },
      {
        category: "education center"
      },
      {
        category: "education centre"
      },
      {
        category: "educational consultant"
      },
      {
        category: "educational institution"
      },
      {
        category: "educational supply shop"
      },
      {
        category: "educational supply store"
      },
      {
        category: "educational testing service"
      },
      {
        category: "eftpos equipment supplier"
      },
      {
        category: "egg supplier"
      },
      {
        category: "egyptian restaurant"
      },
      {
        category: "elder law attorney"
      },
      {
        category: "election commission"
      },
      {
        category: "electric motor repair shop"
      },
      {
        category: "electric motor shop"
      },
      {
        category: "electric motor store"
      },
      {
        category: "electric utility company"
      },
      {
        category: "electric utility manufacturer"
      },
      {
        category: "electric vehicle charging station"
      },
      {
        category: "electric vehicle charging station contractor"
      },
      {
        category: "electrical"
      },
      {
        category: "electrical appliance wholesaler"
      },
      {
        category: "electrical engineer"
      },
      {
        category: "electrical equipment"
      },
      {
        category: "electrical equipment supplier"
      },
      {
        category: "electrical installation service"
      },
      {
        category: "electrical repair shop"
      },
      {
        category: "electrical sub-station"
      },
      {
        category: "electrical substation"
      },
      {
        category: "electrical supply shop"
      },
      {
        category: "electrical supply store"
      },
      {
        category: "electrical wholesaler"
      },
      {
        category: "electrician"
      },
      {
        category: "electricity board"
      },
      {
        category: "electrolysis hair removal service"
      },
      {
        category: "electronic engineer"
      },
      {
        category: "electronic parts manufacturer"
      },
      {
        category: "electronic parts supplier"
      },
      {
        category: "electronics"
      },
      {
        category: "electronics accessories wholesaler"
      },
      {
        category: "electronics company"
      },
      {
        category: "electronics device"
      },
      {
        category: "electronics engineer"
      },
      {
        category: "electronics exporter"
      },
      {
        category: "electronics hire shop"
      },
      {
        category: "electronics industry"
      },
      {
        category: "electronics manufacturer"
      },
      {
        category: "electronics repair shop"
      },
      {
        category: "electronics retail and repair shop"
      },
      {
        category: "electronics store"
      },
      {
        category: "electronics vending machine"
      },
      {
        category: "electronics wholesaler"
      },
      {
        category: "elementary school"
      },
      {
        category: "elevated"
      },
      {
        category: "elevator"
      },
      {
        category: "elevator manufacturer"
      },
      {
        category: "elevator service"
      },
      {
        category: "embassy"
      },
      {
        category: "embossing service"
      },
      {
        category: "embroidery service"
      },
      {
        category: "embroidery shop"
      },
      {
        category: "emergency call booth"
      },
      {
        category: "emergency call box"
      },
      {
        category: "emergency care physician"
      },
      {
        category: "emergency care service"
      },
      {
        category: "emergency dental service"
      },
      {
        category: "emergency department"
      },
      {
        category: "emergency locksmith service"
      },
      {
        category: "emergency management ministry"
      },
      {
        category: "emergency room"
      },
      {
        category: "emergency services"
      },
      {
        category: "emergency training"
      },
      {
        category: "emergency training school"
      },
      {
        category: "emergency veterinarian service"
      },
      {
        category: "employment agency"
      },
      {
        category: "employment attorney"
      },
      {
        category: "employment center"
      },
      {
        category: "employment centre"
      },
      {
        category: "employment consultant"
      },
      {
        category: "employment lawyer"
      },
      {
        category: "employment search service"
      },
      {
        category: "employment services"
      },
      {
        category: "endocrinologist"
      },
      {
        category: "endodontist"
      },
      {
        category: "endoscopist"
      },
      {
        category: "energy"
      },
      {
        category: "energy efficiency company"
      },
      {
        category: "energy equipment and solutions"
      },
      {
        category: "energy supplier"
      },
      {
        category: "engine rebuilding service"
      },
      {
        category: "engineer"
      },
      {
        category: "engineering consultant"
      },
      {
        category: "engineering school"
      },
      {
        category: "engineers’ merchant"
      },
      {
        category: "english language camp"
      },
      {
        category: "english language instructor"
      },
      {
        category: "english language school"
      },
      {
        category: "english restaurant"
      },
      {
        category: "engraver"
      },
      {
        category: "entertainer"
      },
      {
        category: "entertainment"
      },
      {
        category: "entertainment agency"
      },
      {
        category: "entertainment and recreation"
      },
      {
        category: "entrance exam preparatory academy"
      },
      {
        category: "envelope supplier"
      },
      {
        category: "environment office"
      },
      {
        category: "environment renewable natural resources"
      },
      {
        category: "environmental consultant"
      },
      {
        category: "environmental engineer"
      },
      {
        category: "environmental health service"
      },
      {
        category: "environmental organization"
      },
      {
        category: "environmental program"
      },
      {
        category: "environmental programme"
      },
      {
        category: "environmental protection organization"
      },
      {
        category: "episcopal church"
      },
      {
        category: "equestrian centre"
      },
      {
        category: "equestrian club"
      },
      {
        category: "equestrian facility"
      },
      {
        category: "equestrian shop"
      },
      {
        category: "equestrian store"
      },
      {
        category: "equipment exporter"
      },
      {
        category: "equipment importer"
      },
      {
        category: "equipment rental agency"
      },
      {
        category: "equipment supplier"
      },
      {
        category: "eritrean restaurant"
      },
      {
        category: "erotic massage"
      },
      {
        category: "escape room center"
      },
      {
        category: "escape room centre"
      },
      {
        category: "escort service"
      },
      {
        category: "escrow service"
      },
      {
        category: "escrow services"
      },
      {
        category: "espresso bar"
      },
      {
        category: "establishment"
      },
      {
        category: "estate agent"
      },
      {
        category: "estate agent auctioneer"
      },
      {
        category: "estate agents"
      },
      {
        category: "estate appraiser"
      },
      {
        category: "estate liquidator"
      },
      {
        category: "estate planning attorney"
      },
      {
        category: "estate planning lawyer"
      },
      {
        category: "estate valuer"
      },
      {
        category: "estuary"
      },
      {
        category: "ethiopian restaurant"
      },
      {
        category: "ethnic restaurant"
      },
      {
        category: "ethnographic museum"
      },
      {
        category: "european institution"
      },
      {
        category: "european restaurant"
      },
      {
        category: "evaluation service"
      },
      {
        category: "evangelical church"
      },
      {
        category: "evening dress rental service"
      },
      {
        category: "evening school"
      },
      {
        category: "event management company"
      },
      {
        category: "event planner"
      },
      {
        category: "event planning service"
      },
      {
        category: "event technology service"
      },
      {
        category: "event ticket seller"
      },
      {
        category: "event venue"
      },
      {
        category: "events venue"
      },
      {
        category: "excavating contractor"
      },
      {
        category: "executive search firm"
      },
      {
        category: "executive suite rental agency"
      },
      {
        category: "executor"
      },
      {
        category: "exercise equipment shop"
      },
      {
        category: "exercise equipment store"
      },
      {
        category: "exhaust silencer shop"
      },
      {
        category: "exhibit"
      },
      {
        category: "exhibition and trade centre"
      },
      {
        category: "exhibition planner"
      },
      {
        category: "exporter"
      },
      {
        category: "extended stay hotel"
      },
      {
        category: "exterior shop"
      },
      {
        category: "extremadurian restaurant"
      },
      {
        category: "eye care"
      },
      {
        category: "eye care center"
      },
      {
        category: "eye care clinic"
      },
      {
        category: "eyebrow bar"
      },
      {
        category: "eyelash salon"
      },
      {
        category: "fabric cleaning"
      },
      {
        category: "fabric manufacturer"
      },
      {
        category: "fabric product manufacturer"
      },
      {
        category: "fabric shop"
      },
      {
        category: "fabric store"
      },
      {
        category: "fabric wholesaler"
      },
      {
        category: "fabrication engineer"
      },
      {
        category: "facial spa"
      },
      {
        category: "facility contractor"
      },
      {
        category: "factory equipment supplier"
      },
      {
        category: "factory outlet shop"
      },
      {
        category: "faculty of arts"
      },
      {
        category: "faculty of law"
      },
      {
        category: "faculty of pharmacy"
      },
      {
        category: "faculty of psychology"
      },
      {
        category: "faculty of science"
      },
      {
        category: "faculty of sports"
      },
      {
        category: "fair"
      },
      {
        category: "fair trade organization"
      },
      {
        category: "fairground"
      },
      {
        category: "faith school"
      },
      {
        category: "falafel restaurant"
      },
      {
        category: "family counsellor"
      },
      {
        category: "family counselor"
      },
      {
        category: "family court"
      },
      {
        category: "family day care service"
      },
      {
        category: "family law attorney"
      },
      {
        category: "family lawyer"
      },
      {
        category: "family planning center"
      },
      {
        category: "family planning clinic"
      },
      {
        category: "family planning counselor"
      },
      {
        category: "family practice physician"
      },
      {
        category: "family restaurant"
      },
      {
        category: "family service center"
      },
      {
        category: "farm"
      },
      {
        category: "farm bureau"
      },
      {
        category: "farm equipment repair service"
      },
      {
        category: "farm equipment supplier"
      },
      {
        category: "farm household tour"
      },
      {
        category: "farm school"
      },
      {
        category: "farm shop"
      },
      {
        category: "farm stay"
      },
      {
        category: "farmer"
      },
      {
        category: "farmers’ market"
      },
      {
        category: "farming"
      },
      {
        category: "farming and cattle raising"
      },
      {
        category: "farmstay"
      },
      {
        category: "fashion"
      },
      {
        category: "fashion accessories shop"
      },
      {
        category: "fashion accessories store"
      },
      {
        category: "fashion design school"
      },
      {
        category: "fashion designer"
      },
      {
        category: "fast food pizza"
      },
      {
        category: "fast food restaurant"
      },
      {
        category: "fastener supplier"
      },
      {
        category: "fault"
      },
      {
        category: "favela"
      },
      {
        category: "fax service"
      },
      {
        category: "federal agency for technical relief"
      },
      {
        category: "federal courthouse"
      },
      {
        category: "federal credit union"
      },
      {
        category: "federal government office"
      },
      {
        category: "federal police"
      },
      {
        category: "federal reserve bank"
      },
      {
        category: "feed manufacturer"
      },
      {
        category: "felt boots store"
      },
      {
        category: "fence contractor"
      },
      {
        category: "fence supply shop"
      },
      {
        category: "fence supply store"
      },
      {
        category: "fencing salon"
      },
      {
        category: "fencing school"
      },
      {
        category: "feng shui consultant"
      },
      {
        category: "feng shui shop"
      },
      {
        category: "ferrari dealer"
      },
      {
        category: "ferris wheel"
      },
      {
        category: "ferry service"
      },
      {
        category: "ferry terminal"
      },
      {
        category: "fertiliser supplier"
      },
      {
        category: "fertility clinic"
      },
      {
        category: "fertility doctor"
      },
      {
        category: "fertility physician"
      },
      {
        category: "fertilizer supplier"
      },
      {
        category: "festival"
      },
      {
        category: "festival hall"
      },
      {
        category: "fiat dealer"
      },
      {
        category: "fiber optic products supplier"
      },
      {
        category: "fiberglass repair service"
      },
      {
        category: "fiberglass supplier"
      },
      {
        category: "fibreglass repair service"
      },
      {
        category: "fibreglass supplier"
      },
      {
        category: "figurine shop"
      },
      {
        category: "filipino restaurant"
      },
      {
        category: "film and photograph library"
      },
      {
        category: "film production company"
      },
      {
        category: "film rental kiosk"
      },
      {
        category: "film rental store"
      },
      {
        category: "filtration plant"
      },
      {
        category: "finance broker"
      },
      {
        category: "financial advisor"
      },
      {
        category: "financial audit"
      },
      {
        category: "financial consultant"
      },
      {
        category: "financial institution"
      },
      {
        category: "financial planner"
      },
      {
        category: "fine dining restaurant"
      },
      {
        category: "fingerprinting service"
      },
      {
        category: "finishing materials supplier"
      },
      {
        category: "finnish restaurant"
      },
      {
        category: "fire alarm supplier"
      },
      {
        category: "fire damage restoration service"
      },
      {
        category: "fire department equipment supplier"
      },
      {
        category: "fire extinguisher"
      },
      {
        category: "fire fighters academy"
      },
      {
        category: "fire protection consultant"
      },
      {
        category: "fire protection equipment supplier"
      },
      {
        category: "fire protection service"
      },
      {
        category: "fire protection system supplier"
      },
      {
        category: "fire station"
      },
      {
        category: "firearms academy"
      },
      {
        category: "fireplace manufacturer"
      },
      {
        category: "fireplace shop"
      },
      {
        category: "fireplace store"
      },
      {
        category: "firewood supplier"
      },
      {
        category: "fireworks shop"
      },
      {
        category: "fireworks store"
      },
      {
        category: "fireworks supplier"
      },
      {
        category: "first aid kit"
      },
      {
        category: "first aid station"
      },
      {
        category: "fish & chips restaurant"
      },
      {
        category: "fish & chips shop"
      },
      {
        category: "fish and chips takeaway"
      },
      {
        category: "fish and seafood restaurant"
      },
      {
        category: "fish farm"
      },
      {
        category: "fish processing"
      },
      {
        category: "fish restaurant"
      },
      {
        category: "fish spa"
      },
      {
        category: "fish store"
      },
      {
        category: "fishing"
      },
      {
        category: "fishing & hunting"
      },
      {
        category: "fishing and hunting"
      },
      {
        category: "fishing area"
      },
      {
        category: "fishing camp"
      },
      {
        category: "fishing charter"
      },
      {
        category: "fishing club"
      },
      {
        category: "fishing lake"
      },
      {
        category: "fishing pier"
      },
      {
        category: "fishing pond"
      },
      {
        category: "fishing port"
      },
      {
        category: "fishing shop"
      },
      {
        category: "fishing store"
      },
      {
        category: "fishmonger"
      },
      {
        category: "fitness center"
      },
      {
        category: "fitness centre"
      },
      {
        category: "fitness equipment wholesaler"
      },
      {
        category: "fitted furniture supplier"
      },
      {
        category: "fixed-base operator"
      },
      {
        category: "fjord"
      },
      {
        category: "flag shop"
      },
      {
        category: "flag store"
      },
      {
        category: "flamenco dance store"
      },
      {
        category: "flamenco school"
      },
      {
        category: "flamenco theater"
      },
      {
        category: "flat complex"
      },
      {
        category: "flavours fragrances and aroma supplier"
      },
      {
        category: "flea market"
      },
      {
        category: "fleamarket"
      },
      {
        category: "flight school"
      },
      {
        category: "floating market"
      },
      {
        category: "floor refinishing service"
      },
      {
        category: "floor sanding and polishing service"
      },
      {
        category: "flooring"
      },
      {
        category: "flooring contractor"
      },
      {
        category: "flooring shop"
      },
      {
        category: "flooring store"
      },
      {
        category: "floridian restaurant"
      },
      {
        category: "florist"
      },
      {
        category: "flour mill"
      },
      {
        category: "flower delivery"
      },
      {
        category: "flower designer"
      },
      {
        category: "flower market"
      },
      {
        category: "flower wholesale"
      },
      {
        category: "fmcg goods wholesaler"
      },
      {
        category: "fmcg manufacturer"
      },
      {
        category: "foam rubber producer"
      },
      {
        category: "foam rubber supplier"
      },
      {
        category: "foie gras producer"
      },
      {
        category: "folk high school"
      },
      {
        category: "fondue restaurant"
      },
      {
        category: "food"
      },
      {
        category: "food and beverage consultant"
      },
      {
        category: "food and beverage distributors"
      },
      {
        category: "food and beverage exporter"
      },
      {
        category: "food and drink"
      },
      {
        category: "food bank"
      },
      {
        category: "food broker"
      },
      {
        category: "food court"
      },
      {
        category: "food delivery"
      },
      {
        category: "food machinery supplier"
      },
      {
        category: "food manufacturer"
      },
      {
        category: "food manufacturing supply"
      },
      {
        category: "food processing company"
      },
      {
        category: "food processing equipment"
      },
      {
        category: "food producer"
      },
      {
        category: "food production"
      },
      {
        category: "food products"
      },
      {
        category: "food products supplier"
      },
      {
        category: "food seasoning manufacturer"
      },
      {
        category: "food service"
      },
      {
        category: "food shop"
      },
      {
        category: "food store"
      },
      {
        category: "foodbank"
      },
      {
        category: "foot bath"
      },
      {
        category: "foot care"
      },
      {
        category: "foot massage parlor"
      },
      {
        category: "foot massage parlour"
      },
      {
        category: "football"
      },
      {
        category: "football association"
      },
      {
        category: "football club"
      },
      {
        category: "football field"
      },
      {
        category: "football pitch"
      },
      {
        category: "football practice"
      },
      {
        category: "football shop"
      },
      {
        category: "footwear wholesaler"
      },
      {
        category: "ford"
      },
      {
        category: "ford dealer"
      },
      {
        category: "foreclosure service"
      },
      {
        category: "foreign consulate"
      },
      {
        category: "foreign exchange students organization"
      },
      {
        category: "foreign languages program school"
      },
      {
        category: "foreign trade consultant"
      },
      {
        category: "foreman builders association"
      },
      {
        category: "forensic consultant"
      },
      {
        category: "forest resort"
      },
      {
        category: "forestry office"
      },
      {
        category: "forestry service"
      },
      {
        category: "forklift dealer"
      },
      {
        category: "forklift rental service"
      },
      {
        category: "formal menswear shop"
      },
      {
        category: "formal wear shop"
      },
      {
        category: "formal wear store"
      },
      {
        category: "fortress"
      },
      {
        category: "fortune telling services"
      },
      {
        category: "foster care service"
      },
      {
        category: "foundation"
      },
      {
        category: "foundry"
      },
      {
        category: "fountain"
      },
      {
        category: "fountain contractor"
      },
      {
        category: "foursquare church"
      },
      {
        category: "fraternal organization"
      },
      {
        category: "free car park"
      },
      {
        category: "free clinic"
      },
      {
        category: "free parking lot"
      },
      {
        category: "freestyle wrestling"
      },
      {
        category: "freight forwarding service"
      },
      {
        category: "french haute cuisine restaurant"
      },
      {
        category: "french language school"
      },
      {
        category: "french restaurant"
      },
      {
        category: "french steak restaurant"
      },
      {
        category: "french steakhouse restaurant"
      },
      {
        category: "fresh food market"
      },
      {
        category: "fried chicken takeaway"
      },
      {
        category: "friends church"
      },
      {
        category: "frituur"
      },
      {
        category: "frozen dessert supplier"
      },
      {
        category: "frozen food manufacturer"
      },
      {
        category: "frozen food store"
      },
      {
        category: "frozen yoghurt shop"
      },
      {
        category: "frozen yogurt shop"
      },
      {
        category: "fruit and vegetable processing"
      },
      {
        category: "fruit and vegetable shop"
      },
      {
        category: "fruit and vegetable store"
      },
      {
        category: "fruit and vegetable wholesaler"
      },
      {
        category: "fruit parlor"
      },
      {
        category: "fruit parlour"
      },
      {
        category: "fruit wholesaler"
      },
      {
        category: "fruits wholesaler"
      },
      {
        category: "fuel and automotive"
      },
      {
        category: "fuel pump"
      },
      {
        category: "fuel station"
      },
      {
        category: "fuel supplier"
      },
      {
        category: "fugu restaurant"
      },
      {
        category: "fujian restaurant"
      },
      {
        category: "full dress rental service"
      },
      {
        category: "full gospel church"
      },
      {
        category: "function room facility"
      },
      {
        category: "fund management company"
      },
      {
        category: "funeral director"
      },
      {
        category: "funeral home"
      },
      {
        category: "fur coat shop"
      },
      {
        category: "fur manufacturer"
      },
      {
        category: "fur service"
      },
      {
        category: "furnace parts supplier"
      },
      {
        category: "furnace repair service"
      },
      {
        category: "furnace shop"
      },
      {
        category: "furnace store"
      },
      {
        category: "furnished apartment building"
      },
      {
        category: "furniture"
      },
      {
        category: "furniture accessories"
      },
      {
        category: "furniture accessories supplier"
      },
      {
        category: "furniture maker"
      },
      {
        category: "furniture manufacturer"
      },
      {
        category: "furniture piece"
      },
      {
        category: "furniture rental service"
      },
      {
        category: "furniture repair shop"
      },
      {
        category: "furniture store"
      },
      {
        category: "furniture wholesaler"
      },
      {
        category: "furrier"
      },
      {
        category: "fusion restaurant"
      },
      {
        category: "futon store"
      },
      {
        category: "futsal court"
      },
      {
        category: "galician restaurant"
      },
      {
        category: "gambling area"
      },
      {
        category: "gambling house"
      },
      {
        category: "gambling instructor"
      },
      {
        category: "game shop"
      },
      {
        category: "game software"
      },
      {
        category: "game store"
      },
      {
        category: "games"
      },
      {
        category: "garage builder"
      },
      {
        category: "garage door supplier"
      },
      {
        category: "garbage collection service"
      },
      {
        category: "garbage dump"
      },
      {
        category: "garbage dump service"
      },
      {
        category: "garden"
      },
      {
        category: "garden allotment"
      },
      {
        category: "garden building supplier"
      },
      {
        category: "garden center"
      },
      {
        category: "garden centre"
      },
      {
        category: "garden furniture shop"
      },
      {
        category: "garden machinery supplier"
      },
      {
        category: "gardener"
      },
      {
        category: "gardening products and services"
      },
      {
        category: "garment exporter"
      },
      {
        category: "gas and automotive"
      },
      {
        category: "gas company"
      },
      {
        category: "gas cylinders supplier"
      },
      {
        category: "gas engineer"
      },
      {
        category: "gas installation service"
      },
      {
        category: "gas logs supplier"
      },
      {
        category: "gas shop"
      },
      {
        category: "gas station"
      },
      {
        category: "gasfitter"
      },
      {
        category: "gasket manufacturer"
      },
      {
        category: "gastroenterologist"
      },
      {
        category: "gastrointestinal surgeon"
      },
      {
        category: "gastropub"
      },
      {
        category: "gate"
      },
      {
        category: "gated community"
      },
      {
        category: "gay & lesbian organisation"
      },
      {
        category: "gay & lesbian organization"
      },
      {
        category: "gay bar"
      },
      {
        category: "gay night club"
      },
      {
        category: "gay sauna"
      },
      {
        category: "gazebo"
      },
      {
        category: "gazebo builder"
      },
      {
        category: "gemologist"
      },
      {
        category: "genealogist"
      },
      {
        category: "general contractor"
      },
      {
        category: "general hospital"
      },
      {
        category: "general practice attorney"
      },
      {
        category: "general practice lawyer"
      },
      {
        category: "general practitioner"
      },
      {
        category: "general register office"
      },
      {
        category: "general store"
      },
      {
        category: "generator shop"
      },
      {
        category: "genesis dealer"
      },
      {
        category: "geography and history faculty"
      },
      {
        category: "geological research company"
      },
      {
        category: "geological service"
      },
      {
        category: "geologist"
      },
      {
        category: "georgian restaurant"
      },
      {
        category: "geotechnical engineer"
      },
      {
        category: "geriatrician"
      },
      {
        category: "german language school"
      },
      {
        category: "german restaurant"
      },
      {
        category: "geyser"
      },
      {
        category: "ghost town"
      },
      {
        category: "gift basket shop"
      },
      {
        category: "gift basket store"
      },
      {
        category: "gift shop"
      },
      {
        category: "gift wrap store"
      },
      {
        category: "ginseng store"
      },
      {
        category: "girl bar"
      },
      {
        category: "girls’ high school"
      },
      {
        category: "girls’ secondary school"
      },
      {
        category: "glacier"
      },
      {
        category: "glass"
      },
      {
        category: "glass & mirror shop"
      },
      {
        category: "glass block supplier"
      },
      {
        category: "glass blower"
      },
      {
        category: "glass crafts"
      },
      {
        category: "glass cutting service"
      },
      {
        category: "glass engraver"
      },
      {
        category: "glass etching service"
      },
      {
        category: "glass industry"
      },
      {
        category: "glass manufacturer"
      },
      {
        category: "glass merchant"
      },
      {
        category: "glass repair service"
      },
      {
        category: "glass shop"
      },
      {
        category: "glassware manufacturer"
      },
      {
        category: "glassware shop"
      },
      {
        category: "glassware store"
      },
      {
        category: "glassware wholesaler"
      },
      {
        category: "glazier"
      },
      {
        category: "gluten-free restaurant"
      },
      {
        category: "gmc dealer"
      },
      {
        category: "go-cart track"
      },
      {
        category: "go-kart track"
      },
      {
        category: "goan restaurant"
      },
      {
        category: "gold dealer"
      },
      {
        category: "gold mining company"
      },
      {
        category: "goldfish store"
      },
      {
        category: "goldsmith"
      },
      {
        category: "golf"
      },
      {
        category: "golf cart dealer"
      },
      {
        category: "golf club"
      },
      {
        category: "golf course"
      },
      {
        category: "golf course builder"
      },
      {
        category: "golf driving range"
      },
      {
        category: "golf instructor"
      },
      {
        category: "golf shop"
      },
      {
        category: "gondola lift station"
      },
      {
        category: "gospel church"
      },
      {
        category: "gourmet grocery shop"
      },
      {
        category: "gourmet grocery store"
      },
      {
        category: "government"
      },
      {
        category: "government college"
      },
      {
        category: "government economic program"
      },
      {
        category: "government hospital"
      },
      {
        category: "government office"
      },
      {
        category: "government ration shop"
      },
      {
        category: "government school"
      },
      {
        category: "gp"
      },
      {
        category: "gps supplier"
      },
      {
        category: "graduate school"
      },
      {
        category: "graduate university"
      },
      {
        category: "graffiti removal service"
      },
      {
        category: "grain elevator"
      },
      {
        category: "grammar school"
      },
      {
        category: "granite supplier"
      },
      {
        category: "graphic designer"
      },
      {
        category: "grassland"
      },
      {
        category: "gravel pit"
      },
      {
        category: "gravel plant"
      },
      {
        category: "greco-roman wrestling"
      },
      {
        category: "greek orthodox church"
      },
      {
        category: "greek restaurant"
      },
      {
        category: "green energy supplier"
      },
      {
        category: "greengrocer"
      },
      {
        category: "greenhouse"
      },
      {
        category: "greeting card shop"
      },
      {
        category: "greetings card shop"
      },
      {
        category: "greyhound stadium"
      },
      {
        category: "grill"
      },
      {
        category: "grill store"
      },
      {
        category: "grocery delivery service"
      },
      {
        category: "grocery store"
      },
      {
        category: "ground self defense force"
      },
      {
        category: "groundwater development company"
      },
      {
        category: "group accommodation"
      },
      {
        category: "group home"
      },
      {
        category: "grow shop"
      },
      {
        category: "guardia civil"
      },
      {
        category: "guardia di finanza police"
      },
      {
        category: "guatemalan restaurant"
      },
      {
        category: "guest house"
      },
      {
        category: "guest ranch"
      },
      {
        category: "guitar instructor"
      },
      {
        category: "guitar shop"
      },
      {
        category: "guitar store"
      },
      {
        category: "guizhou restaurant"
      },
      {
        category: "gun club"
      },
      {
        category: "gun shop"
      },
      {
        category: "gurdwara"
      },
      {
        category: "gurudwara"
      },
      {
        category: "gutter cleaning service"
      },
      {
        category: "gym"
      },
      {
        category: "gym with swimming pool"
      },
      {
        category: "gymnasium cz"
      },
      {
        category: "gymnasium school"
      },
      {
        category: "gymnastics academy"
      },
      {
        category: "gymnastics center"
      },
      {
        category: "gymnastics club"
      },
      {
        category: "gynecologist"
      },
      {
        category: "gypsum product supplier"
      },
      {
        category: "gyro restaurant"
      },
      {
        category: "gyudon restaurant"
      },
      {
        category: "haberdashery"
      },
      {
        category: "haematologist"
      },
      {
        category: "hair"
      },
      {
        category: "hair care"
      },
      {
        category: "hair extension technician"
      },
      {
        category: "hair extensions supplier"
      },
      {
        category: "hair removal service"
      },
      {
        category: "hair replacement service"
      },
      {
        category: "hair salon"
      },
      {
        category: "hair transplantation clinic"
      },
      {
        category: "hairdresser"
      },
      {
        category: "haitian restaurant"
      },
      {
        category: "hakka restaurant"
      },
      {
        category: "halal restaurant"
      },
      {
        category: "haleem restaurant"
      },
      {
        category: "halfway house"
      },
      {
        category: "hall"
      },
      {
        category: "ham shop"
      },
      {
        category: "hamburger restaurant"
      },
      {
        category: "hammam"
      },
      {
        category: "hand surgeon"
      },
      {
        category: "handbags shop"
      },
      {
        category: "handball club"
      },
      {
        category: "handball court"
      },
      {
        category: "handicapped transportation service"
      },
      {
        category: "handicraft"
      },
      {
        category: "handicraft exporter"
      },
      {
        category: "handicraft fair"
      },
      {
        category: "handicraft museum"
      },
      {
        category: "handicraft school"
      },
      {
        category: "handicrafts wholesaler"
      },
      {
        category: "handyman"
      },
      {
        category: "hang gliding center"
      },
      {
        category: "harbor"
      },
      {
        category: "harbour"
      },
      {
        category: "hardware shop"
      },
      {
        category: "hardware store"
      },
      {
        category: "hardware training institute"
      },
      {
        category: "harley-davidson dealer"
      },
      {
        category: "hat shop"
      },
      {
        category: "haunted house"
      },
      {
        category: "haute couture fashion house"
      },
      {
        category: "haute french restaurant"
      },
      {
        category: "hawaiian goods store"
      },
      {
        category: "hawaiian restaurant"
      },
      {
        category: "hawker centre"
      },
      {
        category: "hawker stall"
      },
      {
        category: "hay supplier"
      },
      {
        category: "head start center"
      },
      {
        category: "head start centre"
      },
      {
        category: "health"
      },
      {
        category: "health and beauty"
      },
      {
        category: "health and beauty shop"
      },
      {
        category: "health consultant"
      },
      {
        category: "health counselor"
      },
      {
        category: "health food restaurant"
      },
      {
        category: "health food shop"
      },
      {
        category: "health food store"
      },
      {
        category: "health insurance agency"
      },
      {
        category: "health resort"
      },
      {
        category: "health spa"
      },
      {
        category: "hearing aid repair service"
      },
      {
        category: "hearing aid shop"
      },
      {
        category: "hearing aid store"
      },
      {
        category: "heart hospital"
      },
      {
        category: "heating"
      },
      {
        category: "heating contractor"
      },
      {
        category: "heating equipment supplier"
      },
      {
        category: "heating oil supplier"
      },
      {
        category: "heavy machinery rental service"
      },
      {
        category: "height works"
      },
      {
        category: "helicopter charter"
      },
      {
        category: "helicopter tour agency"
      },
      {
        category: "heliport"
      },
      {
        category: "helium gas supplier"
      },
      {
        category: "helpline"
      },
      {
        category: "hematologist"
      },
      {
        category: "hepatologist"
      },
      {
        category: "herb shop"
      },
      {
        category: "herbal medicine shop"
      },
      {
        category: "herbal medicine store"
      },
      {
        category: "herbalist"
      },
      {
        category: "heritage building"
      },
      {
        category: "heritage museum"
      },
      {
        category: "heritage preservation"
      },
      {
        category: "high and secondary schools"
      },
      {
        category: "high court"
      },
      {
        category: "high ropes course"
      },
      {
        category: "high school"
      },
      {
        category: "higher education"
      },
      {
        category: "higher secondary school"
      },
      {
        category: "highway patrol"
      },
      {
        category: "hiking area"
      },
      {
        category: "hill station"
      },
      {
        category: "hindu priest"
      },
      {
        category: "hindu temple"
      },
      {
        category: "hip hop dance class"
      },
      {
        category: "hispanic church"
      },
      {
        category: "historic city center"
      },
      {
        category: "historical landmark"
      },
      {
        category: "historical market square"
      },
      {
        category: "historical place"
      },
      {
        category: "historical place museum"
      },
      {
        category: "historical society"
      },
      {
        category: "history museum"
      },
      {
        category: "hiv testing center"
      },
      {
        category: "hoagie restaurant"
      },
      {
        category: "hobby club"
      },
      {
        category: "hobby shop"
      },
      {
        category: "hobby store"
      },
      {
        category: "hockey"
      },
      {
        category: "hockey club"
      },
      {
        category: "hockey field"
      },
      {
        category: "hockey pitch"
      },
      {
        category: "hockey rink"
      },
      {
        category: "hockey supply shop"
      },
      {
        category: "hockey supply store"
      },
      {
        category: "holding company"
      },
      {
        category: "holiday accommodation service"
      },
      {
        category: "holiday apartment"
      },
      {
        category: "holiday apartment rental"
      },
      {
        category: "holiday flat"
      },
      {
        category: "holiday home"
      },
      {
        category: "holiday home letting agency"
      },
      {
        category: "holiday park"
      },
      {
        category: "holistic medicine practitioner"
      },
      {
        category: "home and construction"
      },
      {
        category: "home audio shop"
      },
      {
        category: "home audio store"
      },
      {
        category: "home automation company"
      },
      {
        category: "home builder"
      },
      {
        category: "home care service"
      },
      {
        category: "home cinema installation"
      },
      {
        category: "home furnishings"
      },
      {
        category: "home furniture shop"
      },
      {
        category: "home goods store"
      },
      {
        category: "home hairdresser"
      },
      {
        category: "home health care service"
      },
      {
        category: "home help"
      },
      {
        category: "home help service agency"
      },
      {
        category: "home improvement shop"
      },
      {
        category: "home improvement store"
      },
      {
        category: "home inspector"
      },
      {
        category: "home insurance agency"
      },
      {
        category: "home repair contractor"
      },
      {
        category: "home theater store"
      },
      {
        category: "home theatre shop"
      },
      {
        category: "homekill service"
      },
      {
        category: "homeless service"
      },
      {
        category: "homeless shelter"
      },
      {
        category: "homeopath"
      },
      {
        category: "homeopathic pharmacy"
      },
      {
        category: "homeowners’ association"
      },
      {
        category: "homes"
      },
      {
        category: "homestay"
      },
      {
        category: "homewares shop"
      },
      {
        category: "honda dealer"
      },
      {
        category: "honduran restaurant"
      },
      {
        category: "honey farm"
      },
      {
        category: "hong kong style fast food restaurant"
      },
      {
        category: "hookah bar"
      },
      {
        category: "hookah shop"
      },
      {
        category: "hookah store"
      },
      {
        category: "horse boarding stable"
      },
      {
        category: "horse breeder"
      },
      {
        category: "horse carriage station"
      },
      {
        category: "horse rental service"
      },
      {
        category: "horse riding"
      },
      {
        category: "horse riding field"
      },
      {
        category: "horse riding school"
      },
      {
        category: "horse trailer dealer"
      },
      {
        category: "horse trainer"
      },
      {
        category: "horse transport service"
      },
      {
        category: "horse transport supplier"
      },
      {
        category: "horse-riding service"
      },
      {
        category: "horseback riding service"
      },
      {
        category: "horseshoe smith"
      },
      {
        category: "horsestable studfarm"
      },
      {
        category: "hose supplier"
      },
      {
        category: "hospice"
      },
      {
        category: "hospital"
      },
      {
        category: "hospital department"
      },
      {
        category: "hospital equipment and supplies"
      },
      {
        category: "hospitality and tourism school"
      },
      {
        category: "hospitality high school"
      },
      {
        category: "hospitality supplies"
      },
      {
        category: "host club"
      },
      {
        category: "hostel"
      },
      {
        category: "hot bedstone spa"
      },
      {
        category: "hot dog restaurant"
      },
      {
        category: "hot dog stand"
      },
      {
        category: "hot pot restaurant"
      },
      {
        category: "hot spring"
      },
      {
        category: "hot spring hotel"
      },
      {
        category: "hot tub repair service"
      },
      {
        category: "hot tub shop"
      },
      {
        category: "hot tub store"
      },
      {
        category: "hot water system supplier"
      },
      {
        category: "hotel"
      },
      {
        category: "hotel management school"
      },
      {
        category: "hotel room"
      },
      {
        category: "hotel supply shop"
      },
      {
        category: "hotel supply store"
      },
      {
        category: "house cleaning service"
      },
      {
        category: "house clearance service"
      },
      {
        category: "house sitter"
      },
      {
        category: "house sitter agency"
      },
      {
        category: "houseboat rental service"
      },
      {
        category: "household chemicals supplier"
      },
      {
        category: "household goods wholesaler"
      },
      {
        category: "household waste recycling centre"
      },
      {
        category: "housing"
      },
      {
        category: "housing association"
      },
      {
        category: "housing authority"
      },
      {
        category: "housing complex"
      },
      {
        category: "housing cooperative"
      },
      {
        category: "housing development"
      },
      {
        category: "housing offices"
      },
      {
        category: "housing society"
      },
      {
        category: "housing utility company"
      },
      {
        category: "hua gong shop"
      },
      {
        category: "hub cap supplier"
      },
      {
        category: "huissier"
      },
      {
        category: "human resource consulting"
      },
      {
        category: "human resources"
      },
      {
        category: "hunan restaurant"
      },
      {
        category: "hungarian restaurant"
      },
      {
        category: "hunting & fishing store"
      },
      {
        category: "hunting and fishing shop"
      },
      {
        category: "hunting and fishing store"
      },
      {
        category: "hunting area"
      },
      {
        category: "hunting club"
      },
      {
        category: "hunting preserve"
      },
      {
        category: "hunting shop"
      },
      {
        category: "hunting store"
      },
      {
        category: "hvac contractor"
      },
      {
        category: "hydraulic engineer"
      },
      {
        category: "hydraulic equipment supplier"
      },
      {
        category: "hydraulic repair service"
      },
      {
        category: "hydroelectric power plant"
      },
      {
        category: "hydroponics equipment supplier"
      },
      {
        category: "hygiene articles wholesaler"
      },
      {
        category: "hygiene station"
      },
      {
        category: "hyperbaric medicine physician"
      },
      {
        category: "hypermarket"
      },
      {
        category: "hypnotherapy service"
      },
      {
        category: "hyundai dealer"
      },
      {
        category: "ice"
      },
      {
        category: "ice cream and drink shop"
      },
      {
        category: "ice cream equipment supplier"
      },
      {
        category: "ice cream shop"
      },
      {
        category: "ice hockey club"
      },
      {
        category: "ice skating club"
      },
      {
        category: "ice skating instructor"
      },
      {
        category: "ice skating rink"
      },
      {
        category: "ice supplier"
      },
      {
        category: "icelandic restaurant"
      },
      {
        category: "icse school"
      },
      {
        category: "idol manufacturer"
      },
      {
        category: "image consultant"
      },
      {
        category: "imax cinema"
      },
      {
        category: "imax theater"
      },
      {
        category: "immigration & naturalisation service"
      },
      {
        category: "immigration & naturalization service"
      },
      {
        category: "immigration attorney"
      },
      {
        category: "immigration detention centre"
      },
      {
        category: "immigration lawyer"
      },
      {
        category: "immunologist"
      },
      {
        category: "impermeabilization service"
      },
      {
        category: "import export company"
      },
      {
        category: "importer"
      },
      {
        category: "incense supplier"
      },
      {
        category: "incineration plant"
      },
      {
        category: "inclined railway station"
      },
      {
        category: "income protection insurance"
      },
      {
        category: "income tax help association"
      },
      {
        category: "independent or preparatory school"
      },
      {
        category: "independent school"
      },
      {
        category: "indian grocery shop"
      },
      {
        category: "indian grocery store"
      },
      {
        category: "indian muslim restaurant"
      },
      {
        category: "indian restaurant"
      },
      {
        category: "indian sizzler restaurant"
      },
      {
        category: "indian sweets shop"
      },
      {
        category: "indian takeaway"
      },
      {
        category: "indonesian restaurant"
      },
      {
        category: "indoor accommodation"
      },
      {
        category: "indoor arena"
      },
      {
        category: "indoor cycling"
      },
      {
        category: "indoor golf course"
      },
      {
        category: "indoor lodging"
      },
      {
        category: "indoor playground"
      },
      {
        category: "indoor snowcenter"
      },
      {
        category: "indoor snowcentre"
      },
      {
        category: "indoor swimming pool"
      },
      {
        category: "industrial area"
      },
      {
        category: "industrial building"
      },
      {
        category: "industrial chemicals wholesaler"
      },
      {
        category: "industrial consultant"
      },
      {
        category: "industrial design company"
      },
      {
        category: "industrial door supplier"
      },
      {
        category: "industrial engineer"
      },
      {
        category: "industrial engineers association"
      },
      {
        category: "industrial equipment supplier"
      },
      {
        category: "industrial estate"
      },
      {
        category: "industrial framework supplier"
      },
      {
        category: "industrial gas supplier"
      },
      {
        category: "industrial real estate agency"
      },
      {
        category: "industrial supermarket"
      },
      {
        category: "industrial technical engineers association"
      },
      {
        category: "industrial vacuum equipment supplier"
      },
      {
        category: "industry"
      },
      {
        category: "infectious disease doctor"
      },
      {
        category: "infectious disease physician"
      },
      {
        category: "infiniti dealer"
      },
      {
        category: "information and technology services"
      },
      {
        category: "information bureau"
      },
      {
        category: "information desk"
      },
      {
        category: "information services"
      },
      {
        category: "inlet"
      },
      {
        category: "inn"
      },
      {
        category: "inquiry agency"
      },
      {
        category: "insolvency service"
      },
      {
        category: "institute"
      },
      {
        category: "institute of geography and statistics"
      },
      {
        category: "institute of technology"
      },
      {
        category: "instruction"
      },
      {
        category: "instrumentation engineer"
      },
      {
        category: "insulation contractor"
      },
      {
        category: "insulation materials shop"
      },
      {
        category: "insulation materials store"
      },
      {
        category: "insulator supplier"
      },
      {
        category: "insurance"
      },
      {
        category: "insurance agency"
      },
      {
        category: "insurance attorney"
      },
      {
        category: "insurance broker"
      },
      {
        category: "insurance company"
      },
      {
        category: "insurance lawyer"
      },
      {
        category: "insurance school"
      },
      {
        category: "intellectual property registry"
      },
      {
        category: "intelligence agency"
      },
      {
        category: "intensivist"
      },
      {
        category: "interior architect office"
      },
      {
        category: "interior construction contractor"
      },
      {
        category: "interior decoration"
      },
      {
        category: "interior decorator"
      },
      {
        category: "interior designer"
      },
      {
        category: "interior door"
      },
      {
        category: "interior fitting contractor"
      },
      {
        category: "interior plant hire service"
      },
      {
        category: "interior plant service"
      },
      {
        category: "internal medicine ward"
      },
      {
        category: "international airport"
      },
      {
        category: "international school"
      },
      {
        category: "international trade consultant"
      },
      {
        category: "internet"
      },
      {
        category: "internet cafe"
      },
      {
        category: "internet service provider"
      },
      {
        category: "internet shop"
      },
      {
        category: "internist"
      },
      {
        category: "intersection"
      },
      {
        category: "inverter and ups manufacturer"
      },
      {
        category: "investment bank"
      },
      {
        category: "investment banking"
      },
      {
        category: "investment company"
      },
      {
        category: "investment service"
      },
      {
        category: "invitation printing service"
      },
      {
        category: "irish goods shop"
      },
      {
        category: "irish goods store"
      },
      {
        category: "irish pub"
      },
      {
        category: "irish restaurant"
      },
      {
        category: "iron and steel industry"
      },
      {
        category: "iron and steel shop"
      },
      {
        category: "iron and steel store"
      },
      {
        category: "iron steel contractor"
      },
      {
        category: "iron ware dealer"
      },
      {
        category: "iron works"
      },
      {
        category: "irrigation equipment supplier"
      },
      {
        category: "island"
      },
      {
        category: "israeli restaurant"
      },
      {
        category: "isuzu dealer"
      },
      {
        category: "it security service"
      },
      {
        category: "it support and services"
      },
      {
        category: "italian food shop"
      },
      {
        category: "italian grocery store"
      },
      {
        category: "italian restaurant"
      },
      {
        category: "iup"
      },
      {
        category: "izakaya restaurant"
      },
      {
        category: "jaguar dealer"
      },
      {
        category: "jain temple"
      },
      {
        category: "jamaican restaurant"
      },
      {
        category: "janitorial equipment supplier"
      },
      {
        category: "janitorial service"
      },
      {
        category: "japanese cheap sweets shop"
      },
      {
        category: "japanese confectionery shop"
      },
      {
        category: "japanese curry restaurant"
      },
      {
        category: "japanese delicatessen"
      },
      {
        category: "japanese grocery store"
      },
      {
        category: "japanese inn"
      },
      {
        category: "japanese language instructor"
      },
      {
        category: "japanese prefecture government office"
      },
      {
        category: "japanese regional restaurant"
      },
      {
        category: "japanese restaurant"
      },
      {
        category: "japanese steakhouse"
      },
      {
        category: "japanese supermarket"
      },
      {
        category: "japanese sweet shop"
      },
      {
        category: "japanese sweets restaurant"
      },
      {
        category: "japanized western restaurant"
      },
      {
        category: "javanese restaurant"
      },
      {
        category: "jazz club"
      },
      {
        category: "jeans shop"
      },
      {
        category: "jeep dealer"
      },
      {
        category: "jehovah’s witness kingdom hall"
      },
      {
        category: "jeweler"
      },
      {
        category: "jeweller"
      },
      {
        category: "jewellery buyer"
      },
      {
        category: "jewellery designer"
      },
      {
        category: "jewellery engraver"
      },
      {
        category: "jewellery manufacturer"
      },
      {
        category: "jewellery repair service"
      },
      {
        category: "jewellery store"
      },
      {
        category: "jewellery valuer"
      },
      {
        category: "jewelry appraiser"
      },
      {
        category: "jewelry buyer"
      },
      {
        category: "jewelry designer"
      },
      {
        category: "jewelry engraver"
      },
      {
        category: "jewelry equipment supplier"
      },
      {
        category: "jewelry exporter"
      },
      {
        category: "jewelry repair service"
      },
      {
        category: "jewelry store"
      },
      {
        category: "jewish restaurant"
      },
      {
        category: "jiangsu restaurant"
      },
      {
        category: "jiu jitsu school"
      },
      {
        category: "job centre"
      },
      {
        category: "joiner"
      },
      {
        category: "judicial auction"
      },
      {
        category: "judicial scrivener"
      },
      {
        category: "judo club"
      },
      {
        category: "judo school"
      },
      {
        category: "juice bar"
      },
      {
        category: "juice shop"
      },
      {
        category: "jujitsu school"
      },
      {
        category: "junior college"
      },
      {
        category: "junk dealer"
      },
      {
        category: "junk store"
      },
      {
        category: "junkyard"
      },
      {
        category: "justice department"
      },
      {
        category: "justice of the peace"
      },
      {
        category: "jute exporter"
      },
      {
        category: "jute mill"
      },
      {
        category: "juvenile court"
      },
      {
        category: "juvenile detention center"
      },
      {
        category: "juvenile detention centre"
      },
      {
        category: "kabaddi club"
      },
      {
        category: "kaiseki restaurant"
      },
      {
        category: "karaoke"
      },
      {
        category: "karaoke bar"
      },
      {
        category: "karaoke equipment rental service"
      },
      {
        category: "karate club"
      },
      {
        category: "karate school"
      },
      {
        category: "karma dealer"
      },
      {
        category: "karnataka restaurant"
      },
      {
        category: "kashmiri restaurant"
      },
      {
        category: "katsudon restaurant"
      },
      {
        category: "kawasaki motorcycle dealer"
      },
      {
        category: "kazakhstani restaurant"
      },
      {
        category: "kebab shop"
      },
      {
        category: "kennel"
      },
      {
        category: "kennels"
      },
      {
        category: "kerala restaurant"
      },
      {
        category: "kerosene supplier"
      },
      {
        category: "key duplication service"
      },
      {
        category: "kia dealer"
      },
      {
        category: "kickboxing school"
      },
      {
        category: "kilt shop and hire"
      },
      {
        category: "kimono shop"
      },
      {
        category: "kimono store"
      },
      {
        category: "kindergarten"
      },
      {
        category: "kinesiologist"
      },
      {
        category: "kiosk"
      },
      {
        category: "kitchen"
      },
      {
        category: "kitchen furniture shop"
      },
      {
        category: "kitchen furniture store"
      },
      {
        category: "kitchen remodeler"
      },
      {
        category: "kitchen renovator"
      },
      {
        category: "kitchen supply shop"
      },
      {
        category: "kitchen supply store"
      },
      {
        category: "kitchens"
      },
      {
        category: "kitchenware shop"
      },
      {
        category: "kite shop"
      },
      {
        category: "knife manufacturing"
      },
      {
        category: "knife shop"
      },
      {
        category: "knife store"
      },
      {
        category: "knit shop"
      },
      {
        category: "knitting instructor"
      },
      {
        category: "knitwear manufacturer"
      },
      {
        category: "konkani restaurant"
      },
      {
        category: "korean barbecue restaurant"
      },
      {
        category: "korean beef restaurant"
      },
      {
        category: "korean church"
      },
      {
        category: "korean food shop"
      },
      {
        category: "korean grocery store"
      },
      {
        category: "korean restaurant"
      },
      {
        category: "korean rib restaurant"
      },
      {
        category: "kosher food shop"
      },
      {
        category: "kosher grocery store"
      },
      {
        category: "kosher restaurant"
      },
      {
        category: "kung fu school"
      },
      {
        category: "kushiage and kushikatsu restaurant"
      },
      {
        category: "kushiyaki restaurant"
      },
      {
        category: "kyoto style japanese restaurant"
      },
      {
        category: "labor court"
      },
      {
        category: "labor relations attorney"
      },
      {
        category: "labor union"
      },
      {
        category: "labor welfare corporation"
      },
      {
        category: "laboratory"
      },
      {
        category: "laboratory equipment supplier"
      },
      {
        category: "labour club"
      },
      {
        category: "labour department"
      },
      {
        category: "labour relations lawyer"
      },
      {
        category: "ladder supplier"
      },
      {
        category: "ladies’ clothes shop"
      },
      {
        category: "lagoon"
      },
      {
        category: "lake"
      },
      {
        category: "lake shore swimming area"
      },
      {
        category: "lamborghini dealer"
      },
      {
        category: "laminating equipment supplier"
      },
      {
        category: "lamination service"
      },
      {
        category: "lamp repair service"
      },
      {
        category: "lamp shade supplier"
      },
      {
        category: "lancia dealer"
      },
      {
        category: "land allotment"
      },
      {
        category: "land mass"
      },
      {
        category: "land planning authority"
      },
      {
        category: "land reform institute"
      },
      {
        category: "land registry office"
      },
      {
        category: "land rover dealer"
      },
      {
        category: "land surveying office"
      },
      {
        category: "land surveyor"
      },
      {
        category: "landmark"
      },
      {
        category: "landscape architect"
      },
      {
        category: "landscape designer"
      },
      {
        category: "landscape gardener"
      },
      {
        category: "landscape lighting designer"
      },
      {
        category: "landscaper"
      },
      {
        category: "landscaping supply shop"
      },
      {
        category: "landscaping supply store"
      },
      {
        category: "language school"
      },
      {
        category: "laotian restaurant"
      },
      {
        category: "lapidary"
      },
      {
        category: "laser cutting service"
      },
      {
        category: "laser equipment supplier"
      },
      {
        category: "laser hair removal service"
      },
      {
        category: "laser tag center"
      },
      {
        category: "laser tag centre"
      },
      {
        category: "lasik surgeon"
      },
      {
        category: "late night meal restaurant"
      },
      {
        category: "latin american restaurant"
      },
      {
        category: "launderette"
      },
      {
        category: "laundromat"
      },
      {
        category: "laundry"
      },
      {
        category: "laundry room"
      },
      {
        category: "laundry service"
      },
      {
        category: "lava field"
      },
      {
        category: "law book shop"
      },
      {
        category: "law book store"
      },
      {
        category: "law firm"
      },
      {
        category: "law library"
      },
      {
        category: "law school"
      },
      {
        category: "lawn bowls club"
      },
      {
        category: "lawn care service"
      },
      {
        category: "lawn equipment rental service"
      },
      {
        category: "lawn irrigation equipment supplier"
      },
      {
        category: "lawn mower repair service"
      },
      {
        category: "lawn mower shop"
      },
      {
        category: "lawn mower store"
      },
      {
        category: "lawn sprinkler system contractor"
      },
      {
        category: "lawyer"
      },
      {
        category: "lawyer for the elderly"
      },
      {
        category: "lawyer referral service"
      },
      {
        category: "lawyers association"
      },
      {
        category: "leagues club"
      },
      {
        category: "learner driver training area"
      },
      {
        category: "learning center"
      },
      {
        category: "learning centre"
      },
      {
        category: "leasing service"
      },
      {
        category: "leather cleaning service"
      },
      {
        category: "leather coats shop"
      },
      {
        category: "leather coats store"
      },
      {
        category: "leather exporter"
      },
      {
        category: "leather goods manufacturer"
      },
      {
        category: "leather goods shop"
      },
      {
        category: "leather goods store"
      },
      {
        category: "leather goods supplier"
      },
      {
        category: "leather goods wholesaler"
      },
      {
        category: "leather repair service"
      },
      {
        category: "leather wholesaler"
      },
      {
        category: "lebanese restaurant"
      },
      {
        category: "legal affairs bureau"
      },
      {
        category: "legal aid agency"
      },
      {
        category: "legal aid office"
      },
      {
        category: "legal services"
      },
      {
        category: "legally defined lodging"
      },
      {
        category: "leisure centre"
      },
      {
        category: "letter box"
      },
      {
        category: "levee"
      },
      {
        category: "lexus dealer"
      },
      {
        category: "library"
      },
      {
        category: "licence office"
      },
      {
        category: "license bureau"
      },
      {
        category: "license plate frames supplier"
      },
      {
        category: "lido"
      },
      {
        category: "life coach"
      },
      {
        category: "life insurance agency"
      },
      {
        category: "lift service"
      },
      {
        category: "light bulb supplier"
      },
      {
        category: "light rail station"
      },
      {
        category: "lighthouse"
      },
      {
        category: "lighting"
      },
      {
        category: "lighting consultant"
      },
      {
        category: "lighting contractor"
      },
      {
        category: "lighting manufacturer"
      },
      {
        category: "lighting shop"
      },
      {
        category: "lighting store"
      },
      {
        category: "lighting wholesaler"
      },
      {
        category: "ligurian restaurant"
      },
      {
        category: "limousine service"
      },
      {
        category: "lincoln dealer"
      },
      {
        category: "line marking service"
      },
      {
        category: "linen shop"
      },
      {
        category: "linens store"
      },
      {
        category: "lingerie manufacturer"
      },
      {
        category: "lingerie shop"
      },
      {
        category: "lingerie store"
      },
      {
        category: "lingerie wholesaler"
      },
      {
        category: "linoleum shop"
      },
      {
        category: "linoleum store"
      },
      {
        category: "liquidator"
      },
      {
        category: "liquor store"
      },
      {
        category: "liquor wholesaler"
      },
      {
        category: "literacy program"
      },
      {
        category: "lithuanian restaurant"
      },
      {
        category: "little league club"
      },
      {
        category: "little league field"
      },
      {
        category: "live music bar"
      },
      {
        category: "live music venue"
      },
      {
        category: "livery company"
      },
      {
        category: "livestock auction house"
      },
      {
        category: "livestock breeder"
      },
      {
        category: "livestock dealer"
      },
      {
        category: "livestock farming service"
      },
      {
        category: "livestock producer"
      },
      {
        category: "loan agency"
      },
      {
        category: "lobby"
      },
      {
        category: "local government office"
      },
      {
        category: "local history museum"
      },
      {
        category: "local medical services"
      },
      {
        category: "lock store"
      },
      {
        category: "locks supplier"
      },
      {
        category: "locksmith"
      },
      {
        category: "lodge"
      },
      {
        category: "lodger referral service"
      },
      {
        category: "lodging"
      },
      {
        category: "log cabins"
      },
      {
        category: "log home builder"
      },
      {
        category: "logging contractor"
      },
      {
        category: "logistics"
      },
      {
        category: "logistics service"
      },
      {
        category: "lombardian restaurant"
      },
      {
        category: "loss adjuster"
      },
      {
        category: "lost property office"
      },
      {
        category: "lottery retailer"
      },
      {
        category: "lottery shop"
      },
      {
        category: "lounge"
      },
      {
        category: "love hotel"
      },
      {
        category: "low emission zone"
      },
      {
        category: "low income housing program"
      },
      {
        category: "low income housing programme"
      },
      {
        category: "lpg conversion"
      },
      {
        category: "luggage repair service"
      },
      {
        category: "luggage shop"
      },
      {
        category: "luggage storage facility"
      },
      {
        category: "luggage store"
      },
      {
        category: "luggage wholesaler"
      },
      {
        category: "lumber store"
      },
      {
        category: "lunch restaurant"
      },
      {
        category: "lutheran church"
      },
      {
        category: "lyceum"
      },
      {
        category: "lymph drainage therapist"
      },
      {
        category: "machine accessories manufacturer"
      },
      {
        category: "machine construction"
      },
      {
        category: "machine knife supplier"
      },
      {
        category: "machine maintenance"
      },
      {
        category: "machine repair service"
      },
      {
        category: "machine shop"
      },
      {
        category: "machine tool supplier"
      },
      {
        category: "machine workshop"
      },
      {
        category: "machinery"
      },
      {
        category: "machinery parts manufacturer"
      },
      {
        category: "machining manufacturer"
      },
      {
        category: "macrobiotic restaurant"
      },
      {
        category: "madrilian restaurant"
      },
      {
        category: "magazine store"
      },
      {
        category: "magic shop"
      },
      {
        category: "magic store"
      },
      {
        category: "magician"
      },
      {
        category: "magistrates’ court"
      },
      {
        category: "mahjong house"
      },
      {
        category: "mail room"
      },
      {
        category: "mailbox rental service"
      },
      {
        category: "mailbox supplier"
      },
      {
        category: "mailing machine supplier"
      },
      {
        category: "mailing service"
      },
      {
        category: "main customs office"
      },
      {
        category: "majorcan restaurant"
      },
      {
        category: "make-up artist"
      },
      {
        category: "makerspace"
      },
      {
        category: "malaysian restaurant"
      },
      {
        category: "maltese restaurant"
      },
      {
        category: "mammography service"
      },
      {
        category: "manado restaurant"
      },
      {
        category: "management school"
      },
      {
        category: "mandarin restaurant"
      },
      {
        category: "manor house"
      },
      {
        category: "manual therapy"
      },
      {
        category: "manufactured home transporter"
      },
      {
        category: "manufacturer"
      },
      {
        category: "maori organization"
      },
      {
        category: "map shop"
      },
      {
        category: "map store"
      },
      {
        category: "mapping service"
      },
      {
        category: "marae"
      },
      {
        category: "marble contractor"
      },
      {
        category: "marble supplier"
      },
      {
        category: "marche restaurant"
      },
      {
        category: "marina"
      },
      {
        category: "marine"
      },
      {
        category: "marine broker"
      },
      {
        category: "marine engineer"
      },
      {
        category: "marine protected area"
      },
      {
        category: "marine self defense force"
      },
      {
        category: "marine supply shop"
      },
      {
        category: "marine supply store"
      },
      {
        category: "marine surveyor"
      },
      {
        category: "marines facility"
      },
      {
        category: "maritime museum"
      },
      {
        category: "market"
      },
      {
        category: "market operator"
      },
      {
        category: "market researcher"
      },
      {
        category: "markmens clubhouse"
      },
      {
        category: "marquee hire service"
      },
      {
        category: "marriage celebrant"
      },
      {
        category: "marriage counsellor"
      },
      {
        category: "marriage license bureau"
      },
      {
        category: "marriage or relationship counselor"
      },
      {
        category: "marriage registry office"
      },
      {
        category: "martial arts"
      },
      {
        category: "martial arts club"
      },
      {
        category: "martial arts school"
      },
      {
        category: "martial arts supply shop"
      },
      {
        category: "martial arts supply store"
      },
      {
        category: "maserati dealer"
      },
      {
        category: "masonic center"
      },
      {
        category: "masonic hall"
      },
      {
        category: "masonry contractor"
      },
      {
        category: "masonry supply shop"
      },
      {
        category: "masonry supply store"
      },
      {
        category: "massage"
      },
      {
        category: "massage parlor"
      },
      {
        category: "massage school"
      },
      {
        category: "massage services"
      },
      {
        category: "massage spa"
      },
      {
        category: "massage supply shop"
      },
      {
        category: "massage supply store"
      },
      {
        category: "massage therapist"
      },
      {
        category: "match box manufacturer"
      },
      {
        category: "material handling equipment supplier"
      },
      {
        category: "maternity hospital"
      },
      {
        category: "maternity shop"
      },
      {
        category: "maternity store"
      },
      {
        category: "mathematics school"
      },
      {
        category: "mattress shop"
      },
      {
        category: "mattress store"
      },
      {
        category: "mausoleum builder"
      },
      {
        category: "mazda dealer"
      },
      {
        category: "mclaren dealer"
      },
      {
        category: "meal delivery"
      },
      {
        category: "measuring instruments supplier"
      },
      {
        category: "meat dish restaurant"
      },
      {
        category: "meat packer"
      },
      {
        category: "meat processor"
      },
      {
        category: "meat products"
      },
      {
        category: "meat wholesaler"
      },
      {
        category: "mechanic"
      },
      {
        category: "mechanical contractor"
      },
      {
        category: "mechanical engineer"
      },
      {
        category: "mechanical engineering"
      },
      {
        category: "mechanical engineering service"
      },
      {
        category: "mechanical plant"
      },
      {
        category: "mechanical workshop"
      },
      {
        category: "media"
      },
      {
        category: "media and information sciences faculty"
      },
      {
        category: "media company"
      },
      {
        category: "media consultant"
      },
      {
        category: "media house"
      },
      {
        category: "media production"
      },
      {
        category: "mediation service"
      },
      {
        category: "medical billing service"
      },
      {
        category: "medical book shop"
      },
      {
        category: "medical book store"
      },
      {
        category: "medical center"
      },
      {
        category: "medical centre"
      },
      {
        category: "medical certificate service"
      },
      {
        category: "medical clinic"
      },
      {
        category: "medical diagnostic imaging center"
      },
      {
        category: "medical diagnostic imaging centre"
      },
      {
        category: "medical equipment manufacturer"
      },
      {
        category: "medical equipment supplier"
      },
      {
        category: "medical examiner"
      },
      {
        category: "medical group"
      },
      {
        category: "medical imaging centre"
      },
      {
        category: "medical laboratory"
      },
      {
        category: "medical lawyer"
      },
      {
        category: "medical office"
      },
      {
        category: "medical school"
      },
      {
        category: "medical spa"
      },
      {
        category: "medical specialist"
      },
      {
        category: "medical supply store"
      },
      {
        category: "medical technology manufacturer"
      },
      {
        category: "medical transcription service"
      },
      {
        category: "medicine exporter"
      },
      {
        category: "meditation center"
      },
      {
        category: "meditation centre"
      },
      {
        category: "meditation instructor"
      },
      {
        category: "mediterranean restaurant"
      },
      {
        category: "meeting planning service"
      },
      {
        category: "meeting point"
      },
      {
        category: "meeting room"
      },
      {
        category: "mehandi class"
      },
      {
        category: "mehndi designer"
      },
      {
        category: "memorial"
      },
      {
        category: "memorial estate"
      },
      {
        category: "memorial park"
      },
      {
        category: "men’s clothes shop"
      },
      {
        category: "men’s clothing store"
      },
      {
        category: "men’s health physician"
      },
      {
        category: "mennonite church"
      },
      {
        category: "mens tailor"
      },
      {
        category: "mental health"
      },
      {
        category: "mental health clinic"
      },
      {
        category: "mental health service"
      },
      {
        category: "mental health services"
      },
      {
        category: "mercantile development"
      },
      {
        category: "mercedes-benz dealer"
      },
      {
        category: "messianic synagogue"
      },
      {
        category: "metal construction company"
      },
      {
        category: "metal detecting equipment supplier"
      },
      {
        category: "metal fabricator"
      },
      {
        category: "metal finisher"
      },
      {
        category: "metal heat treating service"
      },
      {
        category: "metal industry suppliers"
      },
      {
        category: "metal machinery supplier"
      },
      {
        category: "metal polishing service"
      },
      {
        category: "metal processing company"
      },
      {
        category: "metal services"
      },
      {
        category: "metal stamping service"
      },
      {
        category: "metal supplier"
      },
      {
        category: "metal working shop"
      },
      {
        category: "metal workshop"
      },
      {
        category: "metallic materials suppliers"
      },
      {
        category: "metallurgy company"
      },
      {
        category: "metalware dealer"
      },
      {
        category: "metalware producer"
      },
      {
        category: "metalwork"
      },
      {
        category: "metalworking"
      },
      {
        category: "metaphysical supply shop"
      },
      {
        category: "metaphysical supply store"
      },
      {
        category: "methodist church"
      },
      {
        category: "metropolitan train company"
      },
      {
        category: "mexican goods shop"
      },
      {
        category: "mexican goods store"
      },
      {
        category: "mexican grocers"
      },
      {
        category: "mexican grocery store"
      },
      {
        category: "mexican restaurant"
      },
      {
        category: "mexican torta restaurant"
      },
      {
        category: "mfr"
      },
      {
        category: "microbiologist"
      },
      {
        category: "microbrewery"
      },
      {
        category: "microwave oven repair service"
      },
      {
        category: "microwave repair service"
      },
      {
        category: "mid-atlantic restaurant (us)"
      },
      {
        category: "middle eastern restaurant"
      },
      {
        category: "middle school"
      },
      {
        category: "midwife"
      },
      {
        category: "military"
      },
      {
        category: "military airport"
      },
      {
        category: "military archive"
      },
      {
        category: "military barracks"
      },
      {
        category: "military base"
      },
      {
        category: "military board"
      },
      {
        category: "military cemetery"
      },
      {
        category: "military hospital"
      },
      {
        category: "military recruiting office"
      },
      {
        category: "military residence"
      },
      {
        category: "military school"
      },
      {
        category: "military town"
      },
      {
        category: "milk delivery service"
      },
      {
        category: "mill"
      },
      {
        category: "millwork shop"
      },
      {
        category: "mine"
      },
      {
        category: "mineral supplier"
      },
      {
        category: "mineral water company"
      },
      {
        category: "mineral water wholesale"
      },
      {
        category: "mini dealer"
      },
      {
        category: "miniature golf course"
      },
      {
        category: "miniatures shop"
      },
      {
        category: "miniatures store"
      },
      {
        category: "minibus taxi service"
      },
      {
        category: "mining company"
      },
      {
        category: "mining consultant"
      },
      {
        category: "mining engineer"
      },
      {
        category: "mining equipment"
      },
      {
        category: "ministry of education"
      },
      {
        category: "mirror shop"
      },
      {
        category: "miso cutlet restaurant"
      },
      {
        category: "missing persons organization"
      },
      {
        category: "mission"
      },
      {
        category: "mitsubishi dealer"
      },
      {
        category: "mobile caterer"
      },
      {
        category: "mobile communications service"
      },
      {
        category: "mobile disco"
      },
      {
        category: "mobile hairdresser"
      },
      {
        category: "mobile home dealer"
      },
      {
        category: "mobile home park"
      },
      {
        category: "mobile home rental agency"
      },
      {
        category: "mobile home supply shop"
      },
      {
        category: "mobile home supply store"
      },
      {
        category: "mobile money agent"
      },
      {
        category: "mobile network operator"
      },
      {
        category: "mobile phone accessory shop"
      },
      {
        category: "mobile phone repair shop"
      },
      {
        category: "mobile phone shop"
      },
      {
        category: "mobile tower"
      },
      {
        category: "mobility equipment supplier"
      },
      {
        category: "model car play area"
      },
      {
        category: "model design company"
      },
      {
        category: "model maker"
      },
      {
        category: "model portfolio studio"
      },
      {
        category: "model shop"
      },
      {
        category: "model train shop"
      },
      {
        category: "model train store"
      },
      {
        category: "modeling agency"
      },
      {
        category: "modeling school"
      },
      {
        category: "modelling agency"
      },
      {
        category: "modern art museum"
      },
      {
        category: "modern british restaurant"
      },
      {
        category: "modern european restaurant"
      },
      {
        category: "modern french restaurant"
      },
      {
        category: "modern indian restaurant"
      },
      {
        category: "modern izakaya restaurants"
      },
      {
        category: "modular home builder"
      },
      {
        category: "modular home dealer"
      },
      {
        category: "mold maker"
      },
      {
        category: "molding supplier"
      },
      {
        category: "momo restaurant"
      },
      {
        category: "monastery"
      },
      {
        category: "money order service"
      },
      {
        category: "money transfer service"
      },
      {
        category: "mongolian barbecue restaurant"
      },
      {
        category: "monjayaki restaurant"
      },
      {
        category: "monogramming service"
      },
      {
        category: "monorail station"
      },
      {
        category: "montessori school"
      },
      {
        category: "monument"
      },
      {
        category: "monument maker"
      },
      {
        category: "moped dealer"
      },
      {
        category: "moravian church"
      },
      {
        category: "moroccan restaurant"
      },
      {
        category: "mortgage broker"
      },
      {
        category: "mortgage lender"
      },
      {
        category: "mortuary"
      },
      {
        category: "mosque"
      },
      {
        category: "mot centre"
      },
      {
        category: "motel"
      },
      {
        category: "motocross"
      },
      {
        category: "motor scooter dealer"
      },
      {
        category: "motor scooter repair shop"
      },
      {
        category: "motor vehicle dealer"
      },
      {
        category: "motorbike dealer"
      },
      {
        category: "motorbike parts shop"
      },
      {
        category: "motorbike rental agency"
      },
      {
        category: "motorbike repair shop"
      },
      {
        category: "motorcycle breaker and dismantler"
      },
      {
        category: "motorcycle club"
      },
      {
        category: "motorcycle dealer"
      },
      {
        category: "motorcycle driving school"
      },
      {
        category: "motorcycle insurance agency"
      },
      {
        category: "motorcycle parts store"
      },
      {
        category: "motorcycle rental agency"
      },
      {
        category: "motorcycle repair shop"
      },
      {
        category: "motorcycle shop"
      },
      {
        category: "motorcycle training centre"
      },
      {
        category: "motorcycles"
      },
      {
        category: "motoring club"
      },
      {
        category: "motorsports shop"
      },
      {
        category: "motorsports store"
      },
      {
        category: "motorway services"
      },
      {
        category: "moulding supplier"
      },
      {
        category: "mountain bike"
      },
      {
        category: "mountain cabin"
      },
      {
        category: "mountain cable car"
      },
      {
        category: "mountain pass"
      },
      {
        category: "mountain peak"
      },
      {
        category: "mountain range"
      },
      {
        category: "mountaineering class"
      },
      {
        category: "mountaineering club"
      },
      {
        category: "mover"
      },
      {
        category: "movie rental"
      },
      {
        category: "movie rental kiosk"
      },
      {
        category: "movie rental store"
      },
      {
        category: "movie studio"
      },
      {
        category: "movie theater"
      },
      {
        category: "moving and storage service"
      },
      {
        category: "moving company"
      },
      {
        category: "moving supply shop"
      },
      {
        category: "moving supply store"
      },
      {
        category: "mri center"
      },
      {
        category: "mri centre"
      },
      {
        category: "muay thai boxing gym"
      },
      {
        category: "muffler shop"
      },
      {
        category: "mulch supplier"
      },
      {
        category: "multimedia and electronic book publisher"
      },
      {
        category: "municipal administration office"
      },
      {
        category: "municipal corporation"
      },
      {
        category: "municipal department agricultural development"
      },
      {
        category: "municipal department agriculture food supply"
      },
      {
        category: "municipal department civil defense"
      },
      {
        category: "municipal department communication"
      },
      {
        category: "municipal department finance"
      },
      {
        category: "municipal department housing and urban development"
      },
      {
        category: "municipal department of culture"
      },
      {
        category: "municipal department of sports"
      },
      {
        category: "municipal department of tourism"
      },
      {
        category: "municipal department science technology"
      },
      {
        category: "municipal department social defense"
      },
      {
        category: "municipal guard"
      },
      {
        category: "municipal hall"
      },
      {
        category: "municipal health department"
      },
      {
        category: "municipal office education"
      },
      {
        category: "municipal social development"
      },
      {
        category: "murtabak restaurant"
      },
      {
        category: "museum"
      },
      {
        category: "museum of space history"
      },
      {
        category: "museum of zoology"
      },
      {
        category: "music"
      },
      {
        category: "music academy"
      },
      {
        category: "music box shop"
      },
      {
        category: "music box store"
      },
      {
        category: "music classes"
      },
      {
        category: "music college"
      },
      {
        category: "music conservatory"
      },
      {
        category: "music instruction"
      },
      {
        category: "music instructor"
      },
      {
        category: "music management and promotion"
      },
      {
        category: "music producer"
      },
      {
        category: "music publisher"
      },
      {
        category: "music school"
      },
      {
        category: "music shop"
      },
      {
        category: "music store"
      },
      {
        category: "music teacher"
      },
      {
        category: "musical club"
      },
      {
        category: "musical instrument manufacturer"
      },
      {
        category: "musical instrument rental service"
      },
      {
        category: "musical instrument repair shop"
      },
      {
        category: "musical instrument shop"
      },
      {
        category: "musical instrument store"
      },
      {
        category: "musician"
      },
      {
        category: "musician and composer"
      },
      {
        category: "mutton barbecue restaurant"
      },
      {
        category: "nail salon"
      },
      {
        category: "nanotechnology engineer"
      },
      {
        category: "nappy service"
      },
      {
        category: "nasi goreng restaurant"
      },
      {
        category: "nasi restaurant"
      },
      {
        category: "nasi uduk restaurant"
      },
      {
        category: "national forest"
      },
      {
        category: "national health foundation"
      },
      {
        category: "national library"
      },
      {
        category: "national museum"
      },
      {
        category: "national park"
      },
      {
        category: "national reserve"
      },
      {
        category: "national tax service"
      },
      {
        category: "native american goods shop"
      },
      {
        category: "native american goods store"
      },
      {
        category: "native american restaurant"
      },
      {
        category: "natural beauty spot"
      },
      {
        category: "natural feature"
      },
      {
        category: "natural foods shop"
      },
      {
        category: "natural goods store"
      },
      {
        category: "natural history museum"
      },
      {
        category: "natural stone exporter"
      },
      {
        category: "natural stone supplier"
      },
      {
        category: "natural stone wholesaler"
      },
      {
        category: "nature preserve"
      },
      {
        category: "nature reserve"
      },
      {
        category: "naturopath"
      },
      {
        category: "naturopathic practitioner"
      },
      {
        category: "naval base"
      },
      {
        category: "navarraise restaurant"
      },
      {
        category: "neapolitan restaurant"
      },
      {
        category: "needlecraft shop"
      },
      {
        category: "needlework shop"
      },
      {
        category: "neon sign shop"
      },
      {
        category: "neonatal doctor"
      },
      {
        category: "neonatal physician"
      },
      {
        category: "nepalese restaurant"
      },
      {
        category: "nephrologist"
      },
      {
        category: "netball club"
      },
      {
        category: "neurological ward"
      },
      {
        category: "neurologist"
      },
      {
        category: "neurophysiologist"
      },
      {
        category: "neurosurgeon"
      },
      {
        category: "new age church"
      },
      {
        category: "new american restaurant"
      },
      {
        category: "new england restaurant"
      },
      {
        category: "new residence"
      },
      {
        category: "new service"
      },
      {
        category: "new years tree market"
      },
      {
        category: "new zealand restaurant"
      },
      {
        category: "news service"
      },
      {
        category: "newsagent"
      },
      {
        category: "newspaper advertising department"
      },
      {
        category: "newspaper distribution"
      },
      {
        category: "newspaper publisher"
      },
      {
        category: "newsstand"
      },
      {
        category: "nicaraguan restaurant"
      },
      {
        category: "night club"
      },
      {
        category: "night market"
      },
      {
        category: "nightclub"
      },
      {
        category: "nightlife"
      },
      {
        category: "nissan dealer"
      },
      {
        category: "non smoking holiday home"
      },
      {
        category: "non-denominational church"
      },
      {
        category: "non-governmental organisation"
      },
      {
        category: "non-governmental organization"
      },
      {
        category: "non-profit organisation"
      },
      {
        category: "non-profit organization"
      },
      {
        category: "non-public area"
      },
      {
        category: "noodle shop"
      },
      {
        category: "north african restaurant"
      },
      {
        category: "north eastern indian restaurant"
      },
      {
        category: "northern italian restaurant"
      },
      {
        category: "norwegian restaurant"
      },
      {
        category: "notable street"
      },
      {
        category: "notaries association"
      },
      {
        category: "notary public"
      },
      {
        category: "notions store"
      },
      {
        category: "novelties wholesaler"
      },
      {
        category: "novelty shop"
      },
      {
        category: "novelty store"
      },
      {
        category: "nuclear engineer"
      },
      {
        category: "nuclear power company"
      },
      {
        category: "nuclear power plant"
      },
      {
        category: "nudist club"
      },
      {
        category: "nudist park"
      },
      {
        category: "nuevo latino restaurant"
      },
      {
        category: "numerologist"
      },
      {
        category: "nurse practitioner"
      },
      {
        category: "nursery"
      },
      {
        category: "nursery school"
      },
      {
        category: "nursing agency"
      },
      {
        category: "nursing association"
      },
      {
        category: "nursing college"
      },
      {
        category: "nursing home"
      },
      {
        category: "nursing room"
      },
      {
        category: "nursing school"
      },
      {
        category: "nut shop"
      },
      {
        category: "nut store"
      },
      {
        category: "nutritionist"
      },
      {
        category: "nyonya restaurant"
      },
      {
        category: "oaxacan restaurant"
      },
      {
        category: "obanzai restaurant"
      },
      {
        category: "observation deck"
      },
      {
        category: "observatory"
      },
      {
        category: "obstetrician-gynecologist"
      },
      {
        category: "occupational health service"
      },
      {
        category: "occupational medical doctor"
      },
      {
        category: "occupational medical physician"
      },
      {
        category: "occupational safety and health"
      },
      {
        category: "occupational therapist"
      },
      {
        category: "ocean"
      },
      {
        category: "ocean rock exposed"
      },
      {
        category: "oden restaurant"
      },
      {
        category: "off licence"
      },
      {
        category: "off roading area"
      },
      {
        category: "off track betting shop"
      },
      {
        category: "off-licence"
      },
      {
        category: "off-road area"
      },
      {
        category: "off-road race track"
      },
      {
        category: "offal barbecue restaurant"
      },
      {
        category: "offal pot cooking restaurant"
      },
      {
        category: "office"
      },
      {
        category: "office accessories wholesaler"
      },
      {
        category: "office administration service"
      },
      {
        category: "office building"
      },
      {
        category: "office equipment rental company"
      },
      {
        category: "office equipment rental service"
      },
      {
        category: "office equipment repair service"
      },
      {
        category: "office equipment supplier"
      },
      {
        category: "office furniture shop"
      },
      {
        category: "office furniture store"
      },
      {
        category: "office of vital records"
      },
      {
        category: "office refurbishment service"
      },
      {
        category: "office rental agency"
      },
      {
        category: "office services"
      },
      {
        category: "office space rental agency"
      },
      {
        category: "office supplies shop"
      },
      {
        category: "office supply"
      },
      {
        category: "office supply store"
      },
      {
        category: "office supply wholesaler"
      },
      {
        category: "oil & natural gas company"
      },
      {
        category: "oil and gas exploration service"
      },
      {
        category: "oil change service"
      },
      {
        category: "oil field equipment supplier"
      },
      {
        category: "oil recycling and disposal"
      },
      {
        category: "oil refinery"
      },
      {
        category: "oil store"
      },
      {
        category: "oil wholesaler"
      },
      {
        category: "oilfield"
      },
      {
        category: "okonomiyaki restaurant"
      },
      {
        category: "oldsmobile dealer"
      },
      {
        category: "olive oil bottling company"
      },
      {
        category: "olive oil cooperative"
      },
      {
        category: "olive oil manufacturer"
      },
      {
        category: "oncologist"
      },
      {
        category: "opel dealer"
      },
      {
        category: "open air museum"
      },
      {
        category: "open university"
      },
      {
        category: "open-air museum"
      },
      {
        category: "opera company"
      },
      {
        category: "opera house"
      },
      {
        category: "ophthalmologist"
      },
      {
        category: "ophthalmology clinic"
      },
      {
        category: "optical products manufacturer"
      },
      {
        category: "optical wholesaler"
      },
      {
        category: "optician"
      },
      {
        category: "optometrist"
      },
      {
        category: "oral and maxillofacial surgeon"
      },
      {
        category: "oral surgeon"
      },
      {
        category: "orchard"
      },
      {
        category: "orchestra"
      },
      {
        category: "orchid farm"
      },
      {
        category: "orchid grower"
      },
      {
        category: "organ donation and tissue bank"
      },
      {
        category: "organic"
      },
      {
        category: "organic drug store"
      },
      {
        category: "organic farm"
      },
      {
        category: "organic food shop"
      },
      {
        category: "organic food store"
      },
      {
        category: "organic pharmacy"
      },
      {
        category: "organic restaurant"
      },
      {
        category: "organic shop"
      },
      {
        category: "oriental goods shop"
      },
      {
        category: "oriental goods store"
      },
      {
        category: "oriental medical clinic"
      },
      {
        category: "oriental medicine clinic"
      },
      {
        category: "oriental medicine store"
      },
      {
        category: "oriental rug shop"
      },
      {
        category: "oriental rug store"
      },
      {
        category: "orphan asylum"
      },
      {
        category: "orphanage"
      },
      {
        category: "orthodontist"
      },
      {
        category: "orthodox church"
      },
      {
        category: "orthodox synagogue"
      },
      {
        category: "orthopaedic shoe shop"
      },
      {
        category: "orthopaedic surgeon"
      },
      {
        category: "orthopedic clinic"
      },
      {
        category: "orthopedic shoe store"
      },
      {
        category: "orthopedic surgeon"
      },
      {
        category: "orthoptist"
      },
      {
        category: "orthotics & prosthetics service"
      },
      {
        category: "osteopath"
      },
      {
        category: "otolaryngologist"
      },
      {
        category: "otolaryngology clinic"
      },
      {
        category: "outboard motor shop"
      },
      {
        category: "outboard motor store"
      },
      {
        category: "outdoor activities"
      },
      {
        category: "outdoor activity organiser"
      },
      {
        category: "outdoor bath"
      },
      {
        category: "outdoor cinema"
      },
      {
        category: "outdoor clothing and equipment shop"
      },
      {
        category: "outdoor equestrian facility"
      },
      {
        category: "outdoor furniture shop"
      },
      {
        category: "outdoor furniture store"
      },
      {
        category: "outdoor movie theater"
      },
      {
        category: "outdoor sports shop"
      },
      {
        category: "outdoor sports store"
      },
      {
        category: "outdoor swimming pool"
      },
      {
        category: "outerwear shop"
      },
      {
        category: "outerwear store"
      },
      {
        category: "outlet"
      },
      {
        category: "outlet mall"
      },
      {
        category: "outlet store"
      },
      {
        category: "oxygen cocktail spot"
      },
      {
        category: "oxygen equipment supplier"
      },
      {
        category: "oyster bar restaurant"
      },
      {
        category: "oyster supplier"
      },
      {
        category: "paan shop"
      },
      {
        category: "pachinko parlor"
      },
      {
        category: "pacific northwest restaurant (canada)"
      },
      {
        category: "pacific northwest restaurant (us)"
      },
      {
        category: "pacific rim restaurant"
      },
      {
        category: "package locker"
      },
      {
        category: "packaging company"
      },
      {
        category: "packaging contractors and services"
      },
      {
        category: "packaging machinery"
      },
      {
        category: "packaging supply shop"
      },
      {
        category: "packaging supply store"
      },
      {
        category: "packed lunch supplier"
      },
      {
        category: "padang restaurant"
      },
      {
        category: "padel club"
      },
      {
        category: "padel court"
      },
      {
        category: "paediatric cardiologist"
      },
      {
        category: "paediatric dentist"
      },
      {
        category: "paediatric ophthalmologist"
      },
      {
        category: "pagoda"
      },
      {
        category: "pain control clinic"
      },
      {
        category: "pain management doctor"
      },
      {
        category: "pain management physician"
      },
      {
        category: "paint manufacturer"
      },
      {
        category: "paint shop"
      },
      {
        category: "paint store"
      },
      {
        category: "paint stripping company"
      },
      {
        category: "paintball center"
      },
      {
        category: "paintball centre"
      },
      {
        category: "paintball shop"
      },
      {
        category: "paintball store"
      },
      {
        category: "painter"
      },
      {
        category: "painter and decorator"
      },
      {
        category: "painting"
      },
      {
        category: "painting lessons"
      },
      {
        category: "painting studio"
      },
      {
        category: "paintings store"
      },
      {
        category: "pakistani restaurant"
      },
      {
        category: "palace"
      },
      {
        category: "pallet supplier"
      },
      {
        category: "pan-asian restaurant"
      },
      {
        category: "pan-latin restaurant"
      },
      {
        category: "pancake restaurant"
      },
      {
        category: "pantry"
      },
      {
        category: "paper bag supplier"
      },
      {
        category: "paper distributor"
      },
      {
        category: "paper exporter"
      },
      {
        category: "paper industry"
      },
      {
        category: "paper mill"
      },
      {
        category: "paper shop"
      },
      {
        category: "paper shredding machine supplier"
      },
      {
        category: "paper store"
      },
      {
        category: "paraguayan restaurant"
      },
      {
        category: "paralegal services provider"
      },
      {
        category: "parapharmacy"
      },
      {
        category: "parasailing ride service"
      },
      {
        category: "parish"
      },
      {
        category: "park"
      },
      {
        category: "park & ride"
      },
      {
        category: "park and garden"
      },
      {
        category: "park and ride"
      },
      {
        category: "parking"
      },
      {
        category: "parking area for bicycles"
      },
      {
        category: "parking area for motorcycles"
      },
      {
        category: "parking garage"
      },
      {
        category: "parking lot"
      },
      {
        category: "parking lot for bicycles"
      },
      {
        category: "parking lot for motorcycles"
      },
      {
        category: "parking ticket vending machine"
      },
      {
        category: "parkour spot"
      },
      {
        category: "parochial school"
      },
      {
        category: "parsi temple"
      },
      {
        category: "part time daycare"
      },
      {
        category: "party"
      },
      {
        category: "party equipment rental service"
      },
      {
        category: "party planner"
      },
      {
        category: "party service"
      },
      {
        category: "party shop"
      },
      {
        category: "party store"
      },
      {
        category: "passport agent"
      },
      {
        category: "passport office"
      },
      {
        category: "passport photo processor"
      },
      {
        category: "pasta shop"
      },
      {
        category: "pastry shop"
      },
      {
        category: "patent attorney"
      },
      {
        category: "patent lawyer"
      },
      {
        category: "patent office"
      },
      {
        category: "paternity testing service"
      },
      {
        category: "pathologist"
      },
      {
        category: "patients support association"
      },
      {
        category: "patio enclosure supplier"
      },
      {
        category: "patisserie"
      },
      {
        category: "paved area"
      },
      {
        category: "paving contractor"
      },
      {
        category: "paving materials supplier"
      },
      {
        category: "pawn shop"
      },
      {
        category: "payphone"
      },
      {
        category: "payroll service"
      },
      {
        category: "pedestrian zone"
      },
      {
        category: "pediatric cardiologist"
      },
      {
        category: "pediatric clinic"
      },
      {
        category: "pediatric dentist"
      },
      {
        category: "pediatric dentistry clinic"
      },
      {
        category: "pediatric dermatologist"
      },
      {
        category: "pediatric endocrinologist"
      },
      {
        category: "pediatric gastroenterologist"
      },
      {
        category: "pediatric hematologist"
      },
      {
        category: "pediatric nephrologist"
      },
      {
        category: "pediatric neurologist"
      },
      {
        category: "pediatric oncologist"
      },
      {
        category: "pediatric ophthalmologist"
      },
      {
        category: "pediatric orthopedic surgeon"
      },
      {
        category: "pediatric pulmonologist"
      },
      {
        category: "pediatric rheumatologist"
      },
      {
        category: "pediatric surgeon"
      },
      {
        category: "pediatric urologist"
      },
      {
        category: "pediatrician"
      },
      {
        category: "pen store"
      },
      {
        category: "peninsula"
      },
      {
        category: "pennsylvania dutch restaurant"
      },
      {
        category: "pension office"
      },
      {
        category: "pentecostal church"
      },
      {
        category: "performing arts"
      },
      {
        category: "performing arts group"
      },
      {
        category: "performing arts theater"
      },
      {
        category: "performing arts theatre"
      },
      {
        category: "perfume store"
      },
      {
        category: "perinatal center"
      },
      {
        category: "periodontist"
      },
      {
        category: "permanent make-up clinic"
      },
      {
        category: "persian restaurant"
      },
      {
        category: "personal injury attorney"
      },
      {
        category: "personal injury lawyer"
      },
      {
        category: "personal repair service"
      },
      {
        category: "personal trainer"
      },
      {
        category: "personal trucking service"
      },
      {
        category: "peruvian restaurant"
      },
      {
        category: "pest control service"
      },
      {
        category: "pet adoption service"
      },
      {
        category: "pet boarding service"
      },
      {
        category: "pet care"
      },
      {
        category: "pet care service"
      },
      {
        category: "pet care store"
      },
      {
        category: "pet cemetery"
      },
      {
        category: "pet food and animal feeds"
      },
      {
        category: "pet friendly accommodation"
      },
      {
        category: "pet funeral service"
      },
      {
        category: "pet groomer"
      },
      {
        category: "pet moving service"
      },
      {
        category: "pet shop"
      },
      {
        category: "pet sitter"
      },
      {
        category: "pet store"
      },
      {
        category: "pet supply store"
      },
      {
        category: "pet trainer"
      },
      {
        category: "petrochemical engineer"
      },
      {
        category: "petrol station"
      },
      {
        category: "petroleum products company"
      },
      {
        category: "pets"
      },
      {
        category: "peugeot dealer"
      },
      {
        category: "pharmaceutical"
      },
      {
        category: "pharmaceutical company"
      },
      {
        category: "pharmaceutical lab"
      },
      {
        category: "pharmaceutical products wholesaler"
      },
      {
        category: "pharmacy"
      },
      {
        category: "philharmonic hall"
      },
      {
        category: "pho restaurant"
      },
      {
        category: "phone repair service"
      },
      {
        category: "photo agency"
      },
      {
        category: "photo booth"
      },
      {
        category: "photo lab"
      },
      {
        category: "photo restoration service"
      },
      {
        category: "photo shop"
      },
      {
        category: "photocopiers supplier"
      },
      {
        category: "photographer"
      },
      {
        category: "photography"
      },
      {
        category: "photography class"
      },
      {
        category: "photography school"
      },
      {
        category: "photography service"
      },
      {
        category: "photography shop"
      },
      {
        category: "photography studio"
      },
      {
        category: "physiatrist"
      },
      {
        category: "physical examination center"
      },
      {
        category: "physical examination centre"
      },
      {
        category: "physical fitness program"
      },
      {
        category: "physical fitness programme"
      },
      {
        category: "physical therapist"
      },
      {
        category: "physical therapy clinic"
      },
      {
        category: "physician assistant"
      },
      {
        category: "physician referral service"
      },
      {
        category: "physiotherapist"
      },
      {
        category: "physiotherapy center"
      },
      {
        category: "physiotherapy equipment supplier"
      },
      {
        category: "piano"
      },
      {
        category: "piano bar"
      },
      {
        category: "piano instructor"
      },
      {
        category: "piano maker"
      },
      {
        category: "piano moving service"
      },
      {
        category: "piano repair service"
      },
      {
        category: "piano shop"
      },
      {
        category: "piano store"
      },
      {
        category: "piano tuner"
      },
      {
        category: "piano tuning and repair service"
      },
      {
        category: "piano tuning service"
      },
      {
        category: "pick your own farm produce"
      },
      {
        category: "picnic ground"
      },
      {
        category: "picture frame shop"
      },
      {
        category: "picture framing shop"
      },
      {
        category: "pie shop"
      },
      {
        category: "piedmontese restaurant"
      },
      {
        category: "pier"
      },
      {
        category: "pig farm"
      },
      {
        category: "pilates studio"
      },
      {
        category: "pile driver"
      },
      {
        category: "pilgrimage place"
      },
      {
        category: "pinatas supplier"
      },
      {
        category: "pinball machine supplier"
      },
      {
        category: "pine furniture shop"
      },
      {
        category: "pipe manufacturer"
      },
      {
        category: "pipe supplier"
      },
      {
        category: "pipes wholesaler"
      },
      {
        category: "pitch and putt course"
      },
      {
        category: "pizza delivery"
      },
      {
        category: "pizza restaurant"
      },
      {
        category: "pizza takeaway"
      },
      {
        category: "pizza takeout"
      },
      {
        category: "place"
      },
      {
        category: "place of worship"
      },
      {
        category: "places of interest"
      },
      {
        category: "planetarium"
      },
      {
        category: "plant and machinery hire"
      },
      {
        category: "plant nursery"
      },
      {
        category: "plast window shop"
      },
      {
        category: "plast window store"
      },
      {
        category: "plasterer"
      },
      {
        category: "plastic bag supplier"
      },
      {
        category: "plastic bags wholesaler"
      },
      {
        category: "plastic fabrication company"
      },
      {
        category: "plastic injection molding service"
      },
      {
        category: "plastic products supplier"
      },
      {
        category: "plastic resin manufacturer"
      },
      {
        category: "plastic surgeon"
      },
      {
        category: "plastic surgery clinic"
      },
      {
        category: "plastic wholesaler"
      },
      {
        category: "plateau"
      },
      {
        category: "plating service"
      },
      {
        category: "play school"
      },
      {
        category: "playground"
      },
      {
        category: "playground equipment supplier"
      },
      {
        category: "playgroup"
      },
      {
        category: "playroom"
      },
      {
        category: "plaza"
      },
      {
        category: "plumber"
      },
      {
        category: "plumbers’ merchant"
      },
      {
        category: "plumbing"
      },
      {
        category: "plumbing supply store"
      },
      {
        category: "plus size clothing shop"
      },
      {
        category: "plus size clothing store"
      },
      {
        category: "plywood supplier"
      },
      {
        category: "pneumatic tools supplier"
      },
      {
        category: "po’ boy restaurant"
      },
      {
        category: "podiatrist"
      },
      {
        category: "poke bar"
      },
      {
        category: "pole"
      },
      {
        category: "police"
      },
      {
        category: "police academy"
      },
      {
        category: "police box"
      },
      {
        category: "police court"
      },
      {
        category: "police department"
      },
      {
        category: "police station"
      },
      {
        category: "police supply shop"
      },
      {
        category: "police supply store"
      },
      {
        category: "polish restaurant"
      },
      {
        category: "political party"
      },
      {
        category: "political party office"
      },
      {
        category: "pollution inspection station"
      },
      {
        category: "polo club"
      },
      {
        category: "polygraph service"
      },
      {
        category: "polymer supplier"
      },
      {
        category: "polynesian restaurant"
      },
      {
        category: "polytechnic"
      },
      {
        category: "polythene and plastic sheeting supplier"
      },
      {
        category: "pond"
      },
      {
        category: "pond contractor"
      },
      {
        category: "pond fish supplier"
      },
      {
        category: "pond supply shop"
      },
      {
        category: "pond supply store"
      },
      {
        category: "pontiac dealer"
      },
      {
        category: "pony club"
      },
      {
        category: "pony ride service"
      },
      {
        category: "pool academy"
      },
      {
        category: "pool billard club"
      },
      {
        category: "pool cleaning service"
      },
      {
        category: "pool hall"
      },
      {
        category: "popcorn shop"
      },
      {
        category: "popcorn store"
      },
      {
        category: "porridge restaurant"
      },
      {
        category: "porsche dealer"
      },
      {
        category: "port"
      },
      {
        category: "port authority"
      },
      {
        category: "port master"
      },
      {
        category: "port operating company"
      },
      {
        category: "portable building manufacturer"
      },
      {
        category: "portable toilet supplier"
      },
      {
        category: "portrait studio"
      },
      {
        category: "portuguese restaurant"
      },
      {
        category: "post office"
      },
      {
        category: "post office/courier"
      },
      {
        category: "post town"
      },
      {
        category: "postal code"
      },
      {
        category: "postbox rental service"
      },
      {
        category: "postbox supplier"
      },
      {
        category: "poster shop"
      },
      {
        category: "poster store"
      },
      {
        category: "pottery"
      },
      {
        category: "pottery classes"
      },
      {
        category: "pottery manufacturer"
      },
      {
        category: "pottery shop"
      },
      {
        category: "pottery store"
      },
      {
        category: "poultry farm"
      },
      {
        category: "poultry shop"
      },
      {
        category: "poultry store"
      },
      {
        category: "pound shop"
      },
      {
        category: "powder coating service"
      },
      {
        category: "power plant consultant"
      },
      {
        category: "power plant equipment supplier"
      },
      {
        category: "power station"
      },
      {
        category: "power station equipment supplier"
      },
      {
        category: "pozole restaurant"
      },
      {
        category: "po’ boys restaurant"
      },
      {
        category: "prawn fishing"
      },
      {
        category: "pre gymnasium school"
      },
      {
        category: "pre-school"
      },
      {
        category: "precision engineer"
      },
      {
        category: "prefabricated house companies"
      },
      {
        category: "prefecture"
      },
      {
        category: "pregnancy care center"
      },
      {
        category: "pregnancy care centre"
      },
      {
        category: "preparatory school"
      },
      {
        category: "presbyterian church"
      },
      {
        category: "preschool"
      },
      {
        category: "press advisory"
      },
      {
        category: "pressure washing service"
      },
      {
        category: "pretzel shop"
      },
      {
        category: "pretzel store"
      },
      {
        category: "priest"
      },
      {
        category: "primary care trust"
      },
      {
        category: "primary school"
      },
      {
        category: "print services"
      },
      {
        category: "print shop"
      },
      {
        category: "printed music publisher"
      },
      {
        category: "printer ink refill shop"
      },
      {
        category: "printer ink refill store"
      },
      {
        category: "printer repair service"
      },
      {
        category: "printing"
      },
      {
        category: "printing equipment and supplies"
      },
      {
        category: "printing equipment supplier"
      },
      {
        category: "printing shop"
      },
      {
        category: "prison"
      },
      {
        category: "private college"
      },
      {
        category: "private educational institution"
      },
      {
        category: "private equity firm"
      },
      {
        category: "private golf course"
      },
      {
        category: "private hospital"
      },
      {
        category: "private investigator"
      },
      {
        category: "private mailbox"
      },
      {
        category: "private school"
      },
      {
        category: "private sector bank"
      },
      {
        category: "private tutor"
      },
      {
        category: "private university"
      },
      {
        category: "probation office"
      },
      {
        category: "process server"
      },
      {
        category: "proctologist"
      },
      {
        category: "produce market"
      },
      {
        category: "produce wholesaler"
      },
      {
        category: "production"
      },
      {
        category: "professional and hobby associations"
      },
      {
        category: "professional association"
      },
      {
        category: "professional organiser"
      },
      {
        category: "professional organizer"
      },
      {
        category: "professional services"
      },
      {
        category: "project management company"
      },
      {
        category: "promenade"
      },
      {
        category: "promotional products supplier"
      },
      {
        category: "propane supplier"
      },
      {
        category: "propeller shop"
      },
      {
        category: "property administrator"
      },
      {
        category: "property consultant"
      },
      {
        category: "property developer"
      },
      {
        category: "property investment"
      },
      {
        category: "property lawyer"
      },
      {
        category: "property maintenance"
      },
      {
        category: "property management company"
      },
      {
        category: "property rental"
      },
      {
        category: "property rental agency"
      },
      {
        category: "property surveyor"
      },
      {
        category: "property valuer"
      },
      {
        category: "prosthetics"
      },
      {
        category: "prosthodontist"
      },
      {
        category: "protective clothing supplier"
      },
      {
        category: "protestant church"
      },
      {
        category: "provence restaurant"
      },
      {
        category: "provincial council"
      },
      {
        category: "provincial park"
      },
      {
        category: "psychiatric hospital"
      },
      {
        category: "psychiatrist"
      },
      {
        category: "psychic"
      },
      {
        category: "psychoanalyst"
      },
      {
        category: "psychologist"
      },
      {
        category: "psychomotor therapist"
      },
      {
        category: "psychoneurological specialized clinic"
      },
      {
        category: "psychopedagogy clinic"
      },
      {
        category: "psychosomatic medical practitioner"
      },
      {
        category: "psychotherapist"
      },
      {
        category: "pub"
      },
      {
        category: "public amenity house"
      },
      {
        category: "public bath"
      },
      {
        category: "public bathroom"
      },
      {
        category: "public baths"
      },
      {
        category: "public beach"
      },
      {
        category: "public call office booth"
      },
      {
        category: "public defender’s office"
      },
      {
        category: "public educational institution"
      },
      {
        category: "public female bathroom"
      },
      {
        category: "public golf course"
      },
      {
        category: "public health department"
      },
      {
        category: "public housing"
      },
      {
        category: "public library"
      },
      {
        category: "public mailbox"
      },
      {
        category: "public male bathroom"
      },
      {
        category: "public medical center"
      },
      {
        category: "public medical centre"
      },
      {
        category: "public parking lot"
      },
      {
        category: "public parking space"
      },
      {
        category: "public prosecutors office"
      },
      {
        category: "public relations firm"
      },
      {
        category: "public safety office"
      },
      {
        category: "public sauna"
      },
      {
        category: "public school"
      },
      {
        category: "public sector bank"
      },
      {
        category: "public services"
      },
      {
        category: "public swimming pool"
      },
      {
        category: "public toilet"
      },
      {
        category: "public transport"
      },
      {
        category: "public transport station"
      },
      {
        category: "public transport stop"
      },
      {
        category: "public transportation system"
      },
      {
        category: "public university"
      },
      {
        category: "public utility"
      },
      {
        category: "public webcam"
      },
      {
        category: "public wheelchair-accessible bathroom"
      },
      {
        category: "public works department"
      },
      {
        category: "publisher"
      },
      {
        category: "pueblan restaurant"
      },
      {
        category: "puerto rican restaurant"
      },
      {
        category: "pulmonologist"
      },
      {
        category: "pump supplier"
      },
      {
        category: "pumping equipment and service"
      },
      {
        category: "pumpkin patch"
      },
      {
        category: "pumps"
      },
      {
        category: "punjabi restaurant"
      },
      {
        category: "puppet theater"
      },
      {
        category: "puppet theatre"
      },
      {
        category: "pvc industry"
      },
      {
        category: "pvc windows supplier"
      },
      {
        category: "pyramid"
      },
      {
        category: "qing fang market place"
      },
      {
        category: "quaker church"
      },
      {
        category: "quantity surveyor"
      },
      {
        category: "quarry"
      },
      {
        category: "quilt shop"
      },
      {
        category: "québécois restaurant"
      },
      {
        category: "race car dealer"
      },
      {
        category: "racecourse"
      },
      {
        category: "racetrack"
      },
      {
        category: "racing car dealer"
      },
      {
        category: "racing car parts shop"
      },
      {
        category: "racing car parts store"
      },
      {
        category: "rack"
      },
      {
        category: "raclette restaurant"
      },
      {
        category: "racquetball club"
      },
      {
        category: "radiator repair service"
      },
      {
        category: "radiator shop"
      },
      {
        category: "radio broadcaster"
      },
      {
        category: "radio tower"
      },
      {
        category: "radiologist"
      },
      {
        category: "raft trip outfitter"
      },
      {
        category: "rafting"
      },
      {
        category: "rail depot"
      },
      {
        category: "rail museum"
      },
      {
        category: "railing contractor"
      },
      {
        category: "railroad company"
      },
      {
        category: "railroad contractor"
      },
      {
        category: "railroad equipment supplier"
      },
      {
        category: "railroad ties supplier"
      },
      {
        category: "railway company"
      },
      {
        category: "railway contractor"
      },
      {
        category: "railway equipment supplier"
      },
      {
        category: "railway services"
      },
      {
        category: "rainwater tank supplier"
      },
      {
        category: "ram dealer"
      },
      {
        category: "ramen restaurant"
      },
      {
        category: "ranch"
      },
      {
        category: "ranching"
      },
      {
        category: "rapids"
      },
      {
        category: "rare book shop"
      },
      {
        category: "rare book store"
      },
      {
        category: "ravine"
      },
      {
        category: "raw food restaurant"
      },
      {
        category: "reading room"
      },
      {
        category: "ready mix concrete supplier"
      },
      {
        category: "ready-mix concrete supplier"
      },
      {
        category: "real estate"
      },
      {
        category: "real estate agency"
      },
      {
        category: "real estate agents"
      },
      {
        category: "real estate appraiser"
      },
      {
        category: "real estate attorney"
      },
      {
        category: "real estate auctioneer"
      },
      {
        category: "real estate college"
      },
      {
        category: "real estate consultant"
      },
      {
        category: "real estate developer"
      },
      {
        category: "real estate fair"
      },
      {
        category: "real estate photographer"
      },
      {
        category: "real estate related services"
      },
      {
        category: "real estate rental"
      },
      {
        category: "real estate rental agency"
      },
      {
        category: "real estate school"
      },
      {
        category: "real estate surveyor"
      },
      {
        category: "reclamation centre"
      },
      {
        category: "record company"
      },
      {
        category: "record shop"
      },
      {
        category: "record store"
      },
      {
        category: "recording studio"
      },
      {
        category: "records storage facility"
      },
      {
        category: "recreation"
      },
      {
        category: "recreation center"
      },
      {
        category: "recreation centre"
      },
      {
        category: "recreational activities"
      },
      {
        category: "recreational vehicle"
      },
      {
        category: "recreational vehicle rental agency"
      },
      {
        category: "recruiter"
      },
      {
        category: "rectory"
      },
      {
        category: "recycling"
      },
      {
        category: "recycling bank location"
      },
      {
        category: "recycling center"
      },
      {
        category: "recycling centre"
      },
      {
        category: "recycling collection company"
      },
      {
        category: "recycling container location"
      },
      {
        category: "recycling drop-off location"
      },
      {
        category: "redevelopment union"
      },
      {
        category: "reef"
      },
      {
        category: "reenactment site"
      },
      {
        category: "reflexologist"
      },
      {
        category: "reform synagogue"
      },
      {
        category: "reformed church"
      },
      {
        category: "refrigerated transport service"
      },
      {
        category: "refrigerator repair service"
      },
      {
        category: "refrigerator shop"
      },
      {
        category: "refrigerator store"
      },
      {
        category: "refugee camp"
      },
      {
        category: "regional airport"
      },
      {
        category: "regional council"
      },
      {
        category: "regional government office"
      },
      {
        category: "regional labor office"
      },
      {
        category: "registered general nurse"
      },
      {
        category: "registration chamber"
      },
      {
        category: "registration office"
      },
      {
        category: "registry office"
      },
      {
        category: "rehabilitation"
      },
      {
        category: "rehabilitation center"
      },
      {
        category: "rehabilitation centre"
      },
      {
        category: "rehearsal studio"
      },
      {
        category: "reiki therapist"
      },
      {
        category: "religious book shop"
      },
      {
        category: "religious book store"
      },
      {
        category: "religious destination"
      },
      {
        category: "religious goods shop"
      },
      {
        category: "religious goods store"
      },
      {
        category: "religious institution"
      },
      {
        category: "religious organisation"
      },
      {
        category: "religious organization"
      },
      {
        category: "religious school"
      },
      {
        category: "remodeler"
      },
      {
        category: "remodeller"
      },
      {
        category: "removals company"
      },
      {
        category: "removals service"
      },
      {
        category: "renault dealer"
      },
      {
        category: "renovation contractor"
      },
      {
        category: "rental"
      },
      {
        category: "renter’s insurance agency"
      },
      {
        category: "repair service"
      },
      {
        category: "repairs"
      },
      {
        category: "reproductive health clinic"
      },
      {
        category: "reptile shop"
      },
      {
        category: "reptile store"
      },
      {
        category: "rescue squad"
      },
      {
        category: "research and development"
      },
      {
        category: "research and product development"
      },
      {
        category: "research engineer"
      },
      {
        category: "research foundation"
      },
      {
        category: "research institute"
      },
      {
        category: "reservoir"
      },
      {
        category: "resident registration office"
      },
      {
        category: "residential area"
      },
      {
        category: "residential college"
      },
      {
        category: "residents association"
      },
      {
        category: "resort"
      },
      {
        category: "resort hotel"
      },
      {
        category: "rest stop"
      },
      {
        category: "restaurant"
      },
      {
        category: "restaurant or cafe"
      },
      {
        category: "restaurant supply store"
      },
      {
        category: "resume service"
      },
      {
        category: "retail space rental agency"
      },
      {
        category: "retaining wall supplier"
      },
      {
        category: "retirement centre"
      },
      {
        category: "retirement community"
      },
      {
        category: "retirement home"
      },
      {
        category: "retirement village"
      },
      {
        category: "retreat center"
      },
      {
        category: "retreat centre"
      },
      {
        category: "rheumatologist"
      },
      {
        category: "rice cake shop"
      },
      {
        category: "rice cracker shop"
      },
      {
        category: "rice dealer"
      },
      {
        category: "rice mill"
      },
      {
        category: "rice restaurant"
      },
      {
        category: "rice shop"
      },
      {
        category: "rice wholesaler"
      },
      {
        category: "ridge"
      },
      {
        category: "ritual services"
      },
      {
        category: "river"
      },
      {
        category: "river confluence"
      },
      {
        category: "river port"
      },
      {
        category: "road construction company"
      },
      {
        category: "road construction machine repair service"
      },
      {
        category: "road cycling"
      },
      {
        category: "road safety town"
      },
      {
        category: "roads ports and canals engineers association"
      },
      {
        category: "roadside assistance"
      },
      {
        category: "rock"
      },
      {
        category: "rock climbing"
      },
      {
        category: "rock climbing gym"
      },
      {
        category: "rock climbing instructor"
      },
      {
        category: "rock music club"
      },
      {
        category: "rock shop"
      },
      {
        category: "rocky"
      },
      {
        category: "rodeo"
      },
      {
        category: "rolled metal products supplier"
      },
      {
        category: "roller coaster"
      },
      {
        category: "roller skating club"
      },
      {
        category: "roller skating rink"
      },
      {
        category: "rolls royce dealer"
      },
      {
        category: "roman restaurant"
      },
      {
        category: "romanian restaurant"
      },
      {
        category: "roofing contractor"
      },
      {
        category: "roofing service"
      },
      {
        category: "roofing supply shop"
      },
      {
        category: "roofing supply store"
      },
      {
        category: "room"
      },
      {
        category: "room agency"
      },
      {
        category: "roommate referral service"
      },
      {
        category: "rowing area"
      },
      {
        category: "rowing club"
      },
      {
        category: "rsl club"
      },
      {
        category: "rubber products supplier"
      },
      {
        category: "rubber stamp shop"
      },
      {
        category: "rubber stamp store"
      },
      {
        category: "rug shop"
      },
      {
        category: "rug store"
      },
      {
        category: "rugby"
      },
      {
        category: "rugby club"
      },
      {
        category: "rugby field"
      },
      {
        category: "rugby league club"
      },
      {
        category: "rugby shop"
      },
      {
        category: "rugby store"
      },
      {
        category: "ruin"
      },
      {
        category: "running shop"
      },
      {
        category: "running store"
      },
      {
        category: "russian grocery store"
      },
      {
        category: "russian orthodox church"
      },
      {
        category: "russian restaurant"
      },
      {
        category: "rustic furniture shop"
      },
      {
        category: "rustic furniture store"
      },
      {
        category: "rv dealer"
      },
      {
        category: "rv park"
      },
      {
        category: "rv repair shop"
      },
      {
        category: "rv storage facility"
      },
      {
        category: "rv supply store"
      },
      {
        category: "ryotei restaurant"
      },
      {
        category: "saab dealer"
      },
      {
        category: "sacem"
      },
      {
        category: "saddlery"
      },
      {
        category: "safe & vault shop"
      },
      {
        category: "safety equipment supplier"
      },
      {
        category: "sailing club"
      },
      {
        category: "sailing event area"
      },
      {
        category: "sailing school"
      },
      {
        category: "sailmaker"
      },
      {
        category: "sake brewery"
      },
      {
        category: "salad shop"
      },
      {
        category: "salsa bar"
      },
      {
        category: "salsa classes"
      },
      {
        category: "salt flat"
      },
      {
        category: "salvadoran restaurant"
      },
      {
        category: "salvage dealer"
      },
      {
        category: "salvage yard"
      },
      {
        category: "samba school"
      },
      {
        category: "sambodrome"
      },
      {
        category: "sanctuary"
      },
      {
        category: "sand"
      },
      {
        category: "sand & gravel supplier"
      },
      {
        category: "sand and gravel supplier"
      },
      {
        category: "sand plant"
      },
      {
        category: "sandblasting service"
      },
      {
        category: "sandwich shop"
      },
      {
        category: "sanitary inspection"
      },
      {
        category: "sanitation service"
      },
      {
        category: "sardinian restaurant"
      },
      {
        category: "saree shop"
      },
      {
        category: "satay restaurant"
      },
      {
        category: "satellite communication service"
      },
      {
        category: "saturn dealer"
      },
      {
        category: "sauna"
      },
      {
        category: "sauna club"
      },
      {
        category: "sauna shop"
      },
      {
        category: "sauna store"
      },
      {
        category: "savings bank"
      },
      {
        category: "saw mill"
      },
      {
        category: "saw sharpening service"
      },
      {
        category: "scaffolder"
      },
      {
        category: "scaffolding"
      },
      {
        category: "scaffolding rental service"
      },
      {
        category: "scaffolding service"
      },
      {
        category: "scale model club"
      },
      {
        category: "scale repair service"
      },
      {
        category: "scale supplier"
      },
      {
        category: "scandinavian restaurant"
      },
      {
        category: "scenic point"
      },
      {
        category: "scenic spot"
      },
      {
        category: "school"
      },
      {
        category: "school administrator"
      },
      {
        category: "school bus service"
      },
      {
        category: "school center"
      },
      {
        category: "school centre"
      },
      {
        category: "school district office"
      },
      {
        category: "school for the deaf"
      },
      {
        category: "school house"
      },
      {
        category: "school lunch center"
      },
      {
        category: "school lunch centre"
      },
      {
        category: "school of computing"
      },
      {
        category: "school supply shop"
      },
      {
        category: "school supply store"
      },
      {
        category: "science academy"
      },
      {
        category: "science museum"
      },
      {
        category: "scientific equipment supplier"
      },
      {
        category: "scooter rental service"
      },
      {
        category: "scooter repair shop"
      },
      {
        category: "scottish restaurant"
      },
      {
        category: "scout hall"
      },
      {
        category: "scout home"
      },
      {
        category: "scouting"
      },
      {
        category: "scrap metal dealer"
      },
      {
        category: "scrap yard"
      },
      {
        category: "scrapbooking store"
      },
      {
        category: "screen golf driving range"
      },
      {
        category: "screen printer"
      },
      {
        category: "screen printing shop"
      },
      {
        category: "screen printing supply shop"
      },
      {
        category: "screen printing supply store"
      },
      {
        category: "screen repair service"
      },
      {
        category: "screen shop"
      },
      {
        category: "screen store"
      },
      {
        category: "screw supplier"
      },
      {
        category: "scuba diving"
      },
      {
        category: "scuba instructor"
      },
      {
        category: "scuba tour agency"
      },
      {
        category: "sculptor"
      },
      {
        category: "sculpture"
      },
      {
        category: "sculpture museum"
      },
      {
        category: "sea"
      },
      {
        category: "seafood"
      },
      {
        category: "seafood donburi restaurant"
      },
      {
        category: "seafood farm"
      },
      {
        category: "seafood market"
      },
      {
        category: "seafood restaurant"
      },
      {
        category: "seafood shop"
      },
      {
        category: "seafood store"
      },
      {
        category: "seafood wholesaler"
      },
      {
        category: "seal shop"
      },
      {
        category: "seaplane base"
      },
      {
        category: "seaport"
      },
      {
        category: "seasonal goods shop"
      },
      {
        category: "seasonal goods store"
      },
      {
        category: "seasonal lake"
      },
      {
        category: "seat dealer"
      },
      {
        category: "seating area"
      },
      {
        category: "second hand store"
      },
      {
        category: "second-hand bicycle shop"
      },
      {
        category: "second-hand book shop"
      },
      {
        category: "second-hand cd shop"
      },
      {
        category: "second-hand clothing shop"
      },
      {
        category: "second-hand computer shop"
      },
      {
        category: "second-hand furniture shop"
      },
      {
        category: "second-hand motorcycle dealer"
      },
      {
        category: "second-hand shop"
      },
      {
        category: "secondary school"
      },
      {
        category: "secondary school three"
      },
      {
        category: "secondary walkway"
      },
      {
        category: "secondhand shop"
      },
      {
        category: "security"
      },
      {
        category: "security bureau"
      },
      {
        category: "security checkpoint"
      },
      {
        category: "security guard service"
      },
      {
        category: "security service"
      },
      {
        category: "security system installer"
      },
      {
        category: "security system supplier"
      },
      {
        category: "security-checked area"
      },
      {
        category: "seed supplier"
      },
      {
        category: "seitai"
      },
      {
        category: "self check-in kiosk"
      },
      {
        category: "self defence school"
      },
      {
        category: "self defense school"
      },
      {
        category: "self service car wash"
      },
      {
        category: "self service health station"
      },
      {
        category: "self service restaurant"
      },
      {
        category: "self storage facility"
      },
      {
        category: "self-catering accommodation"
      },
      {
        category: "self-storage facility"
      },
      {
        category: "semi conductor supplier"
      },
      {
        category: "seminar room"
      },
      {
        category: "seminary"
      },
      {
        category: "senior citizen center"
      },
      {
        category: "senior high school"
      },
      {
        category: "septic system service"
      },
      {
        category: "septic tank cleaning service"
      },
      {
        category: "septic tank service"
      },
      {
        category: "serbian restaurant"
      },
      {
        category: "server room"
      },
      {
        category: "service counter"
      },
      {
        category: "service establishment"
      },
      {
        category: "serviced accommodation"
      },
      {
        category: "serviced apartment"
      },
      {
        category: "services"
      },
      {
        category: "seventh-day adventist church"
      },
      {
        category: "sewage disposal service"
      },
      {
        category: "sewage treatment plant"
      },
      {
        category: "sewing company"
      },
      {
        category: "sewing machine repair service"
      },
      {
        category: "sewing machine shop"
      },
      {
        category: "sewing machine store"
      },
      {
        category: "sewing shop"
      },
      {
        category: "sexologist"
      },
      {
        category: "seychelles restaurant"
      },
      {
        category: "sfiha restaurant"
      },
      {
        category: "shabu-shabu restaurant"
      },
      {
        category: "shandong restaurant"
      },
      {
        category: "shanghainese restaurant"
      },
      {
        category: "shared-use commercial kitchen"
      },
      {
        category: "sharpening service"
      },
      {
        category: "shawarma restaurant"
      },
      {
        category: "shed builder"
      },
      {
        category: "sheep shearer"
      },
      {
        category: "sheepskin and wool products supplier"
      },
      {
        category: "sheepskin coat store"
      },
      {
        category: "sheet metal contractor"
      },
      {
        category: "sheet music shop"
      },
      {
        category: "sheet music store"
      },
      {
        category: "shelter"
      },
      {
        category: "sheltered housing"
      },
      {
        category: "shelving shop"
      },
      {
        category: "shelving store"
      },
      {
        category: "sheriff’s department"
      },
      {
        category: "shinkin bank"
      },
      {
        category: "shinto shrine"
      },
      {
        category: "ship building"
      },
      {
        category: "shipbuilding and repair company"
      },
      {
        category: "shipping and mailing"
      },
      {
        category: "shipping and mailing service"
      },
      {
        category: "shipping and postal service"
      },
      {
        category: "shipping company"
      },
      {
        category: "shipping equipment industry"
      },
      {
        category: "shipping service"
      },
      {
        category: "shipyard"
      },
      {
        category: "shisha bar"
      },
      {
        category: "shock absorbers & suspension shop"
      },
      {
        category: "shoe factory"
      },
      {
        category: "shoe repair shop"
      },
      {
        category: "shoe shining service"
      },
      {
        category: "shoe shop"
      },
      {
        category: "shoe store"
      },
      {
        category: "shooting event area"
      },
      {
        category: "shooting range"
      },
      {
        category: "shop"
      },
      {
        category: "shop equipment supplier"
      },
      {
        category: "shop supermarket furniture shop"
      },
      {
        category: "shop supermarket furniture store"
      },
      {
        category: "shopfitter"
      },
      {
        category: "shopping centre"
      },
      {
        category: "shopping mall"
      },
      {
        category: "shopping outlet"
      },
      {
        category: "shops and shopping"
      },
      {
        category: "short term apartment rental agency"
      },
      {
        category: "shower door shop"
      },
      {
        category: "shower screen shop"
      },
      {
        category: "shredding service"
      },
      {
        category: "shrimp farm"
      },
      {
        category: "shrine"
      },
      {
        category: "sichuan restaurant"
      },
      {
        category: "sicilian restaurant"
      },
      {
        category: "siding contractor"
      },
      {
        category: "sightseeing tour agency"
      },
      {
        category: "sign shop"
      },
      {
        category: "signwriter and manufacturer"
      },
      {
        category: "silk plant shop"
      },
      {
        category: "silk shop"
      },
      {
        category: "silk store"
      },
      {
        category: "silversmith"
      },
      {
        category: "singaporean restaurant"
      },
      {
        category: "singing telegram service"
      },
      {
        category: "single sex secondary school"
      },
      {
        category: "singles organization"
      },
      {
        category: "sixth form college"
      },
      {
        category: "skate park"
      },
      {
        category: "skate sharpening service"
      },
      {
        category: "skate shop"
      },
      {
        category: "skateboard park"
      },
      {
        category: "skateboard shop"
      },
      {
        category: "skating instructor"
      },
      {
        category: "skeet shooting range"
      },
      {
        category: "ski"
      },
      {
        category: "ski club"
      },
      {
        category: "ski jumping hill"
      },
      {
        category: "ski rental service"
      },
      {
        category: "ski repair service"
      },
      {
        category: "ski resort"
      },
      {
        category: "ski school"
      },
      {
        category: "ski shop"
      },
      {
        category: "ski trail"
      },
      {
        category: "skiing club"
      },
      {
        category: "skin care"
      },
      {
        category: "skin care clinic"
      },
      {
        category: "skin care products vending machine"
      },
      {
        category: "skittle club"
      },
      {
        category: "skoda dealer"
      },
      {
        category: "skydiving center"
      },
      {
        category: "skydiving centre"
      },
      {
        category: "skylight contractor"
      },
      {
        category: "slaughterhouse"
      },
      {
        category: "sleep clinic"
      },
      {
        category: "slope"
      },
      {
        category: "small appliance repair service"
      },
      {
        category: "small claims assistance service"
      },
      {
        category: "small engine repair service"
      },
      {
        category: "small plates restaurant"
      },
      {
        category: "smart car dealer"
      },
      {
        category: "smart dealer"
      },
      {
        category: "smart shop"
      },
      {
        category: "smog inspection station"
      },
      {
        category: "smoking area"
      },
      {
        category: "smoking room"
      },
      {
        category: "snack bar"
      },
      {
        category: "snack vending machine"
      },
      {
        category: "snooker and pool club"
      },
      {
        category: "snow removal service"
      },
      {
        category: "snowboard rental service"
      },
      {
        category: "snowboard shop"
      },
      {
        category: "snowmobile dealer"
      },
      {
        category: "snowmobile rental service"
      },
      {
        category: "soapland"
      },
      {
        category: "soba noodle shop"
      },
      {
        category: "soccer"
      },
      {
        category: "soccer club"
      },
      {
        category: "soccer field"
      },
      {
        category: "soccer practice"
      },
      {
        category: "soccer store"
      },
      {
        category: "social club"
      },
      {
        category: "social court"
      },
      {
        category: "social organization"
      },
      {
        category: "social security attorney"
      },
      {
        category: "social security financial department"
      },
      {
        category: "social security lawyer"
      },
      {
        category: "social security office"
      },
      {
        category: "social services"
      },
      {
        category: "social services organisation"
      },
      {
        category: "social services organization"
      },
      {
        category: "social welfare center"
      },
      {
        category: "social welfare centre"
      },
      {
        category: "social worker"
      },
      {
        category: "societe de flocage"
      },
      {
        category: "sod supplier"
      },
      {
        category: "sofa store"
      },
      {
        category: "soft drinks shop"
      },
      {
        category: "softball club"
      },
      {
        category: "softball field"
      },
      {
        category: "software company"
      },
      {
        category: "software training institute"
      },
      {
        category: "soil testing service"
      },
      {
        category: "sokol house"
      },
      {
        category: "solar energy company"
      },
      {
        category: "solar energy contractor"
      },
      {
        category: "solar energy equipment supplier"
      },
      {
        category: "solar hot water system supplier"
      },
      {
        category: "solar photovoltaic power plant"
      },
      {
        category: "solid fuel company"
      },
      {
        category: "solid waste engineer"
      },
      {
        category: "soondae restaurant"
      },
      {
        category: "soto ayam restaurant"
      },
      {
        category: "soul food restaurant"
      },
      {
        category: "soup kitchen"
      },
      {
        category: "soup restaurant"
      },
      {
        category: "soup shop"
      },
      {
        category: "south african restaurant"
      },
      {
        category: "south american restaurant"
      },
      {
        category: "south asian restaurant"
      },
      {
        category: "south east asian restaurant"
      },
      {
        category: "south indian restaurant"
      },
      {
        category: "southeast asian restaurant"
      },
      {
        category: "southern comfort food restaurant"
      },
      {
        category: "southern italian restaurant"
      },
      {
        category: "southern restaurant (us)"
      },
      {
        category: "southwest france restaurant"
      },
      {
        category: "southwestern restaurant (us)"
      },
      {
        category: "souvenir manufacturer"
      },
      {
        category: "souvenir shop"
      },
      {
        category: "souvenir store"
      },
      {
        category: "soy sauce maker"
      },
      {
        category: "spa"
      },
      {
        category: "spa and health club"
      },
      {
        category: "spa garden"
      },
      {
        category: "spa town"
      },
      {
        category: "spanish restaurant"
      },
      {
        category: "special education school"
      },
      {
        category: "special food and drink"
      },
      {
        category: "specialised clinic"
      },
      {
        category: "specialised hospital"
      },
      {
        category: "specialist book shop"
      },
      {
        category: "specialized clinic"
      },
      {
        category: "specialized hospital"
      },
      {
        category: "specific trade education"
      },
      {
        category: "speech pathologist"
      },
      {
        category: "sperm bank"
      },
      {
        category: "spice shop"
      },
      {
        category: "spice store"
      },
      {
        category: "spices exporter"
      },
      {
        category: "spices wholesalers"
      },
      {
        category: "spiritist center"
      },
      {
        category: "spiritist centre"
      },
      {
        category: "sport tour agency"
      },
      {
        category: "sporting goods shop"
      },
      {
        category: "sporting goods store"
      },
      {
        category: "sports"
      },
      {
        category: "sports accessories wholesaler"
      },
      {
        category: "sports activity location"
      },
      {
        category: "sports association"
      },
      {
        category: "sports bar"
      },
      {
        category: "sports card shop"
      },
      {
        category: "sports card store"
      },
      {
        category: "sports club"
      },
      {
        category: "sports coaching"
      },
      {
        category: "sports complex"
      },
      {
        category: "sports equipment rental service"
      },
      {
        category: "sports injury clinic"
      },
      {
        category: "sports management and promotion"
      },
      {
        category: "sports massage therapist"
      },
      {
        category: "sports medicine clinic"
      },
      {
        category: "sports medicine doctor"
      },
      {
        category: "sports medicine physician"
      },
      {
        category: "sports memorabilia shop"
      },
      {
        category: "sports memorabilia store"
      },
      {
        category: "sports nutrition shop"
      },
      {
        category: "sports nutrition store"
      },
      {
        category: "sports school"
      },
      {
        category: "sportswear shop"
      },
      {
        category: "sportswear store"
      },
      {
        category: "sportwear manufacturer"
      },
      {
        category: "spring"
      },
      {
        category: "spring supplier"
      },
      {
        category: "spur"
      },
      {
        category: "squash club"
      },
      {
        category: "squash court"
      },
      {
        category: "sri lankan restaurant"
      },
      {
        category: "stable"
      },
      {
        category: "stadium"
      },
      {
        category: "stadium seating area"
      },
      {
        category: "staffing agency"
      },
      {
        category: "stage"
      },
      {
        category: "stage lighting equipment supplier"
      },
      {
        category: "stained glass design and material supplier"
      },
      {
        category: "stained glass studio"
      },
      {
        category: "stainless steel plant"
      },
      {
        category: "stair contractor"
      },
      {
        category: "staircase"
      },
      {
        category: "stall installation service"
      },
      {
        category: "stamp collectors club"
      },
      {
        category: "stamp shop"
      },
      {
        category: "stamp vending machine"
      },
      {
        category: "stand bar"
      },
      {
        category: "staple food package"
      },
      {
        category: "state archive"
      },
      {
        category: "state department agricultural development"
      },
      {
        category: "state department agriculture food supply"
      },
      {
        category: "state department civil defense"
      },
      {
        category: "state department communication"
      },
      {
        category: "state department finance"
      },
      {
        category: "state department for social development"
      },
      {
        category: "state department housing and urban development"
      },
      {
        category: "state department of environment"
      },
      {
        category: "state department of tourism"
      },
      {
        category: "state department of transportation"
      },
      {
        category: "state department science technology"
      },
      {
        category: "state department social defense"
      },
      {
        category: "state dept of culture"
      },
      {
        category: "state dept of sports"
      },
      {
        category: "state employment department"
      },
      {
        category: "state government office"
      },
      {
        category: "state liquor store"
      },
      {
        category: "state office of education"
      },
      {
        category: "state owned farm"
      },
      {
        category: "state park"
      },
      {
        category: "state police"
      },
      {
        category: "state social development"
      },
      {
        category: "stationery manufacturer"
      },
      {
        category: "stationery shop"
      },
      {
        category: "stationery store"
      },
      {
        category: "stationery wholesaler"
      },
      {
        category: "statuary"
      },
      {
        category: "statue"
      },
      {
        category: "std clinic"
      },
      {
        category: "std testing service"
      },
      {
        category: "steak house"
      },
      {
        category: "steamboat restaurant"
      },
      {
        category: "steamed bun shop"
      },
      {
        category: "steel construction company"
      },
      {
        category: "steel distributor"
      },
      {
        category: "steel drum supplier"
      },
      {
        category: "steel erector"
      },
      {
        category: "steel fabricator"
      },
      {
        category: "steel framework contractor"
      },
      {
        category: "steel industry"
      },
      {
        category: "steel stockholder and supplier"
      },
      {
        category: "steelwork design company"
      },
      {
        category: "steelwork manufacturer"
      },
      {
        category: "stereo rental store"
      },
      {
        category: "stereo repair service"
      },
      {
        category: "sticker manufacturer"
      },
      {
        category: "stitching class"
      },
      {
        category: "stock broker"
      },
      {
        category: "stock exchange building"
      },
      {
        category: "stone carving"
      },
      {
        category: "stone cutter"
      },
      {
        category: "stone supplier"
      },
      {
        category: "storage"
      },
      {
        category: "storage facility"
      },
      {
        category: "store"
      },
      {
        category: "store equipment supplier"
      },
      {
        category: "stores and shopping"
      },
      {
        category: "stove builder"
      },
      {
        category: "strait"
      },
      {
        category: "stringed instrument maker"
      },
      {
        category: "structural engineer"
      },
      {
        category: "stucco contractor"
      },
      {
        category: "student accommodation centre"
      },
      {
        category: "student career counseling office"
      },
      {
        category: "student dormitory"
      },
      {
        category: "student halls"
      },
      {
        category: "student housing center"
      },
      {
        category: "student union"
      },
      {
        category: "students parents association"
      },
      {
        category: "students support association"
      },
      {
        category: "studio"
      },
      {
        category: "studio apartment"
      },
      {
        category: "study at home school"
      },
      {
        category: "studying center"
      },
      {
        category: "studying centre"
      },
      {
        category: "stylist"
      },
      {
        category: "subaru dealer"
      },
      {
        category: "suburban train line"
      },
      {
        category: "subway station"
      },
      {
        category: "sugar factory"
      },
      {
        category: "sugar shack"
      },
      {
        category: "sukiyaki and shabu shabu restaurant"
      },
      {
        category: "sukiyaki restaurant"
      },
      {
        category: "summer camp"
      },
      {
        category: "summer toboggan run"
      },
      {
        category: "sundae restaurant"
      },
      {
        category: "sundanese restaurant"
      },
      {
        category: "sunglasses shop"
      },
      {
        category: "sunglasses store"
      },
      {
        category: "sunroom contractor"
      },
      {
        category: "super public bath"
      },
      {
        category: "superannuation consultant"
      },
      {
        category: "superfund site"
      },
      {
        category: "superior courts"
      },
      {
        category: "supermarket"
      },
      {
        category: "suppliers"
      },
      {
        category: "suppon restaurant"
      },
      {
        category: "supreme court"
      },
      {
        category: "surety bond service"
      },
      {
        category: "surf lifesaving club"
      },
      {
        category: "surf school"
      },
      {
        category: "surf shop"
      },
      {
        category: "surf spot"
      },
      {
        category: "surgeon"
      },
      {
        category: "surgical center"
      },
      {
        category: "surgical oncologist"
      },
      {
        category: "surgical products wholesaler"
      },
      {
        category: "surgical supply shop"
      },
      {
        category: "surgical supply store"
      },
      {
        category: "surinamese restaurant"
      },
      {
        category: "surplus store"
      },
      {
        category: "surveyor"
      },
      {
        category: "sushi restaurant"
      },
      {
        category: "sushi takeaway"
      },
      {
        category: "suzuki dealer"
      },
      {
        category: "suzuki motorcycle dealer"
      },
      {
        category: "swabian restaurant"
      },
      {
        category: "swedish restaurant"
      },
      {
        category: "sweet shop"
      },
      {
        category: "sweets and dessert buffet"
      },
      {
        category: "swim club"
      },
      {
        category: "swimming"
      },
      {
        category: "swimming basin"
      },
      {
        category: "swimming club"
      },
      {
        category: "swimming competition"
      },
      {
        category: "swimming facility"
      },
      {
        category: "swimming instructor"
      },
      {
        category: "swimming lake"
      },
      {
        category: "swimming pool"
      },
      {
        category: "swimming pool contractor"
      },
      {
        category: "swimming pool repair service"
      },
      {
        category: "swimming pool supply shop"
      },
      {
        category: "swimming pool supply store"
      },
      {
        category: "swimming school"
      },
      {
        category: "swimwear shop"
      },
      {
        category: "swimwear store"
      },
      {
        category: "swiss restaurant"
      },
      {
        category: "synagogue"
      },
      {
        category: "syokudo and teishoku restaurant"
      },
      {
        category: "syrian restaurant"
      },
      {
        category: "t-shirt company"
      },
      {
        category: "t-shirt shop"
      },
      {
        category: "t-shirt store"
      },
      {
        category: "tabascan restaurant"
      },
      {
        category: "table tennis club"
      },
      {
        category: "table tennis facility"
      },
      {
        category: "table tennis supply shop"
      },
      {
        category: "table tennis supply store"
      },
      {
        category: "tacaca restaurant"
      },
      {
        category: "tack shop"
      },
      {
        category: "taco restaurant"
      },
      {
        category: "tae kwon do school"
      },
      {
        category: "taekwondo competition area"
      },
      {
        category: "taekwondo school"
      },
      {
        category: "tag agency"
      },
      {
        category: "tai chi school"
      },
      {
        category: "tailor"
      },
      {
        category: "taiwanese restaurant"
      },
      {
        category: "takeaway"
      },
      {
        category: "takeout restaurant"
      },
      {
        category: "takoyaki restaurant"
      },
      {
        category: "talent agency"
      },
      {
        category: "tamale shop"
      },
      {
        category: "tank"
      },
      {
        category: "tannery"
      },
      {
        category: "tanning salon"
      },
      {
        category: "taoist temple"
      },
      {
        category: "tapas bar"
      },
      {
        category: "tapas restaurant"
      },
      {
        category: "tarmac"
      },
      {
        category: "tatami store"
      },
      {
        category: "tattoo and piercing shop"
      },
      {
        category: "tattoo artist"
      },
      {
        category: "tattoo removal service"
      },
      {
        category: "tattoo shop"
      },
      {
        category: "tattoo-removal service"
      },
      {
        category: "tavern"
      },
      {
        category: "tax"
      },
      {
        category: "tax advisor"
      },
      {
        category: "tax assessor"
      },
      {
        category: "tax attorney"
      },
      {
        category: "tax collector’s office"
      },
      {
        category: "tax consultant"
      },
      {
        category: "tax department"
      },
      {
        category: "tax lawyer"
      },
      {
        category: "tax office"
      },
      {
        category: "tax preparation"
      },
      {
        category: "tax preparation service"
      },
      {
        category: "taxi rank"
      },
      {
        category: "taxi service"
      },
      {
        category: "taxicab stand"
      },
      {
        category: "taxidermist"
      },
      {
        category: "taxis"
      },
      {
        category: "tb clinic"
      },
      {
        category: "tea and coffee merchant"
      },
      {
        category: "tea exporter"
      },
      {
        category: "tea house"
      },
      {
        category: "tea manufacturer"
      },
      {
        category: "tea market place"
      },
      {
        category: "tea room"
      },
      {
        category: "tea shop"
      },
      {
        category: "tea store"
      },
      {
        category: "tea wholesaler"
      },
      {
        category: "teacher college"
      },
      {
        category: "technical education academy"
      },
      {
        category: "technical school"
      },
      {
        category: "technical service"
      },
      {
        category: "technical university"
      },
      {
        category: "technology museum"
      },
      {
        category: "technology park"
      },
      {
        category: "teeth whitening service"
      },
      {
        category: "telecommunication school"
      },
      {
        category: "telecommunications"
      },
      {
        category: "telecommunications contractor"
      },
      {
        category: "telecommunications engineer"
      },
      {
        category: "telecommunications equipment supplier"
      },
      {
        category: "telecommunications service provider"
      },
      {
        category: "telemarketing service"
      },
      {
        category: "telephone answering service"
      },
      {
        category: "telephone company"
      },
      {
        category: "telephone exchange"
      },
      {
        category: "telescope shop"
      },
      {
        category: "telescope store"
      },
      {
        category: "television"
      },
      {
        category: "television repair service"
      },
      {
        category: "television station"
      },
      {
        category: "television tower"
      },
      {
        category: "temp agency"
      },
      {
        category: "tempura donburi restaurant"
      },
      {
        category: "tempura restaurant"
      },
      {
        category: "tenant ownership"
      },
      {
        category: "tenant’s insurance agency"
      },
      {
        category: "tenant’s union"
      },
      {
        category: "tennis"
      },
      {
        category: "tennis center"
      },
      {
        category: "tennis club"
      },
      {
        category: "tennis court"
      },
      {
        category: "tennis court construction company"
      },
      {
        category: "tennis instructor"
      },
      {
        category: "tennis shop"
      },
      {
        category: "tennis store"
      },
      {
        category: "tent rental service"
      },
      {
        category: "teppanyaki restaurant"
      },
      {
        category: "terminal point"
      },
      {
        category: "terrain"
      },
      {
        category: "tesla showroom"
      },
      {
        category: "tex-mex restaurant"
      },
      {
        category: "textile engineer"
      },
      {
        category: "textile exporter"
      },
      {
        category: "textile merchant"
      },
      {
        category: "textile mill"
      },
      {
        category: "textiles"
      },
      {
        category: "thai massage therapist"
      },
      {
        category: "thai restaurant"
      },
      {
        category: "theater company"
      },
      {
        category: "theater production"
      },
      {
        category: "theater supply store"
      },
      {
        category: "theatre company"
      },
      {
        category: "theatrical costume supplier"
      },
      {
        category: "theatrical supplies shop"
      },
      {
        category: "theme park"
      },
      {
        category: "therapists"
      },
      {
        category: "thermal baths"
      },
      {
        category: "thermal energy company"
      },
      {
        category: "thread supplier"
      },
      {
        category: "threads and yarns wholesaler"
      },
      {
        category: "thrift store"
      },
      {
        category: "thuringian restaurant"
      },
      {
        category: "tibetan restaurant"
      },
      {
        category: "ticket gate"
      },
      {
        category: "ticket holder area"
      },
      {
        category: "ticket vending counter"
      },
      {
        category: "ticket vending machine"
      },
      {
        category: "ticketing area"
      },
      {
        category: "tiffin center"
      },
      {
        category: "tiki bar"
      },
      {
        category: "tile contractor"
      },
      {
        category: "tile manufacturer"
      },
      {
        category: "tile shop"
      },
      {
        category: "tile store"
      },
      {
        category: "timber merchant"
      },
      {
        category: "time and temperature announcement service"
      },
      {
        category: "timeshare agency"
      },
      {
        category: "tire repair shop"
      },
      {
        category: "tire shop"
      },
      {
        category: "title company"
      },
      {
        category: "toast restaurant"
      },
      {
        category: "tobacco exporter"
      },
      {
        category: "tobacco shop"
      },
      {
        category: "tobacco supplier"
      },
      {
        category: "tofu restaurant"
      },
      {
        category: "tofu shop"
      },
      {
        category: "toiletries shop"
      },
      {
        category: "toiletries store"
      },
      {
        category: "toll booth"
      },
      {
        category: "toll road rest stop"
      },
      {
        category: "toll road services"
      },
      {
        category: "toner cartridge supplier"
      },
      {
        category: "tongue restaurant"
      },
      {
        category: "tonkatsu restaurant"
      },
      {
        category: "tool & die shop"
      },
      {
        category: "tool exporter"
      },
      {
        category: "tool grinding service"
      },
      {
        category: "tool manufacturer"
      },
      {
        category: "tool rental service"
      },
      {
        category: "tool repair shop"
      },
      {
        category: "tool shop"
      },
      {
        category: "tool store"
      },
      {
        category: "tool wholesaler"
      },
      {
        category: "toolroom"
      },
      {
        category: "topography company"
      },
      {
        category: "topsoil supplier"
      },
      {
        category: "tortilla shop"
      },
      {
        category: "tour agency"
      },
      {
        category: "tour operator"
      },
      {
        category: "tourism"
      },
      {
        category: "tourist attraction"
      },
      {
        category: "tourist information center"
      },
      {
        category: "tourist information centre"
      },
      {
        category: "tours"
      },
      {
        category: "tower"
      },
      {
        category: "tower communication service"
      },
      {
        category: "towing equipment provider"
      },
      {
        category: "towing service"
      },
      {
        category: "town"
      },
      {
        category: "town hall"
      },
      {
        category: "town office"
      },
      {
        category: "town square"
      },
      {
        category: "townhouse complex"
      },
      {
        category: "township office"
      },
      {
        category: "toy and game manufacturer"
      },
      {
        category: "toy library"
      },
      {
        category: "toy manufacturer"
      },
      {
        category: "toy museum"
      },
      {
        category: "toy shop"
      },
      {
        category: "toy store"
      },
      {
        category: "toyota dealer"
      },
      {
        category: "tractor dealer"
      },
      {
        category: "tractor repair shop"
      },
      {
        category: "trade centre"
      },
      {
        category: "trade education center"
      },
      {
        category: "trade fair construction company"
      },
      {
        category: "trade school"
      },
      {
        category: "trade union"
      },
      {
        category: "tradesperson"
      },
      {
        category: "trading card shop"
      },
      {
        category: "trading card store"
      },
      {
        category: "trading firm"
      },
      {
        category: "traditional american restaurant"
      },
      {
        category: "traditional costume club"
      },
      {
        category: "traditional kostume store"
      },
      {
        category: "traditional market"
      },
      {
        category: "traditional restaurant"
      },
      {
        category: "traditional teahouse"
      },
      {
        category: "traffic officer"
      },
      {
        category: "traffic police station"
      },
      {
        category: "trail head"
      },
      {
        category: "trailer dealer"
      },
      {
        category: "trailer manufacturer"
      },
      {
        category: "trailer rental service"
      },
      {
        category: "trailer repair shop"
      },
      {
        category: "trailer supply shop"
      },
      {
        category: "trailer supply store"
      },
      {
        category: "train depot"
      },
      {
        category: "train repairing center"
      },
      {
        category: "train repairing centre"
      },
      {
        category: "train station"
      },
      {
        category: "train ticket agency"
      },
      {
        category: "train ticket counter"
      },
      {
        category: "train ticket office"
      },
      {
        category: "train yard"
      },
      {
        category: "training"
      },
      {
        category: "training centre"
      },
      {
        category: "training consultant"
      },
      {
        category: "training courses"
      },
      {
        category: "training provider"
      },
      {
        category: "training school"
      },
      {
        category: "tram stop"
      },
      {
        category: "transcription service"
      },
      {
        category: "transit depot"
      },
      {
        category: "transit platform group"
      },
      {
        category: "transit station"
      },
      {
        category: "transit stop"
      },
      {
        category: "translator"
      },
      {
        category: "transmission shop"
      },
      {
        category: "transplant surgeon"
      },
      {
        category: "transport infrastructure"
      },
      {
        category: "transport interchange"
      },
      {
        category: "transportation"
      },
      {
        category: "transportation authority office"
      },
      {
        category: "transportation escort service"
      },
      {
        category: "transportation infrastructure"
      },
      {
        category: "transportation service"
      },
      {
        category: "travel"
      },
      {
        category: "travel agency"
      },
      {
        category: "travel agent"
      },
      {
        category: "travel clinic"
      },
      {
        category: "travel lounge"
      },
      {
        category: "travel services"
      },
      {
        category: "travellers lodge"
      },
      {
        category: "tree farm"
      },
      {
        category: "tree service"
      },
      {
        category: "trial attorney"
      },
      {
        category: "trial lawyer"
      },
      {
        category: "tribal headquarters"
      },
      {
        category: "tribunal administratif"
      },
      {
        category: "triumph motorcycle dealer"
      },
      {
        category: "trolleybus stop"
      },
      {
        category: "trophy shop"
      },
      {
        category: "tropical fish shop"
      },
      {
        category: "tropical fish store"
      },
      {
        category: "truck accessories store"
      },
      {
        category: "truck dealer"
      },
      {
        category: "truck farmer"
      },
      {
        category: "truck parts supplier"
      },
      {
        category: "truck rental agency"
      },
      {
        category: "truck repair shop"
      },
      {
        category: "truck stop"
      },
      {
        category: "truck topper supplier"
      },
      {
        category: "trucking"
      },
      {
        category: "trucking company"
      },
      {
        category: "trucking school"
      },
      {
        category: "trucks"
      },
      {
        category: "truss manufacturer"
      },
      {
        category: "trust bank"
      },
      {
        category: "tsukigime parking lot"
      },
      {
        category: "tuna restaurant"
      },
      {
        category: "tune up supplier"
      },
      {
        category: "tuning automobile"
      },
      {
        category: "tunisian restaurant"
      },
      {
        category: "tunnel"
      },
      {
        category: "turf and soil supplier"
      },
      {
        category: "turf supplier"
      },
      {
        category: "turkish restaurant"
      },
      {
        category: "turkmen restaurant"
      },
      {
        category: "turnery"
      },
      {
        category: "tuscan restaurant"
      },
      {
        category: "tutor"
      },
      {
        category: "tutoring service"
      },
      {
        category: "tuxedo shop"
      },
      {
        category: "typewriter repair service"
      },
      {
        category: "typewriter supplier"
      },
      {
        category: "typing service"
      },
      {
        category: "tyre manufacturer"
      },
      {
        category: "tyre shop"
      },
      {
        category: "udon noodle restaurant"
      },
      {
        category: "ukrainian restaurant"
      },
      {
        category: "unagi restaurant"
      },
      {
        category: "underground station"
      },
      {
        category: "underwear shop"
      },
      {
        category: "underwear store"
      },
      {
        category: "unemployment office"
      },
      {
        category: "unfinished furniture shop"
      },
      {
        category: "unfinished furniture store"
      },
      {
        category: "uniform shop"
      },
      {
        category: "uniform store"
      },
      {
        category: "unitarian universalist church"
      },
      {
        category: "united church of canada"
      },
      {
        category: "united church of christ"
      },
      {
        category: "united methodist church"
      },
      {
        category: "united states armed forces base"
      },
      {
        category: "unity church"
      },
      {
        category: "university"
      },
      {
        category: "university department"
      },
      {
        category: "university hospital"
      },
      {
        category: "university lab room"
      },
      {
        category: "university library"
      },
      {
        category: "upholstery cleaning service"
      },
      {
        category: "upholstery shop"
      },
      {
        category: "upland"
      },
      {
        category: "urban development corporation"
      },
      {
        category: "urban planning department"
      },
      {
        category: "urgent care center"
      },
      {
        category: "urgent care centre"
      },
      {
        category: "urologist"
      },
      {
        category: "urology clinic"
      },
      {
        category: "uruguayan restaurant"
      },
      {
        category: "used"
      },
      {
        category: "used appliance shop"
      },
      {
        category: "used appliance store"
      },
      {
        category: "used auto parts store"
      },
      {
        category: "used bicycle shop"
      },
      {
        category: "used book store"
      },
      {
        category: "used car dealer"
      },
      {
        category: "used cd store"
      },
      {
        category: "used clothing store"
      },
      {
        category: "used computer store"
      },
      {
        category: "used furniture store"
      },
      {
        category: "used game shop"
      },
      {
        category: "used game store"
      },
      {
        category: "used motorcycle dealer"
      },
      {
        category: "used musical instrument shop"
      },
      {
        category: "used musical instrument store"
      },
      {
        category: "used office furniture shop"
      },
      {
        category: "used office furniture store"
      },
      {
        category: "used store"
      },
      {
        category: "used store fixture supplier"
      },
      {
        category: "used tire shop"
      },
      {
        category: "used truck dealer"
      },
      {
        category: "used tyre shop"
      },
      {
        category: "used vehicle parts shop"
      },
      {
        category: "utilities"
      },
      {
        category: "utilities contractor"
      },
      {
        category: "utility contractor"
      },
      {
        category: "utility pole"
      },
      {
        category: "utility trailer dealer"
      },
      {
        category: "uzbeki restaurant"
      },
      {
        category: "vacation home rental agency"
      },
      {
        category: "vacuum cleaner"
      },
      {
        category: "vacuum cleaner repair shop"
      },
      {
        category: "vacuum cleaner shop"
      },
      {
        category: "vacuum cleaner store"
      },
      {
        category: "vacuum cleaning system supplier"
      },
      {
        category: "valencian restaurant"
      },
      {
        category: "valet parking service"
      },
      {
        category: "valeting service"
      },
      {
        category: "van accessories shop"
      },
      {
        category: "van rental agency"
      },
      {
        category: "vaporiser shop"
      },
      {
        category: "vaporizer store"
      },
      {
        category: "variety shop"
      },
      {
        category: "variety store"
      },
      {
        category: "vascular surgeon"
      },
      {
        category: "vastu consultant"
      },
      {
        category: "vauxhall/opel dealer"
      },
      {
        category: "vcr repair service"
      },
      {
        category: "vegan restaurant"
      },
      {
        category: "vegetable wholesale market"
      },
      {
        category: "vegetable wholesaler"
      },
      {
        category: "vegetarian cafe and deli"
      },
      {
        category: "vegetarian restaurant"
      },
      {
        category: "vegetation"
      },
      {
        category: "vehicle dealers"
      },
      {
        category: "vehicle dent removal service"
      },
      {
        category: "vehicle examination office"
      },
      {
        category: "vehicle exporter"
      },
      {
        category: "vehicle hire"
      },
      {
        category: "vehicle inspection"
      },
      {
        category: "vehicle parts market"
      },
      {
        category: "vehicle parts shop"
      },
      {
        category: "vehicle registration agency"
      },
      {
        category: "vehicle rental"
      },
      {
        category: "vehicle repair"
      },
      {
        category: "vehicle repair shop"
      },
      {
        category: "vehicle shipping agent"
      },
      {
        category: "vehicle storage facility"
      },
      {
        category: "vehicle sunroof shop"
      },
      {
        category: "vehicle tuning service"
      },
      {
        category: "vehicle upholsterer"
      },
      {
        category: "velodrome"
      },
      {
        category: "vending machine"
      },
      {
        category: "vending machine supplier"
      },
      {
        category: "venereologist"
      },
      {
        category: "venetian restaurant"
      },
      {
        category: "venezuelan restaurant"
      },
      {
        category: "ventilating equipment manufacturer"
      },
      {
        category: "venture capital company"
      },
      {
        category: "veterans"
      },
      {
        category: "veterans affairs department"
      },
      {
        category: "veterans center"
      },
      {
        category: "veterans centre"
      },
      {
        category: "veterans hospital"
      },
      {
        category: "veterans organization"
      },
      {
        category: "veterans’ organization"
      },
      {
        category: "veterinarian"
      },
      {
        category: "veterinarian osteopath"
      },
      {
        category: "veterinary care"
      },
      {
        category: "veterinary pharmacy"
      },
      {
        category: "viaduct"
      },
      {
        category: "video"
      },
      {
        category: "video arcade"
      },
      {
        category: "video camera repair service"
      },
      {
        category: "video conferencing equipment supplier"
      },
      {
        category: "video conferencing service"
      },
      {
        category: "video duplication service"
      },
      {
        category: "video editing service"
      },
      {
        category: "video equipment and services"
      },
      {
        category: "video equipment repair service"
      },
      {
        category: "video game rental kiosk"
      },
      {
        category: "video game rental service"
      },
      {
        category: "video game rental store"
      },
      {
        category: "video game shop"
      },
      {
        category: "video game store"
      },
      {
        category: "video karaoke"
      },
      {
        category: "video player repair service"
      },
      {
        category: "video production service"
      },
      {
        category: "video shop"
      },
      {
        category: "video store"
      },
      {
        category: "vietnamese restaurant"
      },
      {
        category: "viewpoint"
      },
      {
        category: "villa"
      },
      {
        category: "village hall"
      },
      {
        category: "vineyard"
      },
      {
        category: "vineyard church"
      },
      {
        category: "vintage clothing shop"
      },
      {
        category: "vintage clothing store"
      },
      {
        category: "vinyl sign shop"
      },
      {
        category: "violin shop"
      },
      {
        category: "virtual office rental"
      },
      {
        category: "visa and passport office"
      },
      {
        category: "visa consultant"
      },
      {
        category: "visitor center"
      },
      {
        category: "visitor centre"
      },
      {
        category: "vista"
      },
      {
        category: "vista point"
      },
      {
        category: "vitamin & supplements shop"
      },
      {
        category: "vitamin & supplements store"
      },
      {
        category: "vocal instructor"
      },
      {
        category: "vocational college"
      },
      {
        category: "vocational school"
      },
      {
        category: "vocational school one"
      },
      {
        category: "volcano"
      },
      {
        category: "volkswagen dealer"
      },
      {
        category: "volleyball club"
      },
      {
        category: "volleyball court"
      },
      {
        category: "volleyball instructor"
      },
      {
        category: "voluntary fire brigade"
      },
      {
        category: "voluntary organisation"
      },
      {
        category: "volunteer organization"
      },
      {
        category: "volvo dealer"
      },
      {
        category: "voter registration office"
      },
      {
        category: "voting location"
      },
      {
        category: "waiting room"
      },
      {
        category: "waldorf kindergarten"
      },
      {
        category: "waldorf school"
      },
      {
        category: "walk-in clinic"
      },
      {
        category: "walkway"
      },
      {
        category: "wall"
      },
      {
        category: "wallpaper installer"
      },
      {
        category: "wallpaper shop"
      },
      {
        category: "wallpaper store"
      },
      {
        category: "war memorial"
      },
      {
        category: "war museum"
      },
      {
        category: "warehouse"
      },
      {
        category: "warehouse club"
      },
      {
        category: "warehouse store"
      },
      {
        category: "washer & dryer repair service"
      },
      {
        category: "washer & dryer store"
      },
      {
        category: "washing machine & dryer repair service"
      },
      {
        category: "washing machine & dryer shop"
      },
      {
        category: "waste collection service"
      },
      {
        category: "waste container"
      },
      {
        category: "waste management service"
      },
      {
        category: "waste water and sewage treatment company"
      },
      {
        category: "waste-management service"
      },
      {
        category: "watch manufacturer"
      },
      {
        category: "watch repair service"
      },
      {
        category: "watch repair shop"
      },
      {
        category: "watch shop"
      },
      {
        category: "watch store"
      },
      {
        category: "water"
      },
      {
        category: "water companies"
      },
      {
        category: "water cooler supplier"
      },
      {
        category: "water damage restoration service"
      },
      {
        category: "water filter supplier"
      },
      {
        category: "water filters"
      },
      {
        category: "water jet cutting service"
      },
      {
        category: "water mill"
      },
      {
        category: "water navigation"
      },
      {
        category: "water park"
      },
      {
        category: "water polo pool"
      },
      {
        category: "water pump supplier"
      },
      {
        category: "water purification company"
      },
      {
        category: "water ski shop"
      },
      {
        category: "water skiing club"
      },
      {
        category: "water skiing instructor"
      },
      {
        category: "water skiing service"
      },
      {
        category: "water softening equipment supplier"
      },
      {
        category: "water sport"
      },
      {
        category: "water sports equipment rental service"
      },
      {
        category: "water tank cleaning service"
      },
      {
        category: "water testing service"
      },
      {
        category: "water treatment plant"
      },
      {
        category: "water treatment supplier"
      },
      {
        category: "water utility company"
      },
      {
        category: "water works"
      },
      {
        category: "water works equipment supplier"
      },
      {
        category: "waterbed repair service"
      },
      {
        category: "waterbed shop"
      },
      {
        category: "waterbed store"
      },
      {
        category: "waterfall"
      },
      {
        category: "watering hole"
      },
      {
        category: "waterproofing company"
      },
      {
        category: "wax museum"
      },
      {
        category: "wax supplier"
      },
      {
        category: "waxing hair removal service"
      },
      {
        category: "waxing hair-removal service"
      },
      {
        category: "weather forecast service"
      },
      {
        category: "weaving mill"
      },
      {
        category: "web hosting company"
      },
      {
        category: "website designer"
      },
      {
        category: "wedding bakery"
      },
      {
        category: "wedding buffet"
      },
      {
        category: "wedding cake shop"
      },
      {
        category: "wedding chapel"
      },
      {
        category: "wedding dress rental service"
      },
      {
        category: "wedding photographer"
      },
      {
        category: "wedding planner"
      },
      {
        category: "wedding service"
      },
      {
        category: "wedding shop"
      },
      {
        category: "wedding souvenir shop"
      },
      {
        category: "wedding store"
      },
      {
        category: "wedding venue"
      },
      {
        category: "weddings"
      },
      {
        category: "weigh station"
      },
      {
        category: "weighbridge"
      },
      {
        category: "weight loss service"
      },
      {
        category: "weight-loss service"
      },
      {
        category: "weightlifting area"
      },
      {
        category: "weir"
      },
      {
        category: "welder"
      },
      {
        category: "welding"
      },
      {
        category: "welding gas supplier"
      },
      {
        category: "welding supply shop"
      },
      {
        category: "welding supply store"
      },
      {
        category: "welfare office"
      },
      {
        category: "well"
      },
      {
        category: "well drilling contractor"
      },
      {
        category: "wellness"
      },
      {
        category: "wellness center"
      },
      {
        category: "wellness centre"
      },
      {
        category: "wellness hotel"
      },
      {
        category: "wellness program"
      },
      {
        category: "wellness programme"
      },
      {
        category: "welsh restaurant"
      },
      {
        category: "wesleyan church"
      },
      {
        category: "west african restaurant"
      },
      {
        category: "western apparel store"
      },
      {
        category: "western clothing shop"
      },
      {
        category: "western food"
      },
      {
        category: "western restaurant"
      },
      {
        category: "wetland"
      },
      {
        category: "whale watching tour agency"
      },
      {
        category: "wheel alignment service"
      },
      {
        category: "wheel shop"
      },
      {
        category: "wheel store"
      },
      {
        category: "wheelchair ramp"
      },
      {
        category: "wheelchair rental service"
      },
      {
        category: "wheelchair repair service"
      },
      {
        category: "wheelchair shop"
      },
      {
        category: "wheelchair store"
      },
      {
        category: "wholesale bakery"
      },
      {
        category: "wholesale drugstore"
      },
      {
        category: "wholesale florist"
      },
      {
        category: "wholesale food store"
      },
      {
        category: "wholesale grocer"
      },
      {
        category: "wholesale jeweler"
      },
      {
        category: "wholesale jeweller"
      },
      {
        category: "wholesale market"
      },
      {
        category: "wholesale plant nursery"
      },
      {
        category: "wholesaler"
      },
      {
        category: "wholesaler household appliances"
      },
      {
        category: "wi-fi spot"
      },
      {
        category: "wicker shop"
      },
      {
        category: "wicker store"
      },
      {
        category: "wig shop"
      },
      {
        category: "wilderness center"
      },
      {
        category: "wildlife and safari park"
      },
      {
        category: "wildlife park"
      },
      {
        category: "wildlife refuge"
      },
      {
        category: "wildlife rescue service"
      },
      {
        category: "willow basket manufacturer"
      },
      {
        category: "wind farm"
      },
      {
        category: "wind turbine builder"
      },
      {
        category: "windmill"
      },
      {
        category: "window cleaning service"
      },
      {
        category: "window installation service"
      },
      {
        category: "window supplier"
      },
      {
        category: "window tinting service"
      },
      {
        category: "window treatment store"
      },
      {
        category: "windows"
      },
      {
        category: "windshield repair service"
      },
      {
        category: "windsurfing shop"
      },
      {
        category: "windsurfing store"
      },
      {
        category: "wine"
      },
      {
        category: "wine bar"
      },
      {
        category: "wine cellar"
      },
      {
        category: "wine club"
      },
      {
        category: "wine shop"
      },
      {
        category: "wine storage facility"
      },
      {
        category: "wine store"
      },
      {
        category: "wine wholesaler and importer"
      },
      {
        category: "wine-making supply shop"
      },
      {
        category: "winemaking supply store"
      },
      {
        category: "winery"
      },
      {
        category: "wing chun school"
      },
      {
        category: "wok restaurant"
      },
      {
        category: "women’s clothing store"
      },
      {
        category: "women’s health clinic"
      },
      {
        category: "women’s organisation"
      },
      {
        category: "women’s organization"
      },
      {
        category: "women’s shelter"
      },
      {
        category: "womens college"
      },
      {
        category: "womens personal trainer"
      },
      {
        category: "womens protection service"
      },
      {
        category: "wood and laminate flooring supplier"
      },
      {
        category: "wood floor installation service"
      },
      {
        category: "wood floor refinishing service"
      },
      {
        category: "wood frame supplier"
      },
      {
        category: "wood industry"
      },
      {
        category: "wood stove shop"
      },
      {
        category: "wood supplier"
      },
      {
        category: "wood working class"
      },
      {
        category: "woods"
      },
      {
        category: "woodwork wholesaler"
      },
      {
        category: "woodworker"
      },
      {
        category: "woodworking supply shop"
      },
      {
        category: "woodworking supply store"
      },
      {
        category: "wool shop"
      },
      {
        category: "wool store"
      },
      {
        category: "work clothes shop"
      },
      {
        category: "work clothes store"
      },
      {
        category: "workers’ club"
      },
      {
        category: "working womens hostel"
      },
      {
        category: "workshop"
      },
      {
        category: "worm farm supplier"
      },
      {
        category: "wrapping paper shop"
      },
      {
        category: "wrestling school"
      },
      {
        category: "x-ray equipment supplier"
      },
      {
        category: "x-ray lab"
      },
      {
        category: "yacht broker"
      },
      {
        category: "yacht club"
      },
      {
        category: "yacht dealer"
      },
      {
        category: "yakatabune"
      },
      {
        category: "yakiniku restaurant"
      },
      {
        category: "yakisoba restaurant"
      },
      {
        category: "yakitori restaurant"
      },
      {
        category: "yamaha motorcycle dealer"
      },
      {
        category: "yarn store"
      },
      {
        category: "yemenite restaurant"
      },
      {
        category: "yeshiva"
      },
      {
        category: "yoga instructor"
      },
      {
        category: "yoga retreat center"
      },
      {
        category: "yoga retreat centre"
      },
      {
        category: "yoga studio"
      },
      {
        category: "youth care"
      },
      {
        category: "youth center"
      },
      {
        category: "youth centre"
      },
      {
        category: "youth clothing shop"
      },
      {
        category: "youth clothing store"
      },
      {
        category: "youth club"
      },
      {
        category: "youth group"
      },
      {
        category: "youth hostel"
      },
      {
        category: "youth organisation"
      },
      {
        category: "youth organization"
      },
      {
        category: "youth social services organization"
      },
      {
        category: "yucatan restaurant"
      },
      {
        category: "zhejiang restaurant"
      },
      {
        category: "zoo"
      }
    ]
    Outscrapper::Category.create!(category_array)

    puts "Data added successfully"
  end
end
