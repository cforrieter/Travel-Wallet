helpers do
 def current_user
   @user = User.find(session[:user_id]) if session[:user_id]
 end

 def get_error
   if session[:error]
     @error = session[:error]
     session[:error] = nil
   end
 end
end

before do
 current_user
 get_error
end

get '/users/new' do
  erb :'/users/new'
end

post '/user/new' do
  @user = User.new(
    email: params[:email])
end


# login page
get '/login' do
 erb :login
end

# Login verificaton
post '/login' do
 email = params[:email]
 password = params[:password]

 user = User.find_by(email: email)

 password_hash = BCrypt::Password.new(user.password_hash) if user

 if user && password_hash == password
   session[:user_id] = user.id
   redirect "/users/#{user.id}"
 else
   session[:error] = "Your log in information is incorrect"
   redirect '/'
 end
end


# Create and save new user
post '/users/new' do
 
  email = params[:email]
  first_name = params[:first_name] 
  last_name = params[:last_name] 
  password = BCrypt::Password.create(params[:password])
  
  user = User.create(first_name: first_name, last_name: last_name, email: email, password_hash: password)
  binding.pry
  if user
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  else
    session[:error] = "Your sign up information is incorrect"
    redirect '/'
  end
end


# exit session and user log out
get '/logout' do
 session.clear
 redirect '/'
end

# Homepage (Root path)

# before filter => if not logged in, redirect to 401

get '/' do
  session[:user_id] = 1
  erb :index
end

get '/users/:id' do |id|
  if session[:user_id]
    @the_user = User.find(id)
    @shares = Share.find_by_sql(["SELECT * FROM shares as s JOIN categories as c ON s.category_id = c.id WHERE s.user_id = ? AND c.user_id = ?", @user.id, @the_user.id])  
    if @user.id === @the_user.id || !@shares.empty?
      erb :'users/index'
    end
  else
    "404 not found!"
  end
end

get '/category/:id' do |id|
  if session[:user_id]
    @shares = Share.find_by_sql(["SELECT * FROM shares as s JOIN categories as c ON s.category_id = c.id WHERE s.user_id = ? AND c.user_id = ?", @user.id, Category.find(id).user_id])  
    if @user.id == Category.find(id).user_id || !@shares.empty?
      @category = Category.find(id)
      erb :'/category/show'
    else
      "No access"
    end
  else
    "Not logged in"
  end
end

post '/category/:id/document/new' do |id|
  @category = Category.find(id)
  
  params[:files].each do |import_file|
    document = @category.documents.new
    document.file = import_file
    document.save
  end
  @category.save
  
  redirect "/category/#{id}"
end

post '/category/create' do
  category = Category.new
  category.name = params[:name]
  category.user = User.find(session[:user_id])
  category.save!
  redirect "/users/#{session[:user_id]}"
end

post '/shares/:id/create' do |id|
  share = Share.new
  user = User.find_by(email: params[:email])
  category = Category.find(id)
  unless Share.exists?(user_id: user.id, category_id: category.id)
    share.user = user
    share.category = category
    share.save
  end
end


# Will delete a file from a category.
delete 'document/:id/destroy/' do |id|
  document = Document.find(id)
  category_id = document.category.id
  document.destroy
  redirect "/category/#{category_id}"
end

# Will delete a category
delete '/category/:id' do |id|
  category = Category.find(id)
  user_id = category.user_id
  category.destroy
  redirect "/users/#{user_id}"
end


