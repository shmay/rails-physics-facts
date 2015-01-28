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
    title: 'did you know that there was some craziness during 1989?',
    tag_list: 'craziness,facty,what,how',
    body: 'yup it happened like *dis*\n\n ya know?'
  },
  {
    title: 'they dont tink like i tink',
    tag_list: 'dude,bro,what,how',
    body: 'yup it happened like *dis*\n\n ya know?'
  },
  {
    title: 'dey dun talk like i tulk',
    tag_list: 'craziness,nope,yes,what',
    body: 'yup it happened like *dis*\n\n ya know?'
  },
  {
    title: 'harby darby sarby garby',
    tag_list: 'nony,ihop,mcgregor,where',
    body: 'nonononononoononono'
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
