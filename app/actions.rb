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

# Login varificaton
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
   redirect '/users/new'
 end
end

# user page retrieve
get '/users/new' do
 erb :'users/new'
end

# Create and save new user
post '/user/new' do

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
  @user = User.find(id)
  erb :'users/index'
end

get '/category/:id' do |id|
  # binding.pry
  @category = Category.find(id)
  erb :'/category/show'
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
  @share = Share.new
  @share.user = User.find_by(email: params[:email])
  @share.category = Category.find(id)
  @share.save
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







