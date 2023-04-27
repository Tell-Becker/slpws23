def connect_to_db(path)
    db = SQLite3::Database.new('db/Workout_app_database.db')
    db.results_as_hash = true
    return db
end

def add_values_to_tables(title, muscletype, exercise, sets, reps)
    db = connect_to_db('db/Workout_app_database.db')
    
    db.execute("INSERT INTO Workouts (title, sets, reps, user_id) VALUES (?,?,?,?)",title, sets, reps, session[:id])
    workout_id = db.execute("SELECT id FROM Workouts WHERE title = ?",title)
    # p "workout_id #{workout_id}"
    workout_id = workout_id.last["id"]
    # p "workout_id #{workout_id}"
    db.execute("INSERT INTO Workouts_Users (Workouts_id, Users_id) VALUES (?,?)", workout_id, session[:id])
    muscle_id = db.execute("SELECT id FROM Muscles WHERE name = ?", muscletype).first()["id"]
    exercise_id = db.execute("SELECT id FROM Exercises WHERE name = ?", exercise).first()["id"]

    workout_id = db.execute("SELECT id FROM Workouts ORDER BY id ASC").last()["id"]
    
    db.execute("INSERT INTO Workout_Muscle (workout_id, muscle_id) VALUES (?,?)",workout_id, muscle_id)

    db.execute("INSERT INTO Workout_exercise (workout_id, exercise_id) VALUES (?,?)",workout_id, exercise_id)
   
end

def get_user_id_from_workout_id(workout_id)
    db = connect_to_db('db/Workout_app_database.db')

    list_of_users = db.execute("SELECT Users.username
                    FROM Workouts_Users
                    INNER JOIN Workouts, Users
                    ON Workouts_Users.Workouts_id = Workouts.id AND Workouts_Users.Users_id = Users.id 
                    WHERE Workouts.id = ?", workout_id)

    # puts "List_of_users:"
    return list_of_users

    # users_ids = db.execute("SELECT Users_id FROM Workouts_Users WHERE Workouts_id = ?", workout_id)
    # if !users_ids.empty?
    #     # p "Users_ids #{users_ids}"
    #     puts "users_ids innan "
    #     p users_ids
    #     users_ids = users_ids.last["Users_id"]
    #     puts "users_ids efter: "
    #     p users_ids
    #     extra_username = db.execute("SELECT username FROM Users WHERE id = ?", users_ids)
    #     extra_username = extra_username.last["username"]
    #     return extra_username

    # end

    # users_ids = users_ids["Users_id"]
    # return users_ids
    # users_ids = users_ids.last["Users_id"]
    # return users_ids
end

# def get_workout_id_from_user_id(user_id)

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