require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'
require 'bcrypt'
require_relative './model.rb'
enable :sessions
include Model 

# Start that redirects to '/workouts', Makes it easier to understand the code
#
get('/') do
    redirect("/workouts")
end

# Display landing page that displays all created workouts, and correlating users
#
# @see Model#select_element_from_table
get('/workouts') do 

    @result = select_element_from_table('*','Workouts')
    @user_result = select_element_from_table('*','Users')

    slim(:"workouts/index")

end

# Should before have yardoc code? It isn't displayed
#
before('/create') do 
    if (session[:id] == nil)
        session[:error] = 'You cant enter this page unless you are logged in!'
        redirect('/error')
    end
end

# Displays a single button
#
get('/create') do
    slim(:"workouts/createButton")
end

# Before ? 
before('/workout/new') do 
    if (session[:id] == nil)
        session[:error] = 'You cant create a workout unless you are logged in!'
        redirect('/error')
    end
end

# Displays form containing title, exercises, muscles, sets and reps
#
# @see Model#select_element_from_table
get('/workout/new') do
    @muscles = select_element_from_table('name','Muscles')
    @exercises = select_element_from_table('name','Exercises')
    slim(:"workouts/new")
end

# Creates a new workout and redirects to '/workouts
#
# @param [String] title, The title of the workout
# @param [String] muscle, The muscle targeted by the workout
# @param [String] exercise, The name of the exercise performed in the workout
# @param [Integer] sets, The amount of sets performed in the exercise
# @param [Integer] reps, The amount of reps to every set in the exercise
# @param [Integer] user_id, The id belonging to the user
#
# @see Model#select_element_from_table
# @see Model#add_values_to_tables
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

    user_id = session[:id]

    all_workouts_titles = select_element_from_table('title','Workouts')

    all_workouts_titles.each do |workout_title|
        if workout_title['title'] == title
            session[:error] = "There already exists a workout with this title, try a new one!"
            redirect('/error')
        end
    end

    if sets != ""
        add_values_to_tables(title, muscletype, exercise, sets, reps, user_id)
    end
    if sets2 != ""
        add_values_to_tables(title, muscletype2, exercise2, sets2, reps2, user_id)
    end
    if sets3 != ""
        add_values_to_tables(title, muscletype3, exercise3, sets3, reps3, user_id)
    end
    if sets4 != ""
        add_values_to_tables(title, muscletype4, exercise4, sets4, reps4, user_id)
    end
    if sets5 != ""
        add_values_to_tables(title, muscletype5, exercise5, sets5, reps5, user_id)
    end

    redirect('/workouts')
end

# Displays an existing workout and gives opportunity to edit title, sets and reps 
#
# @see Model#select_element_from_table_where_id
# @see Model#select_value_from_table_where_value
get('/workouts/:id/edit') do 
    id = params[:id].to_i
    id2 = id + 1
    id3 = id + 2 
    id4 = id + 3 
    id5 = id + 4 

    check1 = select_element_from_table_where_id('title','Workouts','id',id2)
    check2 = select_element_from_table_where_id('title','Workouts','id',id3)
    check3 = select_element_from_table_where_id('title','Workouts','id',id4)
    check4 = select_element_from_table_where_id('title','Workouts','id',id5)

    result = select_element_from_table_where_id('*','Workouts','id',id)

    what_user = select_value_from_table_where_value('user_id','Workouts','id',id)
    p "what_user:"
    p what_user
   
    what_user.each do |user|
        if session[:id] != user["user_id"]
            session[:error] = 'You cant edit workouts if you are not logged in!'
            redirect('/error')
        end    
        if user["user_id"] == session[:id]
            if check1 != nil && check1 != []
                if check1['title'] == result['title']
                    @result2 = select_element_from_table_where_id('*','Workouts','id',id2)
                end
            end
            if check2 != nil && check2 != []
                if check2['title'] == result['title']
                    @result3 = select_element_from_table_where_id('*','Workouts','id',id3)
                end
            end 
            if check3 != nil && check3 != []
                if check3['title'] == result['title']
                    @result4 = select_element_from_table_where_id('*','Workouts','id',id4)
                end
            end
            if check4 != nil && check4 != []
                if check4['title'] == result['title']
                    @result5 = select_element_from_table_where_id('*','Workouts','id',id5)
                end
            end
        end
    end

    slim(:"workouts/edit",locals:{workout:result})
end

