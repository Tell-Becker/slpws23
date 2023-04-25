def connect_to_db(path)
    db = SQLite3::Database.new('db/Workout_app_database.db')
    db.results_as_hash = true
    return db
end

def add_values_to_tables(title, muscletype, exercise, sets, reps)
    db = connect_to_db('db/Workout_app_database.db')
    
    db.execute("INSERT INTO Workouts (title, sets, reps, user_id) VALUES (?,?,?,?)",title, sets, reps, session[:id])
    workout_id = db.execute("SELECT id FROM Workouts WHERE title = ?",title)
    workout_id = workout_id.last["id"]
    p "workout_id #{workout_id}"
    db.execute("INSERT INTO Workouts_Users (Workouts_id, Users_id) VALUES (?,?)", workout_id, session[:id])
    muscle_id = db.execute("SELECT id FROM Muscles WHERE name = ?", muscletype).first()["id"]
    exercise_id = db.execute("SELECT id FROM Exercises WHERE name = ?", exercise).first()["id"]

    workout_id = db.execute("SELECT id FROM Workouts ORDER BY id ASC").last()["id"]
    
    db.execute("INSERT INTO Workout_Muscle (workout_id, muscle_id) VALUES (?,?)",workout_id, muscle_id)

    db.execute("INSERT INTO Workout_exercise (workout_id, exercise_id) VALUES (?,?)",workout_id, exercise_id)
   
end


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