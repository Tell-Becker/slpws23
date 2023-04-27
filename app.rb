require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require_relative './model.rb'
enable :sessions

get('/') do
    redirect("/workouts")
end

get('/workouts') do 

    @result = get_everything_from_table('Workouts')
    @user_result = get_everything_from_table('Users')

    slim(:"account/index")

end

get('/create') do
    slim(:"account/createButton")
end

get('/workout/new') do
    @muscles = select_element_from_table('name','Muscles')
    @exercises = select_element_from_table('name','Exercises')
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

    if sets != ""
        add_values_to_tables(title, muscletype, exercise, sets, reps)
    end
    if sets2 != ""
        add_values_to_tables(title, muscletype2, exercise2, sets2, reps2)
    end
    if sets3 != ""
        add_values_to_tables(title, muscletype3, exercise3, sets3, reps3)
    end
    if sets4 != ""
        add_values_to_tables(title, muscletype4, exercise4, sets4, reps4)
    end
    if sets5 != ""
        add_values_to_tables(title, muscletype5, exercise5, sets5, reps5)
    end

    redirect('/workouts')
end

get('/workouts/:id/edit') do 
    db = connect_to_db('db/Workout_app_database.db')
    id = params[:id].to_i
    id2 = id + 1
    id3 = id + 2 
    id4 = id + 3 
    id5 = id + 4 

    check1 = select_element_from_table_where_id('title','Workouts',id2)
    check2 = select_element_from_table_where_id('title','Workouts',id3)
    check3 = select_element_from_table_where_id('title','Workouts',id4)
    check4 = select_element_from_table_where_id('title','Workouts',id5)

    result = select_element_from_table_where_id('*','Workouts',id)

    if check1 != nil && check1 != []
        if check1['title'] == result['title']
            @result2 = select_element_from_table_where_id('*','Workouts',id2)
            # @result2 = db.execute("SELECT * FROM Workouts WHERE id = ?", id2).first
        end
    end
    if check2 != nil && check2 != []
        if check2['title'] == result['title']
            @result3 = select_element_from_table_where_id('*','Workouts',id3)
            # @result3 = db.execute("SELECT * FROM Workouts WHERE id = ?", id3).first
        end
    end 
    if check3 != nil && check3 != []
        if check3['title'] == result['title']
            @result4 = select_element_from_table_where_id('*','Workouts',id4)
            # @result4 = db.execute("SELECT * FROM Workouts WHERE id = ?", id4).first
        end
    end
    if check4 != nil && check4 != []
        if check4['title'] == result['title']
            @result5 = select_element_from_table_where_id('*','Workouts',id5)
            # @result5 = db.execute("SELECT * FROM Workouts WHERE id = ?", id5).first
        end
    end

    slim(:"account/edit",locals:{workout:result})
end

post('/workouts/:id/update') do 
    id = params[:id].to_i
    title = params[:title]
    sets = params[:sets]
    reps = params[:reps]
    if params[:sets2] != nil
        sets2 = params[:sets2]
        reps2 = params[:reps2]
    end
    if params[:sets3] != nil
        sets3 = params[:sets3]
        reps3 = params[:reps3]
    end
    if params[:sets4] != nil
        sets4 = params[:sets4]
        reps4 = params[:reps4]
    end
    if params[:sets5] != nil
        sets5 = params[:sets5]
        reps5 = params[:reps5]
    end
    db = connect_to_db('db/Workout_app_database.db')
    if db.execute("SELECT title FROM Workouts WHERE id = ?", id) == db.execute("SELECT title FROM Workouts WHERE id = ?", id + 1)
        id2 = id + 1
        db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id2)
        if sets2 != nil
            db.execute("UPDATE Workouts SET sets=? WHERE id = ?",sets2, id2)
            db.execute("UPDATE Workouts SET reps=? WHERE id = ?",reps2, id2)
        end
    end
    if db.execute("SELECT title FROM Workouts WHERE id = ?", id) == db.execute("SELECT title FROM Workouts WHERE id = ?", id + 2)
        id3 = id + 2
        db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id3)
        if sets3 != nil
            db.execute("UPDATE Workouts SET sets=? WHERE id = ?",sets3, id3)
            db.execute("UPDATE Workouts SET reps=? WHERE id = ?",reps3, id3)
        end
    end
    if db.execute("SELECT title FROM Workouts WHERE id = ?", id) == db.execute("SELECT title FROM Workouts WHERE id = ?", id + 3)
        id4 = id + 3
        db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id4)
        if sets4 != nil
            db.execute("UPDATE Workouts SET sets=? WHERE id = ?",sets4, id4)
            db.execute("UPDATE Workouts SET reps=? WHERE id = ?",reps4, id4)
        end
    end
    if db.execute("SELECT title FROM Workouts WHERE id = ?", id) == db.execute("SELECT title FROM Workouts WHERE id = ?", id + 4)
        id5 = id + 4
        db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id5)
        if sets5 != nil
            db.execute("UPDATE Workouts SET sets=? WHERE id = ?",sets5, id5)
            db.execute("UPDATE Workouts SET reps=? WHERE id = ?",reps5, id5)
        end
    end
    # if db.execute("SELECT title FROM Workouts WHERE id = ?", id) == db.execute("SELECT title FROM Workouts WHERE id = ?", id + 4)
    #     id5 = id + 4
    #     db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id5)
    # end
    db.execute("UPDATE Workouts SET title=? WHERE id = ?",title,id)
    if sets != nil
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

post('/workouts/:id/delete_admin') do 
    db = connect_to_db('db/Workout_app_database.db')
    id = params[:id].to_i

    db.execute("DELETE FROM Workouts WHERE id = ?",id)
    db.execute("DELETE FROM Workouts WHERE id = ?",id + 1)
    db.execute("DELETE FROM Workouts WHERE id = ?",id + 2)
    db.execute("DELETE FROM Workouts WHERE id = ?",id + 3)
    db.execute("DELETE FROM Workouts WHERE id = ?",id + 4)


    redirect('/workouts')
end

post('/workouts/:id/like_funktion') do
    db = connect_to_db('db/Workout_app_database.db')
    id = params[:id].to_i
    what_users = db.execute("SELECT Users_id FROM Workouts_Users WHERE Workouts_id = ?",id)
    p "what_user:"
    p what_users
    what_users.each do |user|
        if user["Users_id"] == session[:id]
            redirect('/')
        end

    end

    db.execute("INSERT INTO Workouts_Users (Workouts_id, Users_id) VALUES (?,?)", id, session[:id])
    
    redirect('/')
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