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
    slim(:"account/new")
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
    what_user.each do |user|
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

    slim(:"account/edit",locals:{workout:result})
end

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
                delete_from_table_where_id('Workouts',id2)
            end
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id3)
                delete_from_table_where_id('Workouts',id3)
            end
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id4)
                delete_from_table_where_id('Workouts',id4)
            end
            if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id5)
                delete_from_table_where_id('Workouts',id5)
            end

            delete_from_table_where_id('Workouts',id)
        end
    end

    redirect('/profile')
end

#Dont know if i actually need this (?)
post('/workouts/:id/delete_admin') do 
    id = params[:id].to_i
    id2 = id + 1 
    id3 = id + 2 
    id4 = id + 3 
    id5 = id + 4

    if session[:username] == "ADMIN"
        if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id2)
            delete_from_table_where_id('Workouts',id2)
        end
        if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id3)
            delete_from_table_where_id('Workouts',id3)
        end
        if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id4)
            delete_from_table_where_id('Workouts',id4)
        end
        if select_element_from_table_where_id('title','Workouts','id',id) == select_element_from_table_where_id('title','Workouts','id',id5)
            delete_from_table_where_id('Workouts',id5)
        end

        delete_from_table_where_id('Workouts',id)
    end


    redirect('/workouts')
end

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

post('/workouts/:id/delete_users') do 
    if session[:id] != "ADMIN"
        redirect('/')
    end
    id = params[:id].to_i
    if session[:username] == "ADMIN" 
        delete_from_table_where_id('USERS',id)
    end
    redirect('/users')
end

get('/profile') do
    @result = select_element_from_table('*','Workouts')
    slim(:"account/profile")
end

get('/users') do 
    @result = select_element_from_table('*','Users')
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
        insert_into_table_item1_and_item2('Users','username','pwdigest',username,password_digest)
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
    user_login_info = select_value_from_table_where_value('*','Users','username',username)
    # user_login_info = db.execute("SELECT * FROM Users WHERE username = ?", username)

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