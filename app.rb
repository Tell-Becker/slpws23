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
    # db.execute("INSERT INTO Workouts (title, sets, reps, user_id) VALUES (?,?,?,?)",title, sets, reps, session[:id])
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
    
    db.execute("INSERT INTO Workouts (title, sets, reps, user_id) VALUES (?,?,?,?)",title, sets, reps, session[:id])
    muscle_id = db.execute("SELECT id FROM Muscles WHERE name = ?", muscletype).first()["id"]
    exercise_id = db.execute("SELECT id FROM Exercises WHERE name = ?", exercise).first()["id"]

    workout_id = db.execute("SELECT id FROM Workouts ORDER BY id ASC").last()["id"]
    
    db.execute("INSERT INTO Workout_Muscle (workout_id, muscle_id) VALUES (?,?)",workout_id, muscle_id)

    db.execute("INSERT INTO Workout_exercise (workout_id, exercise_id) VALUES (?,?)",workout_id, exercise_id)
   
end

get('/workouts/:id/edit') do 
    db = connect_to_db('db/Workout_app_database.db')
    id = params[:id].to_i
    id2 = id + 1
    id3 = id + 2 
    id4 = id + 3 
    id5 = id + 4 

    result = db.execute("SELECT * FROM Workouts WHERE id = ?", id).first
    @result2 = db.execute("SELECT * FROM Workouts WHERE id = ?", id2).first
    @result3 = db.execute("SELECT * FROM Workouts WHERE id = ?", id3).first
    @result4 = db.execute("SELECT * FROM Workouts WHERE id = ?", id4).first
    @result5 = db.execute("SELECT * FROM Workouts WHERE id = ?", id5).first


    slim(:"account/edit",locals:{workout:result})
end

post('/workouts/:id/update') do 
    id = params[:id].to_i
    title = params[:title]
    sets = params[:sets]
    reps = params[:reps]
    sets2 = params[:sets2]
    reps2 = params[:reps2]
    sets3 = params[:sets3]
    reps3 = params[:reps3]
    sets4 = params[:sets4]
    reps4 = params[:reps4]
    sets5 = params[:sets5]
    reps5 = params[:reps5]
    db = connect_to_db('db/Workout_app_database.db')
    if sets2 != nil
        if db.execute("SELECT title FROM Workouts WHERE id = ?", id) == db.execute("SELECT title FROM Workouts WHERE id = ?", id + 1)
            id2 = id + 1
            db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id2)
            db.execute("UPDATE Workouts SET sets=? WHERE id = ?",sets2, id2)
            db.execute("UPDATE Workouts SET reps=? WHERE id = ?",reps2, id2)
        end
    end
    if sets3 != nil
        if db.execute("SELECT title FROM Workouts WHERE id = ?", id) == db.execute("SELECT title FROM Workouts WHERE id = ?", id + 2)
            id3 = id + 2
            db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id3)
            db.execute("UPDATE Workouts SET sets=? WHERE id = ?",sets3, id3)
            db.execute("UPDATE Workouts SET reps=? WHERE id = ?",reps3, id3)
        end
    end
    if sets4 != nil
        if db.execute("SELECT title FROM Workouts WHERE id = ?", id) == db.execute("SELECT title FROM Workouts WHERE id = ?", id + 3)
            id4 = id + 3
            db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id4)
            db.execute("UPDATE Workouts SET sets=? WHERE id = ?",sets2, id4)
            db.execute("UPDATE Workouts SET reps=? WHERE id = ?",reps2, id4)
        end
    end
    if sets5 != nil
        if db.execute("SELECT title FROM Workouts WHERE id = ?", id) == db.execute("SELECT title FROM Workouts WHERE id = ?", id + 4)
            id5 = id + 4
            db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id5)
            db.execute("UPDATE Workouts SET sets=? WHERE id = ?",sets2, id5)
            db.execute("UPDATE Workouts SET reps=? WHERE id = ?",reps2, id5)
        end
    end
    # if db.execute("SELECT title FROM Workouts WHERE id = ?", id) == db.execute("SELECT title FROM Workouts WHERE id = ?", id + 4)
    #     id5 = id + 4
    #     db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id5)
    # end
    if sets != nil
        db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id)
        db.execute("UPDATE Workouts SET sets=? WHERE id = ?",sets, id)
        db.execute("UPDATE Workouts SET reps=? WHERE id = ?",reps, id)
    end
    redirect('/profile')
end

post('/workouts/:id/delete') do 
    db = connect_to_db('db/Workout_app_database.db')
    id = params[:id].to_i

    db.execute("DELETE FROM Workouts WHERE id = ?",id)
    db.execute("DELETE FROM Workouts WHERE id = ?",id + 1)
    db.execute("DELETE FROM Workouts WHERE id = ?",id + 2)
    db.execute("DELETE FROM Workouts WHERE id = ?",id + 3)
    db.execute("DELETE FROM Workouts WHERE id = ?",id + 4)


    redirect('/profile')
end

post('/workouts/:id/delete_users') do 
    db = connect_to_db('db/Workout_app_database.db')
    id = params[:id].to_i
    db.execute("DELETE FROM USERS WHERE id = ?",id)
    redirect('/users')
end
# get('/workout') do 
#     slim(:"account/index")
# end

get('/profile') do
    db = connect_to_db('db/Workout_app_database.db')
    @result = db.execute("SELECT * FROM Workouts")
    slim(:"account/profile")
end

get('/users') do 
    db = connect_to_db('db/Workout_app_database.db')
    @result = db.execute("SELECT * FROM Users")
    slim(:"account/users")
end

get('/register') do 
    slim(:"register-login/register")
end

post('/finishregistration') do
    username = params[:username]
    password = params[:password] 
    password_confirm = params[:confirmpassword]
    
    if (password = password_confirm)
        password_digest = BCrypt::Password.create(password)
        db = connect_to_db('db/Workout_app_database.db')
        db.execute("INSERT INTO Users (username, pwdigest) VALUES (?,?)",username, password_digest)
        redirect('/register')
    else 
        "Lösenordet matchade inte"
    end

end

get('/login') do 
    slim(:"register-login/login")
end

post('/finishlogin') do 
    username = params[:username]
    password = params[:password]
    db = connect_to_db('db/Workout_app_database.db')
    user_login_info = db.execute("SELECT * FROM Users WHERE username = ?", username)

    if user_login_info
        pwdigest = user_login_info[0][2]
        user_id = user_login_info[0][0]
    end

    if pwdigest && BCrypt::Password.new(pwdigest) == password
        session[:id] = user_id
        session[:username] = username
        redirect('/')
    else
        "Fel LÖSEN"
    end
    
end

get('/logout') do
    session[:id] = nil
    session[:username] = nil
    redirect('/')
end

#     if BCrypt::Password.new(pwdigest) == password
#         session[:id] = user_id
#         redirect('/')
#     else
#         "Fel LÖSEN"
#     end
# end


# post('/login') do 
#     # db = sqlite3::Database.new('db/Workout_app_database.db')
#     # db.results_as_hash = true
#     # redirect('/account')
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
            FROM Workout_Exercise
            Inner JOIN Exercises, Workouts
            ON Workout_Exercise.workout_id = Workouts.id AND Workout_Exercise.exercise_id = Exercises.id
            WHERE Workouts.id = ?", workout_id)
    end
end