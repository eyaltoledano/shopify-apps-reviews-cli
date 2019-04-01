# # CLI Controller
require_relative 'app_review.rb'
require_relative 'shopify_app.rb'
require_relative 'app_list_scraper.rb'

require 'colorize'

class ShopifyAppReviews::CLI
  def run
    welcome
    scrape_and_create_apps
    # add_reviews_to_apps
    get_input
    goodbye
  end

  def welcome
    puts "The Shopify App Library is being updated. One moment."
  end

  def get_input
    input = nil
    while input != "exit"
      puts "Search for a Shopify app by name or URL to access its information."
      puts "You can use 'exit' to leave at any time."
      print "Please enter the name or URL of a Shopify app: "
      input = gets.chomp.downcase
      display_app_details(input) ? display_app_details(input) : puts("Doesn't look like that app exists. Did you spell that right?")
    end
  end

  def display_app_details(input) # if an app is not found, return falsey
    requested_app = ShopifyApp.find_by_url(input)
    requested_app = ShopifyApp.find_by_name(input) if requested_app.nil?
    requested_app.nil? ? false : app_table(requested_app)

    unless false
      sub_input = nil
      while !sub_input != "new app"
        puts "Use 'show reviews' to see #{requested_app.name}'s reviews.'"
        puts "Use 'back to app' to review #{requested_app.name}'s details.'"
        puts "Use 'new app' to return to the previous menu."
        sub_input = gets.chomp.downcase
        if sub_input == "show reviews"
          reviews_table(requested_app)
        end
        get_input if sub_input == "new app"
        if sub_input == "exit" || sub_input == "quit"
          goodbye
          exit
        end
        app_table(requested_app) if sub_input == "back to app"
      end
    end
  end

  def app_table(app)
    puts app
    # show app data in a nice table/ui
  end

  def reviews_table(app)
    app.app_reviews
    # show each app review in a table format
  end

  def scrape_and_create_apps
    app_array = AppListScraper.scrape_shopify_apps
    ShopifyApp.create_from_collection(app_array)
  end

  def goodbye
    puts "Closing CLI."
  end

end
