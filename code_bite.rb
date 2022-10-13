post '/spaces/:id' do
  space_id = params[:id]
  # if !!Request.space_id.approval_status
  #   start_date_confirmed = Request.space_id.start_date
  #   end_date_confirmed = Request.space_id.end_date
  # end
  
  # def availability?
  #   !(params[:start_date] >= start_date_confirmed && params[:start_date] <= end_date_confirmed)
  # end

  

  if !!session[:user_id] 
    if params[:start_date] && #>= params[:end_date] && params[:start_date] 
      request = Request.create(
        start_date: params[:start_date],
        end_date: params[:end_date],
        user_id: session[:user_id],
        space_id: space_id
    )
      if request.save
        redirect '/request_submitted'
      else
        redirect '/request_error'
      end
    end