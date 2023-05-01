module Model

    # Connects to the SQLite3 database
    #
    # @param [String] path to database
    #
    # @return [Hash] way to interact with SQLite3 database
    def connect_to_db(path)
        db = SQLite3::Database.new('db/Workout_app_database.db')
        db.results_as_hash = true
        return db
    end

    # Attempts to select content from table
    #
    # @param [String] element The name of the element to select from the table
    # @param [String] table The name of the table to select the element from
    # 
    # @return [Hash] containing data from element
    def select_element_from_table(element,table)
        db = connect_to_db('db/Workout_app_database.db')

        return db.execute("SELECT #{element} FROM #{table}")
    end

    # Attempts to insert 5 contents into table
    # 
    # @param [String] title The title of the workout
    # @param [String] muscletype The muscle targeted my the workout
    # @param [String] exercise The name of the exercise performed in the workout
    # @param [Integer] sets The amount of sets performed in the exercise
    # @param [Integer] reps The akount of reps for every set in the exerise
    def add_values_to_tables(title, muscletype, exercise, sets, reps)
        db = connect_to_db('db/Workout_app_database.db')
        
        db.execute("INSERT INTO Workouts (title, sets, reps, user_id) VALUES (?,?,?,?)",title, sets, reps, session[:id])
        workout_id = db.execute("SELECT id FROM Workouts WHERE title = ?",title)
        workout_id = workout_id.last["id"]
        db.execute("INSERT INTO Workouts_Users (Workouts_id, Users_id) VALUES (?,?)", workout_id, session[:id])
        muscle_id = db.execute("SELECT id FROM Muscles WHERE name = ?", muscletype).first()["id"]
        exercise_id = db.execute("SELECT id FROM Exercises WHERE name = ?", exercise).first()["id"]

        workout_id = db.execute("SELECT id FROM Workouts ORDER BY id ASC").last()["id"]
        
        db.execute("INSERT INTO Workout_Muscle (workout_id, muscle_id) VALUES (?,?)",workout_id, muscle_id)

        db.execute("INSERT INTO Workout_exercise (workout_id, exercise_id) VALUES (?,?)",workout_id, exercise_id)
    
    end

    # Attempts to select the first content from table from a certain id
    #
    # @param [String] element The name of the column to select an element from 
    # @param [String] table The name of the table to select the element from
    # @param [String] what_id The type of id to select the element from
    # @param [Integer] id The id of the row to be selected
    #
    # @return [Hash] containing the first data of from the matching id
    def select_element_from_table_where_id(element,table,what_id,id)
        db = connect_to_db('db/Workout_app_database.db')

        return db.execute("SELECT #{element} FROM #{table} WHERE #{what_id} = ?",id).first
    end

    # Attempts to update a row on a table 
    #
    # @param [String] what_table The name of the table to update
    # @param [String] what_condition The name of the column to update
    # @param [String] condition The new value to give the column
    # @param [Integer] id The id of the row to update
    def update_table_set_condition_where_id(what_table,what_condition,condition,id)
        db = connect_to_db('db/Workout_app_database.db')

        db.execute("UPDATE #{what_table} SET #{what_condition} = ? WHERE id = ?",condition,id)
    end

    # Attempt to delete a row on a table
    #
    # @param [String] table The name of the table to delete from
    # @param [String] what_id The type of id to delete from
    # @param [Integer] id The id of the row to be deleted
    def delete_from_table_where_id(table,what_id,id)
        db = connect_to_db('db/Workout_app_database.db')

        db.execute("DELETE FROM #{table} WHERE #{what_id} = ?",id)
    end

    # Attempts to insert two id:s into a table
    #
    # @param [String] table The name of table to insert into
    # @param [String] what_id1 The type of id to insert into
    # @param [String] what_id2 The other type of id to insert into
    # @param [Integer] value1 The value to be inserted into the column
    # @param [Integer] value The other value to be inserted into column
    def insert_into_table_item1_and_item2(table,what_id1,what_id2,value1,value2)
        db = connect_to_db('db/Workout_app_database.db')

        db.execute("INSERT INTO #{table} (#{what_id1},#{what_id2}) VALUES (?,?)",value1,value2)
    end

    # Attempts to select content from table from a certain id
    #
    # @param [String] element The name of the column to select an element from 
    # @param [String] table The name of the table to select the element from
    # @param [String] what_id The type of id to select the element from
    # @param [Integer] id The id of the row to be selected
    #
    # @return [Hash] containing the data from the matching id
    def select_value_from_table_where_value(element,table,what_id,id)
        db = connect_to_db('db/Workout_app_database.db')

        return db.execute("SELECT #{element} FROM #{table} WHERE #{what_id} = ?",id)
    end

    # Attempts to get username from workout_id
    #
    # @param [Integer] workout_id The value of the workout id
    #
    # @return [Hash] contaning the usernames from the matching id
    def get_username_from_workout_id(workout_id)
        db = connect_to_db('db/Workout_app_database.db')

        list_of_users = db.execute("SELECT Users.username
                        FROM Workouts_Users
                        INNER JOIN Workouts, Users
                        ON Workouts_Users.Workouts_id = Workouts.id AND Workouts_Users.Users_id = Users.id 
                        WHERE Workouts.id = ?", workout_id)

        return list_of_users

    end

    # Attempts to get all muscles from workout_id
    #
    # @param [Integer] workout_id The value of the workout id
    #
    # @return [Hash] contaning the muscles from the matching id
    def get_all_muscles_for_workout(workout_id)
        db = connect_to_db('db/Workout_app_database.db')
        return db.execute("
            SELECT Muscles.name 
            FROM Workout_Muscle 
            INNER JOIN Muscles, Workouts 
            ON Workout_Muscle.workout_id = Workouts.id AND Workout_Muscle.muscle_id = Muscles.id
            WHERE Workouts.id = ?", workout_id)
    end

    # Attempts to get all exercises from workout_id
    #
    # @param [Integer] workout_id The value of the workout id
    #
    # @return [Hash] contaning the exercises from the matching id
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