# Updates an existing workout and redirects to '/profile'
#
# @param [Integer] id, The workout id
# @param [String] title, The title of the workout
# @param [Integer] sets, The amount of sets in the exercise
# @param [Integer] reps, The amount of reps per set in the exercise
#
# @see Model#select_value_from_table_where_value
# @see Model#select_element_from_table_where_id
# @see Model#update_table_set_condition_where_id
post('/workouts/:id/update') do 
    id = params[:id].to_i
    id2 = id + 1 
    id3 = id + 2 
    id4 = id + 3
    id5 = id + 4
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
    what_user = select_value_from_table_where_value('user_id','Workouts','id',id)
    what_user.each do |user|
        if user["user_id"] == session[:id]  
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id2)
                update_table_set_condition_where_id('Workouts','title',title,id2)
                if sets2 != nil
                    update_table_set_condition_where_id('Workouts','sets',sets2,id2)
                    update_table_set_condition_where_id('Workouts','reps',reps2,id2)
                end
            end
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id3)
                update_table_set_condition_where_id('Workouts','title',title,id3)
                if sets3 != nil
                    update_table_set_condition_where_id('Workouts','sets',sets3,id3)
                    update_table_set_condition_where_id('Workouts','reps',reps3,id3)
                end
            end
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id4)
                update_table_set_condition_where_id('Workouts','title',title,id4)
                if sets4 != nil
                    update_table_set_condition_where_id('Workouts','sets',sets4,id4)
                    update_table_set_condition_where_id('Workouts','reps',reps4,id4)
                end
            end
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id5,)
                update_table_set_condition_where_id('Workouts','title',title,id5)
                if sets5 != nil
                    update_table_set_condition_where_id('Workouts','sets',sets5,id5)
                    update_table_set_condition_where_id('Workouts','reps',reps5,id5)
                end
            end
            update_table_set_condition_where_id('Workouts','title',title,id)
            if sets != nil
                update_table_set_condition_where_id('Workouts','sets',sets,id)
                update_table_set_condition_where_id('Workouts','reps',reps,id)
                
            end
        end
    end
    redirect('/profile')
end

# Deletes an existing workout and redirects to '/profile'
#
# @param [Integer] id, The workout id
#
# @see Model#select_value_from_table_where_value
# @see Model#select_element_from_table_where_id
# @see Model#delete_from_table_where_id
post('/workouts/:id/delete') do 
    id = params[:id].to_i
    id2 = id + 1 
    id3 = id + 2 
    id4 = id + 3 
    id5 = id + 4

    what_user = select_value_from_table_where_value('user_id','Workouts','id',id)

    what_user.each do |user|
        if user["user_id"] == session[:id]
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id2)
                delete_from_table_where_id('Workouts','id',id2)
                delete_from_table_where_id('Workouts_Users','Workouts_id',id2)
            end
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id3)
                delete_from_table_where_id('Workouts','id',id3)
                delete_from_table_where_id('Workouts_Users','Workouts_id',id3)

            end
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id4)
                delete_from_table_where_id('Workouts','id',id4)
                delete_from_table_where_id('Workouts_Users','Workouts_id',id2)
            end
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id5)
                delete_from_table_where_id('Workouts','id',id5)
                delete_from_table_where_id('Workouts_Users','Workouts_id',id2)
            end

            delete_from_table_where_id('Workouts','id',id)
            delete_from_table_where_id('Workouts_Users','Workouts_id',id)

        end
    end

    redirect('/profile')
end

# Deletes workout displayed from '/workouts' if logged in user is ADMIN and redirects to '/workouts'
#
# @param [Integer] id, The workout id
#
# @see Model#select_value_from_table_where_value
# @see Model#select_element_from_table_where_id
# @see Model#delete_from_table_where_id
post('/workouts/:id/delete_admin') do 
    id = params[:id].to_i
    id2 = id + 1 
    id3 = id + 2 
    id4 = id + 3 
    id5 = id + 4

    if session[:username] == "ADMIN"
        if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id2)
            delete_from_table_where_id('Workouts','id',id2)
            delete_from_table_where_id('Workouts_Users','Workouts_id',id2)
        end
        if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id3)
            delete_from_table_where_id('Workouts','id',id3)
            delete_from_table_where_id('Workouts_Users','Workouts_id',id3)

        end
        if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id4)
            delete_from_table_where_id('Workouts','id',id4)
            delete_from_table_where_id('Workouts_Users','Workouts_id',id4)
        end
        if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id5)
            delete_from_table_where_id('Workouts','id',id5)
            delete_from_table_where_id('Workouts_Users','Workouts_id',id5)
        end

        delete_from_table_where_id('Workouts','id',id)
        delete_from_table_where_id('Workouts_Users','Workouts_id',id)

    end

    redirect('/workouts')
end

