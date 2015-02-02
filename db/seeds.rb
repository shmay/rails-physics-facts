require 'byebug'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all
Fact.destroy_all
Tag.destroy_all

me = User.create username: 'murph', email: 'kmurph73@gmail.com', password: 'pass1212', password_confirmation: 'pass1212'
piss = User.create email: 'piss@heah.net', username: 'pissah', password: 'pass1212', password_confirmation: 'pass1212'
shmay = User.create email: 'chobo@map.net', username: 'shmay', password: 'pass1212', password_confirmation: 'pass1212'

facts = [
  {
    title: 'This site is being built in Polymer JS (Web Components) and Rails',
    tag_list: 'polymerjs,rails,kyle,notaphysicsfact',
    body: 'polymer js alone is interesting; components can be extracted from apps for public and private reuse; easy to use material design as well;  rails is also cool'
  },
  {
    title: "click on the 'ADD NEW FACT' button to see a cool composer drawer pop up",
    tag_list: 'thissite,notaphysicsfact',
    body: "this\n\nhas return"
  },
  {
    title: 'two particles can exist in an entangled state',
    tag_list: 'quantum,quantum-entanglement',
    body: 'spooky action at a distance'
  },
  {
    title: 'the holographic principle',
    tag_list: 'holographic-principle',
    body: %{The holographic principle is a property of string theories and a supposed property of quantum gravity that states that the description of a volume of space can be thought of as encoded on a boundary to the region; 
      \n source: [wikipedia](http://en.wikipedia.org/wiki/Holographic_principle)
      \n\nreally interesting video here: https://www.youtube.com/watch?v=PLc5Pzas4l8
    }
  }
]

facts.each_with_index do |f,i|
  fact = Fact.new(f)
  fact.user_id = i % 2 == 0 ? me.id : piss.id

  vote1 = nil
  vote2 = nil

  if i == 0
    vote1 = Vote.new(dir: -1, user_id: me.id)
    vote2 = Vote.new(dir: 1, user_id: shmay.id)
  elsif i == 1
    vote1 = Vote.new(dir: -1, user_id: shmay.id)
  elsif i == 2
    vote1 = Vote.new(dir: 1, user_id: piss.id)
    vote2 = Vote.new(dir: 1, user_id: me.id)
  end

  fact.save

  if vote1
    vote1.fact_id = fact.id
    vote1.save
  end

  if vote2
    vote2.fact_id = fact.id
    vote2.save
  end
end
