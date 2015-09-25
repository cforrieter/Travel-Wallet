

# Homepage (Root path)

# before filter => if not logged in, redirect to 401

get '/' do
  # TODO
  session[:user_id] = 1
  erb :index
end


get '/login' do
  erb :login
end

get '/users/:id' do |id|
  @user = User.find(id)
  erb :'user/index'
end

get '/category/:id' do |id|
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