# Likes other users workouts and redirects to '/'
#
# @param [Integer] id, The workout id
#
# @see Model#select_value_from_table_where_value
# @see Model#insert_into_table_item1_and_item2
post('/workouts/:id/like_funktion') do
    id = params[:id].to_i
    what_users = select_value_from_table_where_value('Users_id','Workouts_Users','Workouts_id',id)
    what_users.each do |user|
        if user["Users_id"] == session[:id]
            redirect('/')
        end

    end
    
    insert_into_table_item1_and_item2('Workouts_Users','Workouts_id','Users_id',id,session[:id])    
    redirect('/')
end

# Deletes an existing user if logged in user is admin ADMIN and redirects to '/users'
#
# @see Model#select_value_from_table_where_value
# @see Model#delete_from_table_where_id
post('/workouts/:id/delete_users') do 
    if session[:username] != "ADMIN"
        redirect('/')
    end
    id = params[:id].to_i
    if session[:username] == "ADMIN" 
        
        all_workouts_belonging_to_user = select_value_from_table_where_value('id','Workouts','user_id',id)

        all_workouts_belonging_to_user.each do |user_workouts|
            delete_from_table_where_id('Workouts','id',user_workouts['id'])
        end

        all_liked_workouts_belonging_to_user = select_value_from_table_where_value('Workouts_id','Workouts_Users','Users_id',id)

        all_liked_workouts_belonging_to_user.each do |liked|
            delete_from_table_where_id('Workouts_Users','Workouts_id',liked['Workouts_id'])
        end

        delete_from_table_where_id('USERS','id',id)

    end

    redirect('/users')
end

# Before?
before('/profile') do 
    if (session[:id] == nil)
        session[:error] = 'You cant enter this page unless you are logged in!'
        redirect('/error')
    end
end

# Displays workouts that user owns
#
# @see Model#select_element_from_table
get('/profile') do
    @result = select_element_from_table('*','Workouts')
    slim(:"account/profile")
end

# Before ? 
before('/users') do 
    if (session[:username] != 'ADMIN')
        session[:error] = 'You cant enter this page unless you are ADMIN!'
        redirect('error')
    end
end

# Displays all users
#
get('/users') do 
    @result = select_element_from_table('*','Users')
    slim(:"account/users")
end

# Displays a register form
#
get('/register') do 
    slim(:"register-login/register")
end

# Attempts registration
#
# @param [String] username, The username
# @param [String] password, The password
# @param [String] password confirmation, The password confirmation
#
# @see Model#select_element_from_table
# @see Model#insert_into_table_item1_and_item2
post('/finishregistration') do
    username = params[:username]
    password = params[:password] 
    password_confirm = params[:confirmpassword] 

    all_usernames = select_element_from_table('username','Users')

    all_usernames.each do |users|
        if users['username'] == username
            halt 401, 'This username is already taken, make another one!'
            redirect('/register')
        end
    end
    
    if (password = password_confirm)
        password_digest = BCrypt::Password.create(password)
        insert_into_table_item1_and_item2('Users','username','pwdigest',username,password_digest)
        redirect('/register')
    else 
        "Lösenordet matchade inte"
    end

end

#Displays a login form
#
get('/login') do 
    slim(:"register-login/login")
end

# Attempts login and updates the session and redirects to '/' if log in worked and 'login' if it didn't work
#
# @param [String] username, The username
# @param [String] password, The password
#
# @see Model#select_value_from_table_where_value
post('/finishlogin') do 
    username = params[:username]
    password = params[:password]
    user_login_info = select_value_from_table_where_value('*','Users','username',username)

    if session[:login_tries] == nil
        session[:login_tries] = 0
    end

    if session[:login_tries] >= 2

        session[:last_login_time] = session[:last_login_time] || Time.now

        if Time.now - session[:last_login_time] > 20 
            session[:login_tries] = 0 
            session[:last_login_time] = nil
        else
            session[:error] = "You have tried to many times, you need to wait 20 seconds before trying to login again" 
            redirect('/error')
        end
    end

    if user_login_info != []
        if user_login_info
            pwdigest = user_login_info[0][2]
            user_id = user_login_info[0][0]
        end

        if pwdigest && BCrypt::Password.new(pwdigest) == password
            session[:login_tries] = 0
            session[:id] = user_id
            session[:username] = username
            redirect('/')
        else
            "Fel LÖSEN"
        end
    end
    session[:login_tries] += 1 
    redirect('/login')
end

# Logs user out and redirects to '/'
#
get('/logout') do
    session[:id] = nil
    session[:username] = nil
    redirect('/')
end

# Displays an error message
#
get('/error') do 
    slim(:"error")
end