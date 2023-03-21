require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require_relative './model.rb'
enable :sessions

def connect_to_db(path)
    db = SQLite3::Database.new('db/Workout_app_database.db')
    db.results_as_hash = true
    return db
end

get('/explore') do 
    slim(:"account/index")
end

get('/') do
    redirect("/workouts")
end

get('/workouts') do 
    db = connect_to_db('db/Workout_app_database.db')
    @result = db.execute("SELECT * FROM Workouts")

    #p @result
    slim(:"account/index")

end

get('/create') do
    slim(:"account/createButton")
end

get('/workout/new') do
    db = connect_to_db('db/Workout_app_database.db')
    @muscles = db.execute("SELECT name FROM Muscles")
    @exercises = db.execute("SELECT name FROM Exercises")
    slim(:"account/create")
end

post('/workout/create') do
    title = params[:title]
    muscletype = params[:muscletype1]
    exercise = params[:exercise1]
    sets = params[:sets1]
    reps = params[:reps1]

    muscletype2 = params[:muscletype2]
    exercise2 = params[:exercise2]
    sets2 = params[:sets2]
    reps2 = params[:reps2]

    muscletype3 = params[:muscletype3]
    exercise3 = params[:exercise3]
    sets3 = params[:sets3]
    reps3 = params[:reps3]
    
    muscletype4 = params[:muscletype4]
    exercise4 = params[:exercise4]
    sets4 = params[:sets4]
    reps4 = params[:reps4]

    muscletype5 = params[:muscletype5]
    exercise5 = params[:exercise5]
    sets5 = params[:sets5]
    reps5 = params[:reps5]

    p "Vi fick in datan #{title}, #{muscletype}, #{exercise}, #{sets}, #{reps}"
    # Funktion som gör att man enklare kan få in de olika övningarna i vardera tabell
    db = connect_to_db('db/Workout_app_database.db')
    db.execute("INSERT INTO Workouts (title, sets, reps, user_id) VALUES (?,?,?,?)",title, sets, reps, 1)

    doNotAddTable = "nothing"
    add_values_to_tables(title, muscletype, exercise, sets, reps)
    add_values_to_tables(title, muscletype2, exercise2, sets2, reps2)
    add_values_to_tables(title, muscletype3, exercise3, sets3, reps3)
    add_values_to_tables(title, muscletype4, exercise4, sets4, reps4)
    add_values_to_tables(title, muscletype5, exercise5, sets5, reps5)




    redirect('/workouts')
end

def add_values_to_tables(title, muscletype, exercise, sets, reps)
    db = connect_to_db('db/Workout_app_database.db')
    db.execute("INSERT INTO Workouts (title, sets, reps, user_id) VALUES (?,?,?,?)",title, sets, reps, 1)
    muscle_id = db.execute("SELECT id FROM Muscles WHERE name = ?", muscletype).first()["id"]
    exercise_id = db.execute("SELECT id FROM Exercises WHERE name = ?", exercise).first()["id"]

    workout_id = db.execute("SELECT id FROM Workouts ORDER BY id ASC").last["id"]
    
    db.execute("INSERT INTO Workout_Muscle (workout_id, muscle_id) VALUES (?,?)",workout_id, muscle_id)

    db.execute("INSERT INTO Workout_exercise (workout_id, exercise_id) VALUES (?,?)",workout_id, exercise_id)
   
end


# get('/workout') do 
#     slim(:"account/index")
# end

get('/profile') do
    slim(:"account/profile")
end
# get('/register') do 
#     slim(:register)
# end

# get('/showlogin') do 
#     slim(:login)
# end

# post('/login') do 
#     # db = sqlite3::Database.new('db/Workout_app_database.db')
#     # db.results_as_hash = true
#     redirect('/account')
# end

# get('/account') do 
#     username = "lars"
#     slim(:"account/index")
# end

helpers do
    def get_all_muscles_for_workout(workout_id)
        db = connect_to_db('db/Workout_app_database.db')
        return db.execute("
            SELECT Muscles.name 
            FROM Workout_Muscle 
            INNER JOIN Muscles, Workouts 
            ON Workout_Muscle.workout_id = Workouts.id AND Workout_Muscle.muscle_id = Muscles.id
            WHERE Workouts.id = ?", workout_id)
    end

    def get_all_exercises_for_workout(workout_id)
        db = connect_to_db('db/Workout_app_database.db')
        return db.execute("
            SELECT Exercises.name
            FRom Workout_Exercise
            Inner JOIN Exercises, Workouts
            ON Workout_Exercise.workout_id = Workouts.id AND Workout_Exercise.exercise_id = Exercises.id
            WHERE Workouts.id = ?", workout_id)
    end
end