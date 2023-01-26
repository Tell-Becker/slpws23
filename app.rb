require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'
require 'bcrypt'
enable :sessions

get('/') do 
    slim(:register)
end

get('/register') do 
    slim(:register)
end


get('/showlogin') do 
    slim(:login)
end

post('/login') do 
    # db = sqlite3::Database.new('db/Workout_app_database.db')
    # db.results_as_hash = true
    redirect('/account')
end

get('/account') do 
    slim(:"account/index")
end