# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
PER_PAGE = "100"
page = "4"
url = "https://qiita.com/api/v2/tags?page=" + page + "&per_page=" + PER_PAGE + "&sort=count"
uri = URI.parse(url)
response = Net::HTTP.get(uri)
results = JSON.parse(response)
puts results
for result in results do
    SkillCategory.create(tag_name: result["id"],icon_url: result["icon_url"],followers_count: result["followers_count"],items_count: result["items_count"])
end