# Homepage (Root path)
get '/' do
  erb :index
end


get '/login' do
  erb :login
end

post '/login' do
  email = params[:email]
  password = params[:password]

  user = User.find_by(email: email, password: password)

  if user
    session[:user_id] = user.user_id
  else
    session[:error] = "Your log in information is incorrect"
    redirect '/login'
  end
end